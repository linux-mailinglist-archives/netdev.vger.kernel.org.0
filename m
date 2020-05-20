Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A590D1DBD4D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgETSuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:50:18 -0400
Received: from muru.com ([72.249.23.125]:55216 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgETSuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 14:50:17 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 2994B819C;
        Wed, 20 May 2020 18:51:06 +0000 (UTC)
Date:   Wed, 20 May 2020 11:50:13 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maital Hahn <maitalm@ti.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wlcore: fix runtime pm imbalance in
 __wl1271_op_remove_interface
Message-ID: <20200520185013.GZ37466@atomide.com>
References: <20200520130806.14789-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520130806.14789-1-dinghao.liu@zju.edu.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Dinghao Liu <dinghao.liu@zju.edu.cn> [200520 13:09]:
> When wl12xx_cmd_role_disable() returns an error code,
> a pairing runtime PM usage counter decrement is needed to
> keep the counter balanced.

Acked-by: Tony Lindgren <tony@atomide.com>
