Return-Path: <netdev+bounces-11977-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CBC2735923
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC91A2810FF
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0099011C8F;
	Mon, 19 Jun 2023 14:07:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B838BE5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:07:10 +0000 (UTC)
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8268AB
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:07:09 -0700 (PDT)
Received: from sparky.lan (unknown [159.196.93.152])
	by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 7386320153;
	Mon, 19 Jun 2023 22:07:00 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=codeconstruct.com.au; s=2022a; t=1687183622;
	bh=Zi8Q3+lSjvBrfrM3SdqJlbZi4/Rc2YBaeBye3BWAkN0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VCafOUSti/j8wBPaEI67oO15YsgZjEm8lvA8i00E8kVkjSQC2gg6e0k7fcOr78eH8
	 RcP5euhw5himZZ+NVUyMKF+Qk2el1Ql6Je+xB34vThMA7gNY6jrbMkDnUn3Mlse1gp
	 hJXhlxfIn/aZZuajiyGL7qJ+uZ54EajOyFwJYtf8GJg3mzFnsOCjWLzDmchMokMtMh
	 6r5a88Eo+yVd9MAOL9fvMT5Ir+Vt5cg6HH4cBKy6B24OjxZWGOqvdvsD8X5pyb0VHP
	 eOMeZZnX23dc+pFTO+Pb8LeqSafyRZUlgzXhtfY7hQP4XqjdbK94QQ/4r/eqSrOXSg
	 F5Wm3c49BnheA==
Message-ID: <c83bb6cf8f0d1ea8f5e3da690cda5e9742498a39.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next] mctp: Reorder fields in 'struct mctp_route'
From: Jeremy Kerr <jk@codeconstruct.com.au>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Matt Johnston
 <matt@codeconstruct.com.au>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	netdev@vger.kernel.org
Date: Mon, 19 Jun 2023 22:06:59 +0800
In-Reply-To: <393ad1a5aef0aa28d839eeb3d7477da0e0eeb0b0.1687080803.git.christophe.jaillet@wanadoo.fr>
References: 
	<393ad1a5aef0aa28d839eeb3d7477da0e0eeb0b0.1687080803.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Christoph,

> Group some variables based on their sizes to reduce hole and avoid
> padding. On x86_64, this shrinks the size of 'struct mctp_route' from
> 72 to 64 bytes.
>=20
> It saves a few bytes of memory and is more cache-line friendly.

The savings will be fairly minimal, but this doesn't affect readability
for the route struct. LGTM.

Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>

Thanks!


Jeremy

