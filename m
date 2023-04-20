Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C6F6E88F4
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 06:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjDTED4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 00:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjDTEDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 00:03:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C188DE5F
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 21:03:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AD61643D4
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 04:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49045C433EF;
        Thu, 20 Apr 2023 04:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681963432;
        bh=ggcePdRBvDcfz+32CwypFAPRKKQBSAWsZyHWK6xW9VU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XpOV4UALJXBvX0NFr4cSnkjh0lW+m9dDOXEdigh2Fh31Khr8dEZJ/cJ0tCpJDf1fH
         zzEcrWWvZyD0vWQ8iA0Ky23WKVr/4vuXUlaVMGIAlRlQNrrxDvev0vjNm2w00L6snx
         hRhVeI9PojgGkMXkdeouFlgk8eGdd/tN2TswwNWpCWEjW76/JECTCtMkmr0swp3+8Q
         5/Y/MI1msJhFZi/BXPzI47X1CJRf+a2xbhIDv9iHWqUxm3AUdI6HZFlBXxDktI+rob
         ya8rNqh1/sUQ2VOcVbSaHzqB7GLHkGkSwnZSdL9Y/MG5gosOrvzl5AEhc2eSTi0z7N
         ZBLRtUNXMSeng==
Date:   Wed, 19 Apr 2023 21:03:48 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, leon@kernel.org
Subject: Re: [PATCH net-next] eth: mlx5: avoid iterator use outside of a loop
Message-ID: <ZEC5pIaQfzirGSqd@x130>
References: <20230420015802.815362-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230420015802.815362-1-kuba@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 Apr 18:58, Jakub Kicinski wrote:
>Fix the following warning about risky iterator use:
>
>drivers/net/ethernet/mellanox/mlx5/core/eq.c:1010 mlx5_comp_irq_get_affinity_mask() warn: iterator used outside loop: 'eq'
>

Acked-by: Saeed Mahameed <saeed@kernel.org>

