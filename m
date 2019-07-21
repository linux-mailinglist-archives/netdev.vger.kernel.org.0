Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF0F6F4C2
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 20:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfGUSqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 14:46:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33722 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfGUSqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 14:46:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1413115259C70;
        Sun, 21 Jul 2019 11:46:45 -0700 (PDT)
Date:   Sun, 21 Jul 2019 11:46:44 -0700 (PDT)
Message-Id: <20190721.114644.1830499425455144315.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        tanhuazhong@huawei.com, lipeng321@huawei.com,
        shenjian15@huawei.com, liuzhongzhu@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: hns3: typo in the name of a constant
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190721130831.16330-1-christophe.jaillet@wanadoo.fr>
References: <20190721130831.16330-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 11:46:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 21 Jul 2019 15:08:31 +0200

> All constant in 'enum HCLGE_MBX_OPCODE' start with HCLGE, except
> 'HLCGE_MBX_PUSH_VLAN_INFO' (C and L switched)
> 
> s/HLC/HCL/
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
