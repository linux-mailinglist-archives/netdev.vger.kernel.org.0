Return-Path: <netdev+bounces-2016-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1FE6FFF85
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6F5D2819FF
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 04:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 108A4A48;
	Fri, 12 May 2023 04:06:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F15A3D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 04:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38364C433D2;
	Fri, 12 May 2023 04:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683864381;
	bh=ZenAXuk85BLF9QfhqeAKss5Dc208nfw0dw945rZtVAI=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=oksvC1fE3y+hm3RTUqqYksjkqIP0DXFJBo1VxUa4AARnudKoo31ulg/zxJmvVAhoo
	 lqdDZdkffi93VKGZgKlpG0OS1mVv7nZIIVGuXFYNiM6XqNVyEcNQ4IYoQ44cMSub51
	 UcQyoeEQKBaUA2bzywRbjyJ3db+OKVSBbL02eVeVODo7zermhXdGtgKeBjxN5NfW2L
	 99IwVUYKpUAyTmUmQbVwwevXTA+46G+Zk51bNBzK5Wp5CjIRcJtLXtlYwBj/spMl17
	 Qp6JXT7uMYaKlPCVcW4ABtV4OwFaEtWig8lSbWR/7/JuhHNf1w9n/usIHol+RXbWRr
	 keSuFjOErh2zA==
From: Kalle Valo <kvalo@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jakub Kicinski <kuba@kernel.org>,  davem@davemloft.net,  netdev@vger.kernel.org,  edumazet@google.com,  pabeni@redhat.com,  linux-wireless@vger.kernel.org
Subject: Re: [PATCH net] MAINTAINERS: exclude wireless drivers from netdev
References: <20230511160310.979113-1-kuba@kernel.org>
	<d505bf5bbcd0f13a37f9c8465667e355ce20bc26.camel@sipsolutions.net>
Date: Fri, 12 May 2023 07:06:15 +0300
In-Reply-To: <d505bf5bbcd0f13a37f9c8465667e355ce20bc26.camel@sipsolutions.net>
	(Johannes Berg's message of "Thu, 11 May 2023 18:38:37 +0200")
Message-ID: <87y1lumbwo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2023-05-11 at 09:03 -0700, Jakub Kicinski wrote:
>> It seems that we mostly get netdev CCed on wireless patches
>> which are written by people who don't know any better and
>> CC everything that get_maintainers spits out. Rather than
>> patches which indeed could benefit from general networking
>> review.
>> 
>> Marking them down in patchwork as Awaiting Upstream is
>> a bit tedious.
>> 
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>> CC: kvalo@kernel.org
>> CC: johannes@sipsolutions.net
>> CC: linux-wireless@vger.kernel.org
>> 
>> Is this okay with everyone?
>> 
>
> Yeah, makes sense.
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

I didn't even know about 'X', a very good idea:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

