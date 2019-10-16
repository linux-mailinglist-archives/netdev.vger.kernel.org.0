Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BB5D99AB
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436676AbfJPTEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:04:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53110 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436617AbfJPTEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:04:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2155A142C0124;
        Wed, 16 Oct 2019 12:04:22 -0700 (PDT)
Date:   Wed, 16 Oct 2019 12:04:19 -0700 (PDT)
Message-Id: <20191016.120419.1631440501656175018.davem@davemloft.net>
To:     marcelo.leitner@gmail.com
Cc:     lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, nhorman@tuxdriver.com,
        david.laight@aculab.com
Subject: Re: [PATCHv3 net-next 0/5] sctp: update from rfc7829
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016183209.GA4250@localhost.localdomain>
References: <cover.1571033544.git.lucien.xin@gmail.com>
        <20191016.142534.1360443052637911866.davem@davemloft.net>
        <20191016183209.GA4250@localhost.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 12:04:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 16 Oct 2019 15:32:09 -0300

> On Wed, Oct 16, 2019 at 02:25:34PM -0400, David Miller wrote:
>> From: Xin Long <lucien.xin@gmail.com>
>> Date: Mon, 14 Oct 2019 14:14:43 +0800
>> 
>> > SCTP-PF was implemented based on a Internet-Draft in 2012:
>> > 
>> >   https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
>> > 
>> > It's been updated quite a few by rfc7829 in 2016.
>> > 
>> > This patchset adds the following features:
>> 
>> Sorry but I'm tossing these until an knowledgable SCTP person can
>> look at them.
> 
> Hi Dave,
> 
> Maybe the email didn't get through but Neil actually already acked it,
> 2 days ago.
>   Message-ID: <20191014124249.GB11844@hmswarspite.think-freely.org>
> 
> I won't be able to review it :-(

All I saw was David Laight replying saying he thought the APIs weren't
implemented correctly.

I have to admit that I'm really going to proceed carefully with SCTP
API changes because there has been a lot of discussions in the past
involving backwards-incompatible things happening.

I'm not saying that is happening here, but my confidence in SCTP API
changes is very low.

I want this to sit for a while and Xin can respin and resubmit in a
day or two.
