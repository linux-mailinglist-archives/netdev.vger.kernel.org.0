Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251AF5710B6
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 05:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiGLDRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 23:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiGLDRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 23:17:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3516766BAA;
        Mon, 11 Jul 2022 20:17:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2DDBB81647;
        Tue, 12 Jul 2022 03:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B12AC34115;
        Tue, 12 Jul 2022 03:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657595833;
        bh=J25fbPyZIElwvHcgf+FundCXwLuPZRG1xQlqXVip9Sg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rAMZU+jz8OfrUllrWPBQdgLoWIUBI1WLjkO8be0PilC9I4wSktXcx5426LtUfpuBc
         xTsT67ZCbo5GPlNBem8NcKcaQF0ZE87X9rbrGBCPfshm8JwhjWOcFhRCslhFOKRifX
         jP31eBnrnnyo8p8EKe+bDMrtcsLSYcuuWC0ROTOh36n27aKO8Hp9SVeGxjDqX/BX8S
         EKQwSto4TF+o8FAY4x51FSyBaO8/vgiE6tj+yYc2GFjcAr+Dykz7vG2TKy9TVOtMFL
         IPwH9LTS4QB6TnEqBD+PdBwxJXS3JBXMcpRPJmr2F11nYhknopf4xNlHXK7w2OoGEe
         rhDZxiz4biIeA==
Date:   Mon, 11 Jul 2022 20:17:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/9] net: marvell: prestera: add nexthop routes
 offloading
Message-ID: <20220711201712.64536a7d@kernel.org>
In-Reply-To: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
References: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
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

On Sun, 10 Jul 2022 20:21:58 +0300 Yevhen Orlov wrote:
> Add support for nexthop routes for Marvell Prestera driver.
> Subscribe on NEIGH_UPDATE events.

$ git pw series apply 658304
Failed to apply patch:
Applying: net: marvell: prestera: Add router nexthops ABI
error: sha1 information is lacking or useless (drivers/net/ethernet/marvell/prestera/prestera_router.c).
error: could not build fake ancestor
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Patch failed at 0001 net: marvell: prestera: Add router nexthops ABI
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
