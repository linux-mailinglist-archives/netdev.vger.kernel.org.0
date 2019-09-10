Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C89AE4EE
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 09:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbfIJHxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 03:53:11 -0400
Received: from first.geanix.com ([116.203.34.67]:34944 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfIJHxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 03:53:10 -0400
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id E6A7863F8C;
        Tue, 10 Sep 2019 07:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1568101957; bh=JWpMCBOZzAtqev9tXfl5tAGFLKML/ZFox/BCoTvX3yk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=BH5vAOUrDlJBeQw2NpdpaWtrPZj8ZxHuxUTuvdjBmvbI5v1JFTf73Wvv76Y3V9/zm
         sjoR1u1hPMvdsIykouomn14Sk7V4aOsaTF0FT0xiehVS/kmL24SQ+X5j6y5E5AbMrq
         kpWBCKUxXWsZaTWBLrykrZY00HH2vuVBfFeGYC9CRFnjvE5hHhWX3MoGRaDhsp8ul3
         UfcNHhvWup2YwZrIq+mvE01F8GGRocNvHrJsxTAOBpGXmKlK2PFv6jZIN7wxiy0Z+y
         XtVWYlIYhWuLzooFUHxhD4vp8ugFg3ghPIykkVhh97lSFm40csg4y9sBG8NmXkxqBc
         0pdxYWVSC2aVQ==
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
 <588ab34d-613d-ac01-7949-921140ca4543@geanix.com>
 <DB7PR04MB461868320DA0B25CC8255213E6BB0@DB7PR04MB4618.eurprd04.prod.outlook.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <739eee2e-2919-93b4-24fe-8d0d198ae042@geanix.com>
Date:   Tue, 10 Sep 2019 09:52:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <DB7PR04MB461868320DA0B25CC8255213E6BB0@DB7PR04MB4618.eurprd04.prod.outlook.com>
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



On 05/09/2019 09.10, Joakim Zhang wrote:
> Hi Sean,
> 
> Could you update lastest flexcan driver using linux-can-next/flexcan and then merge below two patches from linux-can/testing?
> d0b53616716e (HEAD -> testing, origin/testing) can: flexcan: add LPSR mode support for i.MX7D
> 803eb6bad65b can: flexcan: fix deadlock when using self wakeup
> 
> Best Regards,
> Joakim Zhang

Hi

I reverted 2 commits on thw nand driver and got the testing kernel to work.

I can confirm the issue is resolved with this patch :-)

/Sean
