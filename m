Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7346A69167A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjBJCFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBJCFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:05:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9494A6E889;
        Thu,  9 Feb 2023 18:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=7vWptRrr6ZcyxNo05+kCpak7wSWep3HJR4uaRpVpmZg=; b=tPoovkBE8eL2H9L85pgbKbKo48
        qZpC4v/tbRt1gEyRbNAJCY+lDtOhw/I0qlPyFefi8Rq+99Tk4jtsSHlcUWQUROfuCiOJ2fGsNjsXy
        9+7uGng7ulApgSqh4Q8sijFui4OoXNCTvhn34LsHUaIuEdLAaxjhyAvuclerVrbxa1tWKKU1Qq+zK
        Dh25Rpm1rOVcDku5O7IUckm4etl/JeWCHM0vKw/079cdVfsPU129fqC3KsRNtQoP9EULZ1TCCEGkJ
        r84Xy7ExbcjVlVXS6merQQ55e/zfh3SQnyEQ/5XwSk/z3/byPMt/AFxRkJwS/6RR8GbAHjXCqh6aW
        9OXcMo8A==;
Received: from [2601:1c2:980:9ec0::df2f]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pQImh-003trK-PY; Fri, 10 Feb 2023 02:05:07 +0000
Message-ID: <63c3edef-35c6-867a-0ea7-06ed03ac74b9@infradead.org>
Date:   Thu, 9 Feb 2023 18:05:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: =?UTF-8?Q?Re=3a_error=3a_too_many_arguments_to_function_=e2=80=98ca?=
 =?UTF-8?B?bl9jYWxjX2JpdHRpbWluZ+KAmQ==?=
Content-Language: en-US
From:   Randy Dunlap <rdunlap@infradead.org>
To:     Network Development <netdev@vger.kernel.org>,
        linux-can@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
References: <42ffb65d-31da-fc5e-0e47-5f24fa1e4f88@infradead.org>
In-Reply-To: <42ffb65d-31da-fc5e-0e47-5f24fa1e4f88@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[corrected linux-can@ email address]


On 2/9/23 17:56, Randy Dunlap wrote:
> Hi,
> 
> It's possible to have a kernel .config (randconfig) file with
> # CONFIG_CAN_CALC_BITTIMING is not set
> 
> which ends up with different number of arguments to can_calc_bittiming().
> 
> Full compiler error listing is:
> 
> ../drivers/net/can/dev/bittiming.c: In function ‘can_get_bittiming’:
> ../drivers/net/can/dev/bittiming.c:145:24: error: too many arguments to function ‘can_calc_bittiming’
>   145 |                 return can_calc_bittiming(dev, bt, btc, extack);
>       |                        ^~~~~~~~~~~~~~~~~~
> In file included from ../include/linux/can/dev.h:18,
>                  from ../drivers/net/can/dev/bittiming.c:7:
> ../include/linux/can/bittiming.h:126:1: note: declared here
>   126 | can_calc_bittiming(const struct net_device *dev, struct can_bittiming *bt,
>       | ^~~~~~~~~~~~~~~~~~
> 
> 
> A failing i386 .config file is attached.
> 
> Do you have any suggestions for resolving this error?
> 
> Thank you.

-- 
~Randy
