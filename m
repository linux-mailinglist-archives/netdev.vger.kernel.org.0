Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A540B233C43
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbgG3XrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730765AbgG3XrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:47:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC221C061574;
        Thu, 30 Jul 2020 16:47:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D0B7126C06A6;
        Thu, 30 Jul 2020 16:30:33 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:47:17 -0700 (PDT)
Message-Id: <20200730.164717.749974909338549420.davem@davemloft.net>
To:     min.li.xe@renesas.com
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ptp: ptp_clockmatrix: update to support 4.8.7
 firmware
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595966430-8603-1-git-send-email-min.li.xe@renesas.com>
References: <1595966430-8603-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:30:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <min.li.xe@renesas.com>
Date: Tue, 28 Jul 2020 16:00:30 -0400

> From: Min Li <min.li.xe@renesas.com>
> 
> With 4.8.7 firmware, adjtime can change delta instead of absolute time,
> which greately increases snap accuracy. PPS alignment doesn't have to
> be set for every single TOD change. Other minor changes includes:
> adding more debug logs, increasing snap accuracy for pre 4.8.7 firmware
> and supporting new tcs2bin format.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

Applied to net-next, thanks.
