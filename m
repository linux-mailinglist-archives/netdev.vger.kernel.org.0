Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2148B69263B
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbjBJTYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbjBJTYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:24:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6D57CCBF
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:24:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C4D661E6F
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F15C4339C;
        Fri, 10 Feb 2023 19:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676057059;
        bh=7Qxod96LSnSKzVITRlniwsV0wHAit3T/YwpPhOyeuyM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OzrK+9lqbMXkgTe3W3dwyI3kOcMJr+cHNxFyWXgHcchNmSfa763b444I6AqyJ3OBy
         StulqalaTmgYmMHmyqV3ew7LhFmonspiq9sohHIEBh6oYipYTGxifFpasvA7Hhipv7
         GZ9OwIDy5sVb0FYTw1NXtVuqXCQgzw7I78zsa+IrscaO0kfxH3OlzCCctAJNJ/vK/8
         2mHAl9sWjzFVaIvIVBGadwDVxmQoS0WggTk6FtaTfi7GKRTKjNUkRqD/qR9sMPDElX
         HO8ApOm+UjtOdaleALrtvpu/W5KJyOr+Up8aXf8u514LHZilF8N/JCcr3FrtKlciKC
         DcEj89sUirPQQ==
Message-ID: <cddb7fbf-1f34-0cac-b0d5-a1c9398e696b@kernel.org>
Date:   Fri, 10 Feb 2023 12:24:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/4] net: dropreason: add
 SKB_DROP_REASON_IPV6_BAD_EXTHDR
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20230210184708.2172562-1-edumazet@google.com>
 <20230210184708.2172562-2-edumazet@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230210184708.2172562-2-edumazet@google.com>
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

On 2/10/23 11:47 AM, Eric Dumazet wrote:
> This drop reason can be used whenever an IPv6 packet
> has a malformed extension header.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/dropreason.h | 3 +++
>  1 file changed, 3 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


