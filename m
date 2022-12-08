Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC33646FC1
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLHMco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiLHMcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:32:36 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE0D2AC
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:32:32 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 5178F1884583;
        Thu,  8 Dec 2022 12:32:31 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 477A225002E1;
        Thu,  8 Dec 2022 12:32:31 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 3E9729EC002B; Thu,  8 Dec 2022 12:32:31 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 08 Dec 2022 13:32:31 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 0/3] Trace points for mv88e6xxx
In-Reply-To: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
References: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
User-Agent: Gigahost Webmail
Message-ID: <e6b0d7b55710e47b831ef20f48739954@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-12-08 00:39, Vladimir Oltean wrote:
> While testing Hans Schultz' attempt at offloading MAB on mv88e6xxx:
> https://patchwork.kernel.org/project/netdevbpf/cover/20221205185908.217520-1-netdev@kapio-technology.com/
> I noticed that he still didn't get rid of the huge log spam caused by
> ATU and VTU violations, even if we discussed about this:
> https://patchwork.kernel.org/project/netdevbpf/cover/20221112203748.68995-1-netdev@kapio-technology.com/#25091076
> 
> It seems unlikely he's going to ever do this

Ohh, I didn't expect it to be part of the MAB patch set, but rather 
something after, as there is enough for me already for the moment. But I 
welcome your contribution of course. :-)
