Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574E51946C1
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgCZSqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:46:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbgCZSqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:46:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2026615CBBAC9;
        Thu, 26 Mar 2020 11:46:14 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:46:13 -0700 (PDT)
Message-Id: <20200326.114613.217642686345799497.davem@davemloft.net>
To:     vulab@iscas.ac.cn
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qlcnic: Fix bad kzalloc null test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326101429.18876-1-vulab@iscas.ac.cn>
References: <20200326101429.18876-1-vulab@iscas.ac.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 11:46:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>
Date: Thu, 26 Mar 2020 18:14:29 +0800

> In qlcnic_83xx_get_reset_instruction_template, the variable
> of null test is bad, so correct it.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Applied, thanks.
