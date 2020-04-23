Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D8B1B64D1
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgDWTvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgDWTvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:51:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60EDC09B042;
        Thu, 23 Apr 2020 12:51:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5858712783B16;
        Thu, 23 Apr 2020 12:51:23 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:51:22 -0700 (PDT)
Message-Id: <20200423.125122.52192814388655212.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     richardcochran@gmail.com, lokeshvutla@ti.com, tony@atomide.com,
        netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH net-next v5 00/10] net: ethernet: ti: cpts: add irq and
 HW_TS_PUSH events
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200423142022.10538-1-grygorii.strashko@ti.com>
References: <20200423142022.10538-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 12:51:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Thu, 23 Apr 2020 17:20:12 +0300

> This is re-spin of patches to add CPSW IRQ and HW_TS_PUSH events support I've
> sent long time ago [1]. In this series, I've tried to restructure and split changes,
> and also add few additional optimizations comparing to initial RFC submission [1].
 ...
> Changes in v5:
>  - fixed build issue
 ...

Series applied, thanks.
