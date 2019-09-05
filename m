Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42C5A9A4F
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 07:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbfIEF6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 01:58:14 -0400
Received: from first.geanix.com ([116.203.34.67]:36916 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfIEF6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 01:58:14 -0400
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id BE2656335C;
        Thu,  5 Sep 2019 05:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1567663083; bh=EGHUcxlHylHqa4RpQhXEj02KCbsDpUsUgP5G5aGhjRM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=DDSgUrd6dO3cG11OMj3GFVZFONbVqDmDus9CzQySaMZLI/96MpEsBwy5OW8aoj8gy
         B9t31+/gHbMrDFC7fP+rSDZb4upVjnJmnJkVILHhRymigS/9X3b+rO9La+ihyPAwUD
         L1JmhnZ3QMJOPFFlgr96gL6xefOrPLZhD54B9Fd+YCAs40Jf9rQEULSwmdX/mPQDYF
         w1YoakrqrEy5U1zF2IgL6SjnFHuh6aFIgyk3UXzMZZOulGvbYdwZ8SENYEc4ryk9QX
         UBXF+x4qi5HyAvHghfzeR5lyIFoEuig42/i47ADnJOKcPGElerPRBzHQNzKdDboZGh
         kw3eGtju6FCTQ==
Subject: Re: [PATCH REPOST 1/2] can: flexcan: fix deadlock when using self
 wakeup
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <martin@geanix.com>
References: <20190816081749.19300-1-qiangqing.zhang@nxp.com>
 <20190816081749.19300-2-qiangqing.zhang@nxp.com>
 <dd8f5269-8403-702b-b054-e031423ffc73@geanix.com>
 <DB7PR04MB4618A1F984F2281C66959B06E6AB0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <35190c5b-f8be-8784-5b4f-32a691a6cffe@geanix.com>
 <6a9bc081-334a-df91-3a23-b74a6cdd3633@geanix.com>
 <DB7PR04MB4618E527339B69AEAD46FB06E6A20@DB7PR04MB4618.eurprd04.prod.outlook.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <588ab34d-613d-ac01-7949-921140ca4543@geanix.com>
Date:   Thu, 5 Sep 2019 07:57:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <DB7PR04MB4618E527339B69AEAD46FB06E6A20@DB7PR04MB4618.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 77834cc0481d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/08/2019 09.30, Joakim Zhang wrote:
> Hi Sean,
> 
> I'm sorry that I can't get the debug log as the site can't be reached. And I connect two boards to do test at my side, this issue can't be reproduced.
> 
> Best Regards,
> Joakim Zhang

Hi Joakim,

What commit and branch are you doing your tests with?

/Sean
