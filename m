Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD5CFF599
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 21:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfKPUvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 15:51:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbfKPUvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 15:51:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44CCA1518AA5F;
        Sat, 16 Nov 2019 12:51:17 -0800 (PST)
Date:   Sat, 16 Nov 2019 12:51:16 -0800 (PST)
Message-Id: <20191116.125116.355989617007258357.davem@davemloft.net>
To:     keescook@chromium.org
Cc:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, samitolvanen@google.com,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] bnx2x: Remove function casts
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115050715.6247-1-keescook@chromium.org>
References: <20191115050715.6247-1-keescook@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:51:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Nov 2019 21:07:10 -0800

> In order to make the entire kernel usable under Clang's Control Flow
> Integrity protections, function prototype casts need to be avoided
> because this will trip CFI checks at runtime (i.e. a mismatch between
> the caller's expected function prototype and the destination function's
> prototype). Many of these cases can be found with -Wcast-function-type,
> which found that bnx2x had a bunch of needless (or at least confusing)
> function casts. This series removes them all.

Looks reasonable, series applied to net-next.

Thank you.
