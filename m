Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8FB4368D3
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfFFAm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:42:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43396 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfFFAm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:42:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D763810000176;
        Wed,  5 Jun 2019 17:42:25 -0700 (PDT)
Date:   Wed, 05 Jun 2019 17:42:14 -0700 (PDT)
Message-Id: <20190605.174214.1514924637718698470.davem@davemloft.net>
To:     Igor.Russkikh@aquantia.com
Cc:     netdev@vger.kernel.org, Nikita.Danilov@aquantia.com
Subject: Re: [PATCH net] net: aquantia: fix wol configuration not applied
 sometimes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e06ec30228aac6503f9da33e411dd07a175683b0.1559571979.git.igor.russkikh@aquantia.com>
References: <e06ec30228aac6503f9da33e411dd07a175683b0.1559571979.git.igor.russkikh@aquantia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 17:42:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>
Date: Tue, 4 Jun 2019 13:23:49 +0000

> From: Nikita Danilov <nikita.danilov@aquantia.com>
> 
> WoL magic packet configuration sometimes does not work due to
> couple of leakages found.
> 
> Mainly there was a regression introduced during readx_poll refactoring.
> 
> Next, fw request waiting time was too small. Sometimes that
> caused sleep proxy config function to return with an error
> and to skip WoL configuration.
> At last, WoL data were passed to FW from not clean buffer.
> That could cause FW to accept garbage as a random configuration data.
> 
> Signed-off-by: Nikita Danilov <nikita.danilov@aquantia.com>
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
> Fixes: 6a7f2277313b ("net: aquantia: replace AQ_HW_WAIT_FOR with readx_poll_timeout_atomic")

Applied and queued up for -stable.
