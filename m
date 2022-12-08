Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AF564722F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiLHOwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLHOwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:52:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D47499F3E;
        Thu,  8 Dec 2022 06:52:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A83B5B82430;
        Thu,  8 Dec 2022 14:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D6EC433D6;
        Thu,  8 Dec 2022 14:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670511130;
        bh=Zt1ASjxOfP069nTeasoXmi8s76tlDSB1EMEAvURlJ5o=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Rb10/78v2DiHCeqVt87llYpYUyQflxiNWcOAJDo1xg1/sC3NQDhVYPA23xhqnpxpa
         tVnuv2G6qaRVIceaUSJXuEWspQO594gVa6zpxoaccZ8com02XM94xRQtpEc1/yiatF
         /UXnrFDs2+jmGdYkz/sKFh3vRdcX/HLdaqunIrDXyrOGv3KuhI0Cxokmfb43WiEAYh
         +hr6RLRmOVhW6u43x2Un+LST99/aJ+1CNZ3ZSiY8rX7Ba4ZoDr1QO29I4OzhS0X4l0
         qZ1D9yJFwUsOYC/DeiJcwLRmP2B9fsj6cYmRDC9ubxmoKsUmfnmLapxr7Lo9adO3JH
         6+oLFj7orYySA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 01/11] wifi: rtw88: print firmware type in info message
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221202081224.2779981-2-s.hauer@pengutronix.de>
References: <20221202081224.2779981-2-s.hauer@pengutronix.de>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167051112518.9839.10838893022314456612.kvalo@kernel.org>
Date:   Thu,  8 Dec 2022 14:52:07 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> wrote:

> It's confusing to read two different firmware versions in the syslog
> for the same device:
> 
> rtw_8822cu 2-1:1.2: Firmware version 9.9.4, H2C version 15
> rtw_8822cu 2-1:1.2: Firmware version 9.9.11, H2C version 15
> 
> Print the firmware type in this message to make clear these are really
> two different firmwares for different purposes:
> 
> rtw_8822cu 1-1.4:1.2: WOW Firmware version 9.9.4, H2C version 15
> rtw_8822cu 1-1.4:1.2: Firmware version 9.9.11, H2C version 15
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

11 patches applied to wireless-next.git, thanks.

1d8966049440 wifi: rtw88: print firmware type in info message
69020957bcb7 wifi: rtw88: Call rtw_fw_beacon_filter_config() with rtwdev->mutex held
d57ca103e54e wifi: rtw88: Drop rf_lock
1e2701f4079a wifi: rtw88: Drop h2c.lock
8647f7f0b908 wifi: rtw88: Drop coex mutex
78d5bf925f30 wifi: rtw88: iterate over vif/sta list non-atomically
a82dfd33d123 wifi: rtw88: Add common USB chip support
aff5ffd718de wifi: rtw88: Add rtw8821cu chipset support
45794099f5e1 wifi: rtw88: Add rtw8822bu chipset support
07cef03b8d44 wifi: rtw88: Add rtw8822cu chipset support
87caeef032fc wifi: rtw88: Add rtw8723du chipset support

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221202081224.2779981-2-s.hauer@pengutronix.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

