Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DD31784E1
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 22:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732599AbgCCV3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 16:29:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36338 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730958AbgCCV3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 16:29:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02777158C1656;
        Tue,  3 Mar 2020 13:29:22 -0800 (PST)
Date:   Tue, 03 Mar 2020 13:29:17 -0800 (PST)
Message-Id: <20200303.132917.1665670137065821039.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 00/16] net: add missing netlink policies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 13:29:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon,  2 Mar 2020 21:05:10 -0800

> Recent one-off fixes motivated me to do some grepping for
> more missing netlink attribute policies. I didn't manage
> to even produce a KASAN splat with these, but it should
> be possible with sufficient luck. All the missing policies
> are pretty trivial (NLA_Uxx).
> 
> I've only tested the devlink patches, the rest compiles.

Looks good to me, and I'll queue these up for -stable as well.

Thanks.
