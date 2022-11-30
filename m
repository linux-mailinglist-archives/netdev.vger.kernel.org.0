Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8829C63DB02
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiK3Qwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiK3Qwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:52:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4171D48408;
        Wed, 30 Nov 2022 08:52:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDA9561D07;
        Wed, 30 Nov 2022 16:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE185C433B5;
        Wed, 30 Nov 2022 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669827148;
        bh=AMSe9EGDR+5O4nwyLE+yASodhltqR8IPvBjmoxFG2hg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iXe2kbUVRJDiM4YxUpRudKFv7kEJRCfAulvtVoXPXBxKcdTbb27K+pBpjACwmBzmj
         yONtHtuDs/SMz9ZhMdhCV+u21+RUhAy8ulRYu5SINduyK45P5y9EmOZSO9rVE4lFaR
         JnFoUUx4XHgWGepcHrnNqFFjOdr+UedBkJjSkl5pYcL0olKiN0W1AXPra8RRnf/GUJ
         U4zowFMoyt0KAZHjEJ52sVZ3nMsjvbiurj2nEw2/QTk3htd3f+80THDDRz0tyVt4cT
         Iz6JHjxNw4RqcJS6DMhmVEa7C3hlYJmBvsTyzW1dKqusfR8rUNh+u297tSK6wGbylW
         exokgpqhQsTAg==
Date:   Wed, 30 Nov 2022 08:52:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Jerry.Ray@microchip.com>
Cc:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Message-ID: <20221130085226.16c1ffc3@kernel.org>
In-Reply-To: <MWHPR11MB1693E002721F0696949C5DCBEF159@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221128205521.32116-1-jerry.ray@microchip.com>
        <20221128152145.486c6e4b@kernel.org>
        <MWHPR11MB1693E002721F0696949C5DCBEF159@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Nov 2022 15:51:44 +0000 Jerry.Ray@microchip.com wrote:
>> Why not add them there as well?
>>
>> Are these drops accounted for in any drop / error statistics within
>> rtnl_link_stats?
>>
>> It's okay to provide implementation specific breakdown via ethtool -S
>> but user must be able to notice that there are some drops / errors in
>> the system by looking at standard stats.
> 
> The idea here is to provide the statistics as documented in the part
> datasheet.  In the future, I'll be looking to add support for the stats64
> API and will deal with appropriately sorting the available hardware stats
> into the rtnl_link_stats buckets.

Upstream we care about providing reasonably uniform experience across
drivers and vendors. Because I don't know you and therefore don't trust
you to follow up you must do the standard thing in the same patch set,
pretty please.
