Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71CCAFBBAB
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKMWdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:33:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfKMWdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 17:33:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0E96128F3859;
        Wed, 13 Nov 2019 14:33:46 -0800 (PST)
Date:   Wed, 13 Nov 2019 14:33:46 -0800 (PST)
Message-Id: <20191113.143346.1023883959757211854.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, olof@lixom.net,
        venkatkumar.duvvuru@broadcom.com
Subject: Re: [PATCH net-next] bnxt_en: Fix array overrun in
 bnxt_fill_l2_rewrite_fields().
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573671079-27248-1-git-send-email-michael.chan@broadcom.com>
References: <1573671079-27248-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 14:33:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Wed, 13 Nov 2019 13:51:19 -0500

> From: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
> 
> Fix the array overrun while keeping the eth_addr and eth_addr_mask
> pointers as u16 to avoid unaligned u16 access.  These were overlooked
> when modifying the code to use u16 pointer for proper alignment.
> 
> Fixes: 90f906243bf6 ("bnxt_en: Add support for L2 rewrite")
> Reported-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Applied.
