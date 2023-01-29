Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D005B67FF58
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 14:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbjA2N0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 08:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjA2N0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 08:26:35 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCCB1A4AB;
        Sun, 29 Jan 2023 05:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1674998783; bh=Q38jMOkyWKuY/IpUMNAkzzPVXDAh+9+tfSo0XYhWNbY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=WsuuQRcwAyRTxn/Ci+eBs6DlpQl9lqZoYI7wOFJAxV/aMtjRchMPzPDr+vhe3MGwo
         YV8OZw1AYt3Wzgzzq++rQqtRfkJPQU9FYPJ6x4K1gLouoUyLJuTB+yS8w0dabNcVM6
         rFeE5c9MwMTt6VM7yHCE5iRYHWD9tTNCnTXKeFB9jEpYtrHJserkZ5nRfNxt+MR8IB
         VufOPITZKWO53VveMJo1VrTQY2p0NmRPxA4LUBGxgeryslFzwskKGEbM/OLQuynJ4Y
         gaGKFk3ROg+ez9XssidbXAwNUSEaE5GSLpqOh0+QMOlaweIA25u9ngmGW5CMqj4JXG
         xEzHlTshDgYYA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([95.223.44.193]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MD9XF-1pVA6g0ZAf-0099Fv; Sun, 29
 Jan 2023 14:26:23 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] net: Add kerneldoc comment to napi_complete_done
Date:   Sun, 29 Jan 2023 14:26:18 +0100
Message-Id: <20230129132618.1361421-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QiC9h5jojdZvzGtSfUVkexs965laYcCfzf2bsW2PJpmdr2c7w6I
 i11be65HERuHkzytqsUz9guku7VZy2W2bLzNtORAvwwwB6SFa+cubMHB6NiR7N88H6y7hxD
 wv0f9JoTik44rQX7gJ6HP1SfB2916gjJI5lHNyxFMR6Gf7gawT/Nq+BPU4BEWJdrwWhVa/D
 pmAOn3WYwMXvAXZvpQGKQ==
UI-OutboundReport: notjunk:1;M01:P0:iJySu1Rp10g=;8+B9zMuSrQRw8DXU7ruOAwdHFub
 bEbsnG6DRaK29GidFPnBl6nukhaCgkq1kiqHp1Me6nwNCxNKmwgGwWHlGKWvg15EmdGA4I54m
 AEaRXwy1mbkdjt9g2HIicuJL8/SpKOnfVbTZM8IZtdv93U4/kwJDYfVm2zLf6I4tiPRT+52up
 e1+FTh4o6RM9apNAy13+k5dOFV/gxEh2aG73NiWyE8lRhAyWpkXviRPPZaCC7kbUqFsJEeBTd
 uySh16CXLsnxfkIP2rvViFx+DfEYxUu/OzGUke+aZ8f5uN5AiNORUwoYRt/rCPrCVeiEA00Vu
 kUzrRqi0A+dqYqPolMJXsNe3f6IsOebpf0Y0lLHbPSnGt9biiBwlbPDzNuWlKLJdLxLv5IX0l
 SmqrBPE6MIxnm2BpznAcn0MfZ8CnnJxIreSo8EBueMhF//Lu+7fnI7/4yJneSjHx4+jmMVHYl
 RDKVu1VAcyKsEcyLktcX4sYjpOHIcEtsR/+5OCXLuXzohWoj9IP33tr3b3K3eqACy+FPXaUeW
 vY+/5kT801RhengEYaLutu9PDPwn9ckDPN5eIjd2kQF/ZsSDnoSq8Z1tMXJu2iRYZFnDmwW9o
 IeboZ9uxUCJ0rujyboFLSo+2vXadnlnjgQL4tSd/a1qxsQ4VOloXiY39cbcGdIAelq8blgZsR
 1Hx3gs3wqBO4n/eWQ7E7PtngUEljOWVcGEGW7VcUhmR+cRzQ0rJC1DikWemiFssV0m8OKKLUn
 G67fFg3Gl3mL2L2O6uz8UuTtqDQO8zJIeVeGun3X3F6RgFAwcoV82Qzmqnv4IDnzlLu6wzgzd
 YGMqA+xoEnOKTGpXf7N2iJU8Me6q+aQwCImT8G278jGgUhKAMYsTP3rcmF6S6nSrp8SckbcfF
 m/ai4CmFqgFX+EalRIDE5O2QLGhCBNPOaUXDMdVEYUJ252nwpeBWW4s5RegB15DCtOzq8MIhA
 71J74X7FJjDJ21eaCFGOugsp+jA=
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document napi_complete_done, so that it shows up in HTML documentation.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 include/linux/netdevice.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index aad12a179e540..828e58791baa1 100644
=2D-- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -504,7 +504,16 @@ static inline bool napi_reschedule(struct napi_struct=
 *napi)
 	return false;
 }

+/**
+ *	napi_complete_done - NAPI processing complete
+ *	@n: NAPI context
+ *	@work_done: The number of packets that were processed
+ *
+ * Mark NAPI processing as complete.
+ * Return false if device should avoid rearming interrupts.
+ */
 bool napi_complete_done(struct napi_struct *n, int work_done);
+
 /**
  *	napi_complete - NAPI processing complete
  *	@n: NAPI context
=2D-
2.39.0

