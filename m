Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D60A21FC
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfH2RQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:16:59 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40034 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfH2RQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:16:59 -0400
Received: by mail-pl1-f194.google.com with SMTP id h3so1871235pls.7;
        Thu, 29 Aug 2019 10:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NRznbnxEWY+qWoYeVGueN4YTAamRXlvpw8xIbz20Lgs=;
        b=Ip2brTNUSZufRT7ajPKX2XmDiE/4k99B4Qw6Tu9NBHa2NgeQwrn3SxWVrTfn5drQYI
         TB+gtkXppxZC2sm+oEb1VHeWFmwGRbiauC4sCOXb/Uw0SPZS2tTGu3wcS1V/oQadLomF
         dyZd1YEbfg+7Tyl/dBHjUDuvkhUqJe0KBu7ZxTiLaAngvwplmuuHvrhc3djSPmBA3xxo
         bsTskEPJFjY/ciIkkQ+5LrOOHVCvtIezovHNh4LnpaxjRJ20Yi5SrbU1eidtwnD5+Cg4
         d/WgwD9cqmAZAtWfEZprK9dsuP4vYRuY0Rx1Mz3Gq3ErZEME19s0CxUSXJaURayKouz5
         wxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NRznbnxEWY+qWoYeVGueN4YTAamRXlvpw8xIbz20Lgs=;
        b=MruRO+IwItYnCF+TA92QxaLdsv4fwQ9inDkw1ybeKFwLiZCcok/PyiqUNRBBVMFgpR
         jKOrIO9SGh5i4vKvRDvWhVXHPCJxl6yGgAHD/qE/KHqrZ6rxziaK/4vSHvJUnyLHjmb6
         RpQ3a1STkEry8wKMcWNR+6QcZ6+OJH3vg4EfUsJ8x4oHP7JLN55R1pbIckHukrodioPd
         81aeXytcyJrqwQtuaxOxfa2iGUCxcPcFnLEtciHUOIkDbCUL4DRJ1pa06zlnhHWHyXyw
         DiFtgAxSS/LUbDcylTDmrDZLUJ7evJrYPGou35XCXMk5hdNfbKMv5Vo4343/c+ehMiKg
         JHUw==
X-Gm-Message-State: APjAAAVkJKUQnG0OG/cy/o8+oxq/ONzu1aXeTziEwYGA7ZtChS3xHdFN
        6AK2Ymk4GMqNUVZO25NTPy8=
X-Google-Smtp-Source: APXvYqx4BiyE1NCYS+lshAeU+SaBj8mn6xKaWsz+BXUBUKH2O9TJD4ouiGurN/bQK3ZbpAgM/a3ukg==
X-Received: by 2002:a17:902:7d82:: with SMTP id a2mr11387111plm.57.1567099018801;
        Thu, 29 Aug 2019 10:16:58 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:1347])
        by smtp.gmail.com with ESMTPSA id 185sm4739240pfd.125.2019.08.29.10.16.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 10:16:58 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:16:56 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Julia Kartseva <hex@fb.com>, ast@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, rdna@fb.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: auto-split of commit. Was: [PATCH bpf-next 04/10] tools/bpf: add
 libbpf_prog_type_(from|to)_str helpers
Message-ID: <20190829171655.fww5qxtfusehcpds@ast-mbp.dhcp.thefacebook.com>
References: <cover.1567024943.git.hex@fb.com>
 <467620c966825173dbd65b37a3f9bd7dd4fb8184.1567024943.git.hex@fb.com>
 <20190828163422.3d167c4b@cakuba.netronome.com>
 <20190828234626.ltfy3qr2nne4uumy@ast-mbp.dhcp.thefacebook.com>
 <20190829065151.GB30423@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829065151.GB30423@kroah.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 08:51:51AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Aug 28, 2019 at 04:46:28PM -0700, Alexei Starovoitov wrote:
> > On Wed, Aug 28, 2019 at 04:34:22PM -0700, Jakub Kicinski wrote:
> > > 
> > > Greg, Thomas, libbpf is extracted from the kernel sources and
> > > maintained in a clone repo on GitHub for ease of packaging.
> > > 
> > > IIUC Alexei's concern is that since we are moving the commits from
> > > the kernel repo to the GitHub one we have to preserve the commits
> > > exactly as they are, otherwise SOB lines lose their power.
> > > 
> > > Can you provide some guidance on whether that's a valid concern, 
> > > or whether it's perfectly fine to apply a partial patch?
> > 
> > Right. That's exactly the concern.
> > 
> > Greg, Thomas,
> > could you please put your legal hat on and clarify the following.
> > Say some developer does a patch that modifies
> > include/uapi/linux/bpf.h
> > ..some other kernel code...and
> > tools/include/uapi/linux/bpf.h
> > 
> > That tools/include/uapi/linux/bpf.h is used by perf and by libbpf.
> > We have automatic mirror of tools/libbpf into github/libbpf/
> > so that external projects and can do git submodule of it,
> > can build packages out of it, etc.
> > 
> > The question is whether it's ok to split tools/* part out of
> > original commit, keep Author and SOB, create new commit out of it,
> > and automatically push that auto-generated commit into github mirror.
> 
> Note, I am not a laywer, and am not _your_ lawyer either, only _your_
> lawyer can answer questions as to what is best for you.
> 
> That being said, from a "are you keeping the correct authorship info",
> yes, it sounds like you are doing the correct thing here.
> 
> Look at what I do for stable kernels, I take the original commit and add
> it to "another tree" keeping the original author and s-o-b chain intact,
> and adding a "this is the original git commit id" type message to the
> changelog text so that people can link it back to the original.

I think you're describing 'git cherry-pick -x'.
The question was about taking pieces of the original commit. Not the whole commit.
Author field obviously stays, but SOB is questionable.
If author meant to change X and Y and Z. Silently taking only Z chunk of the diff
doesn't quite seem right.
If we document that such commit split happens in Documentation/bpf/bpf_devel_QA.rst
do you think it will be enough to properly inform developers?
The main concern is the surprise factor when people start seeing their commits
in the mirror, but not their full commits.

