Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03726295C5
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbiKOK1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiKOK1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:27:02 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9552B1834D;
        Tue, 15 Nov 2022 02:26:57 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id A7FA61883A6E;
        Tue, 15 Nov 2022 10:26:55 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id A143325002DE;
        Tue, 15 Nov 2022 10:26:55 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 967B991201E4; Tue, 15 Nov 2022 10:26:55 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 15 Nov 2022 11:26:55 +0100
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
In-Reply-To: <Y3NcOYvCkmcRufIn@shredder>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <Y3NcOYvCkmcRufIn@shredder>
User-Agent: Gigahost Webmail
Message-ID: <5559fa646aaad7551af9243831b48408@kapio-technology.com>
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

On 2022-11-15 10:30, Ido Schimmel wrote:
> On Sat, Nov 12, 2022 at 09:37:46PM +0100, Hans J. Schultz wrote:
>> This patchset adds MAB [1] offload support in mv88e6xxx.
>> 
>> Patch #1: Fix a problem when reading the FID needed to get the VID.
>> 
>> Patch #2: The MAB implementation for mv88e6xxx.
> 
> Just to be sure, this was tested with bridge_locked_port.sh, right?

As I have the phy regression I have given notice of, that has simply not
been possible. After maybe 50 resets it worked for me at a point
(something to do with timing), and I tested it manually.

When I have tried to run the selftests, I get errors related to the phy
problem, which I have not been able to find a way around.
