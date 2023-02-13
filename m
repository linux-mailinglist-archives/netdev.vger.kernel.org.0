Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02243693F73
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 09:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjBMITx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 03:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjBMITp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 03:19:45 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF7B126FA;
        Mon, 13 Feb 2023 00:19:31 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aeab2.dynamic.kabel-deutschland.de [95.90.234.178])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D5F0961CC457B;
        Mon, 13 Feb 2023 09:19:27 +0100 (CET)
Message-ID: <868017d2-c85f-20a1-292f-0b97ab8bf752@molgen.mpg.de>
Date:   Mon, 13 Feb 2023 09:19:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] Bluetooth: hci_core: Fix poential Use-after-Free bug in
 hci_remove_adv_monitor
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     marcel@holtmann.org, hackerzheng666@gmail.com,
        alex000young@gmail.com, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230210041030.865478-1-zyytlz.wz@163.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230210041030.865478-1-zyytlz.wz@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Zheng,


Thank you for your patch.

Am 10.02.23 um 05:10 schrieb Zheng Wang:
> In hci_remove_adv_monitor, if it gets into HCI_ADV_MONITOR_EXT_MSFT case,
> the function will free the monitor and print its handle after that.
> 
> Fix it by switch the order.

… by switch*ing* …

There is a small typo in the commit message summary/title: po*t*ential

> Fixes: 7cf5c2978f23 ("Bluetooth: hci_sync: Refactor remove Adv Monitor")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
>   net/bluetooth/hci_core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

[…]


Kind regards,

Paul
