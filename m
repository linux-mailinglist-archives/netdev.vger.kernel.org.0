Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEC051BDA8
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 13:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242160AbiEELHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 07:07:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50274 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351727AbiEELHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 07:07:03 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 7735682316CF;
        Thu,  5 May 2022 04:03:22 -0700 (PDT)
Date:   Thu, 05 May 2022 12:03:05 +0100 (BST)
Message-Id: <20220505.120305.2196682232464025660.davem@davemloft.net>
To:     leon@kernel.org
Cc:     steffen.klassert@secunet.com, leonro@nvidia.com, kuba@kernel.org,
        dsahern@kernel.org, herbert@gondor.apana.org.au,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com, raeds@nvidia.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH ipsec-next 2/8] xfrm: delete not used number of
 external headers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <099569952c609251ea4c156d6c6aed6031abafa7.1651743750.git.leonro@nvidia.com>
References: <cover.1651743750.git.leonro@nvidia.com>
        <099569952c609251ea4c156d6c6aed6031abafa7.1651743750.git.leonro@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 05 May 2022 04:03:25 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Thu,  5 May 2022 13:06:39 +0300

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> num_exthdrs is set but never used, so delete it.
> 
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: David S. Miller <davem@davemloft.net>
