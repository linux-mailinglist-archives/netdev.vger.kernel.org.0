Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8A04310D
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389032AbfFLUlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:41:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41662 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388336AbfFLUlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:41:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DC10153159AD;
        Wed, 12 Jun 2019 13:41:15 -0700 (PDT)
Date:   Wed, 12 Jun 2019 13:41:14 -0700 (PDT)
Message-Id: <20190612.134114.1226850504034942939.davem@davemloft.net>
To:     nhorman@tuxdriver.com
Cc:     marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        lucien.xin@gmail.com
Subject: Re: [PATCH v4 net] sctp: Free cookie before we memdup a new one
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612203230.GB23166@hmswarspite.think-freely.org>
References: <20190612003814.7219-1-nhorman@tuxdriver.com>
        <20190612180715.GC3500@localhost.localdomain>
        <20190612203230.GB23166@hmswarspite.think-freely.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 13:41:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 12 Jun 2019 16:32:30 -0400

> On Wed, Jun 12, 2019 at 03:07:15PM -0300, Marcelo Ricardo Leitner wrote:
>> On Tue, Jun 11, 2019 at 08:38:14PM -0400, Neil Horman wrote:
>> > Based on comments from Xin, even after fixes for our recent syzbot
>> > report of cookie memory leaks, its possible to get a resend of an INIT
>> > chunk which would lead to us leaking cookie memory.
>> > 
>> > To ensure that we don't leak cookie memory, free any previously
>> > allocated cookie first.
>> > 
>> > ---
>> 
>> This marker can't be here, as it causes git to loose everything below.
>> 
> thats intentional so that, when Dave commits it, the change notes arent carried
> into the changelog (I.e. the change notes are useful for email review, but not
> especially useful in the permanent commit history).

1) I like the changelog notes to be included

2) Your signoff etc. was in that area too so would have been lost as well
