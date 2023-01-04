Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0902065DC66
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 19:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239593AbjADSxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 13:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240027AbjADSw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 13:52:56 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4845833D46
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 10:52:43 -0800 (PST)
Received: from gmx.fr ([181.118.46.223]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MUosN-1pLdIY09Tt-00Qit9; Wed, 04
 Jan 2023 19:52:19 +0100
Date:   Wed, 4 Jan 2023 14:52:13 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 1/1] e1000e: Enable Link Partner Advertised
 Support
Message-ID: <Y7XK3eUAzVbwMNXR@gmx.fr>
References: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
 <Y7TMhVy5CdqqysRb@lunn.ch>
 <Y7U/4Q0QKtkuexLu@gmx.fr>
 <Y7W66ZstaAb9kIDe@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7W66ZstaAb9kIDe@lunn.ch>
X-Provags-ID: V03:K1:ScPQJDXkYxWZTSKRwZNFmNUzmPz+4L59DZMj9nt3dMVfWkmNDDT
 NNfJDB86DK2dCeM6MQehpsCJ2o02apWCGS5X9VYZnRbbzpFFmQgHg4zGAgx5IMb0npSHOWr
 MwO19A0W2qkjN98Hv/Z7jf37zExgUGfb3SuBlVbxQUxxzuMUeENzvcuqVwMmOfQNZqrZ+An
 PcVmOZDOiHCsiGEq58/NA==
UI-OutboundReport: notjunk:1;M01:P0:wd4JsWd9Y5s=;MGEos9mhguRAk91LKTC7m3UaFkl
 MXVfLxHycHJ42gtj+pJpRSqXbrF+2WRhx8sztk5x4jpIQ+Rr9R9yJMqxYQTf3T3B/hlJ/5cMo
 fGdOmJEbzhuLDeh+SAMJJgeNsCH4ksG7GCd09DcOJCXrK57+VUqf5jX523MgnWMfkYTrCEpOO
 zPY4w9zHaCjJ9mIcBSHPozTVkbcLBChNvJJCE/+zeVMGCzWa0InHQIEuoxdz4+FYHhassEGhz
 nVZ7F4HhEiy0uytR3GABMt8CBTUgL7rwK2FlOn+Fcp2NW7yUf9yEDBN7Sf7/NedSTouj7EmaV
 28RjWtqqVTksasPQDbrbus7r7WYk9Mu7I737m6slS3s9AVUTmjcU1nEXY4kchyUvJ59D8qKhK
 Wp43t0Ex64lPXwEC2XxEtmvKrTpqO5aMZSkRG+w2RHgVJSgC9DeQdnNgLMzbN4gr0oNSPaeiM
 z8rplqOJAYyE7uLA18lc6bECnNp2usDd8ptd9eId7Bi7AC3D0zvsEkKWljMgQzpVapgOE2PvR
 K2q1wgNjLOha+5ehvKpW/36GOmu48eZ8UHNb5G6vhpbHJ+m3R+pUWisCP0OjBH16WUV9MRO2/
 n1uiJ0OtFMf4gDbrqG/GOCGTa0WYhfkhjVdwcjBo1gNnelnX1VQT1RzOCiSvGP9UiVXw/S1hc
 mfcWT5IQ26nWi5WRZr8uYMNFEVic4NbhAT9OoPKonX23qMX96K4qMsl+JAA2mj4X76b0+1s3a
 0HJ8L25vLiRXJjrfKfovphV63IUHjpW8gx4tBU42gmZ4vR6kfiXYLwSrrkwC0K3sQ/kMH2iff
 3BrtSVKDG6W9cEFf7lkuTnnMvqQYNUbHnBZ4YWq4oW416sExHEnMoLWiX5u6o5zrMokjw3Klv
 1eGO3WfUb6PrYYIYyyFn9Jpl59rAeujjv5d7EgMylVQnuz5dsOS2XcrWzSKRkdx+oU8qHnAYB
 pT8KdQ==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 06:44:09PM +0100, Andrew Lunn wrote:
> > > I don't know this driver at all. What i don't see anywhere here is
> > > using the results of the pause auto-neg. Is there some code somewhere
> > > that looks at the local and link peer advertising values and runs a
> > > resolve algorithm to determine what pause should be used, and program
> > > it into the MAC?
> > > 
> > >     Andrew
> > This is a old patch i had laying around, If i remember correctly, phy->autoneg_advertised plugs in "Link partner
> > advertised pause frame use link" line in ethtool everytime the nic renegotiate.
> 
> Hi Jamie
> 
> Could you point me at the code which interprets the results of the
> auto neg and configures the MAC for the correct pause.
> 
> Thanks
> 	Andrew
Oh I now understand what you're saying. No clue. The guys at intel should have a better idea. Btw my old nic is not working anymore, Gosh!
