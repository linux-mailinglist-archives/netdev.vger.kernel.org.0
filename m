Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85767180BFA
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCJXCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:02:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43854 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgCJXCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:02:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2EC8914CCCAD5;
        Tue, 10 Mar 2020 16:02:02 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:02:01 -0700 (PDT)
Message-Id: <20200310.160201.2246480794930648188.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, mstarovoitov@marvell.com,
        sd@queasysnail.net, antoine.tenart@bootlin.com
Subject: Re: [PATCH net 0/2] MACSec bugfixes related to MAC address change
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310152225.2338-1-irusskikh@marvell.com>
References: <20200310152225.2338-1-irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 16:02:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Tue, 10 Mar 2020 18:22:23 +0300

> We found out that there's an issue in MACSec code when the MAC address
> is changed.
> Both s/w and offloaded implementations don't update SCI when the MAC
> address changes at the moment, but they should do so, because SCI contains
> MAC in its first 6 octets.

Series applied and patch #1 queued up for -stable.
