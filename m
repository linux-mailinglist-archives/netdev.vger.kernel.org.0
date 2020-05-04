Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E7B1C45AB
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbgEDSUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729958AbgEDSUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:20:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE7DC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:20:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A37011F5F61A;
        Mon,  4 May 2020 11:20:12 -0700 (PDT)
Date:   Mon, 04 May 2020 11:20:11 -0700 (PDT)
Message-Id: <20200504.112011.1261931135036003399.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: add helper eth_hw_addr_crc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <329df165-a6a3-3c3b-cbb3-ea77ce2ea672@gmail.com>
References: <329df165-a6a3-3c3b-cbb3-ea77ce2ea672@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 11:20:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 4 May 2020 19:25:58 +0200

> Several drivers use the same code as basis for filter hashes. Therefore
> let's factor it out to a helper. This way drivers don't have to access
> struct netdev_hw_addr internals.
> 
> First user is r8169.

Series applied.
