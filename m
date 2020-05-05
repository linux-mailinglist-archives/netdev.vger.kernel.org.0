Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C461C6230
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgEEUke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEEUke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:40:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2577AC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 13:40:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 82C5C12812C55;
        Tue,  5 May 2020 13:40:33 -0700 (PDT)
Date:   Tue, 05 May 2020 13:40:32 -0700 (PDT)
Message-Id: <20200505.134032.1012670754893659391.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     mrv@mojatatu.com, netdev@vger.kernel.org, kernel@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net 1/1] neigh: send protocol value in neighbor create
 notification
From:   David Miller <davem@davemloft.net>
In-Reply-To: <073f9bbb-fece-68e8-dc39-fa3eeccb152e@gmail.com>
References: <1588383258-11049-1-git-send-email-mrv@mojatatu.com>
        <073f9bbb-fece-68e8-dc39-fa3eeccb152e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 13:40:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Tue, 5 May 2020 11:00:47 -0600

> On 5/1/20 7:34 PM, Roman Mashak wrote:
>> When a new neighbor entry has been added, event is generated but it does not
>> include protocol, because its value is assigned after the event notification
>> routine has run, so move protocol assignment code earlier.
>> 
>> Fixes: df9b0e30d44c ("neighbor: Add protocol attribute")
>> Cc: David Ahern <dsahern@gmail.com>
>> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
>> ---
>>  net/core/neighbour.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable, thanks everyone.
