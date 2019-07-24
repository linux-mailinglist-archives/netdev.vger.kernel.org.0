Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FC4736C6
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfGXSmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:42:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGXSmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 14:42:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 56B3615409B9E;
        Wed, 24 Jul 2019 11:42:53 -0700 (PDT)
Date:   Wed, 24 Jul 2019 11:42:52 -0700 (PDT)
Message-Id: <20190724.114252.458305207498876259.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     hslester96@gmail.com, mlindner@marvell.com,
        stephen@networkplumber.org, jirislaby@gmail.com,
        mickflemm@gmail.com, mcgrof@kernel.org, sgruszka@redhat.com,
        ath9k-devel@qca.qualcomm.com, merez@codeaurora.org,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, amitkarwar@gmail.com,
        nishants@marvell.com, gbhat@marvell.com, huxinming820@gmail.com,
        imitsyanko@quantenna.com, avinashp@quantenna.com,
        smatyukevich@quantenna.com, pkshih@realtek.com,
        linuxwifi@intel.com, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        netdev@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] Use dev_get_drvdata where possible
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87zhl3zlu1.fsf@kamboji.qca.qualcomm.com>
References: <20190724112524.13042-1-hslester96@gmail.com>
        <87zhl3zlu1.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 11:42:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Wed, 24 Jul 2019 14:57:42 +0300

> Do note that wireless patches go to wireless-drivers-next, not net-next.
> But I assume Dave will ignore patches 5-10 and I can take them.

Yes, that is what I plan to do.
