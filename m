Return-Path: <netdev+bounces-5109-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1460670FAB1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:46:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6A3F1C202F1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15C319BC8;
	Wed, 24 May 2023 15:46:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E593419BB3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:46:55 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9DE1B4
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:46:28 -0700 (PDT)
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 097AA41B3C
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684943138;
	bh=92JsxtKc2doKzuIzI6aLPIX3GzuVF3Oem9Ak6r3By98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=Oy3mUJtsR8+daqdkE/eZzHg5GtrArvzXZSD1wf3sRtRff5lVcxrbz2iyIFQtBF4jW
	 vU1qslA5ZpVtSeNcxr6hTScry9QVUJltLo7awpa67Q8mjwRVvfXyINkvURd5aKkedm
	 LxrZN9cGORnnlFpxAHWwh1V7MDMdMcckZwdxNKPsUHe7x16BTCyrKosGZrj43uTYay
	 aH/oK+8BSMppKCIv1aQqEYcCpzgYq8PaiQuT9oX3BveCOvJZl+vtv4bqmsJDX3gChS
	 m3nfAGQsqCI9LYbQTgUEgNBxbDOeCCxfx5dl7kgE4vABU+w5Nai3HjYRpRNomwG6au
	 NjLnpJn/qo36g==
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-561985d744fso127516057b3.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684943137; x=1687535137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92JsxtKc2doKzuIzI6aLPIX3GzuVF3Oem9Ak6r3By98=;
        b=h+BIVAWOiqK3llxD4ip24fhHFTMJ5ZTr0undeXdYwe1KcO4pwxcDC+2X7lmFRgVP1X
         y5DPMQ4n01vwVe4kpujDilEgammutNy0mNcCbpL/W+drqJueMaZ5pXOdn90g3b6tETDB
         64x1jhq1j+RP7oU55PKYWbi609i8aYi2HAGC+K4GlPE/xaGFi45rtdbEefOF7vcEvABU
         zJlC0z8XCR00x2jYhcL3EwN/s+qW+qJHCOQr8HyYXaRjHwND8CacD9waHP60r2ckAkWh
         cBuf+JnliNNYMlLz9j0FNg07ig780DAenogQhDDNNiRdZ/A3nz135u8XDeCeSK1/WvA0
         0Ylw==
X-Gm-Message-State: AC+VfDztjntPK7zLCLn4HyeQSMwljNzCvv7eJZRsloo0NIOhSXSkiOp5
	0Ajsl3qbCohSze6REwQjJ8Qt4FZPW3QyvWJ1M1sg305BKdo9aQM9W9f4y6KXWNmUvB/daM2gUTs
	FdMJ8YNRhhFTHNjbE+Xm0aVNzk8zKgEsV85MB6JYDLEtrSyntSA==
X-Received: by 2002:a81:9a0e:0:b0:565:4c40:fc3 with SMTP id r14-20020a819a0e000000b005654c400fc3mr5833533ywg.23.1684943137038;
        Wed, 24 May 2023 08:45:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4NCqrhc0yq/4yGhKiNRTK/xREKkd6tNR7bvv/mKO+Lk2sONFl/YAqyvoWKLnPhNWxGPsyLx7N9OEP4prvaTeQ=
X-Received: by 2002:a81:9a0e:0:b0:565:4c40:fc3 with SMTP id
 r14-20020a819a0e000000b005654c400fc3mr5833509ywg.23.1684943136808; Wed, 24
 May 2023 08:45:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522132439.634031-1-aleksandr.mikhalitsyn@canonical.com>
 <20230522132439.634031-2-aleksandr.mikhalitsyn@canonical.com>
 <20230522133409.5c6e839a@kernel.org> <20230523-flechten-ortsschild-e5724ecc4ed0@brauner>
 <CAMw=ZnS8GBTDV0rw+Dh6hPv3uLXJVwapRFQHLMYEYGZHNoLNOw@mail.gmail.com>
 <20230523140844.5895d645@kernel.org> <CAEivzxeS2J5i0RJDvFHq-U_RAU5bbKVF5ZbphYDGoPcMZTsE3Q@mail.gmail.com>
 <CAMw=ZnRmNaoRb2uceatrV8EAufJSKZzD2AsfT5PJE8NBBOrHCg@mail.gmail.com> <20230524081933.44dc8bea@kernel.org>
In-Reply-To: <20230524081933.44dc8bea@kernel.org>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Wed, 24 May 2023 17:45:25 +0200
Message-ID: <CAEivzxcTEghPqk=9hQMReSGzE=ruWnJyiuPhW5rGd7eUOEg12A@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
To: Jakub Kicinski <kuba@kernel.org>
Cc: Luca Boccassi <bluca@debian.org>, Christian Brauner <brauner@kernel.org>, davem@davemloft.net, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Kees Cook <keescook@chromium.org>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Lennart Poettering <mzxreary@0pointer.de>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 5:19=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed, 24 May 2023 11:47:50 +0100 Luca Boccassi wrote:
> > > I will send SO_PEERPIDFD as an independent patch too, because it
> > > doesn't require this change with CONFIG_UNIX
> > > and we can avoid waiting until CONFIG_UNIX change will be merged.
> > > I've a feeling that the discussion around making CONFIG_UNIX  to be a
> > > boolean won't be easy and fast ;-)
> >
> > Thank you, that sounds great to me, I can start using SO_PEERPIDFD
> > independently of SCM_PIDFD, there's no hard dependency between the
> > two.
>
> How about you put the UNIX -> bool patch at the end of the series,
> (making it a 4 patch series) and if there's a discussion about it
> I'll just skip it and apply the first 3 patches?

Sure, I will do that!

>
> In the (IMHO more likely) case that there isn't a discussion it saves
> me from remembering to chase you to send that patch ;)

Thanks a lot, Jakub!

Kind regards,
Alex

