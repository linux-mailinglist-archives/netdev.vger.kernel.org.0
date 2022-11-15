Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3602F62A002
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiKORLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiKORLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:11:12 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F14328705;
        Tue, 15 Nov 2022 09:11:10 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id B357B1883A8F;
        Tue, 15 Nov 2022 17:11:08 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id A85D225002DE;
        Tue, 15 Nov 2022 17:11:08 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 9C9F691201E4; Tue, 15 Nov 2022 17:11:08 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 15 Nov 2022 18:11:08 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
In-Reply-To: <20221115161528.nlshuexccymfkree@skbuf>
References: <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <20221115122237.jfa5aqv6hauqid6l@skbuf>
 <fb1707b55bd8629770e77969affaa2f9@kapio-technology.com>
 <20221115145650.gs7crhkidbq5ko6v@skbuf>
 <551b958d6df4ee608a5da6064a2843db@kapio-technology.com>
 <20221115161528.nlshuexccymfkree@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <5cec856c6a1e1721dc75a74815dad4a7@kapio-technology.com>
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

On 2022-11-15 17:15, Vladimir Oltean wrote:
> On Tue, Nov 15, 2022 at 04:14:05PM +0100, netdev@kapio-technology.com 
> wrote:
>> I think the violation log issue should be handled in a seperate 
>> patch(set)?
> 
> idk, what do you plan to do about it?

When I think about it, I think that the messages should be disabled by 
default
and like one enables NO_LL_LEARN (echo 1 >/sys/class...), they can be 
activated
if one needs it. And of course the ethtool stats will still be there 
anyhow...

How does that sound?
