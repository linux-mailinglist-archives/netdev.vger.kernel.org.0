Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B19D50DC18
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240963AbiDYJNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241506AbiDYJMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:12:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41F8BCAB99;
        Mon, 25 Apr 2022 02:09:42 -0700 (PDT)
Date:   Mon, 25 Apr 2022 11:09:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Willi <martin@strongswan.org>
Cc:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf v2 1/2] netfilter: Update ip6_route_me_harder to
 consider L3 domain
Message-ID: <YmZlUvXJ7LYoIXio@salvia>
References: <20220419134701.153090-1-martin@strongswan.org>
 <20220419134701.153090-2-martin@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220419134701.153090-2-martin@strongswan.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 03:47:00PM +0200, Martin Willi wrote:
> The commit referenced below fixed packet re-routing if Netfilter mangles
> a routing key property of a packet and the packet is routed in a VRF L3
> domain. The fix, however, addressed IPv4 re-routing, only.
> 
> This commit applies the same behavior for IPv6. While at it, untangle
> the nested ternary operator to make the code more readable.

Applied to nf.git
