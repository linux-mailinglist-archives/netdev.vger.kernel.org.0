Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F9A507AA1
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 22:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356590AbiDSUIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 16:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355603AbiDSUIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 16:08:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111C512603;
        Tue, 19 Apr 2022 13:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DA2861698;
        Tue, 19 Apr 2022 20:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C7DC385A7;
        Tue, 19 Apr 2022 20:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650398738;
        bh=uho8PuTiwfdn/y6WfbCZOVjYCV1gkGfBjh/CNH8W0M8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=iKm6ayet0TSvP8VR6TFA6ZfpCYbZZ8bUS8Vfv0+Tomx07NXbqQnIF8FoNrF9Bks6g
         hrrcQxYS2tpORqfqbIN0xzw3Wzxm8JhGFSMxvVUu1iNteDuajM7FUIv9hHTyOoFdZy
         HhQm2smIQubmGQs+tYOXXLW3XQqxosZ0Ei5MK7cr8ZREPuHNc6lXBdjH9MNv9jD7vY
         jbgWM0YGBdIEPVipf9cOB9rQ1id556YPusBaabr+cdhisqywDMajKGKPNtZNUWMD6u
         0LXpy87DQLBNq7PE2WawukXOB10z4USdDSckTIo0iq2zPOkpZLkC2Nm84LHSJjUqYE
         QBzYbWaW08Bkg==
Message-ID: <b7de43c3-104b-f76e-5a5b-773946d0781f@kernel.org>
Date:   Tue, 19 Apr 2022 14:05:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH nf v2 1/2] netfilter: Update ip6_route_me_harder to
 consider L3 domain
Content-Language: en-US
To:     Martin Willi <martin@strongswan.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <20220419134701.153090-1-martin@strongswan.org>
 <20220419134701.153090-2-martin@strongswan.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220419134701.153090-2-martin@strongswan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/22 7:47 AM, Martin Willi wrote:
> The commit referenced below fixed packet re-routing if Netfilter mangles
> a routing key property of a packet and the packet is routed in a VRF L3
> domain. The fix, however, addressed IPv4 re-routing, only.
> 
> This commit applies the same behavior for IPv6. While at it, untangle
> the nested ternary operator to make the code more readable.
> 
> Fixes: 6d8b49c3a3a3 ("netfilter: Update ip_route_me_harder to consider L3 domain")
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Willi <martin@strongswan.org>
> ---
>  net/ipv6/netfilter.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


