Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14F0244DB
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 02:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfEUABL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 20:01:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59630 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfEUABL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 20:01:11 -0400
Received: from localhost (50-78-161-185-static.hfc.comcastbusiness.net [50.78.161.185])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E60EE128FF110;
        Mon, 20 May 2019 17:01:10 -0700 (PDT)
Date:   Mon, 20 May 2019 20:01:10 -0400 (EDT)
Message-Id: <20190520.200110.790291057530054027.davem@davemloft.net>
To:     b.spranger@linutronix.de
Cc:     netdev@vger.kernel.org
Subject: Re: [[PATCH net-next] 0/2] Convert mdio wait function to use
 readx_poll_timeout()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190519175937.3955-1-b.spranger@linutronix.de>
References: <20190519175937.3955-1-b.spranger@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 17:01:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benedikt Spranger <b.spranger@linutronix.de>
Date: Sun, 19 May 2019 19:59:35 +0200

> On loaded systems with a preemptible kernel both functions
> axienet_mdio_wait_until_ready() and xemaclite_mdio_wait() may report a
> false positive error return.
> Convert both functions to use readx_poll_timeout() to handle the
> situation in a safe manner.

Series applied, thank you.
