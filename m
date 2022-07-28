Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397B2583FB9
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237450AbiG1NPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbiG1NPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:15:30 -0400
Received: from smtp105.ord1c.emailsrvr.com (smtp105.ord1c.emailsrvr.com [108.166.43.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398581D30C
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1659014127;
        bh=nVyncxBbFfBP0UJB18/l9WTFsKwCNL1U/OTwv2Q77DA=;
        h=Date:Subject:To:From:From;
        b=nsk3DOmjPBZ1GglZRpyKS0n6v0e4IpPjB4XLKnTSIoO29+qoPnsuhsa2CvXbOxSCT
         LwBjFbO4injAnqKuWEQMnVwE7+fs/M+RoocwPqzbeI/u8N2d7fAJ7eU5/jAi83Lyf3
         UwhkTLUop5fYyqoZr8wq3jWQA8nnn5//XCQXxWOU=
X-Auth-ID: antonio@openvpn.net
Received: by smtp14.relay.ord1c.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id C6016C0100;
        Thu, 28 Jul 2022 09:15:26 -0400 (EDT)
Message-ID: <52b9d7c9-9f7c-788e-2327-33af63b9c748@openvpn.net>
Date:   Thu, 28 Jul 2022 15:16:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net> <YtbNBUZ0Kz7pgmWK@lunn.ch>
 <c490b87c-085b-baca-b7e4-c67a3ee2c25e@openvpn.net> <YuKKJxSFOgOL836y@lunn.ch>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
In-Reply-To: <YuKKJxSFOgOL836y@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: b21c8d6c-fc14-4b0b-8f33-28a996a66e1f-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 28/07/2022 15:07, Andrew Lunn wrote:
> Also, using a mainline driver out of tree is not easy. The code will
> make use of the latest APIs, and internal APIs are not stable, making
> it hard to use in older kernels. So you end up with out of tree
> wrapper code for whatever version of out of tree Linux you decide to
> support. Take a look at
> 
> https://github.com/open-mesh-mirror/batman-adv

Yeah, this is exactly what we are already doing.
We're just trying to keep is as simple as possible for now:

https://github.com/OpenVPN/ovpn-dco/blob/master/linux-compat.h

Thanks for the pointer anyway (I am already deeply inspired by 
batman-adv, as you may imagine ;-)),

-- 
Antonio Quartulli
OpenVPN Inc.
