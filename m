Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755BB5C6DF
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 03:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfGBB7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 21:59:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53752 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbfGBB7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 21:59:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B9A614DE8879;
        Mon,  1 Jul 2019 18:59:50 -0700 (PDT)
Date:   Mon, 01 Jul 2019 18:59:49 -0700 (PDT)
Message-Id: <20190701.185949.574028305206352997.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        jiri@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next v2 00/16] mlxsw: PTP timestamping support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190630060500.7882-1-idosch@idosch.org>
References: <20190630060500.7882-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 18:59:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 30 Jun 2019 09:04:44 +0300

> This is the second patchset adding PTP support in mlxsw. Next patchset
> will add PTP shapers which are required to maintain accuracy under rates
> lower than 40Gb/s, while subsequent patchsets will add tracepoints and
> selftests.
 ...

Series applied, thank you.
