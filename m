Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78DD510769F
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKVRmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:42:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38158 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVRmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:42:52 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8B1E1527D803;
        Fri, 22 Nov 2019 09:42:51 -0800 (PST)
Date:   Fri, 22 Nov 2019 09:42:51 -0800 (PST)
Message-Id: <20191122.094251.536759158186199937.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: pull-request: can 2019-11-22
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191122145251.9775-1-mkl@pengutronix.de>
References: <20191122145251.9775-1-mkl@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 09:42:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Fri, 22 Nov 2019 15:52:49 +0100

> this is a pull request of 2 patches for net/master, if possible for the
> current release cycle. Otherwise these patches should hit v5.4 via the
> stable tree.
> 
> Both patches of this pull request target the m_can driver. Pankaj Sharma
> fixes the fallout in the m_can_platform part, which appeared with the
> introduction of the m_can platform framework.

Pulled, thanks Marc.
