Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4F71C7C48
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgEFVUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729543AbgEFVUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:20:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F33C061A0F;
        Wed,  6 May 2020 14:20:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7BA8123229ED;
        Wed,  6 May 2020 14:20:11 -0700 (PDT)
Date:   Wed, 06 May 2020 14:20:11 -0700 (PDT)
Message-Id: <20200506.142011.1280227366362981007.davem@davemloft.net>
To:     chentao107@huawei.com
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: enetc: Make some symbols static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506112217.161534-1-chentao107@huawei.com>
References: <20200506112217.161534-1-chentao107@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 14:20:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ChenTao <chentao107@huawei.com>
Date: Wed, 6 May 2020 19:22:17 +0800

> Fix the following warning:
> 
> drivers/net/ethernet/freescale/enetc/enetc_qos.c:427:20: warning:
> symbol 'enetc_act_fwd' was not declared. Should it be static?
> drivers/net/ethernet/freescale/enetc/enetc_qos.c:966:20: warning:
> symbol 'enetc_check_flow_actions' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: ChenTao <chentao107@huawei.com>

Applied.
