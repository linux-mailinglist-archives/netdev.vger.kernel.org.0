Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD986E50CA
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjDQTZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjDQTZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:25:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA18729E
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 12:25:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55BA862464
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 19:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2ACC433EF;
        Mon, 17 Apr 2023 19:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681759528;
        bh=xkOA7rwvIdQsJs+nMSFL37aruz/R+94tfH5rLNYnLKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mdPQiE4MCnJj/sDdfWr8FxnQrY4ju0bX8r35sWrfoHHjrq8Y2QAmhm4QLaV5EBDMp
         WVmHqPkRYZRo6KTttJ1sZc1jBpLoraZLljBLJJ8pDSDxf/pJeFOn54PvX3GRcWxAOg
         QIAmLQyaUwcLyMUzNGjF99x8AkQso3IXFck9bqgu8wQtda7NvJqBNubVcNIK9NOGM8
         t8/E5nxR+qdWjKk6NX3hLBOVOmJDELv7FUHU4rAW+H0eRGoUgO3cQZXRE1fwm887Nh
         NKBqc/obNx8aWNwYhHUyn1ILdBGmVNNblzp/+Gcb4Zc3ecz62lE6HPubBcxqJgePJ9
         du6NA31/ESR1Q==
Date:   Mon, 17 Apr 2023 12:25:27 -0700
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
Message-ID: <20230417122527.24f43578@kernel.org>
In-Reply-To: <ZD1LzTfcr6vIVZCW@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
        <20230416210519.1c91c559@kernel.org>
        <ZD1FM0g+KWo5GtlA@corigine.com>
        <ZD1LzTfcr6vIVZCW@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 15:38:21 +0200 Simon Horman wrote:
> sorry for the delay in getting to this patch - I was on a short break.
> I had already looked over v0 prior to my break.
> And, after reviewing v1, I am happy with this series.

Thank you!
