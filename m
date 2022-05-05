Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF5051BDAC
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 13:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353665AbiEELHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 07:07:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50276 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356393AbiEELHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 07:07:22 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 62DEC82316D0;
        Thu,  5 May 2022 04:03:40 -0700 (PDT)
Date:   Thu, 05 May 2022 12:03:38 +0100 (BST)
Message-Id: <20220505.120338.1740932781798266692.davem@davemloft.net>
To:     leon@kernel.org
Cc:     steffen.klassert@secunet.com, leonro@nvidia.com, kuba@kernel.org,
        dsahern@kernel.org, herbert@gondor.apana.org.au,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com, raeds@nvidia.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH ipsec-next 3/8] xfrm: rename xfrm_state_offload struct
 to allow reuse
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2a59f8a4bfa849da0b3a9931bc2f687a6efdb74b.1651743750.git.leonro@nvidia.com>
References: <cover.1651743750.git.leonro@nvidia.com>
        <2a59f8a4bfa849da0b3a9931bc2f687a6efdb74b.1651743750.git.leonro@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 05 May 2022 04:03:43 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Thu,  5 May 2022 13:06:40 +0300

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The struct xfrm_state_offload has all fields needed to hold information
> for offloaded policies too. In order to do not create new struct with
> same fields, let's rename existing one and reuse it later.
> 
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: David S. Miller <davem@davemloft.net>
