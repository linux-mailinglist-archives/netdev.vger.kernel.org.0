Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA832247B0
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgGRBZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGRBZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:25:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F94FC0619D2;
        Fri, 17 Jul 2020 18:25:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94C7911E45910;
        Fri, 17 Jul 2020 18:25:43 -0700 (PDT)
Date:   Fri, 17 Jul 2020 18:25:40 -0700 (PDT)
Message-Id: <20200717.182540.2222186339961093391.davem@davemloft.net>
To:     mstarovoitov@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ndanilov@marvell.com
Subject: Re: [PATCH net] net: atlantic: disable PTP on AQC111, AQC112
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717203949.9098-1-mstarovoitov@marvell.com>
References: <20200717203949.9098-1-mstarovoitov@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 18:25:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>
Date: Fri, 17 Jul 2020 23:39:49 +0300

> From: Nikita Danilov <ndanilov@marvell.com>
> 
> This patch disables PTP on AQC111 and AQC112 due to a known HW issue,
> which can cause datapath issues.
> 
> Ideally PTP block should have been disabled via PHY provisioning, but
> unfortunately many units have been shipped with enabled PTP block.
> Thus, we have to work around this in the driver.
> 
> Fixes: dbcd6806af420 ("net: aquantia: add support for Phy access")
> Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
> Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Applied and queued up for -stable, thank you.
