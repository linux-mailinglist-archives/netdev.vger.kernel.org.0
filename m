Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F935A031E
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 15:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfH1NY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 09:24:57 -0400
Received: from first.geanix.com ([116.203.34.67]:47176 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbfH1NY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 09:24:57 -0400
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 90BC62CB;
        Wed, 28 Aug 2019 13:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1566998655; bh=e8jYmdcNS1XgJtOxsbFWt1uQ18zM0d4s3YnFIR+L4PY=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To;
        b=AD2EMH4W24+IgN8TUiToESJ0AlP3/OzbHcaCCaV8MXjeW8WYI/lBUrevX4rje2zCL
         Y7m6H2hzboI4YywBD9JJr5PIIDU/poRJMn9WhWjl+wGBxhAFM7/OK/eToihxpG25ze
         TKL1rLj1FB+qDQkSibchvZG/9FoUGQrN94TKZmKQKzDlFHAPrwYUiAUu1PHHfZs/Vt
         p76LIziZo70N4o1XN8p4f4ZI/tQPjJqYKCs/7eJ1MjKBczOnqpNTfePE2t7I22bEVX
         x/mwMC5Lt5I7der78mcdFFCC79eg/bCuFL3kF7F0taskYQrBbUKJnvXGHicbg4JhY/
         qbw0Pf1AO1kEg==
Subject: Re: [PATCH REPOST 1/2] can: flexcan: fix deadlock when using self
 wakeup
From:   Sean Nyekjaer <sean@geanix.com>
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
Message-ID: <6a9bc081-334a-df91-3a23-b74a6cdd3633@geanix.com>
Date:   Wed, 28 Aug 2019 15:24:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <35190c5b-f8be-8784-5b4f-32a691a6cffe@geanix.com>
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



On 20/08/2019 13.55, Sean Nyekjaer wrote:
> 
> I have added some more debug, same test setup:
> https://gist.github.com/sknsean/81208714de23aa3639d3e31dccb2f3e0
> 
> root@iwg26:~# systemctl suspend
> 
> ...
> https://gist.github.com/sknsean/2a786f1543305056d4de03d387872403
> 
> /Sean

Any luck reproducing this?

/Sean
