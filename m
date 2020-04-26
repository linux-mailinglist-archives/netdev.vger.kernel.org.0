Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877911B8BB5
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgDZDmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgDZDl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:41:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE412C061A0C;
        Sat, 25 Apr 2020 20:41:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 736D5159FD9F4;
        Sat, 25 Apr 2020 20:41:59 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:41:58 -0700 (PDT)
Message-Id: <20200425.204158.1357076098544552662.davem@davemloft.net>
To:     yangyingliang@huawei.com
Cc:     richardcochran@gmail.com, vincent.cheng.xh@renesas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] ptp: clockmatrix: remove unnecessary
 comparison
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587732746-98057-1-git-send-email-yangyingliang@huawei.com>
References: <1587732746-98057-1-git-send-email-yangyingliang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:41:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>
Date: Fri, 24 Apr 2020 20:52:26 +0800

> The type of loaddr is u8 which is always '<=' 0xff, so the
> loaddr <= 0xff is always true, we can remove this comparison.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Applied.
