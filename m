Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E800B23B23F
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgHDBXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDBXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:23:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA717C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 18:23:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F062B1278B065;
        Mon,  3 Aug 2020 18:06:26 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:23:11 -0700 (PDT)
Message-Id: <20200803.182311.117610323039948835.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     ecree@solarflare.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/11] sfc: driver for EF100 family NICs,
 part 2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803152657.43060397@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
        <20200803152657.43060397@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 18:06:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 3 Aug 2020 15:26:57 -0700

> On Mon, 3 Aug 2020 21:30:32 +0100 Edward Cree wrote:
>> This series implements the data path and various other functionality
>>  for Xilinx/Solarflare EF100 NICs.
>> 
>> Changed from v2:
>>  * Improved error handling of design params (patch #3)
>>  * Removed 'inline' from .c file in patch #4
>>  * Don't report common stats to ethtool -S (patch #8)
>> 
>> Changed from v1:
>>  * Fixed build errors on CONFIG_RFS_ACCEL=n (patch #5) and 32-bit
>>    (patch #8)
>>  * Dropped patch #10 (ethtool ops) as it's buggy and will need a
>>    bigger rework to fix.
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks everyone.
