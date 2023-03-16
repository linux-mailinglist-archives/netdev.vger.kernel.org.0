Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C3C6BC404
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 03:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjCPCxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 22:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCPCxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 22:53:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD381ADE0;
        Wed, 15 Mar 2023 19:53:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A90FAB81FA2;
        Thu, 16 Mar 2023 02:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C50C433EF;
        Thu, 16 Mar 2023 02:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678935220;
        bh=U6vi7FwBOAtQjdOn0Mr1hOIpoxeUx8OuGidQW56SK94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i+NNVM61slkjVhR6VuHLySykIGhGSV5SRESxpqeqapWY1by15Mmo9FcrPavwsFPrd
         pqzKt8U6xPaF8Wz/nwI8rcuA371KIeltcm4A9Lug9EIBfrdnc4JMTvnfUaonS1Db68
         MZ7QRwhW+gX3oiRUk1EGtMUk4sk4rIcN+TxsrcV2Z8mZEav9iY7mIAaIBQvPD9NeTq
         RiXUuiGkpypi91rM5LzYxlnwWj1Ir7ducTSFSMPnDnUTmBeAe9+pFPRsAJhyCpONDc
         AiTqSW1bNswS7L5JRgUc47JWCWpEfSsRERj4ZrwYpOEIScItKYrQDx7g1q8OjWwNxZ
         CcJ5RXDKXBNBg==
Date:   Wed, 15 Mar 2023 19:53:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, shayagr@amazon.com, akiyano@amazon.com,
        darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: Re: [PATCH net v2 7/8] net/mlx5e: take into account device
 reconfiguration for xdp_features flag
Message-ID: <20230315195338.563e1399@kernel.org>
In-Reply-To: <ZBKC8lxQurwQpj4k@x130>
References: <cover.1678364612.git.lorenzo@kernel.org>
        <16c37367670903e86f863cc8c481100dd4b3a323.1678364613.git.lorenzo@kernel.org>
        <20230315163900.381dd25e@kernel.org>
        <20230315172932.71de01fa@kernel.org>
        <ZBKC8lxQurwQpj4k@x130>
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

On Wed, 15 Mar 2023 19:46:10 -0700 Saeed Mahameed wrote:
> >I think so.. let me send a full patch.  
> 
> We have an  internal version of a fix, Tariq is finalizing some review
> comments and we will be posting it ASAP.

Ah, I already posted. Does it look different?

https://patchwork.kernel.org/project/netdevbpf/patch/20230316002903.492497-1-kuba@kernel.org/

I wanted to make sure that it's ready for tomorrow's PR
