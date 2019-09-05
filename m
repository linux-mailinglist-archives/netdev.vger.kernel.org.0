Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA032AA014
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387681AbfIEKlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:41:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731215AbfIEKlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:41:45 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB81B15388142;
        Thu,  5 Sep 2019 03:41:44 -0700 (PDT)
Date:   Thu, 05 Sep 2019 12:41:43 +0200 (CEST)
Message-Id: <20190905.124143.72972869920021226.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] r8152: adjust the settings of ups flags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-328-Taiwan-albertk@realtek.com>
References: <1394712342-15778-327-Taiwan-albertk@realtek.com>
        <1394712342-15778-328-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 03:41:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 5 Sep 2019 10:46:20 +0800

> The UPS feature only works for runtime suspend, so UPS flags only
> need to be set before enabling runtime suspend. Therefore, I create
> a struct to record relative information, and use it before runtime
> suspend.
> 
> All chips could record such information, even though not all of
> them support the feature of UPS. Then, some functions could be
> combined.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
