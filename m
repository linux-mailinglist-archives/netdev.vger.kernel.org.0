Return-Path: <netdev+bounces-9260-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44C257284D5
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97F57281714
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FCEE174D7;
	Thu,  8 Jun 2023 16:24:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9D8174D3
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:24:03 +0000 (UTC)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36F63AAE;
	Thu,  8 Jun 2023 09:23:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 2D0DD605DED7;
	Thu,  8 Jun 2023 18:23:34 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id zpbvNb15rfCI; Thu,  8 Jun 2023 18:23:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 306FB6081100;
	Thu,  8 Jun 2023 18:23:33 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id xSVgNBinm5pl; Thu,  8 Jun 2023 18:23:33 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id ED077605DED7;
	Thu,  8 Jun 2023 18:23:32 +0200 (CEST)
Date: Thu, 8 Jun 2023 18:23:32 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>, 
	linux-hardening <linux-hardening@vger.kernel.org>, 
	netdev <netdev@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, 
	senozhatsky <senozhatsky@chromium.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	davem <davem@davemloft.net>, edumazet <edumazet@google.com>, 
	kuba <kuba@kernel.org>, pabeni <pabeni@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?Q?Bj=C3=B6rn?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, 
	Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>
Message-ID: <447684945.3699459.1686241412894.JavaMail.zimbra@nod.at>
In-Reply-To: <2023060820-atom-doorstep-9442@gregkh>
References: <20230607223755.1610-1-richard@nod.at> <202306071634.51BBAFD14@keescook> <ZIHzbBXlxEz6As9N@alley> <2023060820-atom-doorstep-9442@gregkh>
Subject: Re: [RFC PATCH 0/1] Integer overflows while scanning for integers
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: Integer overflows while scanning for integers
Thread-Index: 8Ta4XA3Xj4SCOt1cjsjdEFB0STxIxQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

----- Urspr=C3=BCngliche Mail -----
> Von: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> "some users" =3D=3D "most major cloud providers and a few billion Android
> phones"  So in pure numbers, the huge majority of Linux systems running
> in the world have that option enabled.
>=20
> So please don't use WARN() to catch issues that can be triggered by
> userspace, that can cause data loss and worse at times.

Sorry for being unclear. My goal is not having the WARN patch immediately
applied without fixing known call sites which can trigger it.

Thanks,
//richard

