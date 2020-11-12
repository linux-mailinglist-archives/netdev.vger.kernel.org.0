Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BFD2B0582
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgKLM7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:59:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728384AbgKLM70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:59:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WoSb32kjs+HkCDM7/fcpglBleXtzkTO/HB6K14aykcc=;
        b=Hpufy3QUUcwJ636DgUkR8ApvNJlqITrFZbgKQVbHgZpiT+GTSv+Pl7rfkMCe1VldmfqRGh
        5g1N1NLfEM7Mi5l69ef5QzhEGsfEtkh+mnbRbhu7+REmz0KnD/VsFCHiuz5zgQ1pp9U76P
        A5ljLYHrLGaDBk/WNYyOO1aXxB2Je54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-pfyv39bUNAampm5-fnZTTg-1; Thu, 12 Nov 2020 07:59:20 -0500
X-MC-Unique: pfyv39bUNAampm5-fnZTTg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D68931016CE5;
        Thu, 12 Nov 2020 12:59:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D55B35D9E4;
        Thu, 12 Nov 2020 12:59:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 11/18] crypto/krb5: Add the AES self-testing data from rfc8009
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:59:15 +0000
Message-ID: <160518595508.2277919.15065092736353629314.stgit@warthog.procyon.org.uk>
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the self-testing data from rfc8009 to test AES + HMAC-SHA2.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/krb5/selftest_data.c |  116 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/crypto/krb5/selftest_data.c b/crypto/krb5/selftest_data.c
index 9085723b730b..00c3b38c01d8 100644
--- a/crypto/krb5/selftest_data.c
+++ b/crypto/krb5/selftest_data.c
@@ -13,6 +13,20 @@
  * Pseudo-random function tests.
  */
 const struct krb5_prf_test krb5_prf_tests[] = {
+	/* rfc8009 Appendix A */
+	{
+		.krb5	= &krb5_aes128_cts_hmac_sha256_128,
+		.name	= "prf",
+		.key	= "3705D96080C17728A0E800EAB6E0D23C",
+		.octet	= "74657374",
+		.prf	= "9D188616F63852FE86915BB840B4A886FF3E6BB0F819B49B893393D393854295",
+	}, {
+		.krb5	= &krb5_aes256_cts_hmac_sha384_192,
+		.name	= "prf",
+		.key	= "6D404D37FAF79F9DF0D33568D320669800EB4836472EA8A026D16B7182460C52",
+		.octet	= "74657374",
+		.prf	= "9801F69A368C2BF675E59521E177D9A07F67EFE1CFDE8D3C8D6F6A0256E3B17DB3C1B62AD1B8553360D17367EB1514D2",
+	},
 	{/* END */}
 };
 
@@ -20,6 +34,28 @@ const struct krb5_prf_test krb5_prf_tests[] = {
  * Key derivation tests.
  */
 const struct krb5_key_test krb5_key_tests[] = {
+	/* rfc8009 Appendix A */
+	{
+		.krb5	= &krb5_aes128_cts_hmac_sha256_128,
+		.name	= "key",
+		.key	= "3705D96080C17728A0E800EAB6E0D23C",
+		.Kc.use	= 0x00000002,
+		.Kc.key	= "B31A018A48F54776F403E9A396325DC3",
+		.Ke.use	= 0x00000002,
+		.Ke.key	= "9B197DD1E8C5609D6E67C3E37C62C72E",
+		.Ki.use	= 0x00000002,
+		.Ki.key	= "9FDA0E56AB2D85E1569A688696C26A6C",
+	}, {
+		.krb5	= &krb5_aes256_cts_hmac_sha384_192,
+		.name	= "key",
+		.key	= "6D404D37FAF79F9DF0D33568D320669800EB4836472EA8A026D16B7182460C52",
+		.Kc.use	= 0x00000002,
+		.Kc.key	= "EF5718BE86CC84963D8BBB5031E9F5C4BA41F28FAF69E73D",
+		.Ke.use	= 0x00000002,
+		.Ke.key	= "56AB22BEE63D82D7BC5227F6773F8EA7A5EB1C825160C38312980C442E5C7E49",
+		.Ki.use	= 0x00000002,
+		.Ki.key	= "69B16514E3CD8E56B82010D5C73012B622C4D00FFC23ED1F",
+	},
 	{/* END */}
 };
 
@@ -27,6 +63,72 @@ const struct krb5_key_test krb5_key_tests[] = {
  * Encryption tests.
  */
 const struct krb5_enc_test krb5_enc_tests[] = {
+	/* rfc8009 Appendix A */
+	{
+		.krb5	= &krb5_aes128_cts_hmac_sha256_128,
+		.name	= "enc no plain",
+		.plain	= "",
+		.conf	= "7E5895EAF2672435BAD817F545A37148",
+		.Ke	= "9B197DD1E8C5609D6E67C3E37C62C72E",
+		.Ki	= "9FDA0E56AB2D85E1569A688696C26A6C",
+		.ct	= "EF85FB890BB8472F4DAB20394DCA781DAD877EDA39D50C870C0D5A0A8E48C718",
+	}, {
+		.krb5	= &krb5_aes128_cts_hmac_sha256_128,
+		.name	= "enc plain<block",
+		.plain	= "000102030405",
+		.conf	= "7BCA285E2FD4130FB55B1A5C83BC5B24",
+		.Ke	= "9B197DD1E8C5609D6E67C3E37C62C72E",
+		.Ki	= "9FDA0E56AB2D85E1569A688696C26A6C",
+		.ct	= "84D7F30754ED987BAB0BF3506BEB09CFB55402CEF7E6877CE99E247E52D16ED4421DFDF8976C",
+	}, {
+		.krb5	= &krb5_aes128_cts_hmac_sha256_128,
+		.name	= "enc plain==block",
+		.plain	= "000102030405060708090A0B0C0D0E0F",
+		.conf	= "56AB21713FF62C0A1457200F6FA9948F",
+		.Ke	= "9B197DD1E8C5609D6E67C3E37C62C72E",
+		.Ki	= "9FDA0E56AB2D85E1569A688696C26A6C",
+		.ct	= "3517D640F50DDC8AD3628722B3569D2AE07493FA8263254080EA65C1008E8FC295FB4852E7D83E1E7C48C37EEBE6B0D3",
+	}, {
+		.krb5	= &krb5_aes128_cts_hmac_sha256_128,
+		.name	= "enc plain>block",
+		.plain	= "000102030405060708090A0B0C0D0E0F1011121314",
+		.conf	= "A7A4E29A4728CE10664FB64E49AD3FAC",
+		.Ke	= "9B197DD1E8C5609D6E67C3E37C62C72E",
+		.Ki	= "9FDA0E56AB2D85E1569A688696C26A6C",
+		.ct	= "720F73B18D9859CD6CCB4346115CD336C70F58EDC0C4437C5573544C31C813BCE1E6D072C186B39A413C2F92CA9B8334A287FFCBFC",
+	}, {
+		.krb5	= &krb5_aes256_cts_hmac_sha384_192,
+		.name	= "enc no plain",
+		.plain	= "",
+		.conf	= "F764E9FA15C276478B2C7D0C4E5F58E4",
+		.Ke	= "56AB22BEE63D82D7BC5227F6773F8EA7A5EB1C825160C38312980C442E5C7E49",
+		.Ki	= "69B16514E3CD8E56B82010D5C73012B622C4D00FFC23ED1F",
+		.ct	= "41F53FA5BFE7026D91FAF9BE959195A058707273A96A40F0A01960621AC612748B9BBFBE7EB4CE3C",
+	}, {
+		.krb5	= &krb5_aes256_cts_hmac_sha384_192,
+		.name	= "enc plain<block",
+		.plain	= "000102030405",
+		.conf	= "B80D3251C1F6471494256FFE712D0B9A",
+		.Ke	= "56AB22BEE63D82D7BC5227F6773F8EA7A5EB1C825160C38312980C442E5C7E49",
+		.Ki	= "69B16514E3CD8E56B82010D5C73012B622C4D00FFC23ED1F",
+		.ct	= "4ED7B37C2BCAC8F74F23C1CF07E62BC7B75FB3F637B9F559C7F664F69EAB7B6092237526EA0D1F61CB20D69D10F2",
+	}, {
+		.krb5	= &krb5_aes256_cts_hmac_sha384_192,
+		.name	= "enc plain==block",
+		.plain	= "000102030405060708090A0B0C0D0E0F",
+		.conf	= "53BF8A0D105265D4E276428624CE5E63",
+		.Ke	= "56AB22BEE63D82D7BC5227F6773F8EA7A5EB1C825160C38312980C442E5C7E49",
+		.Ki	= "69B16514E3CD8E56B82010D5C73012B622C4D00FFC23ED1F",
+		.ct	= "BC47FFEC7998EB91E8115CF8D19DAC4BBBE2E163E87DD37F49BECA92027764F68CF51F14D798C2273F35DF574D1F932E40C4FF255B36A266",
+	}, {
+		.krb5	= &krb5_aes256_cts_hmac_sha384_192,
+		.name	= "enc plain>block",
+		.plain	= "000102030405060708090A0B0C0D0E0F1011121314",
+		.conf	= "763E65367E864F02F55153C7E3B58AF1",
+		.Ke	= "56AB22BEE63D82D7BC5227F6773F8EA7A5EB1C825160C38312980C442E5C7E49",
+		.Ki	= "69B16514E3CD8E56B82010D5C73012B622C4D00FFC23ED1F",
+		.ct	= "40013E2DF58E8751957D2878BCD2D6FE101CCFD556CB1EAE79DB3C3EE86429F2B2A602AC86FEF6ECB647D6295FAE077A1FEB517508D2C16B4192E01F62",
+	},
 	{/* END */}
 };
 
@@ -34,5 +136,19 @@ const struct krb5_enc_test krb5_enc_tests[] = {
  * Checksum generation tests.
  */
 const struct krb5_mic_test krb5_mic_tests[] = {
+	/* rfc8009 Appendix A */
+	{
+		.krb5	= &krb5_aes128_cts_hmac_sha256_128,
+		.name	= "mic",
+		.plain	= "000102030405060708090A0B0C0D0E0F1011121314",
+		.Kc	= "B31A018A48F54776F403E9A396325DC3",
+		.mic	= "D78367186643D67B411CBA9139FC1DEE",
+	}, {
+		.krb5	= &krb5_aes256_cts_hmac_sha384_192,
+		.name	= "mic",
+		.plain	= "000102030405060708090A0B0C0D0E0F1011121314",
+		.Kc	= "EF5718BE86CC84963D8BBB5031E9F5C4BA41F28FAF69E73D",
+		.mic	= "45EE791567EEFCA37F4AC1E0222DE80D43C3BFA06699672A",
+	},
 	{/* END */}
 };


