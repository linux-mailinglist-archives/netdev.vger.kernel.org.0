Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117955282CA
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241233AbiEPLED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiEPLEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:04:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63FAD2C11D;
        Mon, 16 May 2022 04:04:01 -0700 (PDT)
Date:   Mon, 16 May 2022 13:03:58 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Willi <martin@strongswan.org>
Cc:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf v2 2/2] netfilter: Use l3mdev flow key when re-routing
 mangled packets
Message-ID: <YoIvnoaSNyU3aE7D@salvia>
References: <20220419134701.153090-1-martin@strongswan.org>
 <20220419134701.153090-3-martin@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220419134701.153090-3-martin@strongswan.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 03:47:01PM +0200, Martin Willi wrote:
> Commit 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif
> reset for port devices") introduces a flow key specific for layer 3
> domains, such as a VRF master device. This allows for explicit VRF domain
> selection instead of abusing the oif flow key.
> 
> Update ip[6]_route_me_harder() to make use of that new key when re-routing
> mangled packets within VRFs instead of setting the flow oif, making it
> consistent with other users.

Applied to nf-next
