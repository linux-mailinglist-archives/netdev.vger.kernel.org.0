Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439BB1B13E8
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgDTSFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgDTSFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:05:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E275C061A0C;
        Mon, 20 Apr 2020 11:05:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32820127D24B0;
        Mon, 20 Apr 2020 11:05:41 -0700 (PDT)
Date:   Mon, 20 Apr 2020 11:05:40 -0700 (PDT)
Message-Id: <20200420.110540.223495493120390129.davem@davemloft.net>
To:     tangbin@cmss.chinamobile.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: systemport: Omit superfluous error message in
 bcm_sysport_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200418085105.12584-1-tangbin@cmss.chinamobile.com>
References: <20200418085105.12584-1-tangbin@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 11:05:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>
Date: Sat, 18 Apr 2020 16:51:06 +0800

> In the function bcm_sysport_probe(), when get irq failed, the function
> platform_get_irq() logs an error message, so remove redundant message
> here.
> 
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

Applied.
