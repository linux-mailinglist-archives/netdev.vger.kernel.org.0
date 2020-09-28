Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DAD27B5A8
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgI1TtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgI1TtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:49:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B107C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 12:49:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70D1314557734;
        Mon, 28 Sep 2020 12:32:21 -0700 (PDT)
Date:   Mon, 28 Sep 2020 12:49:08 -0700 (PDT)
Message-Id: <20200928.124908.1653966555661157280.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/10] udp_tunnel: convert Intel drivers
 with shared tables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b7faced6b7152e307789359c3a76bfd8d4a679ec.camel@intel.com>
References: <20200926005649.3285089-1-kuba@kernel.org>
        <b7faced6b7152e307789359c3a76bfd8d4a679ec.camel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 12:32:21 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Date: Mon, 28 Sep 2020 16:23:54 +0000

> On Fri, 2020-09-25 at 17:56 -0700, Jakub Kicinski wrote:
>> This set converts Intel drivers which have the ability to spawn
>> multiple netdevs, but have only one UDP tunnel port table.
>> 
>> Appropriate support is added to the core infra in patch 1,
>> followed by netdevsim support and a selftest.
>> 
>> The table sharing works by core attaching the same table
>> structure to all devices sharing the table. This means the
>> reference count has to accommodate potentially large values.
>> 
>> Once core is ready i40e and ice are converted. These are
>> complex drivers, but we got a tested-by from Aaron, so we
>> should be good :)
>> 
> Hi Dave,
> 
> Since we've finished our testing and reviews, do you want to pull this
> series or would you like me to re-send it as a pull request now that
> the email issue is fixed?

I'll take it in myself, thanks Tony.
