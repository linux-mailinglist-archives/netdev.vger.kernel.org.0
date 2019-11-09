Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699A8F6165
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfKIU3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:29:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfKIU3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:29:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6A6B1474ECF1;
        Sat,  9 Nov 2019 12:29:35 -0800 (PST)
Date:   Sat, 09 Nov 2019 12:28:18 -0800 (PST)
Message-Id: <20191109.122818.2192239314738108074.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: request: merge net/master into net-next/master,request: merge
 net/master into net-next/master
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e9b0dcdb-15c3-6f4d-36db-f62c055c15d0@pengutronix.de>
References: <20191105163215.30194-1-mkl@pengutronix.de>
        <20191105163215.30194-1-mkl@pengutronix.de>
        <e9b0dcdb-15c3-6f4d-36db-f62c055c15d0@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 09 Nov 2019 12:29:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Thu, 7 Nov 2019 09:45:08 +0100

> I've some patches for net-next/master rely on some CAN related changes
> in net/master. Can you please merge net/master into net-next/master to
> avoid merge conflicts.

This has now been done.
