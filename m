Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0D2560DA0
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 01:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiF2Xhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 19:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiF2Xhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 19:37:31 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66008B10;
        Wed, 29 Jun 2022 16:37:30 -0700 (PDT)
Received: from [10.22.0.128] (unknown [176.74.39.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 8B9BE5005C5;
        Thu, 30 Jun 2022 02:35:50 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 8B9BE5005C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1656545751; bh=zCQ4JA9OXV9FjwFr6O6e3eTB5QmVfvYRSojJ4nPLGWA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=zcS8Jv1Dra8uP8LjkzBRcA+vJWxllLJC6cdoO23bklHqfknrkmqn9QYEzcqKgF4F/
         hVsSKelqGzb47ocxihqoUP7G08m4FmrrA31soqTUHVrvI9CcQaZpJeSUvS1c/5MPY8
         EIzpZkXQ3n7DMlLlnOxWFSqq8yKDm5c67nt1qAfY=
Message-ID: <3bdbf164-f28a-5954-408b-99be3ecaa6c1@novek.ru>
Date:   Thu, 30 Jun 2022 00:37:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v2 1/3] dpll: Add DPLL framework base functions
Content-Language: en-US
To:     Stephen Boyd <sboyd@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-2-vfedorenko@novek.ru>
 <20220629083439.6F5E3C34114@smtp.kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220629083439.6F5E3C34114@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen!

On 29.06.2022 09:34, Stephen Boyd wrote:
> Quoting Vadim Fedorenko (2022-06-26 12:24:42)
>> From: Vadim Fedorenko <vadfed@fb.com>
>>
>> DPLL framework is used to represent and configure DPLL devices
>> in systems. Each device that has DPLL and can configure sources
>> and outputs can use this framework.
> 
> Please add more details to the commit text, and possibly introduce some
> Documentation/ about this driver subsystem. I'm curious what is
> different from drivers/clk/, is it super large frequencies that don't
> fit into 32-bits when represented in Hz? Or PLL focused? Or is sub-Hz
> required?

Sure, I'm working on adding Documentation/ patch in the next iteration. For now 
I would it's mostly focused on PLL configuration rather then clocking thing. And 
the main reason is to provide flexible netlink API.

> 
> Details please!
> 
> Does DPLL stand for digital phase locked loop? Again, I have no idea! I
> think you get my point.

Yes, you are right, DPLL stands for digital phase locked loop.
