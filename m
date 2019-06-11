Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D923C4B0
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391332AbfFKHIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:08:32 -0400
Received: from first.geanix.com ([116.203.34.67]:48560 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391121AbfFKHIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 03:08:32 -0400
Received: from [10.130.30.123] (unknown [89.221.170.34])
        by first.geanix.com (Postfix) with ESMTPSA id C7B5013EA;
        Tue, 11 Jun 2019 07:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1560236770; bh=O2niOTOhNGiNDk8HzKWU1vaZJJAl7wgZCIqiGLXAQ80=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Xv4MNpjGbEtIXyukxpVpjIMIe1ugM1AGQ9wrFqEpvIAI46plcdM3JE+mKa89/Tg/F
         x1In8uOO4HQIQ7OFtkfrgLVLOwp/tqyannCYswc0ZwrChvBBoYVWZQAtahyMyLT4vH
         rEND+lv1Lf4IcFkTgmVs7G35wdTFtwMqdyi/SJwgXyGYVjRo3wCzFVzszgj70uCZen
         5Nt0sb4KtGnsRgb13lRb7YZU+iZTrtJgq9sFUdjlDU0Mdg4MbPMtrH+9dKNEewR+Mp
         MEkuiqMYP0QcNCGgQQ2X2GScfPLoS/t/V2miQenUcEDB4sw2m6mir+kmKrZkHSN7WO
         hds7cMKrIcEvg==
Subject: Re: [PATCH] can: flexcan: fix deadlock when using self wakeup
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190517023652.19285-1-qiangqing.zhang@nxp.com>
 <fbbe474f-bdf7-a97a-543d-da17dfd2a114@geanix.com>
 <DB7PR04MB46181EE74BF030D728042FD6E6ED0@DB7PR04MB4618.eurprd04.prod.outlook.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <23fcfa1b-a664-7768-a793-26627b14463e@geanix.com>
Date:   Tue, 11 Jun 2019 09:08:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <DB7PR04MB46181EE74BF030D728042FD6E6ED0@DB7PR04MB4618.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF autolearn=disabled
        version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 796779db2bec
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/06/2019 08.58, Joakim Zhang wrote:
>>
>> How is it going with the updated patch?
> 
> Hi Sean,
> 
> 	I still need discuss with Marc about the solution.
> 
> Joakim Zhang

Hi, Joakim

Please include me in the loop :-)

/Sean
