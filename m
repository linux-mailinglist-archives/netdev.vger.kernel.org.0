Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B861DEEB6
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbgEVR55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:57:57 -0400
Received: from muru.com ([72.249.23.125]:55554 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730702AbgEVR55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 13:57:57 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id E722F8087;
        Fri, 22 May 2020 17:58:45 +0000 (UTC)
Date:   Fri, 22 May 2020 10:57:53 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Guy Mishol <guym@ti.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wlcore: fix runtime pm imbalance in wlcore_irq_locked
Message-ID: <20200522175753.GD37466@atomide.com>
References: <20200522044906.29564-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522044906.29564-1-dinghao.liu@zju.edu.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Dinghao Liu <dinghao.liu@zju.edu.cn> [200522 04:50]:
> When wlcore_fw_status() returns an error code, a pairing
> runtime PM usage counter decrement is needed to keep the
> counter balanced. It's the same for all error paths after
> wlcore_fw_status().

Acked-by: Tony Lindgren <tony@atomide.com>
