Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF82028B055
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgJLIfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:35:22 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:33706 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgJLIfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:35:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1602491717;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=oa4eaa10d7cHcAXWDr+5ZRxjT5ZHRkvezX1CY1xnr/8=;
        b=Qcr/ifuS8jLJ1y+OdSzUn1gRt8hDIkloBRQqdKvG7njKFUEpCar6iGSjIq3X3BE8zV
        tFo4B3vAJhWBH4EJODuB+CxhNcxIvP4LBvDUTTHLbi5M23sxNJ8gbQgHYOgNJaIVYNe/
        CXWk1CEug1ngO/b9jPyYHyqPWx+GfwgfdB6oAx108r2Q/dL+HZIw8d8CgxlsaSwE5faR
        jyS/M3Ryvyh93v57Q0LT2gw5l0GLS3nZUScCjKTz21OAcebZYD1MYRs8LxrzkhF5F8bZ
        67RPpDlzQpGcNB4NgEMhCGbQg+ln5r4I+fKq1wvYcxuTGgQkz/v7x1SxbUUzYMxH4TSI
        kVUQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGVxiOM9spw=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9C8Z8Oa8
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 12 Oct 2020 10:35:08 +0200 (CEST)
Subject: Re: [PATCH net-next v3 1/2] can-isotp: implement cleanups /
 improvements from review
To:     Marc Kleine-Budde <mkl@pengutronix.de>, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org
References: <20201012074354.25839-1-socketcan@hartkopp.net>
 <7e64959a-9f73-0f0d-bdd9-b12dc65321cb@pengutronix.de>
 <15d1b847-d717-7f85-af3f-aaaeef28bd6d@hartkopp.net>
 <2c57194d-ce05-7a5b-02fa-a8fe776cb467@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <909c84e4-d779-e8a8-827b-3892849c2294@hartkopp.net>
Date:   Mon, 12 Oct 2020 10:35:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <2c57194d-ce05-7a5b-02fa-a8fe776cb467@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12.10.20 10:30, Marc Kleine-Budde wrote:
> On 10/12/20 10:11 AM, Oliver Hartkopp wrote:
>>
>>
>> On 12.10.20 10:05, Marc Kleine-Budde wrote:
>>> On 10/12/20 9:43 AM, Oliver Hartkopp wrote:
>>>> As pointed out by Jakub Kicinski here:
>>>> http://lore.kernel.org/r/20201009175751.5c54097f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com
>>>> this patch addresses the remarked issues:
>>>>
>>>> - remove empty line in comment
>>>> - remove default=y for CAN_ISOTP in Kconfig
>>>> - make use of pr_notice_once()
>>>> - use GFP_ATOMIC instead of gfp_any() in soft hrtimer context
>>>>
>>>> The version strings in the CAN subsystem are removed by a separate patch.
>>>>
>>>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>>> ---
>>>
>>> Added both to linux-can-next.
>>
>> The patches were intended for 'net-next' as the merge window will open
>> *very* soon.
>>
>> I'm not sure if there would be another pull from linux-can-next until
>> then, therefore I would suggest that Jakub takes the patches himself.
> 
> I don't mind. FWIW, here's the pull request:
> 
>      http://lore.kernel.org/r/20201012082727.2338859-1-mkl@pengutronix.de
> 
>      git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.10-20201012
> 
> Marc

:-D

Well thanks!

I just got the feeling that especially the
"remove default=y for CAN_ISOTP in Kconfig"
issue is urgent in net-next.

So now any way to get the patches is fine.

Thanks & BR,
Oliver
