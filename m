Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B352C2AD35D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbgKJKS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:18:57 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:35713 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729604AbgKJKSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:18:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1605003532;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=yuroPseabvHArjtIgNq7j33hyj/gnkOqQTaRSuBpFrQ=;
        b=Aeg3iMdZa0ARrx/3gkiwwtSY4pUjmo1g0nvuBzlnZLxg4ZVd/I36UH9XsavO50ENpG
        VATGrbTBpOi1fGk1c6YVXma+ZdfDPEbldraLFamTLrV3el38T4q7GT7qcriCKeg4W0jj
        8yWyZK+2h8mZoC3mZpGwqjnog0uSX7ww0IfrTgTNbcBMR6ITe3j2CfAjgYU0GKN8UEQZ
        I+NbwQBaQa24mxE1xbvRXrUgdI2XRhvI426yeffNCSAmGtzPmw+CfsglUW5YU5Nx3Sft
        fCXcACNoHGR8lWgcSO9KRgm7naPe5iyXOjkOIq8UoqLfyvXxoeyEU0jMQtyCiiDpiFyl
        Eq7g==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR9J89pyV0="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwAAAIlAQX
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 10 Nov 2020 11:18:47 +0100 (CET)
Subject: Re: [PATCH v5 8/8] can-dev: add len8_dlc support for various CAN USB
 adapters
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org
References: <20201109153657.17897-1-socketcan@hartkopp.net>
 <20201109153657.17897-9-socketcan@hartkopp.net>
 <c9b7ec89-0892-89fa-1f8d-af9c973e4544@pengutronix.de>
 <68005955-4bf3-cdef-f85d-a841eb336921@hartkopp.net>
 <d563bbf7-da72-83ce-a3c1-ebec828e0d5b@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <d6fc6c4e-a03f-4f58-1bb6-2bfb830ebebb@hartkopp.net>
Date:   Tue, 10 Nov 2020 11:18:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <d563bbf7-da72-83ce-a3c1-ebec828e0d5b@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.11.20 08:46, Marc Kleine-Budde wrote:
> On 11/10/20 7:55 AM, Oliver Hartkopp wrote:

>> I would suggest something like
>>
>> u8 can_get_cc_len(const u32 ctrlmode, struct can_frame *cf, u8 dlc)
>>
>> that still returns the 'len' element, so that we can replace
>> can_cc_dlc2len() with can_get_cc_len() for CAN drivers that add support
>> for len8_dlc.
> 
> The regex to replace can_cc_dlc2len() with can_get_cc_len() might be simpler,
> but passing the cf by reference _and_ assigning the return value to a member of
> cf looks strange.

This might be a "make the patch looking good" thing too :-D

The code is now implemented even simpler and easy to follow when we 
migrate the other CAN drivers too.

But take a look on yourself. v6 is sent out.

Thanks,
Oliver
