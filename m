Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60247A0B15
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfH1UGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:06:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36142 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfH1UGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:06:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 819861534DC58;
        Wed, 28 Aug 2019 13:06:24 -0700 (PDT)
Date:   Wed, 28 Aug 2019 13:06:24 -0700 (PDT)
Message-Id: <20190828.130624.876004452510316906.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     ruxandra.radulescu@nxp.com, netdev@vger.kernel.org,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next v2 3/3] dpaa2-eth: Add pause frame support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828115250.GA32178@lunn.ch>
References: <20190827232132.GD26248@lunn.ch>
        <AM0PR04MB499496AC09FD7BE58AE7B9C394A30@AM0PR04MB4994.eurprd04.prod.outlook.com>
        <20190828115250.GA32178@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 13:06:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 28 Aug 2019 13:52:50 +0200

>> Clearing the ASYM_PAUSE flag only means we tell the firmware we want
>> both Rx and Tx pause to be enabled in the beginning. User can still set
>> an asymmetric config (i.e. only Rx pause or only Tx pause to be enabled)
>> if needed.
>> 
>> The truth table is like this:
>> 
>> PAUSE | ASYM_PAUSE | Rx pause | Tx pause
>> ----------------------------------------
>>   0   |     0      | disabled | disabled
>>   0   |     1      | disabled | enabled
>>   1   |     0      | enabled  | enabled
>>   1   |     1      | enabled  | disabled
> 
> Hi Ioana
> 
> Ah, that is not intuitive. Please add a comment, and maybe this table
> to the commit message.

Isn't this the same truth table as for the pause bits in the usual MII
registers?
