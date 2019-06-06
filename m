Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A4637AF7
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfFFRYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:24:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54526 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbfFFRYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:24:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C23E914DD36C7;
        Thu,  6 Jun 2019 10:24:05 -0700 (PDT)
Date:   Thu, 06 Jun 2019 10:24:03 -0700 (PDT)
Message-Id: <20190606.102403.939734306118684379.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: silence sparse warning in
 rtl8169_start_xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <be510df0-ef66-ee10-eb04-c919b14b2794@gmail.com>
References: <be510df0-ef66-ee10-eb04-c919b14b2794@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 10:24:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 6 Jun 2019 07:49:17 +0200

> The opts[] array is of type u32. Therefore remove the wrong
> cpu_to_le32(). The opts[] array members are converted to little endian
> later when being assigned to the respective descriptor fields.
> 
> This is not a new issue, it just popped up due to r8169.c having
> been renamed and more thoroughly checked. Due to the renaming
> this patch applies to net-next only.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
