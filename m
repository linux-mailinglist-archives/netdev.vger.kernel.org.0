Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9081951F468
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 08:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiEIGRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 02:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbiEIGKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 02:10:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B884D5FBC;
        Sun,  8 May 2022 23:06:59 -0700 (PDT)
Date:   Mon, 9 May 2022 08:06:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kevin Mitchell <kevmitch@arista.com>
Cc:     gal@nvidia.com, Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v3] netfilter: conntrack: skip verification of
 zero UDP checksum
Message-ID: <Ynivfw21/nr8PKVD@salvia>
References: <YmlVAXceuasAJjnN@salvia>
 <20220430034027.21286-1-kevmitch@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220430034027.21286-1-kevmitch@arista.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 08:40:27PM -0700, Kevin Mitchell wrote:
> The checksum is optional for UDP packets. However nf_reject would
> previously require a valid checksum to elicit a response such as
> ICMP_DEST_UNREACH.
> 
> Add some logic to nf_reject_verify_csum to determine if a UDP packet has
> a zero checksum and should therefore not be verified.

Applied.
