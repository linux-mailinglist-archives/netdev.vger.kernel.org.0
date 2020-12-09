Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337572D3784
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgLIAUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:20:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45156 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729665AbgLIAUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:20:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 6E7784D248DBE;
        Tue,  8 Dec 2020 16:19:59 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:19:58 -0800 (PST)
Message-Id: <20201208.161958.862390002072491156.davem@davemloft.net>
To:     dqfext@gmail.com
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        kuba@kernel.org, matthias.bgg@gmail.com, linux@armlinux.org.uk,
        frank-w@public-files.de
Subject: Re: [PATCH net-next] net: dsa: mt7530: support setting ageing time
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208070028.3177-1-dqfext@gmail.com>
References: <20201208070028.3177-1-dqfext@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:19:59 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>
Date: Tue,  8 Dec 2020 15:00:28 +0800

> MT7530 has a global address age control register, so use it to set
> ageing time.
> 
> The applied timer is (AGE_CNT + 1) * (AGE_UNIT + 1) seconds
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Applied, thanks
