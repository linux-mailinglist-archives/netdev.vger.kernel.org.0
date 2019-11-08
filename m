Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38B2F3E8B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 04:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbfKHDwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 22:52:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfKHDwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 22:52:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 395CB14EFEF30;
        Thu,  7 Nov 2019 19:51:59 -0800 (PST)
Date:   Thu, 07 Nov 2019 19:51:58 -0800 (PST)
Message-Id: <20191107.195158.1360941452481445706.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 00/12] mlxsw: Add layer 3 devlink-trap support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107164220.20526-1-idosch@idosch.org>
References: <20191107164220.20526-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 19:51:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu,  7 Nov 2019 18:42:08 +0200

> This patch set from Amit adds support in mlxsw for layer 3 traps that
> can report drops and exceptions via devlink-trap.
 ...

Series applied, thank you.
