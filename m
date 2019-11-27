Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212F210ACED
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfK0Jwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:52:47 -0500
Received: from first.geanix.com ([116.203.34.67]:40280 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfK0Jwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:52:47 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id B2A7693C86;
        Wed, 27 Nov 2019 09:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1574848141; bh=T3U6ItvsTziLRDiqIOQZd2paolMr24n9S61D7fqjt5Y=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Lm6Z65uUNl6pkrntdMEq3YsqU1/bY3QEc6ACeYvOsISU8BI6HdOVo2+HVGRjtWqFd
         D/nhcuNd4FcD5Fv5bbFqJ5HlNzJvHGrYTgyXLjNIIW+X1Jl3Nq6Wr5abJl1iaFE9lI
         oiRuDuDPyzNuH2iTwdYxTCAdMgXzmomFnLAA7A1SSLpRY+uj2oiIJ51yAr8s1p4Gwe
         +Y1k4lKgC0BLmgY9dmd08iDVfIuKC6XJszl/vqjqVpdfcU7DhAAQQIDbwBKBOOrZR7
         qsyfqGMDrj3RW9n9orJm4WoS4iENF10+QeezUtHHg5KxLwsj8vOVa09gmSXlRpW5KL
         wO2J77hyr+a7g==
Subject: Re: [PATCH V2 0/4] can: flexcan: fixes for stop mode
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <e936b9b1-d602-ac38-213c-7272df529bef@geanix.com>
 <4a9c2e4a-c62d-6e88-bd9e-01778dab503b@geanix.com>
 <DB7PR04MB46186472F0437A825548CE11E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <DB7PR04MB4618C541894AD851BED5B0B7E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <1c71c2ef-39a4-6f38-98c0-4ee43767a725@geanix.com>
Date:   Wed, 27 Nov 2019 10:52:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <DB7PR04MB4618C541894AD851BED5B0B7E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b0d531b295e6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/11/2019 10.48, Joakim Zhang wrote:
> One more should confirm with you, you inserted a flexcan.ko after stop mode activated without fix patch firstly, and then inserted a flexcan.ko
> with fix patch. If yes, this could cause unbalanced pm_runtime_enabled. The reason is that firstly inserted the flexcan.ko would enable device runtime pm,
> and then you inserted flexcan.ko enable device runtime pm again.
> 
> Could you please insert flexcan.ko with fix patch directly after stop mode activated?
>   
Hi,

If I insert flexcan.ko with fix patch directly after stop mode 
activated, the unbalanced msg is not shown...
I guess we are good then :)

/Sean
