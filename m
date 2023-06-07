Return-Path: <netdev+bounces-8975-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B74C0726732
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AAA0280FE8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F03437353;
	Wed,  7 Jun 2023 17:25:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4960E1641B
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0C0C433EF;
	Wed,  7 Jun 2023 17:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686158713;
	bh=55IckEdoiainGC0Thv2i7gkI02+ZQ8pyWrioShCnfI8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kdJJc1XTErGdBFD6i7N6VCxN7/0zh1GCh6YVKLdfEo6HwL/KBXLF6HeGmdQI+KWWI
	 ntnrtqh6YQUqbh1exPdVMVZezUOUPVD52m9o/dR8fSocPaw1jUGKMzW5Fe/9r1jun/
	 DdQoFugD23UGzfO7N+VtZ9gN6llPnj5kPi0SRb+vdixDLA65tZPwrJ4BIXt+aEH3W1
	 8Jg76P1q1mrv4uRMTE1SGFgaMdDXj6vb4Ti1CfqMjYIMClATqxHc+iS8tKECu/87lY
	 rcm0jyBtC1V55ADJmlcujq3LIucHuxXdiS5T5mX57vC3PwbHF+/yniO9ZIuVeT6pIv
	 u6EVcxUNxPi+w==
Date: Wed, 7 Jun 2023 10:25:12 -0700
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
Subject: Re: [PATCH net-next v5 13/14] tls/device: Support MSG_SPLICE_PAGES
Message-ID: <20230607102512.04491089@kernel.org>
In-Reply-To: <20230607140559.2263470-14-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
	<20230607140559.2263470-14-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 15:05:58 +0100 David Howells wrote:
> Make TLS's device sendmsg() support MSG_SPLICE_PAGES.  This causes pages to
> be spliced from the source iterator if possible.
> 
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

