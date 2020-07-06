Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48B8215F44
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgGFTWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgGFTWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:22:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE573C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 12:22:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C77112755EE7;
        Mon,  6 Jul 2020 12:22:38 -0700 (PDT)
Date:   Mon, 06 Jul 2020 12:22:37 -0700 (PDT)
Message-Id: <20200706.122237.2045017530938753254.davem@davemloft.net>
To:     andre.edich@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net v2 0/2] smsc95xx: fix smsc95xx_bind
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706083935.19040-1-andre.edich@microchip.com>
References: <20200706083935.19040-1-andre.edich@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 12:22:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Edich <andre.edich@microchip.com>
Date: Mon, 6 Jul 2020 10:39:33 +0200

> The patchset fixes two problems in the function smsc95xx_bind:
>  - return of false success
>  - memory leak
> 
> Changes in v2:
> - added "Fixes" tags to both patches

Series applied, thank you.
