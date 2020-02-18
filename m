Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6325163324
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgBRUdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:33:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRUdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:33:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2906C12357E8E;
        Tue, 18 Feb 2020 12:33:49 -0800 (PST)
Date:   Tue, 18 Feb 2020 12:33:48 -0800 (PST)
Message-Id: <20200218.123348.1586092320049853407.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/9] ionic: Add support for Event Queues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e739ddaf-e04b-302e-9ca2-1700385bc379@pensando.io>
References: <4386aa68-d8c5-d619-4d38-cb3f4d441f56@pensando.io>
        <20200217.140344.810813375227195875.davem@davemloft.net>
        <e739ddaf-e04b-302e-9ca2-1700385bc379@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2020 12:33:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Tue, 18 Feb 2020 08:16:43 -0800

> and makes additional queues available for macvlan offload use
 ...
> We don't have support for the macvlan offload in this upstream driver
> yet, but this patchset allows us to play nicely with that FW
> configuration.

Translation: this entire patch set is useless upstream

Make your driver consistent and add support for things that
actually are usable.

I'm not applying this, sorry.
