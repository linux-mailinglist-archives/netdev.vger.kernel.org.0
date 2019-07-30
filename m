Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851927B4E3
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387656AbfG3VSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:18:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55440 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387628AbfG3VS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:18:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2BBC14815596;
        Tue, 30 Jul 2019 14:18:28 -0700 (PDT)
Date:   Tue, 30 Jul 2019 14:18:28 -0700 (PDT)
Message-Id: <20190730.141828.1170755600878594791.davem@davemloft.net>
To:     marcelo.leitner@gmail.com
Cc:     lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCHv2 net-next 0/5] sctp: clean up __sctp_connect function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730194231.GE4064@localhost.localdomain>
References: <cover.1564490276.git.lucien.xin@gmail.com>
        <20190730194231.GE4064@localhost.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 14:18:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 30 Jul 2019 16:42:31 -0300

> On Tue, Jul 30, 2019 at 08:38:18PM +0800, Xin Long wrote:
>> This patchset is to factor out some common code for
>> sctp_sendmsg_new_asoc() and __sctp_connect() into 2
>> new functioins.
>> 
>> v1->v2:
>>   - add the patch 1/5 to avoid a slab-out-of-bounds warning.
>>   - add some code comment for the check change in patch 2/5.
>>   - remove unused 'addrcnt' as Marcelo noticed in patch 3/5.
>> 
>> Xin Long (5):
>>   sctp: only copy the available addr data in sctp_transport_init
>>   sctp: check addr_size with sa_family_t size in
>>     __sctp_setsockopt_connectx
>>   sctp: clean up __sctp_connect
>>   sctp: factor out sctp_connect_new_asoc
>>   sctp: factor out sctp_connect_add_peer
> 
> Series,
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Series applied, thanks.
