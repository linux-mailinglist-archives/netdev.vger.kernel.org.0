Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27622684A9
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 09:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbfGOH5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 03:57:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34870 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfGOH5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 03:57:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eJlbjim1fxU57ZaVX/VVgKi/dG9GtJerPxx9UJo7Fww=; b=JcDzLwBGAR3DIQ5PzjliPmdfB
        wt3f3sg2z3AO/OuERhsRmMQS2qwxDHfr81HUZ8bO4iiwRmK3RrOm2h4/5DNGgtFEZDvuz7A8dJNNm
        8SC+KQ1Nwm9BOBk47L69bPbiRtcflOhdeLDtFR53AOVtvZ10BSu6RTR+jOSoexCb+TOn62JzVO7/Z
        O55lv0FaRBBJ2LYyXSZdelp0ocAQap0NW6KHdOxn0lTVtf8TDPBJOZV7LLeVVU8RcXQa7O955vRo5
        mleM8mlHWSbuEWzj/LK75trdO7CY3hdfI2sN1X09S7ln7kgJuHQUi7kWjs9YHKWyAOp1nM2lXWTrS
        FqvVaEtvQ==;
Received: from [189.27.46.152] (helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hmvrD-0003qC-8d; Mon, 15 Jul 2019 07:57:11 +0000
Date:   Mon, 15 Jul 2019 04:57:02 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Markus Heiser <markus.heiser@darmarit.de>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-sh@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 8/8] docs: remove extra conf.py files
Message-ID: <20190715045702.1e2b569b@coco.lan>
In-Reply-To: <e3ff0a8a-6956-3855-07be-9c126df2da2d@darmarit.de>
References: <cover.1563115732.git.mchehab+samsung@kernel.org>
        <12a160afc9e70156f671010bd4ccff9311acdc5e.1563115732.git.mchehab+samsung@kernel.org>
        <e3ff0a8a-6956-3855-07be-9c126df2da2d@darmarit.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, 15 Jul 2019 08:16:54 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Hi Mauro,
> 
> sorry, I havn't tested your patch, but one question ...
> 
> Am 14.07.19 um 17:10 schrieb Mauro Carvalho Chehab:
> > Now that the latex_documents are handled automatically, we can
> > remove those extra conf.py files.  
> 
> We need these conf.py also for compiling books' into HTML.  For this
> the tags.add("subproject") is needed.  Should we realy drop this feature?
> 
> -- Markus --

You're right: adding "subproject" tags is needed for html. Folding this
to patch 7/8 makes both htmldocs and pdfdocs to work with SPHINXDIRS
without the need of a per-subdir conf.py.

Regards,
Mauro

diff --git a/Documentation/sphinx/load_config.py b/Documentation/sphinx/load_config.py
index 75f527ff4c95..e4a04f367b41 100644
--- a/Documentation/sphinx/load_config.py
+++ b/Documentation/sphinx/load_config.py
@@ -51,3 +51,7 @@ def loadConfig(namespace):
             execfile_(config_file, config)
             del config['__file__']
             namespace.update(config)
+        else:
+            config = namespace.copy()
+            config['tags'].add("subproject")
+            namespace.update(config)

Thanks,
Mauro
