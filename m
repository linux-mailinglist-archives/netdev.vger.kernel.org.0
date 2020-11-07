Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A262AA51D
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 13:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgKGMzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 07:55:15 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:58216 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727084AbgKGMzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 07:55:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UEWYE.-_1604753711;
Received: from IT-FVFX43SYHV2H.lan(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UEWYE.-_1604753711)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 07 Nov 2020 20:55:11 +0800
Subject: Re: [PATCH] net/dsa: remove unused macros to tame gcc warning
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
 <20201106141820.GP933237@lunn.ch>
 <24690741-cc10-eec1-33c6-7960c8b7fac6@gmail.com>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <b3274bdb-5680-0c24-9800-8c025bfa119a@linux.alibaba.com>
Date:   Sat, 7 Nov 2020 20:54:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <24690741-cc10-eec1-33c6-7960c8b7fac6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2020/11/7 上午12:39, Florian Fainelli 写道:
>> Hi Alex
>>
>> It is good to remember that there are multiple readers of source
>> files. There is the compiler which generates code from it, and there
>> is the human trying to understand what is going on, what the hardware
>> can do, how we could maybe extend the code in the future to make use
>> of bits are currently don't, etc.
>>
>> The compiler has no use of these macros, at the moment. But i as a
>> human do. It is valuable documentation, given that there is no open
>> datasheet for this hardware.
>>
>> I would say these warnings are bogus, and the code should be left
>> alone.
> Agreed, these definitions are intended to document what the hardware
> does. These warnings are getting too far.
> -- 

Thanks for all comments! I agree these info are much meaningful.
Is there other way to tame the gcc warning? like put them into a .h file
or covered by comments?

Thanks
Alex
