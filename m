Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB64F677E15
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjAWOb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbjAWOb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:31:58 -0500
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BE3C64C;
        Mon, 23 Jan 2023 06:31:57 -0800 (PST)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 316C2104841C;
        Mon, 23 Jan 2023 17:31:55 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 316C2104841C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1674484315; bh=h57s7zxPueQ/WaUzP0DIV44jkjXvbC4rM4m6NnFYSh8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DKuOEIZmHTZvj2q86LOmAsNduH4lJAWiZayRQd47P94M8cd2DfJ9K+OQuY0ymg/xD
         6cXUgAGIIf9I2oO2fsB2zVB/V2ET16QHWIfzSb0q6JoVwnGooX6jGWv+FnfP8c3mIO
         EjTwD52ouDiPUUXZGAsXiiMNoAZvJJ9MWQw98Vn4=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
        by mx0.infotecs-nt (Postfix) with ESMTP id 2D7D5316A0CB;
        Mon, 23 Jan 2023 17:31:55 +0300 (MSK)
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     "leon@kernel.org" <leon@kernel.org>
CC:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "fw@strlen.de" <fw@strlen.de>, "joe@perches.com" <joe@perches.com>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Subject: [PATCH v2] netfilter: conntrack: remote a return value of the
 'seq_print_acct' function.
Thread-Topic: [PATCH v2] netfilter: conntrack: remote a return value of the
 'seq_print_acct' function.
Thread-Index: AQHZLzdwu2dpvZ83O0uhtAvrU7ziYQ==
Date:   Mon, 23 Jan 2023 14:31:54 +0000
Message-ID: <20230123143202.1785569-1-Ilia.Gavrilov@infotecs.ru>
References: <Y86Lji5prQEAxKLi@unreal>
In-Reply-To: <Y86Lji5prQEAxKLi@unreal>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 174927 [Jan 23 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;infotecs.ru:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/01/23 12:45:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/01/23 00:37:00 #20794104
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The static 'seq_print_acct' function always returns 0.

Change the return value to 'void' and remove unnecessary checks.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: 1ca9e41770cb ("netfilter: Remove uses of seq_<foo> return values")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
---
V2: Fix coding style
 net/netfilter/nf_conntrack_standalone.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_con=
ntrack_standalone.c
index 0250725e38a4..6819d07f9692 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -275,7 +275,7 @@ static const char* l4proto_name(u16 proto)
 	return "unknown";
 }
=20
-static unsigned int
+static void
 seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
 {
 	struct nf_conn_acct *acct;
@@ -283,14 +283,12 @@ seq_print_acct(struct seq_file *s, const struct nf_co=
nn *ct, int dir)
=20
 	acct =3D nf_conn_acct_find(ct);
 	if (!acct)
-		return 0;
+		return;
=20
 	counter =3D acct->counter;
 	seq_printf(s, "packets=3D%llu bytes=3D%llu ",
 		   (unsigned long long)atomic64_read(&counter[dir].packets),
 		   (unsigned long long)atomic64_read(&counter[dir].bytes));
-
-	return 0;
 }
=20
 /* return 0 on success, 1 in case of error */
@@ -342,8 +340,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (seq_has_overflowed(s))
 		goto release;
=20
-	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
-		goto release;
+	seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL);
=20
 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
 		seq_puts(s, "[UNREPLIED] ");
@@ -352,8 +349,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
=20
 	ct_show_zone(s, ct, NF_CT_ZONE_DIR_REPL);
=20
-	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
-		goto release;
+	seq_print_acct(s, ct, IP_CT_DIR_REPLY);
=20
 	if (test_bit(IPS_HW_OFFLOAD_BIT, &ct->status))
 		seq_puts(s, "[HW_OFFLOAD] ");
--=20
2.30.2
