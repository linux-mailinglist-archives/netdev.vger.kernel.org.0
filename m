Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E89E2695FC
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgINUDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgINUDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:03:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B499C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 13:03:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC836125F6C52;
        Mon, 14 Sep 2020 12:46:25 -0700 (PDT)
Date:   Mon, 14 Sep 2020 13:03:11 -0700 (PDT)
Message-Id: <20200914.130311.503773497742738350.davem@davemloft.net>
To:     allen.lkml@gmail.com
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, apais@linux.microsoft.com
Subject: Re: [net-next v3 00/20] ethernet: convert tasklets to use new
 tasklet_setup API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 12:46:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>
Date: Mon, 14 Sep 2020 12:59:19 +0530

> From: Allen Pais <apais@linux.microsoft.com>
> 
> Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
> introduced a new tasklet initialization API. This series converts
> all the crypto modules to use the new tasklet_setup() API
> 
> This series is based on v5.9-rc5
> 
> v3:
>   fix subject prefix
>   use backpointer instead of fragile priv to netdev.
> 
> v2:
>   fix kdoc reported by Jakub Kicinski.

Series applied to net-next, thank you.
