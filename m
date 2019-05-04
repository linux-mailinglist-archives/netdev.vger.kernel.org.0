Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D37713732
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 05:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfEDD6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 23:58:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55614 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfEDD6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 23:58:15 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9BEB514D771AD;
        Fri,  3 May 2019 20:58:12 -0700 (PDT)
Date:   Fri, 03 May 2019 23:58:07 -0400 (EDT)
Message-Id: <20190503.235807.1601334458333376984.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Pass interrupt number in
 platform data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430221050.19749-1-andrew@lunn.ch>
References: <20190430221050.19749-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 20:58:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed,  1 May 2019 00:10:50 +0200

> Allow an interrupt number to be passed in the platform data. The
> driver will then use it if not zero, otherwise it will poll for
> interrupts.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied.
