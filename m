Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504BE5A4B54
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiH2MPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiH2MPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:15:30 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5134C832DF;
        Mon, 29 Aug 2022 04:59:23 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id C4E821E80D90;
        Mon, 29 Aug 2022 19:26:48 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M6hgVIKQLa_j; Mon, 29 Aug 2022 19:26:46 +0800 (CST)
Received: from [172.30.38.131] (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 8AB451E80D59;
        Mon, 29 Aug 2022 19:26:44 +0800 (CST)
Subject: Re: [PATCH] wifi: cfg80211: add error code in
 brcmf_notify_sched_scan_results()
To:     Arend Van Spriel <aspriel@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhe <yuzhe@nfschina.com>
References: <20220829065831.14023-1-liqiong@nfschina.com>
 <a054ffb1-527b-836c-f43e-9f76058cc9ed@gmail.com>
From:   liqiong <liqiong@nfschina.com>
Message-ID: <6b8c94c3-2c8d-a222-67ec-4461615185e1@nfschina.com>
Date:   Mon, 29 Aug 2022 19:31:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <a054ffb1-527b-836c-f43e-9f76058cc9ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RDNS_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022年08月29日 16:51, Arend Van Spriel 写道:
> On 8/29/2022 8:58 AM, Li Qiong wrote:
>> The err code is 0 at the first two "out_err" paths, add error code
>> '-EINVAL' for these error paths.
>
> There is no added value provided in this change. There is an error message, but it is otherwise silently ignored as there is no additional fault handling required.
It should be better to fix the return code, and It seems that the code has been checked, eg:
if (ifp->drvr->fweh.evt_handler[i]) {
.....
}


>
> Regards,
> Arend
>
>> Signed-off-by: Li Qiong <liqiong@nfschina.com>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 ++
>>   1 file changed, 2 insertions(+)

