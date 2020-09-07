Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3585725F574
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgIGIii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:38:38 -0400
Received: from a27-56.smtp-out.us-west-2.amazonses.com ([54.240.27.56]:59014
        "EHLO a27-56.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727897AbgIGIih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 04:38:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599467916;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=I8fOqclJWXPRgQ4JVNxpFHrT/lck1MQGbss6hJodofM=;
        b=eXE2bA8KblDd4HcTyerQmcE6GHmZtqLst1vzNvc6rIAgDClvkr8ihGpU8uroJMqI
        QUtUQT7XlsabNAW4Apgw0b3lUtqLbUkod/cuZyNuW27jf3ko0z6sPd2mMln6KM2RdUs
        1G6kuV49qIZyWP2bpDhnV0SSwwbpKsGI0XPMYDWQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599467916;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=I8fOqclJWXPRgQ4JVNxpFHrT/lck1MQGbss6hJodofM=;
        b=AHb672B5fbYzo1/tl0l1Q7cGof8ddfhCUh7GmiZP9lx9903/R9r6ae/AouB1CHhF
        g2GDkt1Qf8ata2om95Nwl+6nWLOZtCMMYiVIJB1Vuz+2k0NgyK+S795q2IIYmUGFWmd
        PMBYVRldSiH/qrUhfd6lvAUEikj/cWh39Cc0EN04=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B2087C43463
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] Revert "wlcore: Adding suppoprt for IGTK key in wlcore
 driver"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <f0a2cb7ea606f1a284d4c23cbf983da2954ce9b6.1598420968.git.mchehab+huawei@kernel.org>
References: <f0a2cb7ea606f1a284d4c23cbf983da2954ce9b6.1598420968.git.mchehab+huawei@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Maital Hahn <maitalm@ti.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Raz Bouganim <r-bouganim@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017467b78ceb-36db3199-b46c-4a42-890a-a9b236326b25-000000@us-west-2.amazonses.com>
Date:   Mon, 7 Sep 2020 08:38:36 +0000
X-SES-Outgoing: 2020.09.07-54.240.27.56
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> This patch causes a regression betwen Kernel 5.7 and 5.8 at wlcore:
> with it applied, WiFi stops working, and the Kernel starts printing
> this message every second:
> 
>    wlcore: PHY firmware version: Rev 8.2.0.0.242
>    wlcore: firmware booted (Rev 8.9.0.0.79)
>    wlcore: ERROR command execute failure 14
>    ------------[ cut here ]------------
>    WARNING: CPU: 0 PID: 133 at drivers/net/wireless/ti/wlcore/main.c:795 wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
>    Modules linked in: wl18xx wlcore mac80211 libarc4 cfg80211 rfkill snd_soc_hdmi_codec crct10dif_ce wlcore_sdio adv7511 cec kirin9xx_drm(C) kirin9xx_dw_drm_dsi(C) drm_kms_helper drm ip_tables x_tables ipv6 nf_defrag_ipv6
>    CPU: 0 PID: 133 Comm: kworker/0:1 Tainted: G        WC        5.8.0+ #186
>    Hardware name: HiKey970 (DT)
>    Workqueue: events_freezable ieee80211_restart_work [mac80211]
>    pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
>    pc : wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
>    lr : wl12xx_queue_recovery_work+0x24/0x30 [wlcore]
>    sp : ffff8000126c3a60
>    x29: ffff8000126c3a60 x28: 00000000000025de
>    x27: 0000000000000010 x26: 0000000000000005
>    x25: ffff0001a5d49e80 x24: ffff8000092cf580
>    x23: ffff0001b7c12623 x22: ffff0001b6fcf2e8
>    x21: ffff0001b7e46200 x20: 00000000fffffffb
>    x19: ffff0001a78e6400 x18: 0000000000000030
>    x17: 0000000000000001 x16: 0000000000000001
>    x15: ffff0001b7e46670 x14: ffffffffffffffff
>    x13: ffff8000926c37d7 x12: ffff8000126c37e0
>    x11: ffff800011e01000 x10: ffff8000120526d0
>    x9 : 0000000000000000 x8 : 3431206572756c69
>    x7 : 6166206574756365 x6 : 0000000000000c2c
>    x5 : 0000000000000000 x4 : ffff0001bf1361e8
>    x3 : ffff0001bf1790b0 x2 : 0000000000000000
>    x1 : ffff0001a5d49e80 x0 : 0000000000000001
>    Call trace:
>     wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
>     wl12xx_queue_recovery_work+0x24/0x30 [wlcore]
>     wl1271_cmd_set_sta_key+0x258/0x25c [wlcore]
>     wl1271_set_key+0x7c/0x2dc [wlcore]
>     wlcore_set_key+0xe4/0x360 [wlcore]
>     wl18xx_set_key+0x48/0x1d0 [wl18xx]
>     wlcore_op_set_key+0xa4/0x180 [wlcore]
>     ieee80211_key_enable_hw_accel+0xb0/0x2d0 [mac80211]
>     ieee80211_reenable_keys+0x70/0x110 [mac80211]
>     ieee80211_reconfig+0xa00/0xca0 [mac80211]
>     ieee80211_restart_work+0xc4/0xfc [mac80211]
>     process_one_work+0x1cc/0x350
>     worker_thread+0x13c/0x470
>     kthread+0x154/0x160
>     ret_from_fork+0x10/0x30
>    ---[ end trace b1f722abf9af5919 ]---
>    wlcore: WARNING could not set keys
>    wlcore: ERROR Could not add or replace key
>    wlan0: failed to set key (4, ff:ff:ff:ff:ff:ff) to hardware (-5)
>    wlcore: Hardware recovery in progress. FW ver: Rev 8.9.0.0.79
>    wlcore: pc: 0x0, hint_sts: 0x00000040 count: 39
>    wlcore: down
>    wlcore: down
>    ieee80211 phy0: Hardware restart was requested
>    mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
>    mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
>    wlcore: PHY firmware version: Rev 8.2.0.0.242
>    wlcore: firmware booted (Rev 8.9.0.0.79)
>    wlcore: ERROR command execute failure 14
>    ------------[ cut here ]------------
> 
> Tested on Hikey 970.
> 
> This reverts commit 2b7aadd3b9e17e8b81eeb8d9cc46756ae4658265.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Signed-off-by: Raz Bouganim <r-bouganim@ti.com>

I'm going to apply this revert now and queue for v5.9. The feature can be added
again for v5.10 with proper support for older firmware versions.

-- 
https://patchwork.kernel.org/patch/11737193/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

