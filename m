Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C608B51BDA6
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 13:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353496AbiEELGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 07:06:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50272 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242160AbiEELG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 07:06:29 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 68AC682316CB;
        Thu,  5 May 2022 04:02:48 -0700 (PDT)
Date:   Thu, 05 May 2022 12:02:34 +0100 (BST)
Message-Id: <20220505.120234.829231575836812605.davem@davemloft.net>
To:     leon@kernel.org
Cc:     steffen.klassert@secunet.com, leonro@nvidia.com, kuba@kernel.org,
        dsahern@kernel.org, herbert@gondor.apana.org.au,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com, raeds@nvidia.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH ipsec-next 1/8] xfrm: free not used XFRM_ESP_NO_TRAILER
 flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a8b37f45df031108d6b191916570a1005d645d38.1651743750.git.leonro@nvidia.com>
References: <cover.1651743750.git.leonro@nvidia.com>
        <a8b37f45df031108d6b191916570a1005d645d38.1651743750.git.leonro@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 05 May 2022 04:02:50 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Thu,  5 May 2022 13:06:38 +0300

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> After removal of Innova IPsec support from mlx5 driver, the last user
> of this XFRM_ESP_NO_TRAILER was gone too. This means that we can safely
> remove it as no other hardware is capable (or need) to remove ESP trailer.
> 
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: David S. Miller <davem@davemloft.net>
