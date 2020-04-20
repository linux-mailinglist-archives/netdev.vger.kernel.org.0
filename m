Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52091B15D9
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgDTTX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725896AbgDTTX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:23:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26F2C061A0C;
        Mon, 20 Apr 2020 12:23:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 591F5127F98A6;
        Mon, 20 Apr 2020 12:23:27 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:23:26 -0700 (PDT)
Message-Id: <20200420.122326.1497522059061965797.davem@davemloft.net>
To:     aishwaryarj100@gmail.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qed: Remove unneeded cast from memory allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200419162917.23030-1-aishwaryarj100@gmail.com>
References: <20200419162917.23030-1-aishwaryarj100@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:23:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
Date: Sun, 19 Apr 2020 21:59:17 +0530

> Remove casting the values returned by memory allocation function.
> 
> Coccinelle emits WARNING: casting value returned by memory allocation
> function to struct pointer is useless.
> 
> This issue was detected by using the Coccinelle.
> 
> Signed-off-by: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>

Applied to net-next, thanks.
