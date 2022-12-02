Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F9C640CD8
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbiLBSKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiLBSKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:10:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C2BE8E18
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:10:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0116B62394
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7E2C433C1;
        Fri,  2 Dec 2022 18:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670004601;
        bh=w3p4n6VNNlYqCUh8vE7AyADjWOAnO/k35WLPB1qaSMU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kIQoKH7Pp/aQM0ep8TfMUuhGb68sVbfDfoHn23QkCu8nbZ+kbQqAg1urkgYAi8a+4
         /LDL2qEQJ4jad4hqzlmXnxI7mKfp6JnU0evCYUjymP4dN1toZPVAyher1Df3op2N7T
         gSHF6zE2jM89bwFcbYuw39j6SKgyntyXbkaXyEbCaAuzDBVKWAvLdKEX6xuHdr4cUQ
         xbwDXRx+qAL3wa1baljlT+pu+qv+O8rz5glqR/9xDdZfUNcTRUiCM44Ou4H1EK4jCR
         Lqqq5cVY3SNYiOCljwGa83VLoAOMW5iAOXwJZcGyMBzQAY1ewRIYZZCvcrkbkon+5f
         txXi7uHniCw2w==
Date:   Fri, 2 Dec 2022 10:10:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v9 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <20221202101000.0ece5e81@kernel.org>
In-Reply-To: <Y4o+X0bOz0hHh9bL@unreal>
References: <cover.1669547603.git.leonro@nvidia.com>
        <20221202094243.GA704954@gauss3.secunet.de>
        <Y4o+X0bOz0hHh9bL@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Dec 2022 20:05:19 +0200 Leon Romanovsky wrote:
> You won't need to apply and deal with any
> merge conflicts which can bring our code :).

FWIW the ipsec tree feeds the netdev tree, there should be no conflicts
or full release cycle delays. In fact merging the infra in one cycle
and driver in another seems odd, no?
