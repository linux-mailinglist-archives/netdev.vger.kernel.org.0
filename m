Return-Path: <netdev+bounces-6299-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7002715992
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A8AB281036
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E73C134AF;
	Tue, 30 May 2023 09:10:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9233728E7
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:10:40 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.15.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE47EE5;
	Tue, 30 May 2023 02:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
 s=s29768273; t=1685437821; x=1686042621; i=spasswolf@web.de;
 bh=RowAy7vfc/W3m5IXjtWxalCBrofshNZILX1ZCuc28iM=;
 h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
 b=WTLIKpKLSF6HBEcWMPD/howHFNhRFg2N9g0FVHpkAP60F3c4LKKKVGZfPXOJBz7QHND68Xr
 OuilMeMOiQ3yFk5ewlEzMnNbV0O0Jhe6Z8mC1K+DeObK+tanlL0s5LDtabeV3ZhwXwk+xkT51
 87xmX89e4g6oORLAqqCrGtCtHT129kFobEdvx55poaaZaroP9ONow6fEXk21n8jlWtMjq4H9Q
 Kj0dnX+DAvypcVvdR8XwfVDn2d9cH84rP7bZIajm6g8fHOC8iaPY2yc1b1usatFZvVEV312tg
 YDfp8N+phtJGW/44ubZZ7vWxjvy+N/l9zE4t21DApmSyBnv7A/GA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.0.101] ([176.198.191.160]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MwjK2-1qJmUR0vve-00yU3R; Tue, 30
 May 2023 11:10:21 +0200
Message-ID: <2b91165f667d3896a0aded39830905f62f725815.camel@web.de>
Subject: Re: [PATCH net] net: ipa: Use the correct value for IPA_STATUS_SIZE
From: Bert Karwatzki <spasswolf@web.de>
To: Simon Horman <simon.horman@corigine.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, elder@linaro.org,  netdev@vger.kernel.org,
 linux-arm-msm@vger.kernel.org,  linux-kernel@vger.kernel.org
Date: Tue, 30 May 2023 11:10:19 +0200
In-Reply-To: <ZHWhEiWtEC9VKOS1@corigine.com>
References: <7ae8af63b1254ab51d45c870e7942f0e3dc15b1e.camel@web.de>
	 <ZHWhEiWtEC9VKOS1@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Provags-ID: V03:K1:vAmbHNn5RUg4uxRCEOhxAucgIJLGHr907DRoQKnjt00SX6NhbDS
 FRe2n3RtxZuM4uu65KLNjp7aOJDGwZx8VscLdai7cEgeGF7RxAqS8+EuDbllIbp2y0Xr3dp
 VW4DY7wtQed1RjPGohtOBehkZhtei252JCAiykewLQHFQwTV8nA8f4WgL43fWGZC/25uwGa
 i6CpgJAHPb5i14vbRNvwQ==
UI-OutboundReport: notjunk:1;M01:P0:e7JqOYH10qA=;e+rlnv20da8hcJGA50ZinfEIkEG
 fYh73inPDTzIxJ+Paxu/duAkSdrj/cuLfLY5nIiGmcML1a02GXDX6w9cnR4FJAed3uKtR/XxU
 TVmY2vICGVgFDu25zYyTqCH6Bwm9nLP53hqzpeh5rro8qgB2Z+jDFl3PmtwMogFKzC40am8th
 pvbF3T0NePAzSKM+vv+A++OR6y13fj+X6eUTA+DgIw6KB/Tj5Rcxnswxk5qQOW2jbCwR2vx1E
 a6WAhy1hbRVdauV6aVW5Urg4pMvKvHbn4zsIwdZI/129Q5RLOeC/y8Jz+10s7nNt0oZhQ22yv
 m6xVA4euwz1Aih6A7kv7GydYAcVQ5yGCFC2IZg1Q5x21zbXoW/DzatuD7awp5cKW5IunXeq5G
 fZ7Z3g9KWZYuoe37T3sWzfvwjStVWzXq0L/k2wFHQ94t2l2h4ukvngUHDMhXUAoGKs2OO33sc
 pKI5OQhUo+zRZJeh9l4dOvu+vgnXWVnQUFJ9QSYi8MreeRlPSZmV5WYyIgUpN3um7GcPzAJxG
 +CXLTC6DkGwdNwp0I2BAA6wECfMrJ8aWXBKqOWhN69KMMMZvJmbllUMk7PAWKyJPTzO3/mZ6h
 cVkZR48q/M38LFp4dMsALlvniyzL6qmDgih2ocpWsyaEOog9CEqNpBoceCW66AaHNJQbPuUwD
 oF7McNxktkmU5EyHkoNTNC8cv/JPNShbYEBk4SjUvT0KMJ4yd9xx4NrQeJ7fCcDgYTHyykRQN
 vC7Zkdyt+z0c4pA88Qtu4xcuwKaB1Z88/QtAqYEbmzD/mLNs7cthIN1HdiaUBAZhwCrqSJX05
 39xhYrSR3tHmKmxQ5ST2pPUO5T1aFZ1hOXHR3YQKDkSpXHc06Ze3bRrbcA219zbK3RiV11Li3
 6Gy20Eb4F467VJNKT9KQKyCwM8VvLKUco7oIvbjqPlu17YTHvyYYBeW4CoDqeC59bwhoJU2jW
 X1RwCrFq0w53lEizlhNJ/CqOYbw=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Am Dienstag, dem 30.05.2023 um 09:09 +0200 schrieb Simon Horman:
> On Sat, May 27, 2023 at 10:46:25PM +0200, Bert Karwatzki wrote:
> > commit b8dc7d0eea5a7709bb534f1b3ca70d2d7de0b42c introduced
> > IPA_STATUS_SIZE as a replacement for the size of the removed struct
> > ipa_status. sizeof(struct ipa_status) was sizeof(__le32[8]), use this
> > as IPA_STATUS_SIZE.
> >=20
> > > From 0623148733819bb5d3648b1ed404d57c8b6b31d8 Mon Sep 17 00:00:00 200=
1
> > From: Bert Karwatzki <spasswolf@web.de>
> > Date: Sat, 27 May 2023 22:16:52 +0200
> > Subject: [PATCH] Use the correct value for IPA_STATUS_SIZE.
> > IPA_STATUS_SIZE
> > =C2=A0was introduced in commit b8dc7d0eea5a7709bb534f1b3ca70d2d7de0b42c=
 as a
> > =C2=A0replacment for the size of the removed struct ipa_status which ha=
d
> > size =3D
> > =C2=A0sizeof(__le32[8]).
> >=20
> > Signed-off-by: Bert Karwatzki <spasswolf@web.de>
>=20
> Hi Bert,
>=20
> As well as the feedback provided by Jakub elsewhere in this
> thread I think it would be useful to CC the author of the above mentioned
> commit, Alex Elder <elder@linaro.org>. I have CCed him on this email.
> Please consider doing likewise when you post v2.
>=20
> FWIIW, I did take a look.
> And I do agree with your maths: struct ipa_status was 32 (=3D 8 x 4) byte=
s long.
>=20
> > ---
> > =C2=A0drivers/net/ipa/ipa_endpoint.c | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/ipa/ipa_endpoint.c
> > b/drivers/net/ipa/ipa_endpoint.c
> > index 2ee80ed140b7..afa1d56d9095 100644
> > --- a/drivers/net/ipa/ipa_endpoint.c
> > +++ b/drivers/net/ipa/ipa_endpoint.c
> > @@ -119,7 +119,7 @@ enum ipa_status_field_id {
> > =C2=A0};
> > =C2=A0
> > =C2=A0/* Size in bytes of an IPA packet status structure */
> > -#define IPA_STATUS_SIZE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0sizeof(__le32[4])
> > +#define IPA_STATUS_SIZE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0sizeof(__le32[8])
> > =C2=A0
> > =C2=A0/* IPA status structure decoder; looks up field values for a stru=
cture
> > */
> > =C2=A0static u32 ipa_status_extract(struct ipa *ipa, const void *data,
> > --=20
> > 2.40.1
> >=20
> > Bert Karwatzki

Here is v2 of the patch, the first one was garbled by the linebreak setting=
 of
evolution.

From: Bert Karwatzki <spasswolf@web.de>
Date: Tue, 30 May 2023 10:55:55 +0200
Subject: [PATCH] IPA_STATUS_SIZE was introduced in commit b8dc7d0eea5a as a
 replacement for the size of the removed struct ipa_status of size
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



