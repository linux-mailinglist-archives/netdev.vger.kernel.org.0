Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8702CFB2E
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 12:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgLELeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 06:34:06 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:27201 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729588AbgLELah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 06:30:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1607167616;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=BYQqqU+HV7tZnfPNk40gZZLqqvMLAbkZ+V4cJEK+34M=;
        b=rlUkK7owRraaJSpH7RdsPT0xpqo6si7jCg8C39sJgJCdVBrtvQZUb1IAM91AT+FIcU
        x+t2eVy5n7mvhO8B1Hq/wM2cSljNYbCJqSAovWq3cKIHJ2QUYFSZ4AB7pbKBMvBLWjVB
        I0nq9gSZ3VBeZNo6ECLuHi4rTV1O3rTGmrtm7lIehIgv8/4JJKwneG/wfqljDE/6UH63
        hxZxR+i3K0dmv8Fb0sFCaPvbdSriPQccEG+lPkWbeErtaA/ZwtEJ+gI/03F1CkNDWULs
        3V0wnUryd1Bs2LVNck7ePSp/hB2Fi85SpUhYwqXVtvbyg9qZtnJcSMJj8I6hxO5Xh7t+
        bjtA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVch5kErC"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.3.4 DYNA|AUTH)
        with ESMTPSA id n07f3bwB5BQnLY6
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 5 Dec 2020 12:26:49 +0100 (CET)
Subject: Re: [net 3/3] can: isotp: add SF_BROADCAST support for functional
 addressing
To:     Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Thomas Wagner <thwa1@web.de>
References: <20201204133508.742120-1-mkl@pengutronix.de>
 <20201204133508.742120-4-mkl@pengutronix.de>
 <20201204194435.0d4ab3fd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <b4acc4eb-aff6-9d20-b8a9-d1c47213cefd@hartkopp.net>
Date:   Sat, 5 Dec 2020 12:26:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201204194435.0d4ab3fd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05.12.20 04:44, Jakub Kicinski wrote:
> On Fri,  4 Dec 2020 14:35:08 +0100 Marc Kleine-Budde wrote:
>> From: Oliver Hartkopp <socketcan@hartkopp.net>
>>
>> When CAN_ISOTP_SF_BROADCAST is set in the CAN_ISOTP_OPTS flags the CAN_ISOTP
>> socket is switched into functional addressing mode, where only single frame
>> (SF) protocol data units can be send on the specified CAN interface and the
>> given tp.tx_id after bind().
>>
>> In opposite to normal and extended addressing this socket does not register a
>> CAN-ID for reception which would be needed for a 1-to-1 ISOTP connection with a
>> segmented bi-directional data transfer.
>>
>> Sending SFs on this socket is therefore a TX-only 'broadcast' operation.
> 
> Unclear from this patch what is getting fixed. Looks a little bit like
> a feature which could be added in a backward compatible way, no?
> Is it only added for completeness of the ISOTP implementation?
> 

Yes, the latter.

It's a very small and simple tested addition and I hope it can still go 
into the initial upstream process.

Many thanks,
Oliver
