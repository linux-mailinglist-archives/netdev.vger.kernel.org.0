Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A1A1B15D1
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgDTTVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgDTTVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:21:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3946C061A0C;
        Mon, 20 Apr 2020 12:21:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E97AE127F9881;
        Mon, 20 Apr 2020 12:21:41 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:21:41 -0700 (PDT)
Message-Id: <20200420.122141.2220361049378373139.davem@davemloft.net>
To:     aishwaryarj100@gmail.com
Cc:     hkallweit1@gmail.com, kuba@kernel.org, mst@redhat.com,
        mhabets@solarflare.com, jonathan.lemon@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sun: Remove unneeded cast from memory allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200419154444.21977-1-aishwaryarj100@gmail.com>
References: <20200419154444.21977-1-aishwaryarj100@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:21:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
Date: Sun, 19 Apr 2020 21:14:43 +0530

> Remove casting the values returned by memory allocation function.
> 
> Coccinelle emits WARNING: casting value returned by memory allocation
> function to (struct cas_init_block *) is useless.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>

Applied to net-next, thanks.
