Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D730D6DB3DF
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 21:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjDGTCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 15:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjDGTCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 15:02:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDAFCA36
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 12:02:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF11D611E1
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 19:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4631C433EF;
        Fri,  7 Apr 2023 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680894120;
        bh=F290EzQUKpnRqyLE28+hgeCE1Mvr2YphbfOsKpkPSvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IXXYefnj9TJhLVHViH3wxLArb3uJ9HSLBpo8hzQ+WGj0wIH08HpN8P89PrASQ74DW
         TIU/W5WvC2C3vKgS4CIgSoTnSBa8GmyT3jGPIhGzK+KZ8drYBgulwDvAJzLoIC/T+c
         s8kyNuCFJlZIACTbIKlkwe7eit3zxwdgHvDupZjC27h4ugNxoVQeEgAxkiQbATAcDT
         ABTjPuU1JA7jL+5mxfrxxpLBE+lgpzxlSEqM6gPrKhFccGm25hTDrBSA83TFeij3s3
         gUxztLlnmLiTGyaCDqkEYZ5NNXewFPKxq5YrpP2P0H7wbsRhzbEhIJT12Osb8iKQvx
         rpiQLwecrgymg==
Date:   Fri, 7 Apr 2023 22:01:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [GIT PULL v1] Improve IPsec limits, ESN and replay window
Message-ID: <20230407190155.GO4514@unreal>
References: <20230406071902.712388-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406071902.712388-1-leon@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 10:19:02AM +0300, Leon Romanovsky wrote:
> This series overcomes existing hardware limitations in Mellanox ConnectX
> devices around handling IPsec soft and hard limits.
> 
> In addition, the ESN logic is tied and added an interface to configure
> replay window sequence numbers through existing iproute2 interface.
> 
>   ip xfrm state ... [ replay-seq SEQ ] [ replay-oseq SEQ ]
>                     [ replay-seq-hi SEQ ] [ replay-oseq-hi SEQ ]
> 
> Link: https://lore.kernel.org/all/cover.1680162300.git.leonro@nvidia.com
> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> ----------------------------------------------------------------

Hi,

I see that this PR is marked as "Awaiting upstream".
What does it mean in context of this PR?
https://patchwork.kernel.org/project/netdevbpf/patch/20230406071902.712388-1-leon@kernel.org/

Thanks
