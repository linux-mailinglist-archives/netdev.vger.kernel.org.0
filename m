Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCCA70FB5
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbfGWDNw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jul 2019 23:13:52 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:49058 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfGWDNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:13:51 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x6N3DcZF028915, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x6N3DcZF028915
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 23 Jul 2019 11:13:38 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0439.000; Tue, 23 Jul 2019 11:13:38 +0800
From:   Pkshih <pkshih@realtek.com>
To:     David Binderman <dcb314@hotmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8*/sw.c: many redundant assignments ?
Thread-Topic: linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8*/sw.c:
 many redundant assignments ?
Thread-Index: AQHVQGUFo+pdPg0s6Um56sOsyVqY46bXh/kA
Date:   Tue, 23 Jul 2019 03:13:37 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D1D5C1BC7F@RTITMBSVM04.realtek.com.tw>
References: <DB7PR08MB38011180E04CCB548A2316159CC40@DB7PR08MB3801.eurprd08.prod.outlook.com>
In-Reply-To: <DB7PR08MB38011180E04CCB548A2316159CC40@DB7PR08MB3801.eurprd08.prod.outlook.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.114]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: David Binderman [mailto:dcb314@hotmail.com]
> Sent: Monday, July 22, 2019 4:12 PM
> To: Pkshih; kvalo@codeaurora.org; davem@davemloft.net; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8*/sw.c: many redundant assignments ?
> 
> Hello there,
> 
> > [linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c:120]: (warning) Redundant
> assignment of 'rtlpriv->cfg->mod_params->disable_watchdog' to itself.
> > [linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c:134]: (warning) Redundant
> assignment of 'rtlpriv->cfg->mod_params->disable_watchdog' to itself.
> > [linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c:133]: (warning) Redundant
> assignment of 'rtlpriv->cfg->mod_params->disable_watchdog' to itself.
> > [linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c:150]: (warning) Redundant
> assignment of 'rtlpriv->cfg->mod_params->disable_watchdog' to itself.
> > [linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c:118]: (warning) Redundant
> assignment of 'rtlpriv->cfg->mod_params->sw_crypto' to itself.
> > [linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c:116]: (warning) Redundant
> assignment of 'rtlpriv->cfg->mod_params->sw_crypto' to itself.
> > [linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c:42]: (warning) Redundant
> assignment of 'rtlpriv->cfg->mod_params->sw_crypto' to itself.
> > [linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c:164]: (warning) Redundant
> assignment of 'rtlpriv->cfg->mod_params->sw_crypto' to itself.
> > [linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c:132]: (warning) Redundant
> assignment of 'rtlpriv->cfg->mod_params->sw_crypto' to itself.
> > [linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c:131]: (warning) Redundant
> assignment of 'rtlpriv->cfg->mod_params->sw_crypto' to itself.
> > [linux-5.2.2/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c:148]: (warning) Redundant
> assignment of 'rtlpriv->cfg->mod_params->sw_crypto' to itself.
> 
> Might be worth a look
> 

I send a patch to fix it.
https://patchwork.kernel.org/patch/11053745/

Thank you.

---
PK

