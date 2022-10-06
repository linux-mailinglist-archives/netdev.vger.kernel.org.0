Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BC55F5FCA
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJFDyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJFDym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:54:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915DE55A8;
        Wed,  5 Oct 2022 20:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECDFEB81F49;
        Thu,  6 Oct 2022 03:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B2BC433C1;
        Thu,  6 Oct 2022 03:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665028476;
        bh=S2v1XJCej8rVU1VMiGRAEh8kRPtNT+MwCePtNS4bOVs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ib3QbX0sg6WRBcbbuTKuHKaXdFBYTo/mbKIFiYHhASaDB2UHq3CEPJXO2DPrwdW5P
         UD+lQOV6i4doFR9XqRxW7ZvkToeT9yqNlDZjnhMolrWI8/LvasfE8YmM+0BJdfd3gD
         9JLaZTcsPYEX1ViIlAyhTbKmZ5AdFKonQeTm+Ie0wJkBhT7RMYuis2JIwh2YRlTbbk
         RZ/7Vpal35lvOjJMD6xe+l5cdRL3t3ubM4pNHRiAdNLbVGeu+TJDTB4o5Z55Tl56HO
         AtMhEsOta5VfhujTFRQSDH36mCXmxqRWxULBwQP5dGIwDhKs0WuAqmL543Nq9EPB9+
         DUSHVOM7T5e3Q==
Date:   Wed, 5 Oct 2022 20:54:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vsock: replace virtio_vsock_pkt with sk_buff
Message-ID: <20221005205434.57dca13a@kernel.org>
In-Reply-To: <20221006011946.85130-1-bobby.eshleman@bytedance.com>
References: <20221006011946.85130-1-bobby.eshleman@bytedance.com>
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

On Wed,  5 Oct 2022 18:19:44 -0700 Bobby Eshleman wrote:
> - Use alloc_skb() directly instead of sock_alloc_send_pskb() to minimize
>   uAPI changes.
> - Do not marshal errors to -ENOMEM for non-virtio implementations.
> - No longer a part of the original series
> - Some code cleanup and refactoring
> - Include performance stats

minor process notes/quirks - reportedly does not apply to net-next,
and secondly:

# Form letter - net-next is closed

We have already sent the networking pull request for 6.1
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.1-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
