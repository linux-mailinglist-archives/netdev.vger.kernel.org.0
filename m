Return-Path: <netdev+bounces-6209-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B8B7715381
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 04:15:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D8B11C20B26
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 02:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D375ECD;
	Tue, 30 May 2023 02:15:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCAEEBF
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:15:44 +0000 (UTC)
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5BAA3
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:15:43 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id 71dfb90a1353d-456ea0974bcso2939308e0c.1
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685412942; x=1688004942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmLNZNYW3EsN98DRmjWpFOakmG77pFE1A4XNkchyViw=;
        b=YX6r1Ksl9vqNwf2PW+8FU+HyoD0jEBsI421UWhdEJFpSjn96zgP3WkI/xavEF+4AKa
         Fj4zcnDA6TRkpCACi3NC9RJFmYLDS3D0Zt/5iYMObaOppH6QRK0ziQIOfaI43pEdp/LJ
         U8/ePJtlYYkALVwRJ1rtvfMCgKrmN42Qt5PLhtc3hWuffwxD4nCfyQjII0QLMGEx8VFz
         gAv2/70Kwf3ADK/HjZuXH/aVjdytimPKvSwgDdATHi08vsfLrgRStQXY+4N8nBM4vBQj
         Fws5eYGgZsoqsyLOWVi8UpuY+F/sVzlEluJA2nuQQtGPnKBJQ15+gzm0CqIE9i5acCd3
         eLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685412942; x=1688004942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BmLNZNYW3EsN98DRmjWpFOakmG77pFE1A4XNkchyViw=;
        b=Cex0yvajDO2vJulzjcajXesK5A8JmX03Qm2vY0wyNju0JqZFKzQ9tP7mTiSdxU2nmk
         YqDzdTmLJs/x3VfpvIZlJAIfe0Y59ABZ/rjjjUAVvIgSqZ059WjopLQyorJGQOQY7tRH
         gCATb/4X8MILKlyJuDz/PQw/I9Q30MpMfBaWiUVi5Kq3j+79y1sriDMHSKbS64CEmTXV
         plKMVxdpjvJQPBhI6W56Sk3q+dyKanXpq+NP9H1Mel+D2QX/YFDR/vYVZf2GdxyVqSPJ
         3hPmPCGzmQq4r26sdw1xza7L9jgBBs+8qveS5480kBPEOuxwHKglaiVSnSrNvZbLhyVQ
         yLRg==
X-Gm-Message-State: AC+VfDwDIcMp5puBsoka5q+MfQay1ErTDXz51QawsvOUcNAjr5+4fNHV
	V7M32Fx3xOt0Wps/vRd0+SsEjvDcSNqxMrDLUHg=
X-Google-Smtp-Source: ACHHUZ5cp2jaX2E81+PTA+NBRSMm+VGow01k0EGmDWlx84XeG5rceYy4jtU+clzrl18RK+csqjQ00etCmR65ATwBkf8=
X-Received: by 2002:a05:6122:334:b0:450:31d9:e5f5 with SMTP id
 d20-20020a056122033400b0045031d9e5f5mr3050237vko.2.1685412942170; Mon, 29 May
 2023 19:15:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530010348.21425-1-kuniyu@amazon.com>
In-Reply-To: <20230530010348.21425-1-kuniyu@amazon.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 29 May 2023 22:15:06 -0400
Message-ID: <CAF=yD-L88D+vxGcd1u9y07VKW242_macrQ+Q10ZCo_br9z2+ow@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 00/14] udp: Farewell to UDP-Lite.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 9:04=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> Recently syzkaller reported a 7-year-old null-ptr-deref [0] that occurs
> when a UDP-Lite socket tries to allocate a buffer under memory pressure.
>
> Someone should have stumbled on the bug much earlier if UDP-Lite had been
> used in a real app.  Additionally, we do not always need a large UDP-Lite
> workload to hit the bug since UDP and UDP-Lite share the same memory
> accounting limit.
>
> Given no one uses UDP-Lite, we can drop it and simplify UDP code by
> removing a bunch of conditionals.
>
> This series removes UDP-Lite support from the core networking stack first
> and incrementally removes the dead code.
>
> [0]: https://lore.kernel.org/netdev/20230523163305.66466-1-kuniyu@amazon.=
com/

Even if there is high confidence that this protocol is unused, for
which I'm not sure the above is sufficient proof, it should be
disabled first and left in place, and removed only when there is no
chance that it has to be re-enabled.

We already have code churn here from the split between UDP and
UDPLite, which was reverted in commit db8dac20d519 ("[UDP]: Revert
udplite and code split."). This series would be an enormous change to
revert. And if sufficient time passes in between, there might be ample
patch conflicts, the fixups of which are sources for subtle bugs.

