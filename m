Return-Path: <netdev+bounces-164-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A0E6F5931
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFB361C20F13
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D487D534;
	Wed,  3 May 2023 13:40:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079D3321E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 13:40:48 +0000 (UTC)
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E711A5
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 06:40:47 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-55a76ed088aso43765667b3.2
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 06:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683121246; x=1685713246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2CwoA/V621d72KVoXTfvZWyIMvfPtUdQb7pefHxHF30=;
        b=fbeqWTWM2Z52Zm2X2fbDsY2BsLty7a6T1ghr0CKbXPT+KhgQ/uOOc8KtgC9r6Xa8et
         0hTKgWud/7s9QVqxSI8hWo++4KypFmAKpYx3pZQJ+ZVLiINl11OGvExWb3NQAnyT2gVa
         jxBJBx2f0Wgqg/+6HHBWUPEEuP7TzBEL1R6fC0bL6AWb82jQQrQ2Fma8Z2rNTI0orhxb
         ZCHZsBusv6vKi+dAhP8gsAHb47NRaW82xPLKVjBTix4xO/MUK7DLlQ4yP8lDvQmJ+kj9
         /54OtdpJqvf3UIQHnloxYjnHOcNj6vk6mbj+Ot2/vcFsab67CeIq4sVFAEbEn7Dvb8SX
         xHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683121246; x=1685713246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2CwoA/V621d72KVoXTfvZWyIMvfPtUdQb7pefHxHF30=;
        b=BwUeyYpETZFwBlAVbd6kRv6XvCy08P6a+2ucrJ+F2SWHbNVgJVk1sPqL+a6envUPXk
         jBsZVHIsxT+egz/QpBG52U3KkjanGQWEJ4rgjptJockaWJf3ilKx5VXtXn81NpT3V7qr
         Qhf/vrRUmMSojBMN+x7+Q4/t5lSLqT40c5o/VYjLiY8P+cA2Ua1NkB7uc7Z+//6ihB9h
         3w44D0dbV+zt22dlvUS4nuJ6egygDuLOm6qLjKmPJUWB8PN3dKY55MKzcnnkLl2xCy6N
         NSOizFminBryn/lEkSDu4KeSMqvhPr85v5svkssaZjI9SCYXKnNMzMxqy4F2SQEH+lvf
         uoYw==
X-Gm-Message-State: AC+VfDzs+ZYBgqzkoP/3RksmGrCe7IwjaNCmCRKKtNYSO7FSd6E3glCu
	mfEyOGWYHHuYI2dkFYBFry6jhhmEC+eCAZ9bAFojPP+0K79YrQ==
X-Google-Smtp-Source: ACHHUZ5eZhRtcOVu8izjfk75hIpMtfZcgCVv3pvC+/a8STZzar8yJHFd7Gzw/R6DYsdo+iA6MIUCt0CMFhTIQV9vISs=
X-Received: by 2002:a0d:ea13:0:b0:55a:21c1:7679 with SMTP id
 t19-20020a0dea13000000b0055a21c17679mr11405770ywe.19.1683121246643; Wed, 03
 May 2023 06:40:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1683065352.git.lucien.xin@gmail.com> <8e3827ffaf71c0636541c01f76ff3a65868433ea.1683065352.git.lucien.xin@gmail.com>
 <DB9PR05MB9078E51851B2C67489B2BC02886C9@DB9PR05MB9078.eurprd05.prod.outlook.com>
In-Reply-To: <DB9PR05MB9078E51851B2C67489B2BC02886C9@DB9PR05MB9078.eurprd05.prod.outlook.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 3 May 2023 09:40:26 -0400
Message-ID: <CADvbK_fAfetKdgrK3_WpLMv0+xRgDWrvQE1viTJU4p=7QiUkWQ@mail.gmail.com>
Subject: Re: [PATCHv2 net 1/3] tipc: add tipc_bearer_min_mtu to calculate min mtu
To: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
Cc: network dev <netdev@vger.kernel.org>, 
	"tipc-discussion@lists.sourceforge.net" <tipc-discussion@lists.sourceforge.net>, 
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 2, 2023 at 11:37=E2=80=AFPM Tung Quang Nguyen
<tung.q.nguyen@dektech.com.au> wrote:
>
> >As different media may requires different min mtu, and even the
> >same media with different net family requires different min mtu,
> >add tipc_bearer_min_mtu() to calculate min mtu accordingly.
> >
> >This API will be used to check the new mtu when doing the link
> >mtu negotiation in the next patch.
> >
> >v1->v2:
> > - use bearer_get() to avoid the open code.
> This version change comment does not seem right. Please correct it to avo=
id confusion and put it after "---".
See the comment in Patch 2/3.

> >
> >Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >---
> > net/tipc/bearer.c    | 13 +++++++++++++
> > net/tipc/bearer.h    |  3 +++
> > net/tipc/udp_media.c |  5 +++--
> > 3 files changed, 19 insertions(+), 2 deletions(-)
> >
> >diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> >index 35cac7733fd3..0e9a29e1536b 100644
> >--- a/net/tipc/bearer.c
> >+++ b/net/tipc/bearer.c
> >@@ -541,6 +541,19 @@ int tipc_bearer_mtu(struct net *net, u32 bearer_id)
> >       return mtu;
> > }
> >
> >+int tipc_bearer_min_mtu(struct net *net, u32 bearer_id)
> >+{
> >+      int mtu =3D TIPC_MIN_BEARER_MTU;
> >+      struct tipc_bearer *b;
> >+
> >+      rcu_read_lock();
> >+      b =3D bearer_get(net, bearer_id);
> >+      if (b)
> >+              mtu +=3D b->encap_hlen;
> >+      rcu_read_unlock();
> >+      return mtu;
> >+}
> >+
> > /* tipc_bearer_xmit_skb - sends buffer to destination over bearer
> >  */
> > void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
> >diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
> >index 490ad6e5f7a3..bd0cc5c287ef 100644
> >--- a/net/tipc/bearer.h
> >+++ b/net/tipc/bearer.h
> >@@ -146,6 +146,7 @@ struct tipc_media {
> >  * @identity: array index of this bearer within TIPC bearer array
> >  * @disc: ptr to link setup request
> >  * @net_plane: network plane ('A' through 'H') currently associated wit=
h bearer
> >+ * @encap_hlen: encap headers length
> >  * @up: bearer up flag (bit 0)
> >  * @refcnt: tipc_bearer reference counter
> >  *
> >@@ -170,6 +171,7 @@ struct tipc_bearer {
> >       u32 identity;
> >       struct tipc_discoverer *disc;
> >       char net_plane;
> >+      u16 encap_hlen;
> >       unsigned long up;
> >       refcount_t refcnt;
> > };
> >@@ -232,6 +234,7 @@ int tipc_bearer_setup(void);
> > void tipc_bearer_cleanup(void);
> > void tipc_bearer_stop(struct net *net);
> > int tipc_bearer_mtu(struct net *net, u32 bearer_id);
> >+int tipc_bearer_min_mtu(struct net *net, u32 bearer_id);
> > bool tipc_bearer_bcast_support(struct net *net, u32 bearer_id);
> > void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
> >                         struct sk_buff *skb,
> >diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
> >index c2bb818704c8..0a85244fd618 100644
> >--- a/net/tipc/udp_media.c
> >+++ b/net/tipc/udp_media.c
> >@@ -738,8 +738,8 @@ static int tipc_udp_enable(struct net *net, struct t=
ipc_bearer *b,
> >                       udp_conf.local_ip.s_addr =3D local.ipv4.s_addr;
> >               udp_conf.use_udp_checksums =3D false;
> >               ub->ifindex =3D dev->ifindex;
> >-              if (tipc_mtu_bad(dev, sizeof(struct iphdr) +
> >-                                    sizeof(struct udphdr))) {
> >+              b->encap_hlen =3D sizeof(struct iphdr) + sizeof(struct ud=
phdr);
> >+              if (tipc_mtu_bad(dev, b->encap_hlen)) {
> I agree that calling tipc_mtu_bad() is not necessary for UDP bearer enabl=
ing. You can remove it in this patch.
To be honest, it's NOT appropriate to do code cleanup in this patch,
nor in net.git.

Thanks.

> >                       err =3D -EINVAL;
> >                       goto err;
> >               }
> >@@ -760,6 +760,7 @@ static int tipc_udp_enable(struct net *net, struct t=
ipc_bearer *b,
> >               else
> >                       udp_conf.local_ip6 =3D local.ipv6;
> >               ub->ifindex =3D dev->ifindex;
> >+              b->encap_hlen =3D sizeof(struct ipv6hdr) + sizeof(struct =
udphdr);
> >               b->mtu =3D 1280;
> > #endif
> >       } else {
> >--
> >2.39.1
>

