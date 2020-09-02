Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA9D25B4BE
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgIBTtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBTtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 15:49:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C47C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 12:49:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70B3515633BF3;
        Wed,  2 Sep 2020 12:32:23 -0700 (PDT)
Date:   Wed, 02 Sep 2020 12:49:06 -0700 (PDT)
Message-Id: <20200902.124906.595244784602872122.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next v2 1/4] tipc: optimize key switching time and logic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <AM8PR05MB7332A71A7237D3BB3AB29A25E22F0@AM8PR05MB7332.eurprd05.prod.outlook.com>
References: <20200831083817.3611-2-tuong.t.lien@dektech.com.au>
        <20200901.151028.670408362469941141.davem@davemloft.net>
        <AM8PR05MB7332A71A7237D3BB3AB29A25E22F0@AM8PR05MB7332.eurprd05.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 12:32:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Tong Lien <tuong.t.lien@dektech.com.au>
Date: Wed, 2 Sep 2020 06:16:44 +0000

> Yes, the netlink extack message is fine but the fact is that we
> currently do not obtain such message from the user space tool
> (i.e. iproute2/tipc). So, if really needed, we will have to update
> the tool as well... For now, I will remove all the message logs as
> it is fine enough with the return code.

Please convert the messages to extack as I requested from you.

Until then, you'll have no incentive to fix the tool.
