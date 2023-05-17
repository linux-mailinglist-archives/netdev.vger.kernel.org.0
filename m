Return-Path: <netdev+bounces-3392-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E46F6706D7D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CE4D280F37
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:58:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BEA111AF;
	Wed, 17 May 2023 15:58:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B48D111A4
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:58:46 +0000 (UTC)
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C7E93F9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:58:38 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3f396606ab0so211511cf.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684339117; x=1686931117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1uM+WBQHMXIMmmeW7P3Be6HUT9Bj/HTM7NZtfskIHTQ=;
        b=xJ2H8zc1SbZySuHLo7N/aor4N7Ks053dUyJolY0t9l6W9+hDOFCB5SLUcSLIPWb9LM
         7I2a/lnJrvnqDhTBnBTmZdsQ4PnBEYOSjJPjUUvtZ8BwJSK819bBJ53ShEyo1PpAUSKW
         TwLJuX6mFGAC6HSkoql9LFeaayM5d5LyPfxYi+H6bNSDgI4M4RcTCEFyzQAMKnh7ETln
         R2zlhyoRj5V3ixzVijY1f06dDhLP9dz1UPRuChMfiAJu3WLEaC6Km+prDtycUwbN50Zv
         YO/buQtsEdFblTs0T1WJjxZBXrEV2iswHBfCD2oVjszFZkaLgZxvbJ0hIPM1Llr9eKMr
         Bs5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684339117; x=1686931117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1uM+WBQHMXIMmmeW7P3Be6HUT9Bj/HTM7NZtfskIHTQ=;
        b=XFVaX2GaMUHdNBhNZa/25fhi7DN3tWdWZbJKLQmDlhmR81A46qtGAKgjepEovanYZ2
         qdD2RqiyPY3wxwRNHzRuvzZzO5sRqTPingIXOFE5t+qPtFaaJOtEOmzca38VzwpX9gjT
         5mzSwZPHry9eWxXlE+xk3YIjN/uPnRRdIAIEVjkASC5/XNJ5jQASo/fBYpI2WP3nyaI3
         I706/hwv98Hjn9nxZpPe4wPbRfDIl7PS2HB5lOBGmVKvHcURh2+TTqkOdmRp448inexe
         7Z4OR5MAEFMqdL3nwJuRrFqnAh0BAQSCF0dxADMXUVVZjsQ89U7YfZYP3G3RmgUlfVwi
         A4sA==
X-Gm-Message-State: AC+VfDybnckFi+cJg2sPYihRiXyp0B9axgG92z/hfDeOmNj6qTvXXocS
	JrvKrZW5fwn6T05f+AsuW46o36Mdk0bncdlbG52Byq6Skm4xlaTEzxlhsw==
X-Google-Smtp-Source: ACHHUZ4EHGFMEGDDLhBBAj/6NXQ0Y/MN4seOBfd+P4jGxcg8IeXKx/iIYAdKh49JsY7NuEH/OL2ya6Nx2N1XsoIyJb0=
X-Received: by 2002:ac8:580b:0:b0:3d4:edfd:8b61 with SMTP id
 g11-20020ac8580b000000b003d4edfd8b61mr365820qtg.0.1684339116508; Wed, 17 May
 2023 08:58:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
In-Reply-To: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 17 May 2023 17:58:25 +0200
Message-ID: <CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=3u+UyLBmGmifHA@mail.gmail.com>
Subject: Re: net: getsockopt(TCP_MAXSEG) on listen sock returns wrong MSS?
To: Cambda Zhu <cambda@linux.alibaba.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
	Tony Lu <tonylu@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 1:09=E2=80=AFPM Cambda Zhu <cambda@linux.alibaba.co=
m> wrote:
>
> I want to call setsockopt(TCP_MAXSEG) on a listen sock to let
> all child socks have smaller MSS. And I found the child sock
> MSS changed but getsockopt(TCP_MAXSEG) on the listen sock
> returns 536 always.
>

I think TCP_MAXSEG is not like a traditional option you can set and get lat=
er,
expecting to read back the value you set.

It is probably a bug.

Getting tp->mss_cache should have been a separate socket option, but
it is too late.


> It seems the tp->mss_cache is initialized with TCP_MSS_DEFAULT,
> but getsockopt(TCP_MAXSEG) returns tp->rx_opt.user_mss only when
> tp->mss_cache is 0. I don't understand the purpose of the mss_cache
> check of TCP_MAXSEG. If getsockopt(TCP_MAXSEG) on listen sock makes
> no sense, why does it have a branch for close/listen sock to return
> user_mss? If getsockopt(TCP_MAXSEG) on listen sock is ok, why does
> it check mss_cache for a listen sock?
>
> I tried to find the commit log about TCP_MAXSEG, and found that
> in commit 0c409e85f0ac ("Import 2.3.41pre2"), the mss_cache check
> was added. No more detailed information found. Is this a bug or am
> I misunderstanding something?

I wonder if we should simply do:

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4d6392c16b7a5a9a853c27e3a4b258d000738304..cb526257a06a6c7a4e65e710fff=
1770bd382ed2d
100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4080,9 +4080,10 @@ int do_tcp_getsockopt(struct sock *sk, int level,

        switch (optname) {
        case TCP_MAXSEG:
-               val =3D tp->mss_cache;
-               if (!val && ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTE=
N)))
+               if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
                        val =3D tp->rx_opt.user_mss;
+               else
+                       val =3D tp->mss_cache;
                if (tp->repair)
                        val =3D tp->rx_opt.mss_clamp;
                break;

