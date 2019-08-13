Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04298BFBF
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 19:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfHMRk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 13:40:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38382 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfHMRk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 13:40:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB1F6154FAB8C;
        Tue, 13 Aug 2019 10:40:56 -0700 (PDT)
Date:   Tue, 13 Aug 2019 10:40:54 -0700 (PDT)
Message-Id: <20190813.104054.140346412563349218.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace
 accounting for fib entries
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190813071445.GL2428@nanopsycho>
References: <20190812083635.GB2428@nanopsycho>
        <20190812.082802.570039169834175740.davem@davemloft.net>
        <20190813071445.GL2428@nanopsycho>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 Aug 2019 10:40:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Tue, 13 Aug 2019 09:14:45 +0200

> Mon, Aug 12, 2019 at 05:28:02PM CEST, davem@davemloft.net wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Date: Mon, 12 Aug 2019 10:36:35 +0200
>>
>>> I understand it with real devices, but dummy testing device, who's
>>> purpose is just to test API. Why?
>>
>>Because you'll break all of the wonderful testing infrastructure
>>people like David have created.
>  
> Are you referring to selftests? There is no such test there :(
> But if it would be, could implement the limitations
> properly (like using cgroups), change the tests and remove this
> code from netdevsim?

What about older kernels?  Can't you see how illogical this is?
