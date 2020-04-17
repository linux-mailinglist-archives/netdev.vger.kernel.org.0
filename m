Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A6D1AE22F
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 18:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgDQQXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 12:23:54 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54886 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgDQQXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 12:23:54 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id E51352A2AEB
Subject: Re: [RFC 0/8] Stop monitoring disabled devices
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20200407174926.23971-1-andrzej.p@collabora.com>
 <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
 <aeec2ce8-8fb9-9353-f3dd-36a476ceeb3b@collabora.com>
 <CGME20200415104010eucas1p101278e53e34a2e56dfc7c82b533a9122@eucas1p1.samsung.com>
 <dc999149-d168-0b86-0559-7660e0fdec77@samsung.com>
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Message-ID: <fc166e0f-91ec-67d5-28b0-428f556643a4@collabora.com>
Date:   Fri, 17 Apr 2020 18:23:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <dc999149-d168-0b86-0559-7660e0fdec77@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Barlomiej,

>> Thanks for feedback.
>>
>> Anyone else?
> 
> Yes. :)
> 
> Please take a look at the following patchset (which I'm reviving currently):
> 
> 	https://lkml.org/lkml/2018/10/17/926
> 
> It overlaps partially with your work so we need to coordinate our efforts.
> 

I've just sent a v3. After addressing your and Daniel's comments my series
now looks pretty compact. Let's see if there's more feedback. Is your work on
reviving the above mentioned 2018 series ready?

Andrzej
