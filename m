Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8EE37BFC
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbfFFSQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:16:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55290 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfFFSQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:16:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F35014DB7D96;
        Thu,  6 Jun 2019 11:16:03 -0700 (PDT)
Date:   Thu, 06 Jun 2019 11:16:02 -0700 (PDT)
Message-Id: <20190606.111602.618176540061440440.davem@davemloft.net>
To:     festevam@gmail.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        otavio@ossystems.com.br
Subject: Re: [PATCH net-next] net: fec: Do not use netdev messages too early
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606124033.14264-1-festevam@gmail.com>
References: <20190606124033.14264-1-festevam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 11:16:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>
Date: Thu,  6 Jun 2019 09:40:33 -0300

> When a valid MAC address is not found the current messages
> are shown:
> 
> fec 2188000.ethernet (unnamed net_device) (uninitialized): Invalid MAC address: 00:00:00:00:00:00
> fec 2188000.ethernet (unnamed net_device) (uninitialized): Using random MAC address: aa:9f:25:eb:7e:aa
> 
> Since the network device has not been registered at this point, it is better
> to use dev_err()/dev_info() instead, which will provide cleaner log
> messages like these:
> 
> fec 2188000.ethernet: Invalid MAC address: 00:00:00:00:00:00
> fec 2188000.ethernet: Using random MAC address: aa:9f:25:eb:7e:aa
> 
> Tested on a imx6dl-pico-pi board.
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Applied, thanks.
