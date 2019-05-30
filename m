Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 123652F5D3
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388978AbfE3Euf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:50:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46852 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388946AbfE3Eud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 00:50:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EF0513AEF25B;
        Wed, 29 May 2019 21:50:33 -0700 (PDT)
Date:   Wed, 29 May 2019 21:50:32 -0700 (PDT)
Message-Id: <20190529.215032.862998826382261504.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     grygorii.strashko@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: ethernet: ti: cpsw: correct .ndo_open
 error path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528174519.7370-1-ivan.khoronzhuk@linaro.org>
References: <20190528174519.7370-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 21:50:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Tue, 28 May 2019 20:45:19 +0300

> It's found while review and probably never happens, but real number
> of queues is set per device, and error path should be per device.
> So split error path based on usage_count.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Applied, thanks.
