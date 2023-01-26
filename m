Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F3D67C4D7
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjAZHXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:23:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46862 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjAZHXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:23:36 -0500
Received: from [IPV6:2620:137:e001:0:a10c:af48:696f:8164] (unknown [IPv6:2620:137:e001:0:a10c:af48:696f:8164])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 7ADC383ED016;
        Wed, 25 Jan 2023 23:23:35 -0800 (PST)
Message-ID: <dd21bd3d-b3bb-c90b-8950-e71f4af6b167@kernel.org>
Date:   Wed, 25 Jan 2023 23:23:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] net: dsa: mt7530: fix tristate and help description
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, erkin.bozoglu@xeront.com
References: <20230125053653.6316-1-arinc.unal@arinc9.com>
 <20230125224411.5a535817@kernel.org>
From:   John 'Warthog9' Hawley <warthog9@kernel.org>
In-Reply-To: <20230125224411.5a535817@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 25 Jan 2023 23:23:35 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/2023 10:44 PM, Jakub Kicinski wrote:
> On Wed, 25 Jan 2023 08:36:53 +0300 Arınç ÜNAL wrote:
>> Fix description for tristate and help sections which include inaccurate
>> information.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Didn't make it thru to the list again :(
> Double check that none of the addresses in To: or Cc: are missing
> spaces between name and email or after a dot. That seems to be the most
> common cause of trouble. Or try to resend using just emails, no names.
> 

You are also likely to run into trouble if your character set is set to 
UTF-8.

- John 'Warthog9' Hawley
