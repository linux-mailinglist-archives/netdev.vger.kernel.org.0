Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F2929194B
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgJRTQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgJRTQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 15:16:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA33C061755;
        Sun, 18 Oct 2020 12:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jSZ48E7Pk5au6oJE5B/SpoPyGzHAu2LHc5e92XLrkbA=; b=iJ9Ua4Sb+7c2gBb5X093C2g3JF
        uPXvpy94QM9OfF4QdLHnbdoyPK+foTfLSCfptUIJX1L1QmBGwqRRLC+FO4yttdeacV1S+hl8hKo0C
        WTqtwQkEZQTbeO+X3m7Juje7eQPdNT7ZY2bxJ15gxf5bGTukHh/PFeI2Wotfd6qSzqn3KwhwiSJ8q
        nHMmLI1n6mOTyu1OQHnDgD5bqj+pk9E7DasCqQG55sL9hd/rW8umvQBQI/4FGFQAjFO02dSWITtwv
        yXkpHo9Iys1nXXFCivdyuKxTY6HM4UcykOYUxv1R/rziPsZPtETfWCfkBycLom8Snu0zA9/3jwQkF
        l4f6J+YQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kUEAE-0008Qi-Sy; Sun, 18 Oct 2020 19:16:19 +0000
Date:   Sun, 18 Oct 2020 20:16:18 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     trix@redhat.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, clang-built-linux@googlegroups.com,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        storagedev@microchip.com, dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
        ath10k@lists.infradead.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-stm32@st-md-mailman.stormreply.com,
        usb-storage@lists.one-eyed-alien.net,
        linux-watchdog@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvdimm@lists.01.org, amd-gfx@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        industrypack-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, spice-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-nfc@lists.01.org, linux-pm@vger.kernel.org,
        linux-can@vger.kernel.org, linux-block@vger.kernel.org,
        linux-gpio@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-amlogic@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, patches@opensource.cirrus.com,
        bpf@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-power@fi.rohmeurope.com
Subject: Re: [Ocfs2-devel] [RFC] treewide: cleanup unreachable breaks
Message-ID: <20201018191618.GO20115@casper.infradead.org>
References: <20201017160928.12698-1-trix@redhat.com>
 <20201018185943.GM20115@casper.infradead.org>
 <45efa7780c79972eae9ca9bdeb9f7edbab4f3643.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45efa7780c79972eae9ca9bdeb9f7edbab4f3643.camel@HansenPartnership.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 12:13:35PM -0700, James Bottomley wrote:
> On Sun, 2020-10-18 at 19:59 +0100, Matthew Wilcox wrote:
> > On Sat, Oct 17, 2020 at 09:09:28AM -0700, trix@redhat.com wrote:
> > > clang has a number of useful, new warnings see
> > > https://urldefense.com/v3/__https://clang.llvm.org/docs/DiagnosticsReference.html__;!!GqivPVa7Brio!Krxz78O3RKcB9JBMVo_F98FupVhj_jxX60ddN6tKGEbv_cnooXc1nnBmchm-e_O9ieGnyQ$ 
> > 
> > Please get your IT department to remove that stupidity.  If you
> > can't, please send email from a non-Red Hat email address.
> 
> Actually, the problem is at Oracle's end somewhere in the ocfs2 list
> ... if you could fix it, that would be great.  The usual real mailing
> lists didn't get this transformation
> 
> https://lore.kernel.org/bpf/20201017160928.12698-1-trix@redhat.com/
> 
> but the ocfs2 list archive did:
> 
> https://oss.oracle.com/pipermail/ocfs2-devel/2020-October/015330.html
> 
> I bet Oracle IT has put some spam filter on the list that mangles URLs
> this way.

*sigh*.  I'm sure there's a way.  I've raised it with someone who should
be able to fix it.
