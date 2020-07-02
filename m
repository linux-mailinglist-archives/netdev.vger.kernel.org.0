Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2D5212F0B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgGBVr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBVr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 17:47:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3B4C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 14:47:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2FD881210C0A1;
        Thu,  2 Jul 2020 14:47:57 -0700 (PDT)
Date:   Thu, 02 Jul 2020 14:47:56 -0700 (PDT)
Message-Id: <20200702.144756.1230939399441159039.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     ecree@solarflare.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/16] sfc: prerequisites for EF100 driver,
 part 3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702140648.10105fd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
        <20200702140648.10105fd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jul 2020 14:47:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 2 Jul 2020 14:06:48 -0700

> On Thu, 2 Jul 2020 17:25:17 +0100 Edward Cree wrote:
>> Changes in v2:
>> * Patch #1: use efx_mcdi_set_mtu() directly, instead of as a fallback,
>>   in the mtu_only case (Jakub)
>> * Patch #3: fix symbol collision in non-modular builds by renaming
>>   interrupt_mode to efx_interrupt_mode (kernel test robot)
>> * Patch #6: check for failure of netif_set_real_num_[tr]x_queues (Jakub)
>> * Patch #12: cleaner solution for ethtool drvinfo (Jakub, David)
> 
> Thanks, the last two patches with functions with no callers slightly
> worrying, but okay:
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks everyone.
