Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9403F3F19DF
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhHSM7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:59:53 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:53777 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhHSM7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 08:59:52 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 17JCxCtC5031868, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 17JCxCtC5031868
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Aug 2021 20:59:12 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 19 Aug 2021 20:59:11 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Thu, 19 Aug
 2021 20:59:10 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <linux-firmware@kernel.org>
CC:     <nic_swsd@realtek.com>, <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH linux-firmware] rtl_nic: update firmware of RTL8153C
Date:   Thu, 19 Aug 2021 20:58:22 +0800
Message-ID: <20210819125822.6899-380-nic_swsd@realtek.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXH36501.realtek.com.tw (172.21.6.27) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/19/2021 12:45:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzgvMTkgpFekyCAxMDoxNjowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/19/2021 12:42:01
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165664 [Aug 19 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/19/2021 12:45:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- rtl8153c-1 v2 08/19/21:
    1. Update the firmware of RTL_FW_USB.
    2. Set bp_en_addr of RTL_FW_PLA to 0xfc48.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 rtl_nic/rtl8153c-1.fw | Bin 816 -> 832 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)

diff --git a/rtl_nic/rtl8153c-1.fw b/rtl_nic/rtl8153c-1.fw
index 5c3d1c468e5307c588ff347b57f7d0ca719f8341..e2b5d74f8c051a8bb4eefc1d742388701b5aa015 100644
GIT binary patch
delta 224
zcmdnMc7QFxq>sDKZB4b|<Az(|@`4U4KkRudH|HMLs{d=u6wf>_xLs6|V_|4&oUCi8
zP-diHV4-hlsc&S+00&G!)(1ugh6DzNXKH^K7I^&OXVCb=!f;OER*VV98|jIO(k=|w
z&odbr7#YSJ7#kYJ2l<$p8(KQXr{xzVr^b5(#}_1)Bxf)PJg9sy{lUx!3mz<bu;jtA
z2P+<|da&lfx(6E`Y<jTe!M2UtB^d=A5*j=jJ(@fmI+zYI?D`-*`2wTN<X=oWf<Ol_
UZ~%!228JI%S2TD`He~t_0AJNrX#fBK

delta 205
zcmX@Wwt+29E63&t=i_A6`yHVR7j3>jOG|o#lN`&Y>ir?+Rwn(mK}97w7KWzA$-0IL
zWrhj{#`?yF`bLHfaKHp)Jz!*Dh+trNruK(nfyW<q28}<=4CfSX#h7qROq8|*D!6{0
zF*MjIJ|M9qIV0XVKP5H3xGc}u*u<Qn`@g`0$_LXQ%zQBW!Q2P)A1r*Z_`%W#%O9+K
vu=>H;2kRef+_+zoaq>GxvC01!*?`zcn1KOk8v_T#${#>08!RR}GW`bt*oI66

-- 
2.31.1

