Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FFF4AA7FC
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 10:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbiBEJwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 04:52:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54884 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237213AbiBEJwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 04:52:00 -0500
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 256B2841AF62;
        Sat,  5 Feb 2022 01:51:56 -0800 (PST)
Date:   Sat, 05 Feb 2022 09:51:51 +0000 (GMT)
Message-Id: <20220205.095151.756271782683510368.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        alexandr.lobakin@intel.com, edumazet@google.com,
        alexander.duyck@gmail.com
Subject: Re: [PATCH net-next 0/2] gro: a couple of minor optimization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <be23f15d43f7af165c7d2121071b09be73740899.camel@redhat.com>
References: <cover.1643972527.git.pabeni@redhat.com>
        <be23f15d43f7af165c7d2121071b09be73740899.camel@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sat, 05 Feb 2022 01:51:58 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 04 Feb 2022 12:34:03 +0100

> On Fri, 2022-02-04 at 12:28 +0100, Paolo Abeni wrote:
>> This series collects a couple of small optimizations for the GRO engine,
>> reducing slightly the number of cycles for dev_gro_receive().
>> The delta is within noise range in tput tests, but with big TCP coming
>> every cycle saved from the GRO engine will count - I hope ;)
>> 
>> v1 -> v2:
>>  - a few cleanup suggested from Alexander(s)
>>  - moved away the more controversial 3rd patch
>> 
>> Paolo Abeni (2):
>>   net: gro: avoid re-computing truesize twice on recycle
>>   net: gro: minor optimization for dev_gro_receive()
>> 
>>  include/net/gro.h | 52 +++++++++++++++++++++++++----------------------
>>  net/core/gro.c    | 16 ++++-----------
>>  2 files changed, 32 insertions(+), 36 deletions(-)
> 
> This is really a v2. Please let me know if you prefer a formal repost.

Not necessary.

Thank you.
