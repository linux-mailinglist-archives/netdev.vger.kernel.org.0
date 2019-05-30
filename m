Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1D23046D
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfE3V6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:58:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfE3V6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:58:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8473314DB3D28;
        Thu, 30 May 2019 14:49:07 -0700 (PDT)
Date:   Thu, 30 May 2019 14:49:07 -0700 (PDT)
Message-Id: <20190530.144907.723803908854753596.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     grygorii.strashko@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: cpsw_ethtool: fix ethtool ring
 param set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529214753.21804-1-ivan.khoronzhuk@linaro.org>
References: <20190529214753.21804-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:49:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Thu, 30 May 2019 00:47:53 +0300

> Fixes: 37e2d99b59c4765112533a1d38174fea58d28a51 ("ethtool: Ensure new
> ring parameters are within bounds during SRINGPARAM")
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Please do not chop up Fixes: tags into multiple lines.

Please do not place an empty line between Fixes: and other tags,
they should all be together.

Thank you.
