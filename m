Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C297678A15
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 22:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbjAWV7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 16:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjAWV7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 16:59:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623C52D75
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 13:59:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0A4461129
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA51C4339B;
        Mon, 23 Jan 2023 21:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674511150;
        bh=K26gquSRQqPGx8DmXStMeIm1yY756Aks2E1fbLaJaWs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=aFLTbl8COXy8cXFzGsuO0Oi5v7fdsZCBMZDfxV+cu5cv84/zYhtmFHuQIVAnUPw6/
         BStDiuIljzpU2x6JZV3zEXDXLp/QsYM7Sko0nAP9BrJCLQoDVQm5R66kH3ZC11WUkT
         2KmXB+7AqOmW1OJHgu7u9I1YLm2raG8Kjbes6eCWbD4G4Tr4kFQxkzTavyG4hBUj27
         76UqtxnyY+5gaosAJBdGoD4+cPBbVLCADQY9QxgJjxlLYzo/CXNb6HhzJKZC3bqGBe
         /w0KoLaXY8EU138HNttLMnhgiuJ3YRs/r1WRttn1fXCx5AUZbYmJ+CJ5qTAARwBmZH
         WgywivGgRj2dw==
Message-ID: <8f3651e8-163c-8d5b-6c25-5b039dfaf33e@kernel.org>
Date:   Mon, 23 Jan 2023 14:59:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] ipv6: Make ip6_route_output_flags_noref()
 static.
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <50706db7f675e40b3594d62011d9363dce32b92e.1674495822.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <50706db7f675e40b3594d62011d9363dce32b92e.1674495822.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/23 10:47 AM, Guillaume Nault wrote:
> This function is only used in net/ipv6/route.c and has no reason to be
> visible outside of it.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  include/net/ip6_route.h | 4 ----
>  net/ipv6/route.c        | 8 ++++----
>  2 files changed, 4 insertions(+), 8 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

