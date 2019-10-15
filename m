Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8022D7D46
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730840AbfJORTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:19:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37188 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730579AbfJORTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:19:06 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8307915043D41;
        Tue, 15 Oct 2019 10:19:05 -0700 (PDT)
Date:   Tue, 15 Oct 2019 13:19:04 -0400 (EDT)
Message-Id: <20191015.131904.1421707375251725310.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jakub.kicinski@netronome.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Scatter/gather SPI for SJA1105 DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191011223115.27197-1-olteanv@gmail.com>
References: <20191011223115.27197-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 10:19:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 12 Oct 2019 01:31:13 +0300

> This is a small series that reduces the stack memory usage for the
> sja1105 driver.

Series applied, thanks.
