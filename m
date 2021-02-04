Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4739330FE71
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239512AbhBDUdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:33:11 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:25954 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240222AbhBDUcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 15:32:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1612470590;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
        From:Subject:Sender;
        bh=t1aAvkRCETTrfGuIzFK7zRTpWkJziC4roy/wMf7REBc=;
        b=F8P4diFRSwqhumz4wAYnUm6+G6VI9fHN2OckjxOmSyqbXGb1Xiby/ddtvlS+09kFlj
        UQdirJ8etJRuH7eFDcayA5CQockuyEx8u8sIY1crnUIeuF+Dwu2hWkeqZM9T+gK77GiC
        pa0IPTFVIZ1lZwaVtzbhF9CLwgzBeblSDkrtCfuthnoah7cNpH966N4SCvJQwqF1R8Dh
        Iqyat7kaNpjf/jPkMGuD56+rNcEtxpILpcZWK7/VEfE6euIjKYVuLTOzWLGvWChezVCz
        URwwL4nmOUi2PLIdnKRtL8ytaFM+scP830Y0NaZ7F+vu5fht3pvzXGQ55EomgGYr0hYx
        Lbcg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVch5kkU2"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.17.0 DYNA|AUTH)
        with ESMTPSA id U025c8x14KTm0AL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 4 Feb 2021 21:29:48 +0100 (CET)
Subject: Re: [PATCH RESEND iproute2 5.11] iplink_can: add Classical CAN frame
 LEN8_DLC support
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
References: <20210125104055.79882-1-socketcan@hartkopp.net>
 <b835a46c-f950-6c58-f50f-9b2f4fd66b46@gmail.com>
 <d8ba08c4-a1c2-78b8-1b09-36c522b07a8c@hartkopp.net>
 <586c2310-17ee-328e-189c-f03aae1735e9@gmail.com>
 <fe697032-88f2-c1f1-8afc-f4469a5f3bd5@hartkopp.net>
 <1bf605b4-70e5-e5f2-f076-45c9b52a5758@gmail.com>
 <dccf261d-6cc3-f79a-8044-f0800c88108d@hartkopp.net>
 <aeb9d16e-e101-e2e5-d136-b48333f03997@gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <2e59f04e-ca7e-1a23-3554-3760c665d635@hartkopp.net>
Date:   Thu, 4 Feb 2021 21:29:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <aeb9d16e-e101-e2e5-d136-b48333f03997@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04.02.21 04:15, David Ahern wrote:
> On 2/3/21 12:04 PM, Oliver Hartkopp wrote:
>> My only fault was, that I did not send the patch for iproute2-next at
>> the time when the len8_dlc patches were in net-next, right?
> 
> yes
> 

Now that I know about iproute2-next, I will do better next time.

Can you please apply this simple patch intended for Linux 5.11 to the 
iproute2 tree this time?

Thanks,
Oliver

