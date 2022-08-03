Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A92588FA5
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbiHCPr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbiHCPr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:47:57 -0400
Received: from smtp87.ord1d.emailsrvr.com (smtp87.ord1d.emailsrvr.com [184.106.54.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29793E08A
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 08:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1659541676;
        bh=i/m2J20otiRpiEV1Tx+blspiXLX0KONsIWyQG+pcTiU=;
        h=Date:Subject:To:From:From;
        b=huUq7ZsKeZpZCi7rOTPb9Z+dMn3GHOzc0b6J5Nw6GYqHFBmBIwpAReWJ+xvJqpXBT
         BDyXY9lvsMALa+BXOaBYmkBZEpMbRpwCdSXJl/A2u+v2h/+yyz94b6DBFye1QOFMtE
         PMitvMUdrcUDz+DI/WjSAcuWoT0z65sD2Md2QFZQ=
X-Auth-ID: antonio@openvpn.net
Received: by smtp11.relay.ord1d.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id 9666A60083;
        Wed,  3 Aug 2022 11:47:55 -0400 (EDT)
Message-ID: <1219c53f-362e-cd55-73e0-87dfe281ec34@openvpn.net>
Date:   Wed, 3 Aug 2022 17:48:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net> <YtbNBUZ0Kz7pgmWK@lunn.ch>
 <c490b87c-085b-baca-b7e4-c67a3ee2c25e@openvpn.net> <YuKKJxSFOgOL836y@lunn.ch>
 <52b9d7c9-9f7c-788e-2327-33af63b9c748@openvpn.net>
 <20220803084202.4e249bdb@hermes.local>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
In-Reply-To: <20220803084202.4e249bdb@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 70813dac-6f10-4cbb-869c-dc05eee17d75-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On 03/08/2022 17:42, Stephen Hemminger wrote:
> Kernel submissions for upstream must be standalone, and any infrastructure
> that is only used by an out of tree kernel driver will not be accepted.
> 
> The version you propose upstream must have no linux-compat wrappers.
> Sorry kernel developers don't care or want to be concerned about some
> out of tree project.

There must have been some confusion - sorry about that.

The repository I linked in my previous email is this very same driver 
packaged as "out-of-tree" module (i.e. for people running a kernel that 
does not yet ship ovpn-dco) and contains some compat wrapper.


The driver I have submitted to the list is 100% standalone and does not 
contain any compat code.


The only extra component required to do something useful with this 
driver is the OpenVPN software in userspace.


I hope this clarifies.

Regards,


-- 
Antonio Quartulli
OpenVPN Inc.
