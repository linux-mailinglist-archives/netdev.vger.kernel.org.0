Return-Path: <netdev+bounces-10562-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A4472F125
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 02:50:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51B8F1C208E9
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 00:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D98037A;
	Wed, 14 Jun 2023 00:50:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C334C7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0250EC433C8;
	Wed, 14 Jun 2023 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686703852;
	bh=BPkeVu8OxPotzWhrp9aHUHfVrW4/Skp7NV1QkalCka0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hMuC7m1k1oCYmdNL8W4eaq/Fvq7MovlhxOr/OnphL+JQKlG4/ZU3zJOb/L4gKtCys
	 2q2duUg4/aq3zcgK1ztZ6DigIO2B+rjDS3OLvJa/1V2dHQTF53Dt5BJugftKUECuaM
	 gkHPShP4miWFR5HLA40hNR8MmqGZ2k7tBsjMbsAIz2Kg5GMbtyldxMLB4Z6Uv44yOU
	 jQtmRmbCSWxZ90iy3aBDWsV65uhNc5Org6RcU2csRHj+h31HUiXztoV5VjmEPFcSpJ
	 TV4zQPDg7SWfA1b/aeC2Oy7Kujl8dlWJgnsbDW4ybN26mE/HFGi70f8xVfDjwGDNlX
	 YmaTJ5Y9EcqXA==
Date: Tue, 13 Jun 2023 17:50:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 chuck.lever@oracle.com
Subject: Re: [PATCH net-next] tools: ynl-gen: fix nested policy attribute
 type
Message-ID: <20230613175051.32196c59@kernel.org>
In-Reply-To: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
References: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 01:17:07 +0200 Arkadiusz Kubalewski wrote:
> When nested multi-attribute is used in yaml spec, generated type in
> the netlink policy is NLA_NEST, which is wrong as there is no such type.
> Fix be adding `ed` sufix for policy generated for 'nest' type attribute
> when the attribute is parsed as TypeMultiAttr class.

I CCed you on my changes which address the same issue, they have
already been merged:

https://lore.kernel.org/all/20230612155920.1787579-1-kuba@kernel.org/

I think that covers the first two patches. What am I missing? :S

