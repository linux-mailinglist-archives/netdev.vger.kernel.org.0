Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B2A43097D
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 15:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343767AbhJQNz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 09:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242336AbhJQNz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 09:55:27 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCDDC061765;
        Sun, 17 Oct 2021 06:53:17 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1mc6au-0004Ux-Ep; Sun, 17 Oct 2021 15:52:58 +0200
Date:   Sun, 17 Oct 2021 14:52:22 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Nick <vincent@systemli.org>, Kalle Valo <kvalo@codeaurora.org>,
        nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>
Subject: Re: Re: [RFC v2] mt76: mt7615: mt7622: fix ibss and meshpoint
Message-ID: <YWwqlk6rGbEp1obc@makrotopia.org>
References: <20211007225725.2615-1-vincent@systemli.org>
 <87czoe61kh.fsf@codeaurora.org>
 <274013cd-29e4-9202-423b-bd2b2222d6b8@systemli.org>
 <YWGXiExg1uBIFr2c@makrotopia.org>
 <trinity-b64203a5-8e23-4d1c-afd1-a29afa69f8f6-1634473696601@3c-app-gmx-bs33>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-b64203a5-8e23-4d1c-afd1-a29afa69f8f6-1634473696601@3c-app-gmx-bs33>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 17, 2021 at 02:28:16PM +0200, Frank Wunderlich wrote:
> > Gesendet: Samstag, 09. Oktober 2021 um 15:22 Uhr
> > Von: "Daniel Golle" <daniel@makrotopia.org>
> 
> > Does Mesh+AP or Ad-Hoc+AP also work on MT7622 and does it still work on
> > MT7615E card with your patch applied?
> 
> tested bananapi-r2 with mt7615 and bananapi-r64 with internal mt7622-wmac
> 
> ibss/ad-hoc: working
> AP-Mode: still working

Independently of each other or simultanously?
What I meant was to ask if **simultanous** Mesh+AP or Ad-Hoc+AP still
works on MT7615E (you can only test that with OpenWrt-patched hostapd
or by using wpa_supplicant to setup the AP as well as mesh/ad-hoc
interface by settings in wpa_supplicant.conf)
