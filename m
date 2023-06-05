Return-Path: <netdev+bounces-8161-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E01722EF9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:54:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D2052813D6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFA42263F;
	Mon,  5 Jun 2023 18:54:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07255DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323A3C433D2;
	Mon,  5 Jun 2023 18:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685991273;
	bh=vXftzGJAhXXvWT1zyk21njhU2NPx1cGZNIXNxDJXYcc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KpQS+ifNplTlu8LeiCVLzF+tStMil7v/5jnh+D9nLbPbbP1uhLLEFHoCo/nkTFLHl
	 meD4QlpDx6O8BHJBKtH0zCzYLU/KhNF+uI9f/4oGOS+76WYyKhcirHbHlAhB2A5qCy
	 SjeCrEDjVWTQPnZYz9eEC6mGU3jaFfitIyw4r7DyYPjjW1bo+TXV5CgUZN7s0MqGxU
	 yMHKbMJKrMbp9ij4a9olWRBNK3OsgIE3tDRpK0uxEphsIh9qFzZ/SUcz/kWVu+Dvr2
	 EnDEed/h7nkjwN7y5N0mJNo/fcGdzWpmwJDjQ6MM3w1yRTYrA6nkn0JRksjqAWCsPu
	 /B9q2A61j59OA==
Date: Mon, 5 Jun 2023 11:54:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v2 4/4] tools: ynl: add sample for netdev
Message-ID: <20230605115432.05769008@kernel.org>
In-Reply-To: <647dab8865654_d27b6294f8@willemb.c.googlers.com.notmuch>
References: <20230604175843.662084-1-kuba@kernel.org>
	<20230604175843.662084-5-kuba@kernel.org>
	<647dab8865654_d27b6294f8@willemb.c.googlers.com.notmuch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 05 Jun 2023 05:31:52 -0400 Willem de Bruijn wrote:
> > +CFLAGS=-std=gnu99 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow \
> > +	-I../lib/ -I../generated/  
> 
> Should new userspace code also use gnu11?

Well, 99.9% sure it doesn't matter, but okay. Let me send v3.

