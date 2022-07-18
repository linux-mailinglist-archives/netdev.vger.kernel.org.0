Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FF0577F90
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiGRKXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiGRKXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:23:36 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F5F1C901;
        Mon, 18 Jul 2022 03:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1658139792;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=VA8GwCW4QpEMKYWhRM1u4BGCLhp6kJzO4cxOgeUtw4g=;
    b=TL9bjhXIDSnjP6E0R1Z7fTFzgKDwPFOsnsZG8I/wDEzNUI/J88N4A21SABCXOgFXk4
    PGIKC1yOgXwG7kuQNzoTEBpIA2gmhlNdv3yYIhoRsdLFNyACkhvDn+ioJRZ4/pOqfdtT
    5onX4kuhM8vRPXp7f2NqgfYiCFKxudtOzpiVNr7uO4G0Kf+7EncgjSbxV06FVlJrkc1t
    JTxb+uAoYIh4b2E9Oq15F1D1vTwNVnGRMdUdweBK561cZ0r/MGFfPXW3O7V2Ncte1iwR
    noGN1bwOrn6SyMiyw9Ye+xraItzOhRc2YtnJHGC/cNygcGzahck8jvRPn9BSwyDNh2i1
    C90Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytJSqijYPVurqCog2kT72ilCcUDL4c4Q=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d100:b185:70d0:e6b4:7289]
    by smtp.strato.de (RZmta 47.47.0 AUTH)
    with ESMTPSA id t870d5y6IANBDAA
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 18 Jul 2022 12:23:11 +0200 (CEST)
Message-ID: <1dbd95e8-e6d7-a611-32d0-ea974787ff5a@hartkopp.net>
Date:   Mon, 18 Jul 2022 12:23:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH 2/5] can: slcan: remove legacy infrastructure
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Max Staudt <max@enpas.org>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
References: <20220716170007.2020037-1-dario.binacchi@amarulasolutions.com>
 <20220716170007.2020037-3-dario.binacchi@amarulasolutions.com>
 <20220717233842.1451e349.max@enpas.org>
 <6faf29c7-3e9d-bc21-9eac-710f901085d8@hartkopp.net>
 <20220718101507.eioy2bdcmjkgtacz@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220718101507.eioy2bdcmjkgtacz@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/22 12:15, Marc Kleine-Budde wrote:
> On 18.07.2022 08:57:21, Oliver Hartkopp wrote:
>>> What do the maintainers think of dropping the old "slcan" name, and
>>> just allowing this to be a normal canX device? These patches do bring
>>> it closer to that, after all. In this case, this name string magic
>>> could be dropped altogether.
>>>
>>
>> I'm fine with it in general. But we have to take into account that there
>> might be existing setups that still might use the slcan_attach or slcand
>> mechanic which will likely break after the kernel update.
>>
>> But in the end the slcan0 shows up everywhere - even in log files, etc.
>>
>> So we really should name it canX. When people really get in trouble with it,
>> they can rename the network interface name with the 'ip' tool ...
> 
> Don't break user space! If you don't like slcanX use udev to give it a
> proper name.

Ok. Fine with me too.

IMO it does not break user space when slcan gets the common naming 
schema for CAN interface names.

We had the same thing with 'eth0' which is now named enblablabla or 
'wlan0' now named wlp2s0.

But I have no strong opinion on that naming ...

Best regards,
Oliver


