Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E884110AD15
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 11:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfK0KAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 05:00:35 -0500
Received: from first.geanix.com ([116.203.34.67]:40602 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbfK0KAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 05:00:34 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id D596E93CD2;
        Wed, 27 Nov 2019 09:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1574848609; bh=YNVGoJ/mISjfuT4lizZIHp9wmAjciP+AafxbnaYnnvA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=du+6aTL37NzK/yzw3E+b2dYM6sRs6nT5MeJTGhDpVBJ3UtCqYdiCCPaNT9GMyoXLX
         ggryESQphctdHFj/WtR6g7GUMXN0M6KrFnGRq9SCK2vmWse/2l062F3xnnwz2Vp5Kj
         CByWyT5q5NUgXR6786oIAa29u6LUvZz8l+Hi2E1zvPYkC196GIypgjVISvjXzOw8Ty
         o3UeXuvDgMCB7xho/j1caF7UCyClPjK6HHf4W+C086RWoxTOU4cl8Ykz3Ix62l+34D
         wDdmnlMXSXVK+SLJ5xEwGN47akXaP2MzyIqddsYiTsF5KCWCD3lihDUCIiBD3qss5G
         opTJQvxmt+XtQ==
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
 <1c71c2ef-39a4-6f38-98c0-4ee43767a725@geanix.com>
 <DB7PR04MB46180EE59D373F9634DD936AE6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <6fa94966-c21b-ad2b-653d-aa3589b32df8@geanix.com>
Date:   Wed, 27 Nov 2019 10:59:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <DB7PR04MB46180EE59D373F9634DD936AE6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
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



On 27/11/2019 10.58, Joakim Zhang wrote:
> Could you give your Test-by tag for this patch set? And then Marc could review this patch set.

Done :)
Can't test patch 4/4...

Hope Marc can give his comments and pick these.

/Sean
