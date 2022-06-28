Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CA955E831
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347758AbiF1PFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347032AbiF1PFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:05:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40F0192A3;
        Tue, 28 Jun 2022 08:05:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4991F60BBD;
        Tue, 28 Jun 2022 15:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC94C3411D;
        Tue, 28 Jun 2022 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656428708;
        bh=/emgFdNQsGZIinPOgLRzgL0RqK7wZYCMgiKFC1IxysI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=N1LvJL9l9B4QdAJ2Y2NcpX7aZxdEex2d9FVaFZqrRs0haxcf0tk3V98Jw68rgpCek
         XUg+Y6XMzGL226EQ2iBIBtyEXhtrx4n8eW6GdYVwLlA2DE33Pd1/XGzaA4ZUqbK1Zw
         oSUdKKcSRkDr0ParuOEscZpTrkIqn4jEUOzwqonJk/tOdJt7auW/i8rcBK0yXJUgEa
         N1BJ+5iQC7OSkzbU2m0HocdDpiRLV9U4KarKExu6sSeu0syI/YTYejbuBNCPgGOaAw
         Jgm01kG5DzjK3BTjOeiIbRS0oc9cv4lKorOYR8fIFXTd2keFx2XymaLpf4a2JpsRi2
         jmD5tWBIw41sg==
Message-ID: <f11640fc-7ffc-e74d-1cf6-a3889bd62f93@kernel.org>
Date:   Tue, 28 Jun 2022 09:05:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH v3] ipv6/sit: fix ipip6_tunnel_get_prl return value
Content-Language: en-US
To:     zys.zljxml@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        eric.dumazet@gmail.com, pabeni@redhat.com,
        katrinzhou <katrinzhou@tencent.com>
References: <20220628035030.1039171-1-zys.zljxml@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220628035030.1039171-1-zys.zljxml@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/22 9:50 PM, zys.zljxml@gmail.com wrote:
> From: katrinzhou <katrinzhou@tencent.com>
> 
> When kcalloc fails, ipip6_tunnel_get_prl() should return -ENOMEM.
> Move the position of label "out" to return correctly.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 300aaeeaab5f ("[IPV6] SIT: Add SIOCGETPRL ioctl to get/dump PRL.")
> Signed-off-by: katrinzhou <katrinzhou@tencent.com>
> ---
> 
> Changes in v2:
> - Move the position of label "out"
> 
> Changes in v3:
> - Modify commit message
> 
>  net/ipv6/sit.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


