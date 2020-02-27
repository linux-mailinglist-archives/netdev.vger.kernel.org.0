Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2E1170DAD
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 02:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgB0BMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 20:12:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35740 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbgB0BMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 20:12:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A50315AE21CE;
        Wed, 26 Feb 2020 17:11:59 -0800 (PST)
Date:   Wed, 26 Feb 2020 17:11:59 -0800 (PST)
Message-Id: <20200226.171159.1683991665921037285.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, vladbu@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net] sched: act: count in the size of action flags
 bitfield
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225125412.9603-1-jiri@resnulli.us>
References: <20200225125412.9603-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 17:11:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Tue, 25 Feb 2020 13:54:12 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> The put of the flags was added by the commit referenced in fixes tag,
> however the size of the message was not extended accordingly.
> 
> Fix this by adding size of the flags bitfield to the message size.
> 
> Fixes: e38226786022 ("net: sched: update action implementations to support flags")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for v5.5 -stable, thanks Jiri.

This is a common mistake which is made when adding new attributes, so it would
be nice if there were a programmatic way to make sure these adjustments never
get forgotten.
