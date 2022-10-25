Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5346260CE7E
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbiJYOLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbiJYOKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:10:35 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B7E29817
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:09:11 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id ABA461884B6C;
        Tue, 25 Oct 2022 14:09:07 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 34E6725004F0;
        Tue, 25 Oct 2022 14:09:07 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 28CE79EC0002; Tue, 25 Oct 2022 14:09:07 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 25 Oct 2022 16:09:07 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        vladimir.oltean@nxp.com, mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 00/16] bridge: Add MAC Authentication Bypass
 (MAB) support with offload
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
User-Agent: Gigahost Webmail
Message-ID: <274f1bb19fbf00ee053b042abca0107d@kapio-technology.com>
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

On 2022-10-25 12:00, Ido Schimmel wrote:
> 
> Future work
> ===========
> 
> The hostapd fork by Westermo is using dynamic FDB entries to authorize
> hosts [3]. Changes are required in switchdev to allow such entries to 
> be
> offloaded. Hans already indicated he is working on that [4]. It should
> not necessitate any uAPI changes so I do not view it as a blocker 
> (Hans,
> please confirm).

The dynamic ATU patchset will do changes in the switchdev and DSA layers
and in the driver of course, so I suppose that confirms what you think
(e.g. no changes in include/uapi), but it requires the fdb_flags towards
drivers patches of course and MAB driver changes, that are part of my
v8 patchset.
