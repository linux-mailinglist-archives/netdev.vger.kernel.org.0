Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23D3124900
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfLROD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:03:57 -0500
Received: from first.geanix.com ([116.203.34.67]:41822 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbfLROD5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:03:57 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id BBFB95B2;
        Wed, 18 Dec 2019 14:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1576677776; bh=Yiwwv2yYC5oBNyk7+/HqeIxYF+mMdh5a1RnnwxxWSLI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=RRpizVX76J1LFhNbsy5YnRWJDvTdPxiPuH00bOo68DlglcZMx/wwaioH6MN9rSAH3
         hKNTOyd9VJsZg3GZuvlEz72UuD+uE1vSQSO6LvW0Og4F/T5cPLRa3AylJ8CXYSlDMB
         cJtjuehDR+kyPg7Bpa8IJZaFIaC0A7nBnDeO/sFDs0L9OGv99n+3UWA4paMYqGHjJa
         0OwChoaB6F+HlUgNSIY8mNXEsQJeXSRV6R7A+6+rbetqu0KOeWK4N/OUxJOETMLsNL
         T30p0POfvT/cFmq8KiNZ4jDqzqyOWidPoK+6cskwVeQXyBM87r7FxtOhk5Th/6Vjoj
         A2OdsIkqzoCpA==
Subject: Re: [PATCH V2 1/2] can: flexcan: disable runtime PM if register
 flexcandev failed
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191210085721.9853-1-qiangqing.zhang@nxp.com>
 <DB7PR04MB46181D2F1538A53B4F1892E2E6500@DB7PR04MB4618.eurprd04.prod.outlook.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <935f466b-a9c9-de73-be12-6ebb7b77e058@geanix.com>
Date:   Wed, 18 Dec 2019 15:03:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <DB7PR04MB46181D2F1538A53B4F1892E2E6500@DB7PR04MB4618.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/12/2019 07.36, Joakim Zhang wrote:
> 
> Hi Sean,
> 
> Have you found time to test this patch set? Thanks :-)
> 
> Best Regards,
> Joakim Zhang
> 

Hi Joakim

Sorry for the delay :)

I have tested this patchset and found no issues...

Just a heads up when adding "ChangeLog:" do it under the "---" and above 
the diff. That way the ChangeLog doesn't end up in the commit msg...

/Sean


