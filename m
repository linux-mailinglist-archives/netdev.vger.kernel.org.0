Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D7316097B
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 05:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgBQELZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 23:11:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgBQELZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 23:11:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C681915882C66;
        Sun, 16 Feb 2020 20:11:24 -0800 (PST)
Date:   Sun, 16 Feb 2020 20:11:24 -0800 (PST)
Message-Id: <20200216.201124.1598095840697181424.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/9] ionic: Add support for Event Queues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200216231158.5678-1-snelson@pensando.io>
References: <20200216231158.5678-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 20:11:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Sun, 16 Feb 2020 15:11:49 -0800

> This patchset adds a new EventQueue feature that can be used
> for multiplexing the interrupts if we find that we can't get
> enough from the system to support our configuration.  We can
> create a small number of EQs that use interrupts, and have
> the TxRx queue pairs subscribe to event messages that come
> through the EQs, selecting an EQ with (TxIndex % numEqs).

How is a user going to be able to figure out how to direct
traffic to specific cpus using multiqueue settings if you're
going to have the mapping go through this custom muxing
afterwards?
