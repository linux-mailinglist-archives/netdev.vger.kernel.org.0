Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1CF6CD249
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjC2GsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2GsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:48:12 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D4F183;
        Tue, 28 Mar 2023 23:48:10 -0700 (PDT)
Received: from [IPV6:2003:e9:d70f:381f:5e2f:3bee:d4cb:b76b] (p200300e9d70f381f5e2f3beed4cbb76b.dip0.t-ipconnect.de [IPv6:2003:e9:d70f:381f:5e2f:3bee:d4cb:b76b])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C4D71C055C;
        Wed, 29 Mar 2023 08:48:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1680072489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FzpBKVenZRln9tqXGuSSzQR6z7GWvXYzvV9DnLXT7rs=;
        b=Fz/BIxj5CIx16ISljnVjcUN8Hq7lgJbDcZL8VthVsB0KQAgWBW7ZXdCDJwgERgpQtP6gCA
        R3Af4qPV1VtPwiPv/uutDrdeXQOKb/jC22jqRq0XROdhnu0cvKPy465+lOzSjEvdGe98JZ
        uDPNJEX+qGWme08zdmPKKBhxui0XzEl6N+15bbnjfdP/CdpGW+LW0DOCMFpQ50ajVx9LQ4
        m8RMWfmohOy5esjCtWQCwOs+tcJ6Nodz33TK8ciIuXQ6hTuQHq8tmQ0FBzm81kSyMx9wlt
        VkCmdnulpw7OXLCeFFajr8R1P7ztjmw0z79VliKPDACg6lFm9nCWhpV9oOo9Cg==
Message-ID: <364aac26-21a0-ec36-c549-602b4126296d@datenfreihafen.org>
Date:   Wed, 29 Mar 2023 08:48:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: pull-request: ieee802154 for net 2023-03-24
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, miquel.raynal@bootlin.com,
        netdev@vger.kernel.org
References: <20230324173931.1812694-1-stefan@datenfreihafen.org>
 <20230327193842.59631f11@kernel.org>
 <605a1c16-0c03-a3be-9aec-12bb4d0113dc@datenfreihafen.org>
 <20230328151418.699f7026@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230328151418.699f7026@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 29.03.23 00:14, Jakub Kicinski wrote:
> On Tue, 28 Mar 2023 09:10:07 +0200 Stefan Schmidt wrote:
>> Sorry for that. I did not update my pull request script when changing
>> the git tree URLs to our team tree. Updated now.
>>
>> The tag is now on the tree above. You want me to send a new pull request
>> or do you take it from here?
> 
> Thanks, fresh PR would be better, I can't re-trigger the patchwork
> checks on an existing one :(

Sure, no problem. Sent a v2 just now.

regards
Stefan Schmidt
