Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69DF6155740
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 12:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgBGL7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 06:59:04 -0500
Received: from mx.socionext.com ([202.248.49.38]:10065 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgBGL7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 06:59:04 -0500
Received: from unknown (HELO iyokan-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 07 Feb 2020 20:59:02 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by iyokan-ex.css.socionext.com (Postfix) with ESMTP id 8808D603AB;
        Fri,  7 Feb 2020 20:59:02 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Fri, 7 Feb 2020 20:59:02 +0900
Received: from yuzu.css.socionext.com (yuzu [172.31.8.45])
        by kinkan.css.socionext.com (Postfix) with ESMTP id 240201A03A2;
        Fri,  7 Feb 2020 20:59:02 +0900 (JST)
Received: from [10.213.132.48] (unknown [10.213.132.48])
        by yuzu.css.socionext.com (Postfix) with ESMTP id 048FC120133;
        Fri,  7 Feb 2020 20:59:02 +0900 (JST)
Date:   Fri, 07 Feb 2020 20:59:01 +0900
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net: ethernet: ave: Add capability of rgmii-id mode
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <masami.hiramatsu@linaro.org>, <jaswinder.singh@linaro.org>
In-Reply-To: <20200207.111648.1915539223489764931.davem@davemloft.net>
References: <1580954376-27283-1-git-send-email-hayashi.kunihiko@socionext.com> <20200207.111648.1915539223489764931.davem@davemloft.net>
Message-Id: <20200207205901.BE9A.4A936039@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.70 [ja]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, 
Thank you for your comment.

On Fri, 7 Feb 2020 11:16:48 +0100 <davem@davemloft.net> wrote:

> From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> Date: Thu,  6 Feb 2020 10:59:36 +0900
> 
> > This allows you to specify the type of rgmii-id that will enable phy
> > internal delay in ethernet phy-mode.
> > 
> > Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> 
> I do not understand this change at all.
> 
> At a minimum you must explain things more clearly and completely in your
> commit message.
> 
> Are you just adding all of the RGMII cases to the code that only currently
> mentions PHY_INTERFACE_MODE_RGMII?  If so, why did you only do this for
> some but not all of the get_pinmode() methods in this driver?

Yes, this is intended to add all of RGMII cases to the code.
I add the cases to all of get_pinmode() except LD11, because LD11 doesn't
support RGMII due to the constraint of the hardware.

When RGMII phy mode is specified in the devicetree for LD11, the driver
will abort with the message "invalid phy-mode setting".

If it is clear, I'll add this to the next commit message.

Thank you,

---
Best Regards,
Kunihiko Hayashi

