Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA0C338246
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhCLA3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhCLA2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 19:28:50 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF02C061574;
        Thu, 11 Mar 2021 16:28:50 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id F3F154D0ECDFA;
        Thu, 11 Mar 2021 16:28:48 -0800 (PST)
Date:   Thu, 11 Mar 2021 16:28:45 -0800 (PST)
Message-Id: <20210311.162845.1107113962810628804.davem@davemloft.net>
To:     joel@jms.id.au
Cc:     dylan_hung@aspeedtech.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ratbert@faraday-tech.com,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org,
        BMC-SW@aspeedtech.com
Subject: Re: [PATCH 4/4] ftgmac100: Restart MAC HW once
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CACPK8XfMEy2o39v3CG4Zzj9H_kqSFBOddL3SC-_OryMqVXEjOw@mail.gmail.com>
References: <20201019085717.32413-5-dylan_hung@aspeedtech.com>
        <CACPK8Xc8NSBzN+LnZ=b5t7ODjLg9B6m2WDdR-C9SRWaDEXwOtQ@mail.gmail.com>
        <CACPK8XfMEy2o39v3CG4Zzj9H_kqSFBOddL3SC-_OryMqVXEjOw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 11 Mar 2021 16:28:49 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>
Date: Fri, 12 Mar 2021 00:26:43 +0000

> On Tue, 20 Oct 2020 at 04:14, Joel Stanley <joel@jms.id.au> wrote:
>>
>> On Mon, 19 Oct 2020 at 08:57, Dylan Hung <dylan_hung@aspeedtech.com> wrote:
>> >
>> > The interrupt handler may set the flag to reset the mac in the future,
>> > but that flag is not cleared once the reset has occured.
>> >
>> > Fixes: 10cbd6407609 ("ftgmac100: Rework NAPI & interrupts handling")
>> > Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
>> > Signed-off-by: Joel Stanley <joel@jms.id.au>
>>
>> Reviewed-by: Joel Stanley <joel@jms.id.au>
> 
> net maintainers, this one never made it into the tree. Do you need me
> to re-send it?

If it has been this long, definitely you need to resend.

