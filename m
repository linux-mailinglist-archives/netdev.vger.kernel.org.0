Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E63325EF
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 03:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfFCBMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 21:12:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50620 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFCBMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 21:12:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF5E2134116BD;
        Sun,  2 Jun 2019 18:12:15 -0700 (PDT)
Date:   Sun, 02 Jun 2019 18:12:15 -0700 (PDT)
Message-Id: <20190602.181215.1729508834042553864.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: improve
 eth_platform_get_mac_address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <98026ebf-4772-1d8d-1c0c-b75969172c80@gmail.com>
References: <98026ebf-4772-1d8d-1c0c-b75969172c80@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Jun 2019 18:12:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 31 May 2019 19:14:44 +0200

> pci_device_to_OF_node(to_pci_dev(dev)) is the same as dev->of_node,
> so we can simplify the code. In addition add an empty line before
> the return statement.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
