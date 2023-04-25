Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9846E6EE1F5
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbjDYMfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbjDYMff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:35:35 -0400
X-Greylist: delayed 900 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Apr 2023 05:35:33 PDT
Received: from mx01-sz.bfs.de (mx01-sz.bfs.de [194.94.69.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3997212B;
        Tue, 25 Apr 2023 05:35:33 -0700 (PDT)
Received: from SRVEX01-MUC.bfs.intern (unknown [10.161.90.31])
        by mx01-sz.bfs.de (Postfix) with ESMTPS id A6FD420752;
        Tue, 25 Apr 2023 14:10:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1682424631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ce7NVq8nwePgbuk3nSva2AqTwHTxJcrzIkM0P/5Y34w=;
        b=TgqJ8YTZyVEgVXuZue1WypK+dEUgaK6TZy2NMGxIobSduAxBio2ruUOPS3CmuRtjs1cJbY
        0Nm2tkAd1z9LzveQVowC+ijV7/6CDjQW3fQIPQRl2zMBlhvb541YYiSoysvR/Tgz8amYb4
        oX47TG0pyF6upnuh+fYBBQ3Raev8L7ePnE2WjyXkzvk3zp7eYwk+zi0HCR0PbZTSGLnjmx
        /MdKyKFTxhukgsrL1kYdBWPpBvX9AI2VZ+k2UotnXZfwynIPH9ZZ7kyhtEShyFHA1e0gnd
        JvWwV49+8hyB9BTUL0GWDs5PTIX16ixcCRiV5jl/I0YbH0gLvKkniTuFIT0RiQ==
Authentication-Results: mx01-sz.bfs.de;
        none
Received: from SRVEX01-MUC.bfs.intern (10.161.90.31) by SRVEX01-MUC.bfs.intern
 (10.161.90.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.23; Tue, 25 Apr
 2023 14:10:31 +0200
Received: from SRVEX01-MUC.bfs.intern ([fe80::e8ba:5ab1:557f:4aad]) by
 SRVEX01-MUC.bfs.intern ([fe80::e8ba:5ab1:557f:4aad%5]) with mapi id
 15.01.2507.023; Tue, 25 Apr 2023 14:10:31 +0200
From:   Walter Harms <wharms@bfs.de>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "ath12k@lists.infradead.org" <ath12k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: AW: [PATCH] wifi: ath12k: Remove some dead code
Thread-Topic: [PATCH] wifi: ath12k: Remove some dead code
Thread-Index: AQHZd20t3s5fXpiW0UuWPmJZ+6i/x6877q83
Date:   Tue, 25 Apr 2023 12:10:31 +0000
Message-ID: <d0c5ed33fb1644328fbdc5d7aba20a97@bfs.de>
References: <c17edf0811156a33bae6c5cf1906d751cc87edd4.1682423828.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <c17edf0811156a33bae6c5cf1906d751cc87edd4.1682423828.git.christophe.jaillet@wanadoo.fr>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.128.48]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spamd-Result: default: False [-18.00 / 7.00];
        WHITELIST_LOCAL_IP(-15.00)[10.161.90.31];
        BAYES_HAM(-3.00)[99.99%];
        RCVD_NO_TLS_LAST(0.10)[];
        MIME_GOOD(-0.10)[text/plain];
        FREEMAIL_TO(0.00)[wanadoo.fr,kernel.org,davemloft.net,google.com,redhat.com];
        NEURAL_HAM(-0.00)[-1.000];
        HAS_XOIP(0.00)[];
        MIME_TRACE(0.00)[0:+];
        FROM_EQ_ENVFROM(0.00)[];
        RCVD_COUNT_TWO(0.00)[2];
        TO_DN_EQ_ADDR_SOME(0.00)[];
        RCPT_COUNT_SEVEN(0.00)[11];
        DKIM_SIGNED(0.00)[bfs.de:s=dkim201901];
        FROM_HAS_DN(0.00)[];
        MID_RHS_MATCH_FROM(0.00)[];
        TO_DN_SOME(0.00)[];
        TO_MATCH_ENVRCPT_ALL(0.00)[];
        FREEMAIL_ENVRCPT(0.00)[wanadoo.fr];
        ARC_NA(0.00)[]
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Does  mcs =3D ATH12K_HE_MCS_MAX make sense ?

re,
 wh
________________________________________
Von: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Gesendet: Dienstag, 25. April 2023 13:57:19
An: Kalle Valo; David S. Miller; Eric Dumazet; Jakub Kicinski; Paolo Abeni
Cc: linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Christop=
he JAILLET; ath12k@lists.infradead.org; linux-wireless@vger.kernel.org; net=
dev@vger.kernel.org
Betreff: [PATCH] wifi: ath12k: Remove some dead code

ATH12K_HE_MCS_MAX =3D 11, so this test and the following one are the same.
Remove the one with the hard coded 11 value.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless=
/ath/ath12k/dp_rx.c
index e78478a5b978..79386562562f 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1362,11 +1362,6 @@ ath12k_update_per_peer_tx_stats(struct ath12k *ar,
         * Firmware rate's control to be skipped for this?
         */

-       if (flags =3D=3D WMI_RATE_PREAMBLE_HE && mcs > 11) {
-               ath12k_warn(ab, "Invalid HE mcs %d peer stats",  mcs);
-               return;
-       }
-
        if (flags =3D=3D WMI_RATE_PREAMBLE_HE && mcs > ATH12K_HE_MCS_MAX) {
                ath12k_warn(ab, "Invalid HE mcs %d peer stats",  mcs);
                return;
--
2.34.1

