Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0BD6CCCC8
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjC1WF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjC1WF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:05:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484CF19BB;
        Tue, 28 Mar 2023 15:05:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D67BF61994;
        Tue, 28 Mar 2023 22:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99DCC433EF;
        Tue, 28 Mar 2023 22:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680041126;
        bh=pTAUA18Z2rT0wc2ZTFtQyrCCUkkVzm7p1mVUw9+HxbA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H+PnMfT0xgToBJD4TtIsei216fvim2cQZ4Osodut269Fzpg5LhQ66nD+OhRYxS11x
         0rRwxxCPrR0c81Wn5CSME8LEJU4Ia/YVLYINiAmUHKIE4cZW/kX7M1p2ndWFFhZ7mM
         dzNZBEuY8fA+ZRL55VAGvZUSdKTXCGRBh2ypXMXrlvBbM8CF/lsfaYGGQ40GiPNmep
         VZ2pf2QxIXN2pvyaNhkzP1YBd0em11VAp2o24WHcXxZwYGSZg8dqOyKJQmf0gqP2Xi
         39lILIPsVI/sVis7LLmFsdamvM7mt85KEhzeDTDrou9n5fBr/50m7N8B3/WNzvWHQW
         5uwXODUVvYf1g==
Date:   Tue, 28 Mar 2023 15:05:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: remove the linux-nfc@lists.01.org list
Message-ID: <20230328150525.1706bc9a@kernel.org>
In-Reply-To: <20230324081613.32000-1-lukas.bulwahn@gmail.com>
References: <20230324081613.32000-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 09:16:13 +0100 Lukas Bulwahn wrote:
> Some MAINTAINERS sections mention to mail patches to the list
> linux-nfc@lists.01.org. Probably due to changes on Intel's 01.org website
> and servers, the list server lists.01.org/ml01.01.org is simply gone.
> 
> Considering emails recorded on lore.kernel.org, only a handful of emails
> where sent to the linux-nfc@lists.01.org list, and they are usually also
> sent to the netdev mailing list as well, where they are then picked up.
> So, there is no big benefit in restoring the linux-nfc elsewhere.
> 
> Remove all occurrences of the linux-nfc@lists.01.org list in MAINTAINERS.
> 
> Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Link: https://lore.kernel.org/all/CAKXUXMzggxQ43DUZZRkPMGdo5WkzgA=i14ySJUFw4kZfE5ZaZA@mail.gmail.com/
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Applied to netdev/net, thanks!
