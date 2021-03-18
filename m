Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4E73401EF
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 10:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhCRJX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 05:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhCRJXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 05:23:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FC9C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 02:23:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1lMosO-0003JJ-5D; Thu, 18 Mar 2021 10:23:32 +0100
Subject: Re: [BUG] Re: [net 3/6] can: flexcan: invoke flexcan_chip_freeze() to
 enter freeze mode
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-can@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        davem@davemloft.net
References: <20210301112100.197939-1-mkl@pengutronix.de>
 <20210301112100.197939-4-mkl@pengutronix.de>
 <65137c60-4fbe-6772-6d48-ac360930f62b@pengutronix.de>
 <20210317081831.osalrszbje4oofoh@pengutronix.de>
 <20210317114938.lcqudto75wc6nkzq@pengutronix.de>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <148ff70d-96a6-952c-279d-ad1c5cd4e71d@pengutronix.de>
Date:   Thu, 18 Mar 2021 10:23:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210317114938.lcqudto75wc6nkzq@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.03.21 12:49, Marc Kleine-Budde wrote:
> On 17.03.2021 09:18:31, Marc Kleine-Budde wrote:
>> A fix for this in on its way to net/master:
>>
>> https://lore.kernel.org/linux-can/20210316082104.4027260-6-mkl@pengutronix.de/
> 
> It's already in net/master.

Cherry-picked and works for me.

Thanks,
Ahmad

> 
> regards,
> Marc
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
