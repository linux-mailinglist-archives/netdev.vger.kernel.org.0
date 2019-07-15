Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E0168376
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 08:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfGOGRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 02:17:05 -0400
Received: from smtp3.goneo.de ([85.220.129.37]:36750 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfGOGRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 02:17:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id C2C2623F2CD;
        Mon, 15 Jul 2019 08:17:00 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -2.761
X-Spam-Level: 
X-Spam-Status: No, score=-2.761 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=0.139, BAYES_00=-1.9] autolearn=ham
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9DTgEevx57Ss; Mon, 15 Jul 2019 08:16:59 +0200 (CEST)
Received: from [192.168.1.127] (dyndsl-091-248-140-021.ewe-ip-backbone.de [91.248.140.21])
        by smtp3.goneo.de (Postfix) with ESMTPSA id 7016023F001;
        Mon, 15 Jul 2019 08:16:54 +0200 (CEST)
Subject: Re: [PATCH 8/8] docs: remove extra conf.py files
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
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
References: <cover.1563115732.git.mchehab+samsung@kernel.org>
 <12a160afc9e70156f671010bd4ccff9311acdc5e.1563115732.git.mchehab+samsung@kernel.org>
From:   Markus Heiser <markus.heiser@darmarit.de>
Message-ID: <e3ff0a8a-6956-3855-07be-9c126df2da2d@darmarit.de>
Date:   Mon, 15 Jul 2019 08:16:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <12a160afc9e70156f671010bd4ccff9311acdc5e.1563115732.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro,

sorry, I havn't tested your patch, but one question ...

Am 14.07.19 um 17:10 schrieb Mauro Carvalho Chehab:
> Now that the latex_documents are handled automatically, we can
> remove those extra conf.py files.

We need these conf.py also for compiling books' into HTML.  For this
the tags.add("subproject") is needed.  Should we realy drop this feature?

-- Markus --
