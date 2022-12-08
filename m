Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24C6647342
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiLHPgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiLHPgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:36:22 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45C275087
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:36:00 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 9D495188459F;
        Thu,  8 Dec 2022 15:35:59 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 9940B2500651;
        Thu,  8 Dec 2022 15:35:59 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 93FF59EC0022; Thu,  8 Dec 2022 15:35:59 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 08 Dec 2022 16:35:59 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: replace ATU violation
 prints with trace points
In-Reply-To: <20221208152725.g4scosm5klsn5fqf@skbuf>
References: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
 <20221207233954.3619276-3-vladimir.oltean@nxp.com> <Y5EsWNfVQrl8Nb71@x130>
 <20221208144901.tgdhp73n7g5uh7qj@skbuf>
 <1bf9be8b0877a0536b73ceaa957f6234@kapio-technology.com>
 <20221208152725.g4scosm5klsn5fqf@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <78b2412528dae7225d280a904a38bd67@kapio-technology.com>
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

On 2022-12-08 16:27, Vladimir Oltean wrote:
> On Thu, Dec 08, 2022 at 04:22:53PM +0100, netdev@kapio-technology.com 
> wrote:
>> The follow-up patch set to the MAB patch set I have, will make use of 
>> the age
>> out violation.
> 
> Ok, so for v2 I can delete the debugging print, since it's currently
> dead code, and you can add the counter and the trace point when the 
> code
> will be actually exercised, how does that sound?

Ok, sounds like a plan.
