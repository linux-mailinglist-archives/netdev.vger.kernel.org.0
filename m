Return-Path: <netdev+bounces-4483-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5280F70D166
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B89DA1C20C36
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664D94C8D;
	Tue, 23 May 2023 02:38:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152BB63D2
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5999EC433D2;
	Tue, 23 May 2023 02:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684809507;
	bh=bMQX7nxLNAZp0941mwLdOgEWnsP6ucv1KeEe2O/NpT8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=o3Gs7Sk7Sp+Lbl6n2tEs3E4bYqtkYMKda+4PlCDojdgItyBmUfjioKzFQV3jzB6zX
	 Uw5r9uhGfCZLO7wmRwxPkHXFw9wPKSpkah2TmK0nXQG5/OhE320HZdWveEo/9g8dQi
	 7uz6R5DzqnuuaTwjMvC5rElczyEr930FABy3/dDeEAVgUnhlLTacgepBqqAP/Ergv3
	 okZE2cL8xQC1L17Kz4n0X9nGGAzRBqKrA73vMql6NEBU0wUXYmmJwDY/Uz9vCsLNgH
	 /D/woeIv5slR8DMyVJOiqxZaVQcvJtDMdq5lQPAEeiMefHMCwtPQoF+CiAJSAWSQri
	 pVv330gOOTC9Q==
Date: Mon, 22 May 2023 19:38:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jonathan
 Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
 donald.hunter@redhat.com
Subject: Re: [patch net-next v1 2/2] tools: ynl: Handle byte-order in struct
 members
Message-ID: <20230522193826.48ecdd59@kernel.org>
In-Reply-To: <20230521170733.13151-3-donald.hunter@gmail.com>
References: <20230521170733.13151-1-donald.hunter@gmail.com>
	<20230521170733.13151-3-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 21 May 2023 18:07:33 +0100 Donald Hunter wrote:
> Add support for byte-order in struct members in the genetlink-legacy
> spec.

Acked-by: Jakub Kicinski <kuba@kernel.org>

Which spec is this for? 

