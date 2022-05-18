Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE0152B509
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiERIfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbiERIfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:35:07 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2B14DF79;
        Wed, 18 May 2022 01:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=dIJ3ZCJ8RiEmekQECGKajCdMDduhcY5uDKvjz33AJf8=;
        t=1652862905; x=1654072505; b=xig8p+kl+aWFlSm4QRKXEyvG8y5YQWuIRaXZehgpwDJWlC5
        B23WUKLRMOrrIydKCxWS+XEBIg4jlOlo+WS4cCDLY7waUMMNKzvy780bElagGrxCRBEXB0+OEG1Pt
        xYQP+d24WGYfhvWT59dPZoV8HAYEakSiXfAiMoQ2fu8j7P0IwRDqbIrEO9ld14hFjsX3Da5yAXNOG
        eu+LV5o6YpdBLPRstK2gC347kV/GxpFR9929Mc/5NnkiJG0V2NwJ7RCyiJsYE8fRbht1IHmppvXw/
        YAtiIEFEnoYPtWruUhIHvs2jTw6V2tbu0weokSHOWu0ejL6maR9685Lryl5wEUdA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nrF91-00FIFr-KA;
        Wed, 18 May 2022 10:34:59 +0200
Message-ID: <f3d20127a3e24f8f5e4a8faa559908c420a47117.camel@sipsolutions.net>
Subject: Re: [PATCH 06/10] rtw88: Add common USB chip support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        kernel@pengutronix.de, neo_jou <neo_jou@realtek.com>
Date:   Wed, 18 May 2022 10:34:58 +0200
In-Reply-To: <20220518083230.GR25578@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
         <20220518082318.3898514-7-s.hauer@pengutronix.de>
         <20220518083230.GR25578@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-18 at 10:32 +0200, Sascha Hauer wrote:
>=20
> >  	hw->wiphy->flags |=3D WIPHY_FLAG_SUPPORTS_TDLS |
> > +			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
> >  			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
>=20
> This change should be in a separate patch. I don't have an idea though
> what it's good for anyway. Is this change desired for the PCI variants
> as well or only for USB? Do we want to have this change at all?
>=20

This driver uses mac80211, so that change should just not be there.
mac80211 will set it automatically if it's possible, see in
net/mac80211/main.c.

johannes
