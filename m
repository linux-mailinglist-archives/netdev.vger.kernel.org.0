Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB6CFC30B
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfKNJvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:51:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45072 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfKNJvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:51:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C55A61420EA99;
        Thu, 14 Nov 2019 01:51:35 -0800 (PST)
Date:   Thu, 14 Nov 2019 01:51:35 -0800 (PST)
Message-Id: <20191114.015135.640544614517916740.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: pull-request: can 2019-11-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114094548.4867-1-mkl@pengutronix.de>
References: <20191114094548.4867-1-mkl@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 01:51:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Thu, 14 Nov 2019 10:45:47 +0100

> here another pull request for net/master consisting of one patch (including my S-o-b).
> 
> Jouni Hogander's patch fixes a memory leak found by the syzbot in the slcan
> driver's error path.

Pulled, thanks Marc.
