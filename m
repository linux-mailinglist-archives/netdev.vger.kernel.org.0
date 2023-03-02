Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCDE6A7B2F
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 07:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjCBGFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 01:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjCBGFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 01:05:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BB230DB;
        Wed,  1 Mar 2023 22:05:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EA6861549;
        Thu,  2 Mar 2023 06:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0ADC433EF;
        Thu,  2 Mar 2023 06:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677737099;
        bh=UPFD5M3RVbBS0qN7MTanJdpyBZCfZDcQn5iRqw47oeg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Fyu1GXV2qVnZzBlykZrNbOU2wjehz/3/nmygTqKOeWeYZed9aF+o9iW0dT9m30W+5
         ddTcfuOdAKJqNknGUSIaIg1306JPrtU2SE/aDiKUx9ycs8hXfqWcEmJ3KgyXgRCbyb
         WHEaPyIYxT7kfu9qDEORL348WpbTPG1Qm3b/13VAoqy1Miq3UlBWvztbCZ1uuurR54
         l3OfpO6/l3vxAkcSZ5oSCUquLdpVlX8Rct5uBv9LZgsinHIaFzrnWpcHoTwrHdVB2F
         iRz3sBJkqpGP0kQeuORr1j6Uwxa8Zw9dN5cD3VBormZ6BtUbQx/jTr2kpBg4+gADQb
         5PQiXx718w0eg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH v4] wifi: rtlwifi: rtl8192se: Remove some unused variables
References: <20230302023911.59278-1-jiapeng.chong@linux.alibaba.com>
Date:   Thu, 02 Mar 2023 08:04:53 +0200
In-Reply-To: <20230302023911.59278-1-jiapeng.chong@linux.alibaba.com> (Jiapeng
        Chong's message of "Thu, 2 Mar 2023 10:39:11 +0800")
Message-ID: <87wn3zzo1m.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> writes:

> Variable bcntime_cfg, bcn_cw and bcn_ifs are not effectively used, so
> delete it.

I'll do s/it/them/ during commit, no need to resend because of this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
