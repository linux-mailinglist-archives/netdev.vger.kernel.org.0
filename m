Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D745ACD2
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfF2SJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:09:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfF2SJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 14:09:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7EDC414B8F034;
        Sat, 29 Jun 2019 11:09:33 -0700 (PDT)
Date:   Sat, 29 Jun 2019 11:09:32 -0700 (PDT)
Message-Id: <20190629.110932.1480107082787858331.davem@davemloft.net>
To:     harini.katakam@xilinx.com
Cc:     nicolas.ferre@microchip.com, richardcochran@gmail.com,
        claudiu.beznea@microchip.com, rafalo@cadence.com,
        andrei.pistirica@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@xilinx.com,
        harinikatakamlinux@gmail.com
Subject: Re: [PATCH 0/2] Sub ns increment fixes in Macb PTP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561616460-32439-1-git-send-email-harini.katakam@xilinx.com>
References: <1561616460-32439-1-git-send-email-harini.katakam@xilinx.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 11:09:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>
Date: Thu, 27 Jun 2019 11:50:58 +0530

> The subns increment register fields are not captured correctly in the
> driver. Fix the same and also increase the subns incr resolution.
> 
> Sub ns resolution was increased to 24 bits in r1p06f2 version. To my
> knowledge, this PTP driver, with its current BD time stamp
> implementation, is only useful to that version or above. So, I have
> increased the resolution unconditionally. Please let me know if there
> is any IP versions incompatible with this - there is no register to
> obtain this information from.
> 
> Changes from RFC:
> None

Series applied, thanks.
