Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18E0AB91A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393249AbfIFNRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:17:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59996 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392541AbfIFNRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:17:44 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B3597152F6952;
        Fri,  6 Sep 2019 06:17:41 -0700 (PDT)
Date:   Fri, 06 Sep 2019 15:17:39 +0200 (CEST)
Message-Id: <20190906.151739.1653688874182107118.davem@davemloft.net>
To:     radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, michal.simek@xilinx.com,
        anirudha.sarangi@xilinx.com, john.linn@xilinx.com,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        nicolas.ferre@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] MAINTAINERS: add myself as maintainer for
 xilinx axiethernet driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567688168-20607-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1567688168-20607-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 06:17:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Date: Thu,  5 Sep 2019 18:26:08 +0530

> I am maintaining xilinx axiethernet driver in xilinx tree and would like
> to maintain it in the mainline kernel as well. Hence adding myself as a
> maintainer. Also Anirudha and John has moved to new roles, so based on
> request removing them from the maintainer list.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Acked-by: John Linn <john.linn@xilinx.com>
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> ---
> I am resending this patch as earlier version didn't go through mailing
> list due to some config restriction on the external email addresses.
> Also adding Michal's acked-by tag.

Applied to 'net'.
