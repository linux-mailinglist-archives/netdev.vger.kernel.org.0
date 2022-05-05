Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7402451C570
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382107AbiEEQ4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiEEQ4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:56:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E3357B14
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:53:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAC0461E3A
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3781C385A8;
        Thu,  5 May 2022 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651769589;
        bh=r5GQqpd4Djf6aR9amOOzWwYgZVHXIiCxvaP0g6X1ios=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rVCBTPW1wb0zTbZmnnMlzeUtSCR7bv5JveLhRXQhfJKXqhFgl4zQ+56+7oE1g7bSU
         3HQ+ULHgCuk1yOCXjLblERZR0StmjWdP5o74DIw7iT5UtHP67wOy5pxUEe+1boc80G
         TZxwq4x7L+Ergqk8UXpCo3Ti8EzkCLLpayE6toUxPft7+0MgGh8yabBee9vWpDg4xk
         HJWR6mFLsxkTGBTVk9NxtoQIu1X3QGsaLBTcxfOAcXcAqGOz/yz+ni7nyLvRvmLv37
         EQi7+esvNe4tYAkUPZf96CuKbGxL2HPJqJ3kVJn3rceqS+2s9YqvNkyaa0n2MmqR5N
         0xsE9ko4ki3uQ==
Date:   Thu, 5 May 2022 09:53:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH ipsec-next 6/8] netdevsim: rely on XFRM state direction
 instead of flags
Message-ID: <20220505095307.488c093b@kernel.org>
In-Reply-To: <54be8183fb49a5486a8137627c204f00595e21af.1651743750.git.leonro@nvidia.com>
References: <cover.1651743750.git.leonro@nvidia.com>
        <54be8183fb49a5486a8137627c204f00595e21af.1651743750.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 May 2022 13:06:43 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Make sure that netdevsim relies on direction and not on flags.
> 
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
