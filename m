Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7B230BC61
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 11:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhBBKvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 05:51:18 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:13213 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhBBKvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 05:51:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1612262905;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
        From:Subject:Sender;
        bh=kJjoW0ue+wKfKU6hSaQ4q99lNFqdmGDMxx0Kp60tgQI=;
        b=I4PdFkUAqVrNPrJ7RZgJwNv97F6d9PSq6fpoX0xvMMkgWKUtGZUVBtFz4HTCbbLdpg
        t2iAwfBiNEQXVqnVrBz9GabmVbO68p1A35Pzdit0WC1LGshyFv5ETgmjcKl+Ftf+bpiV
        H3ako6bOE1iXL6K8cFWf4+Yq2DFyNS6ndKeabHD210eBRzPgkdrjZjX0IKzkYTr8n+He
        7QHTj+iL39VnFf6VEUhL+B1Gw01cEDpzty4IBYSrHWFw7eAzz/zgwi8C/OA5wbVhUG2B
        PqfQEMXKmbbF3O8sfJ6dmvbljDouXKYKOi/vhwlYeoBVRZlp6cTe3XncKAqksdTHITEP
        9YEQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGVxiOMtqpw=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.16.0 DYNA|AUTH)
        with ESMTPSA id w076a1x12AmOGHT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 2 Feb 2021 11:48:24 +0100 (CET)
Subject: Re: [PATCH RESEND iproute2 5.11] iplink_can: add Classical CAN frame
 LEN8_DLC support
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
References: <20210125104055.79882-1-socketcan@hartkopp.net>
 <b835a46c-f950-6c58-f50f-9b2f4fd66b46@gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <d8ba08c4-a1c2-78b8-1b09-36c522b07a8c@hartkopp.net>
Date:   Tue, 2 Feb 2021 11:48:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <b835a46c-f950-6c58-f50f-9b2f4fd66b46@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

On 29.01.21 16:50, David Ahern wrote:
> On 1/25/21 3:40 AM, Oliver Hartkopp wrote:
>> The len8_dlc element is filled by the CAN interface driver and used for CAN
>> frame creation by the CAN driver when the CAN_CTRLMODE_CC_LEN8_DLC flag is
>> supported by the driver and enabled via netlink configuration interface.
>>
>> Add the command line support for cc-len8-dlc for Linux 5.11+
>>
>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>> ---
>>   ip/iplink_can.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
> 
> 
> applied to iproute2-next
> 

Are you sure this patch is correctly assigned to iproute2-next?

IMO it has to be applied to iproute2 as the functionality is already in 
v5.11 which is in rc6 right now.

Regards,
Oliver
