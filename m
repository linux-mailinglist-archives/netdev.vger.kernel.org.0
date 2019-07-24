Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8884273CBF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392587AbfGXULb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:11:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392080AbfGXULa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 16:11:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A4A715431988;
        Wed, 24 Jul 2019 13:11:29 -0700 (PDT)
Date:   Wed, 24 Jul 2019 13:11:29 -0700 (PDT)
Message-Id: <20190724.131129.622443430636097975.davem@davemloft.net>
To:     nhorman@tuxdriver.com
Cc:     marcelo.leitner@gmail.com, lucien.xin@gmail.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] sctp: clean up __sctp_connect function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724184729.GD7212@hmswarspite.think-freely.org>
References: <cover.1563817029.git.lucien.xin@gmail.com>
        <20190724142512.GG6204@localhost.localdomain>
        <20190724184729.GD7212@hmswarspite.think-freely.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 13:11:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 24 Jul 2019 14:47:29 -0400

> On Wed, Jul 24, 2019 at 11:25:12AM -0300, Marcelo Ricardo Leitner wrote:
>> On Tue, Jul 23, 2019 at 01:37:56AM +0800, Xin Long wrote:
>> > This patchset is to factor out some common code for
>> > sctp_sendmsg_new_asoc() and __sctp_connect() into 2
>> > new functioins.
>> > 
>> > Xin Long (4):
>> >   sctp: check addr_size with sa_family_t size in
>> >     __sctp_setsockopt_connectx
>> >   sctp: clean up __sctp_connect
>> >   sctp: factor out sctp_connect_new_asoc
>> >   sctp: factor out sctp_connect_add_peer
>> 
>> Nice cleanup! These patches LGTM. Hopefully for Neil as well.
>> 
>> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>> 
> 
> Yes, agreed, this all looks good, but I would like to resolve the addr_length
> check issue before I ack it.

Once that's resolved please just respin this series with Marcelo's ACK
retained in the series introduction email.

