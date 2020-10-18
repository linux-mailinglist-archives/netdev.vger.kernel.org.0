Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C677C291C0F
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732996AbgJRTfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731460AbgJRTZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 15:25:55 -0400
X-Greylist: delayed 471 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 18 Oct 2020 12:25:54 PDT
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4D8C061755;
        Sun, 18 Oct 2020 12:25:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 7A1D5128046A;
        Sun, 18 Oct 2020 12:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1603048682;
        bh=aTHhEGSm6DrUFNt/hKuOWL0f+WzaMvx/rc4IP5RJYRs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WcP5INjnqihCMCJ+2ZkHdzEWBsqi3wavZOcf0NGlcoun37UNiQ4GoZk+2AoMrr8hd
         1s2t7Y8IzQcDUGm581+QcIuy/enpzpZm6HswhyX4zoKl9l3S5fk96frr/LU4I9kVw8
         r8s7AtR/5wOGbwEsua/QdQrVgo3j6VSqYIXYukhg=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ywWMwLsGscQI; Sun, 18 Oct 2020 12:18:02 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 340C31280456;
        Sun, 18 Oct 2020 12:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1603048682;
        bh=aTHhEGSm6DrUFNt/hKuOWL0f+WzaMvx/rc4IP5RJYRs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WcP5INjnqihCMCJ+2ZkHdzEWBsqi3wavZOcf0NGlcoun37UNiQ4GoZk+2AoMrr8hd
         1s2t7Y8IzQcDUGm581+QcIuy/enpzpZm6HswhyX4zoKl9l3S5fk96frr/LU4I9kVw8
         r8s7AtR/5wOGbwEsua/QdQrVgo3j6VSqYIXYukhg=
Message-ID: <0a739bcd421a3154c2521b49779b287e6c0d08a2.camel@HansenPartnership.com>
Subject: Re: [Ocfs2-devel] [RFC] treewide: cleanup unreachable breaks
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Matthew Wilcox <willy@infradead.org>
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
Date:   Sun, 18 Oct 2020 12:17:59 -0700
In-Reply-To: <20201018191618.GO20115@casper.infradead.org>
References: <20201017160928.12698-1-trix@redhat.com>
         <20201018185943.GM20115@casper.infradead.org>
         <45efa7780c79972eae9ca9bdeb9f7edbab4f3643.camel@HansenPartnership.com>
         <20201018191618.GO20115@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-10-18 at 20:16 +0100, Matthew Wilcox wrote:
> On Sun, Oct 18, 2020 at 12:13:35PM -0700, James Bottomley wrote:
> > On Sun, 2020-10-18 at 19:59 +0100, Matthew Wilcox wrote:
> > > On Sat, Oct 17, 2020 at 09:09:28AM -0700, trix@redhat.com wrote:
> > > > clang has a number of useful, new warnings see
> > > > https://urldefense.com/v3/__https://clang.llvm.org/docs/DiagnosticsReference.html__;!!GqivPVa7Brio!Krxz78O3RKcB9JBMVo_F98FupVhj_jxX60ddN6tKGEbv_cnooXc1nnBmchm-e_O9ieGnyQ$ 
> > > 
> > > Please get your IT department to remove that stupidity.  If you
> > > can't, please send email from a non-Red Hat email address.
> > 
> > Actually, the problem is at Oracle's end somewhere in the ocfs2
> > list ... if you could fix it, that would be great.  The usual real
> > mailing lists didn't get this transformation
> > 
> > https://lore.kernel.org/bpf/20201017160928.12698-1-trix@redhat.com/
> > 
> > but the ocfs2 list archive did:
> > 
> > https://oss.oracle.com/pipermail/ocfs2-devel/2020-October/015330.html
> > 
> > I bet Oracle IT has put some spam filter on the list that mangles
> > URLs this way.
> 
> *sigh*.  I'm sure there's a way.  I've raised it with someone who
> should be able to fix it.

As someone who works for IBM I can only say I feel your pain ...

James


