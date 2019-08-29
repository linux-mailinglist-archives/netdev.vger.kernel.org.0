Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9F7A2304
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfH2SKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:10:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35418 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfH2SKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:10:50 -0400
Received: by mail-qt1-f193.google.com with SMTP id u34so4740309qte.2;
        Thu, 29 Aug 2019 11:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XWg2qWYsYuRDyAjFtVv4Jv1nOzPDxTjh11wtz2ibi98=;
        b=ddOnkY1+LeWaUfLZa5oslbGOaVSQkn9zXRd4SEwrqpNXCBxvjUBtmfOGtrplAXTMVp
         ECrlTh16vxqclZ8HotnRvbYgoWZhD+SWEqenQPElxeDssH/edIS6YfpYL46v7M2GdEAF
         19Y66McPuH0/IdXGbh4i6pA88bHDJKMVDIOPvP3mPpdGmubErc9rP7g+WF6oS6QMhhhn
         t6wdGda4db80Un9AorxTPM9yG5PALKuTmKenOg1Xhz2OGssdjxfdTjvPCvnOUAun6/Jl
         lyIHdXFi8c8i+lz6Ov+KS6KsZ/tdtIgQCQ3jRZTfEedXTVA2CuZzjUt4BHIfUB1mpXQc
         nGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XWg2qWYsYuRDyAjFtVv4Jv1nOzPDxTjh11wtz2ibi98=;
        b=ZKQozYHJRUHDTW06TLvM9CtpfXF57qx+NrsjRCuWTtsqE3Lj7uvg5iNitZ+7x43hrU
         soQuTpP6JMts+jHqqr5rFnK4hu4ChEi0w9DbbdsuKETah2ZYe8xWeYg5mR6HqedzhmXx
         +ZTWbZGacNvL5HwbAeXRzJYz2XP8oy44uj6pZKfTdVGeZRgi7C63i3DVku6rXcB6XXlJ
         FWiqIjkKFC8FeYpe2PCaERcFBKwVwddVsgyvBj+j0n/yNYB86Md/0hfG37sJSK9uZ0ht
         hHEqGrqFXQB20Ed318fZ3Q0WkSfVGJ4ZrPiHrhJkOf5W338Av4i89Mn31KvvDLY3EW1a
         uI7g==
X-Gm-Message-State: APjAAAU8Mvxl4TLswRIwlh9w32Gk2+OcuRW/2iuSFbi5yu+jGvkBjP2X
        Au/WJsVVUe6ktT72InK8120=
X-Google-Smtp-Source: APXvYqzYTLFVHdX5q6Fiz/MrZkRduRgpQp//7RNqRPay/HdGtIJzJAfUf4tsSeVH5go79bWyKH5wMg==
X-Received: by 2002:ac8:6bca:: with SMTP id b10mr10905910qtt.254.1567102249069;
        Thu, 29 Aug 2019 11:10:49 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.195.212.176])
        by smtp.gmail.com with ESMTPSA id i25sm1480887qki.49.2019.08.29.11.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 11:10:48 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id AD2A041146; Thu, 29 Aug 2019 15:10:39 -0300 (-03)
Date:   Thu, 29 Aug 2019 15:10:39 -0300
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Julia Kartseva <hex@fb.com>, ast@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, rdna@fb.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: auto-split of commit. Was: [PATCH bpf-next 04/10] tools/bpf: add
 libbpf_prog_type_(from|to)_str helpers
Message-ID: <20190829181039.GD28011@kernel.org>
References: <cover.1567024943.git.hex@fb.com>
 <467620c966825173dbd65b37a3f9bd7dd4fb8184.1567024943.git.hex@fb.com>
 <20190828163422.3d167c4b@cakuba.netronome.com>
 <20190828234626.ltfy3qr2nne4uumy@ast-mbp.dhcp.thefacebook.com>
 <20190829065151.GB30423@kroah.com>
 <20190829171655.fww5qxtfusehcpds@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829171655.fww5qxtfusehcpds@ast-mbp.dhcp.thefacebook.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Aug 29, 2019 at 10:16:56AM -0700, Alexei Starovoitov escreveu:
> On Thu, Aug 29, 2019 at 08:51:51AM +0200, Greg Kroah-Hartman wrote:
> > That being said, from a "are you keeping the correct authorship info",
> > yes, it sounds like you are doing the correct thing here.

> > Look at what I do for stable kernels, I take the original commit and add
> > it to "another tree" keeping the original author and s-o-b chain intact,
> > and adding a "this is the original git commit id" type message to the
> > changelog text so that people can link it back to the original.
 
> I think you're describing 'git cherry-pick -x'.
> The question was about taking pieces of the original commit. Not the whole commit.
> Author field obviously stays, but SOB is questionable.
> If author meant to change X and Y and Z. Silently taking only Z chunk of the diff
> doesn't quite seem right.
> If we document that such commit split happens in Documentation/bpf/bpf_devel_QA.rst
> do you think it will be enough to properly inform developers?

Can't we instead establish the rule that for something to be added to
tools/include/ it should first land in a separate commit in include/,
ditto for the other things tools/ copies from the kernel sources.

That was the initial intention of tools/include/ and also that is how
tools/perf/check-headers.h works, warning when something ot out of sync,
etc.

I.e. the tools/ maintainers should refuse patches that touch both
tools/include and tools/.

wdyt?

- Arnaldo
