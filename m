Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E646A0EDF
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 03:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfH2BYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 21:24:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfH2BYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 21:24:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::642])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 62689153CBC26;
        Wed, 28 Aug 2019 18:24:18 -0700 (PDT)
Date:   Wed, 28 Aug 2019 18:24:17 -0700 (PDT)
Message-Id: <20190828.182417.1721891151436459386.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/4] mlxsw: Various updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828155437.9852-1-idosch@idosch.org>
References: <20190828155437.9852-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 18:24:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 28 Aug 2019 18:54:33 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Patch #1 from Amit removes 56G speed support. The reasons for this are
> detailed in the commit message.
> 
> Patch #2 from Shalom ensures that the hardware does not auto negotiate
> the number of used lanes. For example, if a four lane port supports 100G
> over both two and four lanes, it will not advertise the two lane link
> mode.
> 
> Patch #3 bumps the firmware version supported by the driver.
> 
> Patch #4 from Petr adds ethtool counters to help debug the internal PTP
> implementation in mlxsw. I copied Richard on this patch in case he has
> comments.

Series applied.
