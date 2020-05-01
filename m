Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F831C0CF5
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 06:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgEAD7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbgEAD7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:59:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4D0C035494;
        Thu, 30 Apr 2020 20:59:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C070C127806C4;
        Thu, 30 Apr 2020 20:59:50 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:59:50 -0700 (PDT)
Message-Id: <20200430.205950.897709865527369744.davem@davemloft.net>
To:     zou_wei@huawei.com
Cc:     aviad.krawczyk@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] hinic: Use kmemdup instead of kzalloc and memcpy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588131328-49470-1-git-send-email-zou_wei@huawei.com>
References: <1588131328-49470-1-git-send-email-zou_wei@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:59:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>
Date: Wed, 29 Apr 2020 11:35:28 +0800

> Fixes coccicheck warnings:
> 
>  drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c:452:17-24: WARNING opportunity for kmemdup
>  drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c:458:23-30: WARNING opportunity for kmemdup
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>

Applied.
