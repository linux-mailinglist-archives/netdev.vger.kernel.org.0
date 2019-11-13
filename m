Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E830FAE21
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 11:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKMKK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 05:10:28 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:17910 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfKMKK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 05:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573639826;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=OzJc/z8N+OzYqWWGdfhr60X1rBKbg6zH4Hy1sttROBw=;
        b=S5G7GM76cCyv1Bh9kMY0al8REsNNsLheP8/U0ODwzvSAEZv9ZERUR1lE0+dX831LeN
        4RjnNPeIbINf9aoP/4/vcnizRJGe/izCLn+LgaEUSCq33AZnJ5tDIpIKk+hGb6iZBMdt
        Mj9BSgBFvly27VNuvHUwr7PCr3c0ciEH5dbOFmeYsBBRqkvoP+xKfoIr4sgojwYGIOdL
        kuuetqvbVw9fLsqC5bkaeeguSC78Exwtq9KzwxvKPkm5WNW1OKcScENo1/T/dgbhUznm
        278V7BEqDTQ11wU5dok959hRbrnzfBnyDRbpBRf9mTn4+kMYEz2Ri4mqjU0lNub4Qrqm
        CO/w==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1onjMalKFWXBdFnhSk9f/"
X-RZG-CLASS-ID: mo00
Received: from [10.120.65.22]
        by smtp.strato.de (RZmta 44.29.0 AUTH)
        with ESMTPSA id C03a03vADA4PiYC
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 13 Nov 2019 11:04:25 +0100 (CET)
Subject: Re: [PATCH v1 1/9] can: af_can: export can_sock_destruct()
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        dev.kurt@vandijck-laurijssen.be, wg@grandegger.com,
        netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
References: <20191112111600.18719-1-o.rempel@pengutronix.de>
 <20191112111600.18719-2-o.rempel@pengutronix.de>
 <20191112113724.pff6atmyii5ri4my@pengutronix.de>
 <1da06748-6233-b65e-9b02-da5a867a4ecb@pengutronix.de>
 <20191112114539.zjluqnpo3cynhssi@pengutronix.de>
 <5e561756-26b4-9a71-8fe2-c876e0e7d1af@hartkopp.net>
 <70a410f6-d57b-7586-b645-35d97680ac0b@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <51b7adcd-3c32-3913-8dc0-72fe71f0aae9@hartkopp.net>
Date:   Wed, 13 Nov 2019 11:04:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <70a410f6-d57b-7586-b645-35d97680ac0b@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/2019 21.10, Marc Kleine-Budde wrote:

> So I should take this series as is?
> 
> And the CAN namespace is introduced later?

Aeh - yes. Sorry for my late reply.

You already did it right.

Best,
Oliver
