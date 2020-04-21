Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742701B32CF
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 00:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDUWyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 18:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725850AbgDUWyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 18:54:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99EEC0610D5;
        Tue, 21 Apr 2020 15:54:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B0BB128E92AE;
        Tue, 21 Apr 2020 15:54:17 -0700 (PDT)
Date:   Tue, 21 Apr 2020 15:54:16 -0700 (PDT)
Message-Id: <20200421.155416.260842337991054528.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     ynezz@true.cz, swboyd@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Markus.Elfring@web.de
Subject: Re: [PATCH net-next v1] net: broadcom: convert to
 devm_platform_ioremap_resource_byname()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420150641.2528-1-zhengdejin5@gmail.com>
References: <20200420150641.2528-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Apr 2020 15:54:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Mon, 20 Apr 2020 23:06:41 +0800

> Use the function devm_platform_ioremap_resource_byname() to simplify
> source code which calls the functions platform_get_resource_byname()
> and devm_ioremap_resource(). Remove also a few error messages which
> became unnecessary with this software refactoring.
> 
> Suggested-by: Markus Elfring <Markus.Elfring@web.de>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Applied.
