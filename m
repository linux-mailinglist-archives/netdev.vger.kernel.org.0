Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE1E6343EF
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbiKVSrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiKVSrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:47:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6D5637D;
        Tue, 22 Nov 2022 10:47:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BE7A6185D;
        Tue, 22 Nov 2022 18:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEDAC433D6;
        Tue, 22 Nov 2022 18:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669142849;
        bh=taCJgh2lGd3ey1WtvG5t2JKi/c+/EKnirY02H77VRTQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ReMWDK5I5fpizL+H1Ds96fyTeZnnTiwTLmyv70GYOpJxoUBbsnQb84xZm7at0vrRn
         1Zp7IT6dL2LzhtUAXExGMnSF7MXV2Lsx1NsNDYYQwv38Q/Xsq0bh163B+FH8NLTfut
         2vC95yZnvo6eBdIHfHtHzxva0JmqAhJ7570945kCGk9PbZFEIhUPqauBf8wEYX646q
         mOb6gtJUsYmeXzfFWUG/Jv6SEgaB9Xpww7Fz4lvx5TSsbHVMvfBDyXHmohFKSgA1Gw
         PxF9BJYobNiFlJiVUxwjussygP/VBseGHy+L+F/t7Cha8DxRU/ojW0s9kGwPX8GSvq
         sY0rDisAx9aKw==
Date:   Tue, 22 Nov 2022 10:47:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v2 0/8] Add support for VCAP debugFS in Sparx5
Message-ID: <20221122104728.7ef02606@kernel.org>
In-Reply-To: <994f72742a15bec5a93d57324b749b71d0709035.camel@microchip.com>
References: <20221117213114.699375-1-steen.hegelund@microchip.com>
        <20221121110154.709bed49@kernel.org>
        <994f72742a15bec5a93d57324b749b71d0709035.camel@microchip.com>
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

On Tue, 22 Nov 2022 10:17:22 +0100 Steen Hegelund wrote:
> > Have you checked devlink dpipe? On a quick scan it may be the right API
> > to use here? Perhaps this was merged before people who know the code
> > had a chance to take a look :(  
> 
> No I was not aware of the scope of devlink-dpipe, but it looks like the Sparx5
> VCAP feature would fit in.
> 
> I need to take a closer look at the model and see if I can make ends meet, but
> if so, then I could send support for devlink-dpipe at a later stage...

SG. I don't feel strongly, maybe someone else does..
