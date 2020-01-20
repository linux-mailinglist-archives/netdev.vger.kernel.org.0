Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540771431CF
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 19:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgATSrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 13:47:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59282 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgATSrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 13:47:35 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39216151B805D;
        Mon, 20 Jan 2020 10:47:33 -0800 (PST)
Date:   Mon, 20 Jan 2020 19:47:29 +0100 (CET)
Message-Id: <20200120.194729.916480697896712015.davem@davemloft.net>
To:     sashal@kernel.org
Cc:     idosch@idosch.org, hegtvedt@cisco.com, netdev@vger.kernel.org,
        stable@vger.kernel.org, edumazet@google.com,
        gregkh@linuxfoundation.org
Subject: Re: Regression in macvlan driver in stable release 4.4.209
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200120183515.GA1706@sasha-vm>
References: <01accb3f-bb52-906f-d164-c49f2dc170bc@cisco.com>
        <20200120095714.GA3421303@splinter>
        <20200120183515.GA1706@sasha-vm>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 10:47:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Levin <sashal@kernel.org>
Date: Mon, 20 Jan 2020 13:35:15 -0500

> On Mon, Jan 20, 2020 at 11:57:14AM +0200, Ido Schimmel wrote:
>>On Mon, Jan 20, 2020 at 09:17:35AM +0000, Hans-Christian Egtvedt
>>(hegtvedt) wrote:
>>> Hello,
>>>
>>> I am seeing a regression in the macvlan kernel driver after Linux
>>> stable
>>> release 4.4.209, bisecting identifies commit
>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.4.y&id=8d28d7e88851b1081b05dc269a27df1c8a903f3e
>>
>>Noticed it too last week (on net-next), but Eric already fixed it:
>>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1712b2fff8c682d145c7889d2290696647d82dab
>>
>>I assume the patch will find its way to 4.4.y soon now that it is in
>>mainline.
> 
> David, any objection if I grab this patch directly to fix the
> regression
> in the next stable kernel release?

Sure, no problem.
