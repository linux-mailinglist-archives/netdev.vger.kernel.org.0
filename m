Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92DE3A4A1C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhFKU1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhFKU1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:27:18 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CF1C061574;
        Fri, 11 Jun 2021 13:25:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C40625064F1B5;
        Fri, 11 Jun 2021 13:25:17 -0700 (PDT)
Date:   Fri, 11 Jun 2021 13:25:14 -0700 (PDT)
Message-Id: <20210611.132514.1451796354248475314.davem@davemloft.net>
To:     qiangqing.zhang@nxp.com
Cc:     kuba@kernel.org, frieder.schrempf@kontron.de, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
References: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 11 Jun 2021 13:25:18 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>
Date: Fri, 11 Jun 2021 17:50:03 +0800

> This patch set intends to fix TX bandwidth fluctuations, any feedback would be appreciated.
> 
> ---
> ChangeLogs:
> 	V1: remove RFC tag, RFC discussions please turn to below:
> 	    https://lore.kernel.org/lkml/YK0Ce5YxR2WYbrAo@lunn.ch/T/
> 	V2: change functions to be static in this patch set. And add the
> 	t-b tag.

Please fix these warnings in patch #2:

https://patchwork.hopto.org/static/nipa/498729/12315211/build_allmodconfig_warn/summary

Thank you.
