Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5CE553939
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 19:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352796AbiFURyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 13:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238923AbiFURyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 13:54:14 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186981C92F
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 10:54:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so14203872pjz.1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 10:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=BsxaUYR0KU+mllgw/KLVw+aYPcGgZDBql4d2uzAFGcg=;
        b=Fk3VpQaS921p/E7BU/aOMd3n4V/7Th0JVikc9jYIHpe4YRQPWD5//tamnelJ34hAZC
         NCdfKYYAmbEykUYhioY9xjSAW4FvcBXE6Xz+1hRnnB33M/KQeRbnMQv/v4VEUbDr39+h
         Wr4FmcS/yJEp5zScQz0GvKmJtrJDRaFW2J1/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=BsxaUYR0KU+mllgw/KLVw+aYPcGgZDBql4d2uzAFGcg=;
        b=RtQNLUUwEqP79SYNDgjO62ZLGrgXeFy6BS5TNf3w44Dsi91u2rRwKbWGIHR4HnQyol
         cps+UKXvtka6rZQ/i2LwFNuMqZV/vPzt/td97OtjZjlGQF2RQUaZlBK1brgRMy7ZEME9
         wuIu3W1BnUufup4dinLaKCldUflFwJ7NQO2W8u6VrNX6QetIODnkMUBdKJVGQ/UZ/ECo
         H6Xccgsk74ZbFJKv9xw8ppQr74NgqJIgpjJkQZw/VYUoyNK0jZBDnWul7jp3ofu/WCe2
         Ep96X4aw0dtov+leomcIeoBt0z9jNFSKuXqVRl337IJF0eeZJkchi2KhDMapO0WWlyE1
         5qIA==
X-Gm-Message-State: AJIora+CVObbVZaGkYOU8BNfnKAruyLFq7bjhQy0A+5EgzgCVoeX/cYB
        OJamVg02JzkZdQIc2rI2P5VAsQ==
X-Google-Smtp-Source: AGRyM1tuZrQJlxghPeRNsQGZlbKytq2s/RUis1pZFNX5jwx91AWKK9hoWy9T3yzdaMV72mqrfxxqhg==
X-Received: by 2002:a17:903:2012:b0:16a:856:96a7 with SMTP id s18-20020a170903201200b0016a085696a7mr22549922pla.109.1655834053565;
        Tue, 21 Jun 2022 10:54:13 -0700 (PDT)
Received: from driver-testing.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id z14-20020a17090a540e00b001e095a5477bsm12694558pjh.33.2022.06.21.10.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 10:54:13 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, toke@redhat.com, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Andy Gospodarek <gospo@broadcom.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next v2] samples/bpf: fixup some tools to be able to support xdp multibuffer
Date:   Tue, 21 Jun 2022 17:54:02 +0000
Message-Id: <20220621175402.35327-1-gospo@broadcom.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000967bae05e1f8e8d8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MIME_NO_TEXT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000967bae05e1f8e8d8
Content-Transfer-Encoding: 8bit

This changes the section name for the bpf program embedded in these
files to "xdp.frags" to allow the programs to be loaded on drivers that
are using an MTU greater than PAGE_SIZE.  Rather than directly accessing
the buffers, the packet data is now accessed via xdp helper functions to
provide an example for those who may need to write more complex
programs.

v2: remove new unnecessary variable

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 samples/bpf/xdp1_kern.c            | 11 ++++++++---
 samples/bpf/xdp2_kern.c            | 11 ++++++++---
 samples/bpf/xdp_tx_iptunnel_kern.c |  2 +-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
index f0c5d95084de..0a5c704badd0 100644
--- a/samples/bpf/xdp1_kern.c
+++ b/samples/bpf/xdp1_kern.c
@@ -39,11 +39,13 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
 	return ip6h->nexthdr;
 }
 
-SEC("xdp1")
+#define XDPBUFSIZE	64
+SEC("xdp.frags")
 int xdp_prog1(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	__u8 pkt[XDPBUFSIZE] = {};
+	void *data_end = &pkt[XDPBUFSIZE-1];
+	void *data = pkt;
 	struct ethhdr *eth = data;
 	int rc = XDP_DROP;
 	long *value;
@@ -51,6 +53,9 @@ int xdp_prog1(struct xdp_md *ctx)
 	u64 nh_off;
 	u32 ipproto;
 
+	if (bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt)))
+		return rc;
+
 	nh_off = sizeof(*eth);
 	if (data + nh_off > data_end)
 		return rc;
diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
index d8a64ab077b0..3332ba6bb95f 100644
--- a/samples/bpf/xdp2_kern.c
+++ b/samples/bpf/xdp2_kern.c
@@ -55,11 +55,13 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
 	return ip6h->nexthdr;
 }
 
-SEC("xdp1")
+#define XDPBUFSIZE	64
+SEC("xdp.frags")
 int xdp_prog1(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	__u8 pkt[XDPBUFSIZE] = {};
+	void *data_end = &pkt[XDPBUFSIZE-1];
+	void *data = pkt;
 	struct ethhdr *eth = data;
 	int rc = XDP_DROP;
 	long *value;
@@ -67,6 +69,9 @@ int xdp_prog1(struct xdp_md *ctx)
 	u64 nh_off;
 	u32 ipproto;
 
+	if (bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt)))
+		return rc;
+
 	nh_off = sizeof(*eth);
 	if (data + nh_off > data_end)
 		return rc;
diff --git a/samples/bpf/xdp_tx_iptunnel_kern.c b/samples/bpf/xdp_tx_iptunnel_kern.c
index 575d57e4b8d6..0e2bca3a3fff 100644
--- a/samples/bpf/xdp_tx_iptunnel_kern.c
+++ b/samples/bpf/xdp_tx_iptunnel_kern.c
@@ -212,7 +212,7 @@ static __always_inline int handle_ipv6(struct xdp_md *xdp)
 	return XDP_TX;
 }
 
-SEC("xdp_tx_iptunnel")
+SEC("xdp.frags")
 int _xdp_tx_iptunnel(struct xdp_md *xdp)
 {
 	void *data_end = (void *)(long)xdp->data_end;
-- 
2.25.1


--000000000000967bae05e1f8e8d8
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVkwggRBoAMCAQICDBPdG+g0KtOPKKsBCTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDAyMzhaFw0yMjA5MjIxNDExNTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGDAWBgNVBAMTD0FuZHkgR29zcG9kYXJlazEtMCsGCSqGSIb3
DQEJARYeYW5kcmV3Lmdvc3BvZGFyZWtAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAp9JFtMqwgpbnvA3lNVCpnR5ehv0kWK9zMpw2VWslbEZq4WxlXr1zZLZEFo9Y
rdIZ0jlxwJ4QGYCvxE093p9easqc7NMemeMg7JpF63hhjCksrGnsxb6jCVUreXPSpBDD0cjaE409
9yo/J5OQORNPelDd4Ihod6g0XlcxOLtlTk1F0SOODSjBZvaDm0zteqiVZb+7xgle3NOSZm3kiCby
iRuyS0gMTdQN3gdgwal9iC3cSXHMZFBXyQz+JGSHomhPC66L6j4t6dUqSTdSP07wg38ZPV6ct/Sv
/O2HcK+E/yYkdMXrDBgcOelO4t8AYHhmedCIvFVp4pFb2oit9tBuFQIDAQABo4IB3zCCAdswDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDApBgNVHREEIjAggR5hbmRyZXcuZ29zcG9kYXJla0Bicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYI
KwYBBQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFKARn7Ud
RlGu+rBdUDirYE+Ee4TeMA0GCSqGSIb3DQEBCwUAA4IBAQAcWqh4fdwhDN0+MKyH7Mj0vS10E7xg
mDetQhQ+twwKk5qPe3tJXrjD/NyZzrUgguNaE+X97jRsEbszO7BqdnM0j5vLDOmzb7d6qeNluJvk
OYyzItlqZk9cJPoP9sD8w3lr2GRcajj5JCKV4pd2PX/i7r30Qco0VnloXpiesFmNTXQqD6lguUyn
nb7IGM3v/Nb7NTFH8/KUVg33xw829ztuGrOvfrHfBbeVcUoOHEHObXoaofYOJjtmSOQdMeJIiBgP
XEpJG8/HB8t4FF6A8W++4cHhv0+ayyEnznrbOCn6WUmIvV2WiJymRpvRG7Hhdlk0zA97MRpqK5yn
ai3dQ6VvMYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBu
di1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIM
E90b6DQq048oqwEJMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCCOXVSBQs5Hm63
gGCRio7N0wX2k6HhRXanVaaZw+9cHDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMjA2MjExNzU0MTNaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAf8OQwZP/dLekEjgPXnhB7NuCcRXEXgjy
inNzyfKoDu18FYXu4W4ZwMbTshhHo9ctNWGy+ld9RR1Ckg+KxEOW/bu4BIhtrOeAjoT0ANj0zo8u
Fb9tGEQC4TAM4HCl5nK+P7xCa1hkzDfcdAcCCpTS3Qb56zjHaem9hPza77Gf43pOgaMiIgu08d9v
Kw7J5gcpYQ0X9Sjqv9nNfgSJGMbmCErwPe0fX7g9EjfUpZcgpNSJDbREIeXPYpKGaVFVs0OEA0oX
G+ro+hkC4qYcFtXop5nQAx/fg1lTtW3PqVWPBf9SfcsXA6xC37wTBX/uioxBOGAhDajWQ2Q9PWog
GvXNew==
--000000000000967bae05e1f8e8d8--
