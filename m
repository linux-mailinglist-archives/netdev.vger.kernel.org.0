Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB3920AA79
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 04:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgFZCkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 22:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbgFZCkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 22:40:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF894C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 19:40:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 919A11585ABB5;
        Thu, 25 Jun 2020 19:40:11 -0700 (PDT)
Date:   Thu, 25 Jun 2020 19:40:08 -0700 (PDT)
Message-Id: <20200625.194008.791920953816892666.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org
Subject: Re: Request for net merge into net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200625.122137.190059934175313682.davem@davemloft.net>
References: <74156b9ad8529a3228658165396fd5adb2ccd972.camel@redhat.com>
        <20200625.122137.190059934175313682.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 19:40:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 25 Jun 2020 12:21:37 -0700 (PDT)

> From: Paolo Abeni <pabeni@redhat.com>
> Date: Thu, 25 Jun 2020 11:16:47 +0200
> 
>> We have a few net-next MPTCP changes depending on:
>> 
>> commit 9e365ff576b7c1623bbc5ef31ec652c533e2f65e
>> mptcp: drop MP_JOIN request sock on syn cookies
>>     
>> commit 8fd4de1275580a1befa1456d1070eaf6489fb48f
>> mptcp: cache msk on MP_JOIN init_req
>> 
>> Could you please merge net into net-next so that we can post without
>> causing later conflicts?
> 
> I'm going to send a pull request for 'net' to Linus and once he takes that
> I'll sync everything.

This is now done.
