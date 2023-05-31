Return-Path: <netdev+bounces-6762-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 816A8717D43
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:38:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D4371C20E75
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0710979D2;
	Wed, 31 May 2023 10:38:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25E66FC9
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 10:38:54 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.15.4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F61BE;
	Wed, 31 May 2023 03:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1685529518; i=spasswolf@web.de;
	bh=EdzXAuAMFY3t1LSaGo+AZHE/CDQud/bV5pOhIIq/oMk=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKxk6kUiW552tsCiXcNfxoGhPd15Ah4lWu2lTkaZH/Y7qeKC1hk8QgGnFGLbjS8PX
	 PfgQd07nettDbdcgfzfmJStK616i5R0adCa3YYAL13InHqmxTpMmsFT+t4R0x+RERI
	 yar6kFXelc9OuYAPkoiXJdgFTpMxIhgd1D+NyeZ2gglc0Ds+PZp7lWtaFJO1Eqn3Ch
	 uLMQlRqNXXcq6xmgJ7NBJQ+v1tQPKgajMhpkmwOSil7jxrNp8rooeQP3oRnNT4bd5v
	 ZiqD0ISzAN/zHFNEwiMaQyN3CQ1tV4IYODu3GWJReyGRnQDTtBMi2B2d49SOLcUAOd
	 PTAp+BCwsThDg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from localhost.localdomain ([176.198.191.160]) by smtp.web.de
 (mrweb006 [213.165.67.108]) with ESMTPSA (Nemesis) id
 1MBS71-1pvlAI3KSl-00CeGc; Wed, 31 May 2023 12:38:37 +0200
From: Bert Karwatzki <spasswolf@web.de>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: Bert Karwatzki <spasswolf@web.de>,
	elder@kernel.org,
	netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v3] net: ipa: Use correct value for IPA_STATUS_SIZE
Date: Wed, 31 May 2023 12:36:19 +0200
Message-Id: <20230531103618.102608-1-spasswolf@web.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <e144386d-e62a-a470-fcf9-0dab6f7ab837@linaro.org>
References: <e144386d-e62a-a470-fcf9-0dab6f7ab837@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3Dsv7+l5ZvDr30QdVwjfAb5zt4bew3VSOwXjuw4FzsNrtBvP/cH
 Awf4EvPoD3GkxAAvrQmk+sKBUar5b/Kmz25ljlMVEUkOyPdaAoP22GXn2aNaLSXRBJjcoF5
 nidWWUsxnj/dPsKXU/jYj5/sXh9odUu3grZ18GEwE/PWOaiTkv8Afb4hbyNW0/xbT+qxKOj
 0kUCZ9mek74yTLYPADtbQ==
UI-OutboundReport: notjunk:1;M01:P0:4sAftPvt+MU=;wtLMJQB0iheI2e4mLDv8fzTKN7o
 V6rjerJU0Iu+5gTVgemotw0rkOWE+XhEYHWOIDQkbdBkN4krojhoRszloednHJyvjPUBkzi3A
 T8hamwta3xUc+3tnhmjfY837+/ANw6Gs7h6CZoa+xtq08MaD1kJMcVlvOLdK0bnzUyFfx5Vmr
 LAHOTBd9ozujI7ziuV6TkZBUows3LsgapKsJknViRi/tgDP/Rx3B+PWBXxyIc1yR35WOtHgjP
 QrElrbULRrpmP0wtboOiDW1K5OWHWTsheYtO+sGd5YRxnmVrLzMvvitz/LgAYvrB+17T2IZIN
 l2y0Sk07u7LA7RYP6CELoV0JYgeVxwN0fHpawwgjNYQVf3SGhi3VCjiwRJuv+ws3nk5tEMS1L
 ATq48ZUGN4CP24vcgBENd84qDZY0PYMkcg/uygsx3VScbUIuPrwcntuYbWSvu0IpRsb2TwBfL
 EWc/UOPWJEL6AHY8XejFs+9Qm3q2cqZRNCDsen1PW2a6LUaxXBn7xT8+/JihV125usd2i5n6L
 PRf5TfECFyIk+/Fgy//qdmZTiTYfOLJ59XjBNL4jBT+VBkkXBZUBhIsYm/Ja6+SWPPHBNdfgc
 8fSUSAWrOQmjNerKPrkE40d3GtJSHbd+di17FVyYGg1ykQ4GdqUBJaNivGkjyY08rZNPRyLJl
 jQIWc+WymGV99rdrdd0Q74F0jBkS/+RflAIinjoW1cE9ugI10I92wYWDH/OiiUkJrKltL0BTx
 BFENJ14b80k6prKBrEPWQKZOhNlFVOMlhs716TZYI+lvoQSE8knani3R89QsFJk69t1AY9SyY
 uGYmqUwHr1kCcTSUL3A9+DC3vk+FRrxJf1lmx/cLY1E6FgPPTk+DFfPVxksbkB1npda752LFW
 LfrIWYMq+mjovZPKnsSwSP1lQD3CAILTNwOiTYB7SfOKwxidgVL35hMSlLHsyj8SC9xfVzOeS
 7f4B/M/aPZvk5XiNND3xIp/XW7Y=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

IPA_STATUS_SIZE was introduced in commit b8dc7d0eea5a as a replacement
for the size of the removed struct ipa_status which had size
sizeof(__le32[8]). Use this value as IPA_STATUS_SIZE.

Fixes: b8dc7d0eea5a ("net: ipa: stop using sizeof(status)")
Signed-off-by: Bert Karwatzki <spasswolf@web.de>
=2D--
 drivers/net/ipa/ipa_endpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint=
.c
index 2ee80ed140b7..afa1d56d9095 100644
=2D-- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -119,7 +119,7 @@ enum ipa_status_field_id {
 };

 /* Size in bytes of an IPA packet status structure */
-#define IPA_STATUS_SIZE			sizeof(__le32[4])
+#define IPA_STATUS_SIZE			sizeof(__le32[8])

 /* IPA status structure decoder; looks up field values for a structure */
 static u32 ipa_status_extract(struct ipa *ipa, const void *data,
=2D-
2.40.1

As none of you seem to be in Europe, I'll do another attempt, this time
with git send-email.
Bert Karwatzki


