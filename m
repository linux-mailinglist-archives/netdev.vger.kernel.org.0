Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F86F248F09
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgHRTtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgHRTtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:49:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49A3C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:49:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D2864127A25BD;
        Tue, 18 Aug 2020 12:32:45 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:49:30 -0700 (PDT)
Message-Id: <20200818.124930.760832395507896518.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/4] sfc: more EF100 fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
References: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 12:32:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Tue, 18 Aug 2020 13:41:49 +0100

> Fix up some bugs in the initial EF100 submission, and re-fix
>  the hash_valid fix which was incomplete.
> 
> The reset bugs are currently hard to trigger; they were found
>  with an in-progress patch adding ethtool support, whereby
>  ethtool --reset reliably reproduces them.

Series applied.

Thanks for the review Jesse.
