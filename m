Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A461EFE35
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 18:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgFEQtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 12:49:42 -0400
Received: from muru.com ([72.249.23.125]:57048 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgFEQtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 12:49:42 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id E034980F5;
        Fri,  5 Jun 2020 16:50:31 +0000 (UTC)
Date:   Fri, 5 Jun 2020 09:49:38 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hari Nagalla <hnagalla@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, emamd001@umn.edu, wu000273@umn.edu,
        kjlu@umn.edu, smccaman@umn.edu
Subject: Re: [PATCH] wlcore: mesh: handle failure case of pm_runtime_get_sync
Message-ID: <20200605164938.GH37466@atomide.com>
References: <20200605032733.49846-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605032733.49846-1-navid.emamdoost@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Navid Emamdoost <navid.emamdoost@gmail.com> [200605 03:28]:
> Calling pm_runtime_get_sync increments the counter even in case of
> failure, causing incorrect ref count. Call pm_runtime_put if
> pm_runtime_get_sync fails.

Looks like we have a similar patch already in Linux next,
care to check?

Regards,

Tony
