Return-Path: <netdev+bounces-6525-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E4D6716C9D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:36:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD2322812BD
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F2120683;
	Tue, 30 May 2023 18:36:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB891F935
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:36:37 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.15.4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3DEA7;
	Tue, 30 May 2023 11:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1685471780; i=spasswolf@web.de;
	bh=2v7T90+EZYWcRweNwX+3tMDTLQwY1YpThpclSmEMtDg=;
	h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MB1a2xDJY2XJgsPR+GIX+370ThGorfknQItcFu1lKv1wc//Nsljm68ClGBJMo6EKY
	 PYcaxk4vUvBDYXOjc8iRFw4IiiXuRc7UEqEyZVXo2L5rzi3LA3NVJeZziGSHSwAfNi
	 zT3EB0dlu8pXg3Puq5dTnBAOXn5MYu2Xyax2Uo1gIKfFGvCMdj7d7YUIsXFYs4GsSV
	 jLt+8RDGg7NQ672nfMhdOHaV52AYFPDcXnsQKHd4+QriLygOOiH2FezP1RXcf7Yr9d
	 CGKOS4q1sh3DCuX1KkPr3laUaW8khZn/mAVtnxmitQ/FMlY/SqaGWVrMF9l0VXsuNr
	 C8QuqQIreYEPw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.0.101] ([176.198.191.160]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MFayw-1prTob3wA2-00HLCg; Tue, 30
 May 2023 20:36:20 +0200
Message-ID: <8d0e0272c80a594e7425ffcdd7714df7117edde5.camel@web.de>
Subject: Re: [PATCH net] net: ipa: Use the correct value for IPA_STATUS_SIZE
From: Bert Karwatzki <spasswolf@web.de>
To: Alex Elder <elder@linaro.org>, Simon Horman <simon.horman@corigine.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, netdev@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 May 2023 20:36:18 +0200
In-Reply-To: <3c4d235d-8e49-61a2-a445-5d363962d3e7@linaro.org>
References: <7ae8af63b1254ab51d45c870e7942f0e3dc15b1e.camel@web.de>
	 <ZHWhEiWtEC9VKOS1@corigine.com>
	 <2b91165f667d3896a0aded39830905f62f725815.camel@web.de>
	 <3c4d235d-8e49-61a2-a445-5d363962d3e7@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.2-1 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Provags-ID: V03:K1:nvDrN31wa6BU9wTREw0mivrP59WXptU/X0viLPNSxPxk4CLeyr1
 HRVMzwdttRXcgJcTa67MSVOkkXZTcieQ2f1hHsE61La/ZM2FDYAtZCvAkimm/1A4m5NpWzx
 dvHE5rlF1iPeh4/mfJWEhoE/EPYDQrzi8Sa++gFQyL1V8+AmUErVXat/HgVdKUDnPjDKZl6
 srUs9/ICtEkrBJmEXtP2A==
UI-OutboundReport: notjunk:1;M01:P0:u5nL76XZm54=;f37AL66HylzsArkAIjKAdXyQ2/P
 vCzRaQnIGOPuwYLmoJtQpJzaUpo9dDwp3xfv+4Fa9kXkpHvL+BM36MmayKvDTsRa+SpTfD/Rr
 YsNuyLFVo3HN8KCHjRTGJX5q9xn9zErEEOKxICpfXIHhmA1Q7ypeYw0QeqLF2cbbmGbycnhoq
 pztWSPrHI+iNP1+9qH1Jk/sxkdy5ZGms1cuu6d7lKgOjtK3S0tKBh6q0bZ/U0bBfdVJMqkG3O
 CQr3PBlG1AuZTRuTWg6qfb41nTKe55npgxb1q0hKRfYT6aMuabxrNSXDaBG7LH2BPjFQLBqH/
 zqR1SPL7RaExNtZY6fIKQo5wDvAUO9/rxHejcIXcGKVOFelrHxJ7Moga6dgKPeIqQRmMNb/QH
 0MgabqwtJQByRGfaED6Br+zA9PqRS35GL/CIThHCyZr8+rKq0J7zLO2sTNwVnkwqu0TMxsD7m
 JxqLpnsexZ6TWE71Zk06SM+FVzwohPZxAwQrFnoQhiLdo+HmB3h769qii4PD4Af8avsnwR94/
 TUEsNTa/T1ZWF8L3lEBcA+pZqiCo8gpcPtwAV6SMRsNM4MVuNlF0t5NviD1ktHKECsBukdafa
 iOG8r3IYbDNCB3+8K9WsuWiHHcs6DUTCX8Xzwx5ydRoMn9tFUJ7aQnqdLfAMhuJmsM3/VyJeG
 KbV1tCHP6LFWB+OokHO23F75FY/Ys3d0jjLuONLLz91kIE51XRMJ941ZZj5b6ruUjabBWVtII
 jB2OeFRkGJ7VMs8bqqby4HhoOvcM20VfSDQ0ZVxCmLZfasibip9yrFR+5+lb7f5LAqWCF7N8P
 migieMlUX3fLat76mhqglogypSOAPtXLIR8L8TsKbegsn2W8hc7P589sUV8ohRWDhgiLSp49w
 x/G8ysbdJu4Cpezclv3enAhRCB5L0/iMiaD+JoyTnp5VUuaD0CIWbEkJlLB3eUEChSzXbKASq
 vI/NcQKUvj3kAp8vJV9D7QwrLlI=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Am Dienstag, dem 30.05.2023 um 07:29 -0500 schrieb Alex Elder:
> On 5/30/23 4:10 AM, Bert Karwatzki wrote:
> > Am Dienstag, dem 30.05.2023 um 09:09 +0200 schrieb Simon Horman:
> > > On Sat, May 27, 2023 at 10:46:25PM +0200, Bert Karwatzki wrote:
> > > > commit b8dc7d0eea5a7709bb534f1b3ca70d2d7de0b42c introduced
> > > > IPA_STATUS_SIZE as a replacement for the size of the removed struct
> > > > ipa_status. sizeof(struct ipa_status) was sizeof(__le32[8]), use th=
is
> > > > as IPA_STATUS_SIZE.
>=20
> This is better, however it really isn't done in a way that's
> appropriate for a Linux kernel patch.=C2=A0 I will gladly help you
> get it right if you have the patience for that.=C2=A0 But I'm not
> going to say anything yet--until you say you want me to help
> you do this.=C2=A0 If you prefer, I can submit the patch for you.
>=20
> The reason this is important is your commit is permanent, and
> just like code, commit messages are best if kept consistent
> and readable.=C2=A0 I also am offering to help you understand so
> you avoid any trouble next time you want to send a kernel patch.
>=20
> Let me know what you prefer.
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0-Alex
>=20
> > >=20

So here's v3 of the patch, done (I hope) in a way that is more standard
conforming.

From e0dc802b5f6f41c0a388c7281aabe077a4e3c5a2 Mon Sep 17 00:00:00 2001
From: Bert Karwatzki <spasswolf@web.de>
Date: Tue, 30 May 2023 20:23:29 +0200
Subject: [PATCH] net/ipa: Use correct value for IPA_STATUS_SIZE

IPA_STATUS_SIZE was introduced in commit b8dc7d0eea5a as a replacement
for the size of the removed struct ipa_status which had size
sizeof(__le32[8]). Use this value as IPA_STATUS_SIZE.

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


Bert Karwatzki

