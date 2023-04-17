Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159BC6E3E5E
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 06:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjDQEFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 00:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjDQEFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 00:05:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29A5139
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 21:05:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CC7A60EB2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A61C433D2;
        Mon, 17 Apr 2023 04:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681704320;
        bh=iUdT5CgkQW+b5qosxR4s3pN7V5bqeFgO1asHJRwlbZg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KBdVEJvsOipB9Unq7Otw8cVJ5fnCT3ZmC/CI/dCtq6AvmVaGHtLvh6FYjFRmSGP9j
         U+vW8agycYYW6t1c7nJFiEaGrhhMt03gXPWtGYGfezEBCnpEe7BbpCOZheFdiwqTXu
         Can+38zeahXnJ40zg84gNGXP2ZtXK1eGkQN7hRtQ5+zer2hvnw0uEGkEq2MsXPOk3u
         larRi1mpCk5Hg/fYeJ3r1AwSt6ES8yl/tzQxjO3ex3rWltKBrHEJ4rtLzJ7R/XrOYb
         3BcIfIuN3VncNeBFMZfcQG0QdApnLhqgPbtngfpDmA9Y+jCNnN+xwc59o36iDUXWMo
         juYCkGx3K0JMg==
Date:   Sun, 16 Apr 2023 21:05:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next v1 00/10] Support tunnel mode in mlx5 IPsec
 packet offload
Message-ID: <20230416210519.1c91c559@kernel.org>
In-Reply-To: <cover.1681388425.git.leonro@nvidia.com>
References: <cover.1681388425.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 15:29:18 +0300 Leon Romanovsky wrote:
> Changelog:
> v1:
>  * Added Simon's ROB tags
>  * Changed some hard coded values to be defines
>  * Dropped custom MAC header struct in favor of struct ethhdr
>  * Fixed missing returned error
>  * Changed "void *" casting to "struct ethhdr *" casting
> v0: https://lore.kernel.org/all/cover.1681106636.git.leonro@nvidia.com
> 
> ---------------------------------------------------------------------
> Hi,
> 
> This series extends mlx5 to support tunnel mode in its IPsec packet
> offload implementation.

Hi Simon,

would you be able to take a look in the new few days?
I think you have the rare combination of TC and ipsec
expertise :)
