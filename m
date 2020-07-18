Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7542247B5
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgGRB0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGRB0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:26:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6EEC0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 18:26:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A31AF11E45910;
        Fri, 17 Jul 2020 18:26:32 -0700 (PDT)
Date:   Fri, 17 Jul 2020 18:26:32 -0700 (PDT)
Message-Id: <20200717.182632.384224926082494030.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next] net: bnxt: don't complain if TC flower can't
 be supported
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717205958.163031-1-kuba@kernel.org>
References: <20200717205958.163031-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 18:26:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 17 Jul 2020 13:59:58 -0700

> The fact that NETIF_F_HW_TC is not set should be a sufficient
> indication to the user that TC offloads are not supported.
> No need to bother users of older firmware versions with
> pointless warnings on every boot.
> 
> Also, since the support is optional, bnxt_init_tc() should not
> return an error in case FW is old, similarly to how error
> is not returned when CONFIG_BNXT_FLOWER_OFFLOAD is not set.
> 
> With that we can add an error message to the caller, to warn
> about actual unexpected failures.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied, thank you.
