Return-Path: <netdev+bounces-10279-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B31A072D84C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 06:09:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE2761C20BB8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 04:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CB31FB6;
	Tue, 13 Jun 2023 04:09:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8757F
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 04:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A33C433D2;
	Tue, 13 Jun 2023 04:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686629345;
	bh=gcYLEJmYhn8Y/B0gvoEFzJ/4hmgkUFsu0ldSHoSsl6g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JbtnMJXcWJFgFAi7Wx0GxQupFXlVzt/KQaJQItODG9bptE97nZcqSn1IX7ZQ99won
	 ecXw59GLkcgOg8tdHNXWsr7Z6tu0rmAQNqwK3FK4YJPXidXAK1jAdAp5tMkqjCy8yM
	 CWhdfY2WaQEs3kMky3Z+S+2YuPBUOYERXSL0JVz/OrDcjE2o5aEsFI4BHMnDP62e9c
	 1GgX1PeKY/F8ThND0q9lG54yuJqpIsqycnuuWjWZ/fWStarM+Ay8gN3Jb8crIyRKfU
	 szutEdixjzJkDZuLEO+DIYWUTSojEBDkNIn94lcEfDfQk3/cQ0g6/+Le8zJM39gA34
	 vBYmF+qG0PVPg==
Date: Mon, 12 Jun 2023 21:09:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Magali Lemes <magali.lemes@canonical.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 shuah@kernel.org, vfedorenko@novek.ru, tianjia.zhang@linux.alibaba.com,
 andrei.gherzan@canonical.com, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] selftests: net: tls: check if FIPS mode is
 enabled
Message-ID: <20230612210904.1023f312@kernel.org>
In-Reply-To: <20230612125107.73795-3-magali.lemes@canonical.com>
References: <20230612125107.73795-1-magali.lemes@canonical.com>
	<20230612125107.73795-3-magali.lemes@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Jun 2023 09:51:05 -0300 Magali Lemes wrote:
> @@ -406,6 +415,7 @@ static void chunked_sendfile(struct __test_metadata *_metadata,
>  
>  TEST_F(tls, multi_chunk_sendfile)
>  {
> +
>  	chunked_sendfile(_metadata, self, 4096, 4096);
>  	chunked_sendfile(_metadata, self, 4096, 0);
>  	chunked_sendfile(_metadata, self, 4096, 1);

nit: leftover change, with that fixed feel free to add:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
-- 
pw-bot: cr

