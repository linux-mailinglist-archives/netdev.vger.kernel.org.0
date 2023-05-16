Return-Path: <netdev+bounces-3104-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0618D7057D0
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:47:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1B972813C2
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6361C847A;
	Tue, 16 May 2023 19:47:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590A179E0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:47:27 +0000 (UTC)
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79467BE;
	Tue, 16 May 2023 12:47:13 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1684266429; bh=kS06qhDO4SuIPjXTCQd5ri72irx1DJTv1Uk+i6GpwGs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=xn/yjWqqhVOfJWo4wMwSsEXEfyJYKmZgxCmzubpJMDYJ5QRJLaRzPUd3tuhdHHtHH
	 JCkDKPZpK8XjTtu/EztjVbyyKmEeROQBjF6HFojbg1sWdeJdivxBJ7VpTNjv03idRf
	 oqsqVbcNcl9IW8kV/amAEV2RaOV+n8bOMefnCVGGRrmtQhWoXHQUolGO6+pp+vdjRU
	 ZPs87cck+2eOr/VVJUqj1Q+WP34dJsUDPmxbF2OF5Aiw7NzIylnxMEC8joCYobU7h7
	 TTr1dyWNh39FcMBho/IMJ1Fn5yQPdllpQqd0hhx5rBq3hEDPIpjOrlnboQB9g9LIoU
	 JGliQsv/mrhCg==
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Takeshi Misawa
 <jeliantsurux@gmail.com>, Alexey Khoroshilov <khoroshilov@ispras.ru>,
 lvc-project@linuxtesting.org,
 syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] wifi: ath9k: don't allow to overwrite ENDPOINT0
 attributes
In-Reply-To: <20230516150427.79469-1-pchelkin@ispras.ru>
References: <20230516150427.79469-1-pchelkin@ispras.ru>
Date: Tue, 16 May 2023 21:47:08 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <871qjgcb43.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> A bad USB device is able to construct a service connection response
> message with target endpoint being ENDPOINT0 which is reserved for
> HTC_CTRL_RSVD_SVC and should not be modified to be used for any other
> services.
>
> Reject such service connection responses.
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-by: syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

