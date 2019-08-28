Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA81A0E6C
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfH1Xqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:46:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35656 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfH1Xqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:46:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so559715pgv.2;
        Wed, 28 Aug 2019 16:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5d0g3Dl6DhW5niS/Sr8rnftZb+SLlZRLZP+NnA4xrN0=;
        b=bJo6Is24JDWPaRjfEQ+Nws9DB6QjJyldcwWZv7W+vR8r+ODrdUDl+JiFp8dS8WcjNV
         jtN/0Fqm+2HcPUCzZ91XncpezkpdrluzGpHUnJtqzazUuwAegbapPNdXufMFbnHuunB+
         LC5TQUtWHqe+7csMgcFOk2r0wbB9NVs5RaA/ima+8uKA+dTPqOZziVAkKS9Phm0Tapc2
         dwdcG4SafNH+SSDZpyI+KgrVv/dni0dP0JsUzs/y+Ry/xBRquW1XsB7QLReD0auOLL0P
         H+6ByAFoXdgWShPrC4knSqsgYA6lTD6wVYHW4JdPwwUdQqKwZVNEuNgf2aPuc9Kl5QDx
         AdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5d0g3Dl6DhW5niS/Sr8rnftZb+SLlZRLZP+NnA4xrN0=;
        b=jWyo3wBu0l1NAH84NO1rB+q/uy2TWK/TLI4QPOqqy67pbl2LQs0HC/WSX9A0O7MDgU
         u7EuQ+KWae/JR0UTYJ2WJxv1ofoGRxywew0Tj6SkHoIPp7AH/2wyjXEjo3mFOYCHWNdw
         ouBzQXGmGLOYXMdajPiM41G+B2OrhK04XSCqfOdxkamX3/c34QF4VEgmutb12cwEybt7
         smrMthO9iBAZmIqPn2jbhHH+AKocLhgVVLKHaUY0moxzfOJDZJvI0VBK7fph2rZDAMzJ
         T9LPmcvtxmmPZjucIDE8UPPhquuB7ckC1OAgDfrZutXu7J03IJ+hnhQT6qCq3evJMarw
         SO5Q==
X-Gm-Message-State: APjAAAVlwPkoWAHyrKfG4MSskA4A6B3KeTEiqwlwyhqMrDvw9cpVfxrq
        YBeh+4+4UVwse3J0RoN1BMA=
X-Google-Smtp-Source: APXvYqx0JxqrskzUfC3ETWuy5cywCktad3INkEP1oK24ozKVwAkQVgjxPlFe0OPEjDbsAtgWpnCAeQ==
X-Received: by 2002:a63:161c:: with SMTP id w28mr3524886pgl.442.1567035990759;
        Wed, 28 Aug 2019 16:46:30 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::5983])
        by smtp.gmail.com with ESMTPSA id d11sm536066pfh.59.2019.08.28.16.46.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 16:46:29 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:46:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Julia Kartseva <hex@fb.com>, ast@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, rdna@fb.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: auto-split of commit. Was: [PATCH bpf-next 04/10] tools/bpf: add
 libbpf_prog_type_(from|to)_str helpers
Message-ID: <20190828234626.ltfy3qr2nne4uumy@ast-mbp.dhcp.thefacebook.com>
References: <cover.1567024943.git.hex@fb.com>
 <467620c966825173dbd65b37a3f9bd7dd4fb8184.1567024943.git.hex@fb.com>
 <20190828163422.3d167c4b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828163422.3d167c4b@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 04:34:22PM -0700, Jakub Kicinski wrote:
> 
> Greg, Thomas, libbpf is extracted from the kernel sources and
> maintained in a clone repo on GitHub for ease of packaging.
> 
> IIUC Alexei's concern is that since we are moving the commits from
> the kernel repo to the GitHub one we have to preserve the commits
> exactly as they are, otherwise SOB lines lose their power.
> 
> Can you provide some guidance on whether that's a valid concern, 
> or whether it's perfectly fine to apply a partial patch?

Right. That's exactly the concern.

Greg, Thomas,
could you please put your legal hat on and clarify the following.
Say some developer does a patch that modifies
include/uapi/linux/bpf.h
..some other kernel code...and
tools/include/uapi/linux/bpf.h

That tools/include/uapi/linux/bpf.h is used by perf and by libbpf.
We have automatic mirror of tools/libbpf into github/libbpf/
so that external projects and can do git submodule of it,
can build packages out of it, etc.

The question is whether it's ok to split tools/* part out of
original commit, keep Author and SOB, create new commit out of it,
and automatically push that auto-generated commit into github mirror.

So far we've requested all developers to split their patches manually.
So that tools/* update is an individual commit that mirror can
simply git cherry-pick.

