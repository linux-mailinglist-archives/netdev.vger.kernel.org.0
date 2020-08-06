Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1816923D4C5
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 02:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgHFAmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 20:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgHFAmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 20:42:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A411C061574;
        Wed,  5 Aug 2020 17:42:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8C58156879F2;
        Wed,  5 Aug 2020 17:25:32 -0700 (PDT)
Date:   Wed, 05 Aug 2020 17:42:17 -0700 (PDT)
Message-Id: <20200805.174217.627457778756782771.davem@davemloft.net>
To:     min.li.xe@renesas.com
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ptp: ptp_idt82p33: update to support adjphase
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596568334-17070-1-git-send-email-min.li.xe@renesas.com>
References: <1596568334-17070-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Aug 2020 17:25:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <min.li.xe@renesas.com>
Date: Tue, 4 Aug 2020 15:12:14 -0400

> This update includes adjphase support, more debug logs, firmware name
> parameter, correct PTP_CLK_REQ_PEROUT support and use do_aux_work to
> do delay work.

Way too many changes in one patch, and some of them are not appropriate.

> +static char *firmware;
> +module_param(firmware, charp, 0);

We have various kernel interfaces for handling firmware loading and
names.  Please use them instead of a custom module paramter.  Module
paramters are significantly undesirable and addition of such will be
rejected by default.

Thank you.
