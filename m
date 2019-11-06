Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D97F0BD1
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 02:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbfKFB6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 20:58:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41912 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFB6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 20:58:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06D8C150FEF57;
        Tue,  5 Nov 2019 17:58:19 -0800 (PST)
Date:   Tue, 05 Nov 2019 17:58:18 -0800 (PST)
Message-Id: <20191105.175818.826509723756288899.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     idosch@idosch.org, netdev@vger.kernel.org, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105095448.1fbc25a5@cakuba.netronome.com>
References: <20191104153342.36891db7@cakuba.netronome.com>
        <20191105074650.GA14631@splinter>
        <20191105095448.1fbc25a5@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 17:58:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 5 Nov 2019 09:54:48 -0800

> Bottom line is I don't like when data from FW is just blindly passed
> to user space. Printing to the logs is perhaps the smallest of this
> sort of infractions but nonetheless if there is no precedent for doing
> this today I'd consider not opening this box.

I agree with Jakub and we should set this kind of precedence.
