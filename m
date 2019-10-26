Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BBAE575D
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 02:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfJZADt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 20:03:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38794 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfJZADt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 20:03:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5762114AAC08A;
        Fri, 25 Oct 2019 17:03:48 -0700 (PDT)
Date:   Fri, 25 Oct 2019 17:03:44 -0700 (PDT)
Message-Id: <20191025.170344.819362852072467345.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, pmalani@chromium.org,
        grundler@chromium.org, nic_swsd@realtek.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH net-next] r8152: check the pointer rtl_fw->fw before
 using it
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-336-Taiwan-albertk@realtek.com>
References: <1394712342-15778-336-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 17:03:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 23 Oct 2019 21:24:44 +0800

> Fix the pointer rtl_fw->fw would be used before checking in
> rtl8152_apply_firmware() that causes the following kernel oops.
 ...
> Fixes: 9370f2d05a2a ("r8152: support request_firmware for RTL8153")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
