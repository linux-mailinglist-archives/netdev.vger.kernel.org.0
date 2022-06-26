Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5954355B30E
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 19:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiFZRPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 13:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiFZRPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 13:15:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520DDE096;
        Sun, 26 Jun 2022 10:15:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0B3C60E1F;
        Sun, 26 Jun 2022 17:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2C9C34114;
        Sun, 26 Jun 2022 17:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656263731;
        bh=ludklJ6ApT6pvSgqsgkUagNtgj9WrP6wywWzAV/JXKI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Hs6adm+9siiZkyH8PluMpNfNgoNBeIVZz+2aKj79PVwAVwWk+i/JXHTauJ/u4i4/w
         oSaq8dZALC7lUuQNELMnCH8BKJcSPpiNYvJRBUg2teSnrIn6SdegPxRW8X2uHuGrcL
         um8OfWgUP4bHGHH0iNrPN7dZGpYm37HXnhUcHicwpHhjdgt3P0c6uOQGmwVGwl8XYJ
         7EePLl5oLyybOI6VSfnR08KxduFvAWBlVc7cYCFz6qo92e2nsqlyBRTR5NkNzRjNDg
         ELsWgbr1buJvYrn3ROcnp1psekbUZaLbSs3ezwHNiCn6YIRl9Bgc/iQInIdgukMiQE
         iOuDvvxYggBdA==
Message-ID: <959eac09-28ae-da99-f8bd-d4b3d1182988@kernel.org>
Date:   Sun, 26 Jun 2022 11:15:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH v2] ipv6/sit: fix ipip6_tunnel_get_prl when memory
 allocation fails
Content-Language: en-US
To:     zys.zljxml@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        eric.dumazet@gmail.com, pabeni@redhat.com,
        katrinzhou <katrinzhou@tencent.com>
References: <20220625054524.2445867-1-zys.zljxml@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220625054524.2445867-1-zys.zljxml@gmail.com>
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

On 6/24/22 11:45 PM, zys.zljxml@gmail.com wrote:
> From: katrinzhou <katrinzhou@tencent.com>
> 
> Fix an illegal copy_to_user() attempt when the system fails to
> allocate memory for prl due to a lack of memory.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 300aaeeaab5f ("[IPV6] SIT: Add SIOCGETPRL ioctl to get/dump PRL.")
> Signed-off-by: katrinzhou <katrinzhou@tencent.com>
> ---
> 
> Changes in v2:
> - Move the position of label "out"
> 
>  net/ipv6/sit.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


