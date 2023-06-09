Return-Path: <netdev+bounces-9450-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F19729235
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19DF71C21051
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 08:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F20BAA946;
	Fri,  9 Jun 2023 08:06:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E00A940
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495D5C433EF;
	Fri,  9 Jun 2023 08:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686297984;
	bh=VbZVxaGPaRsw6JvGUSTbVpf9AHBEjjB7Txf6NpcNiDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=isyL61hXblRasPl4TUYSr4DLYgRNKmTm4sur8grg95rnbuWHgqvSppAptmviYlZax
	 qpZkWJRj7YOwi9UadXQBzDt1NbjwKcGUB7WroS9hu4q0XoYo2PkU/A70SwjSzTxzBu
	 8r2xDrdqTECGRdGTW8IUUCjFVpDGdrtbWfI0sarH2AJbzJ+wKjcCvEWSMkPgznclF0
	 QZlEs2Jh9oDaCC8BLwaamKHheRNtPt04Ez+A/3mn0yFyeE735lSvVSOVOuoj75NdEO
	 5yjaoNqfu05UPxfT0PQ5Y9WBnLr6ptcAMjKs5ZlhyDCkj2XSdIFh3OjkkNMnpFhNBb
	 BOZtM/PjPDYFw==
Date: Fri, 9 Jun 2023 10:06:13 +0200
From: Christian Brauner <brauner@kernel.org>
To: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v7 4/4] af_unix: Kconfig: make CONFIG_UNIX bool
Message-ID: <20230609-geordert-biegen-51294566232b@brauner>
References: <20230608202628.837772-1-aleksandr.mikhalitsyn@canonical.com>
 <20230608202628.837772-5-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230608202628.837772-5-aleksandr.mikhalitsyn@canonical.com>

On Thu, Jun 08, 2023 at 10:26:28PM +0200, Alexander Mikhalitsyn wrote:
> Let's make CONFIG_UNIX a bool instead of a tristate.
> We've decided to do that during discussion about SCM_PIDFD patchset [1].
> 
> [1] https://lore.kernel.org/lkml/20230524081933.44dc8bea@kernel.org/
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> Cc: Luca Boccassi <bluca@debian.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>

