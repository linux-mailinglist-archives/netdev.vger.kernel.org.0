Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2592B653A53
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 02:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbiLVBa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 20:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234658AbiLVBa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 20:30:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A82B7F4;
        Wed, 21 Dec 2022 17:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2D81B81B9C;
        Thu, 22 Dec 2022 01:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF123C433EF;
        Thu, 22 Dec 2022 01:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671672623;
        bh=p2PB3QQgK33GqL9AEZVltLlPBG152srBC8UueQN4oJc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ew50WOqKybvK9WBrujj7KTXb3+9bb+ndmTauon5r+tKxGFtqfhSxwfH89ELNHQEMz
         0fuFyZVhjSc7N6GhKURPMtmQOCieajxVE7FTeMxpBQMRan2qYknYqQ1zZYUGZ+7B0C
         0YUxYmAhYnEGMQrkF6W2EOQrozJhGlm1ICK9b7bl/DblGeZzQcBkg8o15RDfDkb0VY
         PNnT9e45iCUJnRnk7FJ+fiLII+H1lXYaPYHqoBZ7H50h3UM539F4ay7IEA2ZWbU/AH
         a4KvI2unJ72nhTyfqQv7G6rxIFj+zqjHTRy3pc743WpuMU+4h2FtVJc+87pNgKhqGg
         ML+6paKfnW3TA==
Date:   Wed, 21 Dec 2022 17:30:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v2 0/9] virtio_net: support multi buffer xdp
Message-ID: <20221221173022.2056b45b@kernel.org>
In-Reply-To: <20221220141449.115918-1-hengqi@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
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

On Tue, 20 Dec 2022 22:14:40 +0800 Heng Qi wrote:
> Changes since RFC:
> - Using headroom instead of vi->xdp_enabled to avoid re-reading
>   in add_recvbuf_mergeable();
> - Disable GRO_HW and keep linearization for single buffer xdp;
> - Renamed to virtnet_build_xdp_buff_mrg();
> - pr_debug() to netdev_dbg();
> - Adjusted the order of the patch series.

# Form letter - net-next is closed

We have already submitted the networking pull request to Linus
for v6.2 and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after Jan 2nd.

RFC patches sent for review only are obviously welcome at any time.
