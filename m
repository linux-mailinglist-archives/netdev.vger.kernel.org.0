Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B4E58E635
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 06:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiHJEVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 00:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiHJEVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 00:21:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC03E80F67;
        Tue,  9 Aug 2022 21:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B26C6135A;
        Wed, 10 Aug 2022 04:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6844FC433C1;
        Wed, 10 Aug 2022 04:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660105288;
        bh=VlKCY8+dE9puwDXzh2j1iVq0aMV6gO304TuIjA1IWb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lB6vZ1t+ktZq9rCtZ5iNGsPwecQULC0yYBFn9rHNFfcCLFIgxOBenlJjMvS1ZGkEs
         ELfsUkRMaVyOhIArBo/OW5UaYG8eO1DmyaXRcNj8O/3dzSYhrXfBRMCt7sRseudS/f
         u5akrDr9BofxDPma4dxOaB/g5Q+hBqcNY1S7GgSx5xzaBs4JGJixHG/pPSDacVwkDK
         hc8G5j93ObCQbIZds9MKyL0Kfp9/uTqtXN0w97Vv5ScDrlQCRnoPkv5ctQBFYTaNY7
         MOG3xCtRUzD1Jdp/9gxpH23BpbN4ZGRPGVpXIFl+3SRDIzgMMb0j2rqaPYeE9bNgTb
         T4zy9L1LulV9A==
Date:   Tue, 9 Aug 2022 21:21:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net 1/8] netfilter: nf_tables: validate variable length
 element extension
Message-ID: <20220809212127.44ed6d95@kernel.org>
In-Reply-To: <20220809220532.130240-2-pablo@netfilter.org>
References: <20220809220532.130240-1-pablo@netfilter.org>
        <20220809220532.130240-2-pablo@netfilter.org>
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

On Wed, 10 Aug 2022 00:05:25 +0200 Pablo Neira Ayuso wrote:
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 8bfb9c74afbf..7ece4fd0cf66 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -651,6 +651,7 @@ extern const struct nft_set_ext_type nft_set_ext_types[];
>  struct nft_set_ext_tmpl {
>  	u16	len;
>  	u8	offset[NFT_SET_EXT_NUM];
> +	u8	ext_len[NFT_SET_EXT_NUM];

kdoc missing here, please follow up
