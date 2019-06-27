Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C6658927
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfF0RqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:46:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57244 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfF0RqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:46:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7876E14DDA3FC;
        Thu, 27 Jun 2019 10:46:08 -0700 (PDT)
Date:   Thu, 27 Jun 2019 10:46:07 -0700 (PDT)
Message-Id: <20190627.104607.148681620932952706.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        jiri@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/16] mlxsw: PTP timestamping support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627173525.GA16859@splinter>
References: <20190627135259.7292-1-idosch@idosch.org>
        <20190627165134.zg7rdph2ct377bel@localhost>
        <20190627173525.GA16859@splinter>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 10:46:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 27 Jun 2019 20:35:25 +0300

> On Thu, Jun 27, 2019 at 09:51:34AM -0700, Richard Cochran wrote:
>> On Thu, Jun 27, 2019 at 04:52:43PM +0300, Ido Schimmel wrote:
>> > From: Ido Schimmel <idosch@mellanox.com>
>> > 
>> > This is the second patchset adding PTP support in mlxsw. Next patchset
>> > will add PTP shapers which are required to maintain accuracy under rates
>> > lower than 40Gb/s, while subsequent patchsets will add tracepoints and
>> > selftests.
>> 
>> Please add the PTP maintainer onto CC for PTP patch submissions.
> 
> No problem. To be clear, I didn't Cc you since this is all internal to
> mlxsw.

That's not the issue.

As the PTP maintainer he wants to see if your driver is using the PTP
interfaces properly and providing PTP information as intended by the
various APIs.
