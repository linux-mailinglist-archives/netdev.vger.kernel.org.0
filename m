Return-Path: <netdev+bounces-9789-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38EFA72A975
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 08:44:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59B982819F5
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 06:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C087F5224;
	Sat, 10 Jun 2023 06:44:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E501878
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 06:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCF2C433EF;
	Sat, 10 Jun 2023 06:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686379480;
	bh=g4sanin6+xI0B4vhTYi7+BW9QFwatU7jNWnveSM4k0Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oHrTylRbXOD0v/WbJf+zwohDHhRrbBgRdXVGAjnXtKiFRK9i8qRmilyzORwJ8TbzN
	 oZVYlRicAXeOtFFJZo/r5v18YkUkHC5c09moYtlFY1rNNQ3YPuMMT7u/h+RV6GHErh
	 Ol/8tBN71a2zy7vG0SVhG4XTfnBKgIfK43fnG2k5k6/yap6rkfBE+M8bPyTspPE81e
	 AKupRvkXC9ZU4Fp/KcYIdEpHC8Yt2wHr3KcNSCtq9alBordbA05iXjNEomeZZ8dtG2
	 xiph760PJTFRmW+OjZSAOfG1ZXAxc8jmQ11zObBTLsM48YIS+5ORNRFQL/+RroU88H
	 AReddApGftUAg==
Date: Fri, 9 Jun 2023 23:44:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
Cc: netdev@vger.kernel.org, przemyslaw.kitszel@intel.com,
 michal.swiatkowski@linux.intel.com, pmenzel@molgen.mpg.de,
 maciej.fijalkowski@intel.com, anthony.l.nguyen@intel.com,
 simon.horman@corigine.com, aleksander.lobakin@intel.com
Subject: Re: [PATCH net-next] net: add check for current MAC address in
 dev_set_mac_address
Message-ID: <20230609234439.3f415cd0@kernel.org>
In-Reply-To: <20230609165241.827338-1-piotrx.gardocki@intel.com>
References: <20230609165241.827338-1-piotrx.gardocki@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  9 Jun 2023 18:52:41 +0200 Piotr Gardocki wrote:
> +	if (ether_addr_equal(dev->dev_addr, sa->sa_data))
> +		return 0;

not every device is ethernet, you need to use dev->addr_len for
the comparison.
-- 
pw-bot: cr

