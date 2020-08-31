Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A3125813B
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 20:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgHaSlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 14:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgHaSlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 14:41:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18D1C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 11:41:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C83312856B70;
        Mon, 31 Aug 2020 11:24:25 -0700 (PDT)
Date:   Mon, 31 Aug 2020 11:41:11 -0700 (PDT)
Message-Id: <20200831.114111.792327686991920286.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     xiyou.wangcong@gmail.com, dev@openvswitch.org,
        netdev@vger.kernel.org, pshelar@ovn.org
Subject: Re: [PATCH net-next v2 1/3] net: openvswitch: improve coding style
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAMDZJNU47t1TuqWt+HLBcdiPhTyiYWJeG3y4xFTrnysKcLOALQ@mail.gmail.com>
References: <20200824073602.70812-2-xiangxia.m.yue@gmail.com>
        <CAOrHB_BaechPpGLPdTsFjcPHhzaKQ+PYePrnZdcSkJWm0oC+sA@mail.gmail.com>
        <CAMDZJNU47t1TuqWt+HLBcdiPhTyiYWJeG3y4xFTrnysKcLOALQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 11:24:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date: Mon, 31 Aug 2020 21:00:28 +0800

> On Thu, Aug 27, 2020 at 3:23 AM Pravin Shelar <pravin.ovn@gmail.com> wrote:
>>
>> On Mon, Aug 24, 2020 at 12:37 AM <xiangxia.m.yue@gmail.com> wrote:
>> >
>> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>> >
>> > Not change the logic, just improve coding style.
>> >
>> > Cc: Pravin B Shelar <pshelar@ovn.org>
>> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>
>> Acked-by: Pravin B Shelar <pshelar@ovn.org>
> Hi David
> This series patches were ACKed by Pravin. Will you have a plan to
> apply them to the net-next ? or I sent v4 with ACK tag.

In v3 of this series Stefano Brivio asked you to add some more curly brace
changes as feedback.  So you must address this feedback and post a new
version of the series.
