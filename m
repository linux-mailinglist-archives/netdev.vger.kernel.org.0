Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15161838B5
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCLSaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:30:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33594 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgCLSaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:30:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0684E15741417;
        Thu, 12 Mar 2020 11:30:02 -0700 (PDT)
Date:   Thu, 12 Mar 2020 11:30:02 -0700 (PDT)
Message-Id: <20200312.113002.2094797356741004781.davem@davemloft.net>
To:     joe@perches.com
Cc:     linux-net-drivers@solarflare.com, ecree@solarflare.com,
        mhabets@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc: ethtool: Refactor to remove fallthrough comments
 in case blocks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <062df3c71913d94339aec60020db7594ba97b0a5.camel@perches.com>
References: <062df3c71913d94339aec60020db7594ba97b0a5.camel@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 11:30:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 10 Mar 2020 19:41:41 -0700

> Converting fallthrough comments to fallthrough; creates warnings
> in this code when compiled with gcc.
> 
> This code is overly complicated and reads rather better with a
> little refactoring and no fallthrough uses at all.
> 
> Remove the fallthrough comments and simplify the written source
> code while reducing the object code size.
> 
> Consolidate duplicated switch/case blocks for IPV4 and IPV6.
> 
> defconfig x86-64 with sfc:
> 
> $ size drivers/net/ethernet/sfc/ethtool.o*
>    text	   data	    bss	    dec	    hex	filename
>   10055	     12	      0	  10067	   2753	drivers/net/ethernet/sfc/ethtool.o.new
>   10135	     12	      0	  10147	   27a3	drivers/net/ethernet/sfc/ethtool.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to net-next.
