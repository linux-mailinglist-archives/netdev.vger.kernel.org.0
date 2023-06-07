Return-Path: <netdev+bounces-8990-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF2047267B4
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18D4D1C20E6A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 174BA38CB4;
	Wed,  7 Jun 2023 17:46:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDDB1772E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FCBC433EF;
	Wed,  7 Jun 2023 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686159964;
	bh=w4lH+1m5uA5ObF5GBeQgMdYOBG42Ypds2O9e4uqOF/E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jLQ+buIz34E+qg1PACQhLICnu5B6TtOgF/vjMrcRG7OMSFslvfXQE0GsZCYYEKiRt
	 AAFIBglsDG2yisi3goMFVCP1DscLH172Ta7SigN64q2JKdkDvKj8PUCEX5wUBpeUlQ
	 3SmWhs7IWg0OdZl1fzkmlGcfUVWOYXj4pHm25WXlucrzJAM8jRu/JynxZA4bDdS+ec
	 6rVt24N0nMKYTkc+YTku1vkVqv6kMcZjYtryd9t+HfE3WnAHZRUze/4drOb47l4SzE
	 08pa1cce10zLKXH/DmZgV4raPPZxkEHske9Wg5ZyUQD8rB30gS27UFPhWPiReQL13d
	 Bjhu2oVRRHtFw==
Date: Wed, 7 Jun 2023 10:46:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 Chuck Lever <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>,
 John Fastabend <john.fastabend@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 14/14] tls/device: Convert
 tls_device_sendpage() to use MSG_SPLICE_PAGES
Message-ID: <20230607104602.17488bf3@kernel.org>
In-Reply-To: <2293519.1686159322@warthog.procyon.org.uk>
References: <20230607102600.07d16cf0@kernel.org>
	<20230607140559.2263470-1-dhowells@redhat.com>
	<20230607140559.2263470-15-dhowells@redhat.com>
	<2293519.1686159322@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 07 Jun 2023 18:35:22 +0100 David Howells wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > Acked-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Did you mean Acked-by rather than Reviewed-by?

Yeah, looks mostly mechanical, I trust you did the right thing.

