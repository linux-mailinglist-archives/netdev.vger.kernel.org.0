Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8190519048A
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgCXEih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:38:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56302 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgCXEih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:38:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 666091577F7EE;
        Mon, 23 Mar 2020 21:38:37 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:38:36 -0700 (PDT)
Message-Id: <20200323.213836.1683295256224280916.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] r8169: improvements for scheduled task
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <984b0d19-07f4-fa9c-2ac8-4d7986ca61ee@gmail.com>
References: <984b0d19-07f4-fa9c-2ac8-4d7986ca61ee@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:38:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 22 Mar 2020 19:01:31 +0100

> This series includes some improvements for handling of scheduled tasks.

Series applied.
