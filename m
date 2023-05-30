Return-Path: <netdev+bounces-6613-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F36127171A2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:25:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DB9928125B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB7134CF9;
	Tue, 30 May 2023 23:25:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C691A927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:25:45 +0000 (UTC)
Received: from mout.web.de (mout.web.de [217.72.192.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA385E5;
	Tue, 30 May 2023 16:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1685489121; i=spasswolf@web.de;
	bh=bVokRTnSfY57dTFz84DYa/2uuA3gMO3FTvF8GJZpPz4=;
	h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
	b=TPk9dso0nZHFZ4A9HGLPv5q19jICRkmhyy49NlwO5ZebFT0IP0aMZ/76th+/jdPNR
	 7Ujw+g3hlNdHEKWDXyCK1QOYl0m3jQZHrocZPSSyLqx8wDeuaxqyaVMEer0k6+cG4D
	 dAjQC2D8zA8eRB2UrKGs6MWeFcqiVh/TNpEYY+a45h7FSyUTWVJRIqRxtqei0/fid5
	 HjVlmDCvYg8vn2RbZwmCfBgpgylXHk3AYFneGRb0qRC4eE4HzbIeCxjP13uRx3YomC
	 eBuLhhFVpVkca1V7LOIVZ4dOSaVDLRk5R4AGURKuIT2bmGo2J2UihUm+Fs+tpBSLLF
	 xc+HsI7AfCd5Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.0.101] ([176.198.191.160]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MLAVc-1pm3rn1vpC-00I9Pv; Wed, 31
 May 2023 01:25:21 +0200
Message-ID: <dcfb1ccd722af0e9c215c518ec2cd7a8602d2127.camel@web.de>
Subject: Re: [PATCH net v2] net: ipa: Use the correct value for
 IPA_STATUS_SIZE
From: Bert Karwatzki <spasswolf@web.de>
To: Alex Elder <elder@linaro.org>, Simon Horman <simon.horman@corigine.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, netdev@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 31 May 2023 01:25:20 +0200
In-Reply-To: <f9ccdc27-7b5f-5894-46ab-84c1e1650d9f@linaro.org>
References: <7ae8af63b1254ab51d45c870e7942f0e3dc15b1e.camel@web.de>
	 <ZHWhEiWtEC9VKOS1@corigine.com>
	 <2b91165f667d3896a0aded39830905f62f725815.camel@web.de>
	 <3c4d235d-8e49-61a2-a445-5d363962d3e7@linaro.org>
	 <8d0e0272c80a594e7425ffcdd7714df7117edde5.camel@web.de>
	 <f9ccdc27-7b5f-5894-46ab-84c1e1650d9f@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.2-1 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Provags-ID: V03:K1:ZMkfT2i9P4INUikDQKz7U3w4wYUXQxItqM4vtkNYOcVZXqlmqyA
 kHreVsbcUkyLoZ821vHruw/f97/55ieQ8/iN3lm0vLSlDDbrslwGOddHIYrrwEv/DUxlMCS
 5NUTfzfHztrz0KJeIX6XiQVj5esLXnC9gKSO96nCktEaN7jMVy1RFqj96ZtQ6dMMFAwQHI4
 BY6fjxGDpfzUXLJ3IOzYw==
UI-OutboundReport: notjunk:1;M01:P0:04ZzZfq6434=;Nt/AyWZ4sphIOxnLsgX3rexKZ9Q
 cr4OwuklmBkR/0hAXm+UTo3+iTcjiAspYvPYl+uImuco9R3fXrdb6ZpsfHb5wmXMykncph/SH
 +LGKb3Q1dLlxgePOzhChbcj3cVzsqyBQvMup9/kDQZ/L4bm5Gl4OFUGSwUp2AUBtlZfsMlA+h
 m3YIp+YXQKR4usmNt2O1k+mpCVZbJE6+Ndi6ugchJ6JsXttgHrxbLG1h81znR3eTmeA07zEgP
 5ppnWtGR80DoIQKGCOtwly9L0DtgURBJd/d9M+79m2BFDnsy7oGRFptAcs2AM2hFOTJWNiOAS
 xkJpqhbGM0ophTV9hQcth7PDc4wfv1O6vE2MAHr40wTjl5eib12KQQfwLuzDdyGUnUent/X3W
 xUblI/Jk+g6KSG51vZJd/AkUX2swuGZNTFANyFVkwxLrboj27QRFil55vp175xU244Pv7/7ak
 0Gdz1AppD8rd/YOt8+NiXa5hSoCl+TPKPNlON/Cmea/xikk2/b9YI7Y9pSX665G2yc3s4R4fU
 LtFjAgDQE+USYBhMvrqxpt077FgamsPwtjbEhoqCQZALNHVZLamOcaBLqPSccIPIi2WPUjUj6
 /+TJ1JUtzdZ8GRBVglavAMvshUz6krqq/Hkipyse2DhXZX0ieLzxwiHJ/w7b7w7Upth3qg6hb
 BuFeq5JYKtW8jxy4NiOQ10UJWDnVSeBpqeLWoZ26TqoIckC6mNwhWRBCBumRreMV6Iq+uB+XI
 ZGsAi/DKyvNPFFfXupLBuzR9mZPkDHl+up6RP1+gFxuVD2zbXKCaaQQGI5kpIBGLuVOtWaqBt
 e0uqWymNdmSgzCMm7KC0c2vsyTCc76F1bTrSwuLVTcMPrMyEy06PrwOK/qEvU3rEN4dXh/evz
 IEKRDhtRXuehsr/yZlG+JjMGGgo9p+cwiTNi73BXBGOiaAsJtfQDFlBCv/IrqMk8znl+fGRsu
 nQ3YQ12DMtMnUZVr3bPlglc2uzo=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From 2e5e4c07606a100fd4af0f08e4cd158f88071a3a Mon Sep 17 00:00:00 2001
From: Bert Karwatzki <spasswolf@web.de>
To: davem@davemloft.net
To: edumazet@google.com
To: kuba@kernel.org
To: pabeni@redhat.com
Cc: elder@kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 31 May 2023 00:16:33 +0200
Subject: [PATCH net v2] net: ipa: Use correct value for IPA_STATUS_SIZE

IPA_STATUS_SIZE was introduced in commit b8dc7d0eea5a as a replacement
for the size of the removed struct ipa_status which had size
sizeof(__le32[8]). Use this value as IPA_STATUS_SIZE.

Fixes: b8dc7d0eea5a ("net: ipa: stop using sizeof(status)")
Signed-off-by: Bert Karwatzki <spasswolf@web.de>
---
 drivers/net/ipa/ipa_endpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.=
c
index 2ee80ed140b7..afa1d56d9095 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -119,7 +119,7 @@ enum ipa_status_field_id {
 };
=20
 /* Size in bytes of an IPA packet status structure */
-#define IPA_STATUS_SIZE			sizeof(__le32[4])
+#define IPA_STATUS_SIZE			sizeof(__le32[8])
=20
 /* IPA status structure decoder; looks up field values for a structure */
 static u32 ipa_status_extract(struct ipa *ipa, const void *data,
--=20
2.40.1

As I'm sure that git send-email didn't work (probably due to sendmail/exim
configuration issues), I'm sending this from evolution again.

Bert Karwatzki
=20

