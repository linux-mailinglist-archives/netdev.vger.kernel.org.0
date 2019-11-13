Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9252FB917
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfKMTrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:47:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36852 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfKMTrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:47:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1637153EE9D3;
        Wed, 13 Nov 2019 11:47:19 -0800 (PST)
Date:   Wed, 13 Nov 2019 11:47:19 -0800 (PST)
Message-Id: <20191113.114719.1129176458430744862.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: pull-request: can 2019-11-13
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113095550.26527-1-mkl@pengutronix.de>
References: <20191113095550.26527-1-mkl@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 11:47:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Wed, 13 Nov 2019 10:55:41 +0100

> this is a pull request of 9 patches for net/master, hopefully for the v5.4
> release cycle.
> 
> All nine patches are by Oleksij Rempel and fix locking and use-after-free bugs
> in the j1939 stack found by the syzkaller syzbot.

Pulled, thanks Marc.
