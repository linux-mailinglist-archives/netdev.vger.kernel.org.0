Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF27462B27C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 06:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiKPFAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 00:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKPFAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 00:00:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373441B1D0;
        Tue, 15 Nov 2022 21:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D11186183D;
        Wed, 16 Nov 2022 05:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD4BC433D6;
        Wed, 16 Nov 2022 05:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668574810;
        bh=83gteDewTMe5flZHppBv5SyZK9BuP1LXd6o4ionEeXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NEs0hcPdRTcGIicn3r35yP6A/BhWq08Epx+jowLOrypAf8zgVtgqFPxK0O2YZ55+B
         12PvnwwsqjUfY3GTg8HDB5MZuwIOK7O4d42qJ/IegIK3iScJpRUfeRE8W1tagUNx7x
         JCC5ckbi7xDp4PZOOtYffjhRWMnxulQuIVGMoajysXuPqHnsgyqSuhgZEq7Hcr4GYv
         EtAV/wOWN2u7ebHPWK3TwjaeqspPtDjOXxSg17VMYzvJ0xWbXnQdL/J3cpjVAJ85iX
         NBvGlt/sySjPPqvsEzrD/TqGZzHM7HOnSU4XDlT+2QwLquIXadUo+uEY3PLJ9BcAl7
         xio/3OLievWrw==
Date:   Tue, 15 Nov 2022 21:00:05 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jerry Ray <jerry.ray@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next][PATCH] dsa: lan9303: Changed ethtool stats
Message-ID: <Y3RuVUQRsiJT377E@x130.lan>
References: <20221114210233.27225-1-jerry.ray@microchip.com>
 <Y3KvE+4kYUYTDzZe@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y3KvE+4kYUYTDzZe@lunn.ch>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Nov 22:11, Andrew Lunn wrote:
>Hi Jerry
>
>> Added a version number to the module.
>
>Don't bother, it is useless. A driver is not standalone, it depends on
>the rest of the kernel around it. Somebody telling you version 1.1 is
>broken is no help, you have no idea what version of mainline is around
>it, or if it is a backport in a vendor kernel along with 1000 other
>patches.
>
>And as a general comment, one patch should do one thing. Please break
>this up into a patchset.
>
>     Andrew

Just drop the MODULE_VERSION

it's getting removed from all modules, Gregkh is always asking to remove
them. 
https://lore.kernel.org/lkml/20210528092242.51104-2-eli.billauer@gmail.com/


