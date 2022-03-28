Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9362D4E8E42
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbiC1GkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236714AbiC1GkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:40:06 -0400
X-Greylist: delayed 1376 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 27 Mar 2022 23:38:24 PDT
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com [192.185.48.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A042C2719
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:38:22 -0700 (PDT)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id DD37511443
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 01:15:26 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Yif0nZ3mXHnotYif0nUW7N; Mon, 28 Mar 2022 01:15:26 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jQgqtKv6g3c9JTlzvFF9fkILdnQrG04PzWMmUtyZ79I=; b=Z9m6Uy21YEhtJzNbcBVhcTYQYn
        vTB3fNlc3MOfcSh6ksPbcbYt3oSXkofi5a6lRQPC05JtMruK8znKUKiTTX3akYnERi0THt5V62b9k
        O3i2yVX8iGTxxGcpJ47nvcy0wCRN019I5YMj117403A7hpVRofIkzeD8LQgrGrmdIpYLwgqyOAlD/
        AW2eJjvcAFsrsOMELIVWO1G++G5f5/H22dbAqQ8Ex3v0lYALkLQtX6V/okDZ43zfuA2OfLBspZOEH
        Bw9+aSG4L4fcfrJe4f2a4dwsO/Uoddhuvu6U0FDkQ06+RWGTnrDTKhOxrvlY2iBr2UTk1rSe/pNCM
        ikLFO6lA==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:38018 helo=[192.168.15.9])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1nYif0-000lJi-7y; Mon, 28 Mar 2022 01:15:26 -0500
Message-ID: <4c520e2e-d1a5-6d2b-3ef1-b891d7946c01@embeddedor.com>
Date:   Mon, 28 Mar 2022 01:23:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH][next] iwlwifi: fw: Replace zero-length arrays with
 flexible-array members
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20220216195015.GA904148@embeddedor>
 <202202161235.2FB20E6A5@keescook> <20220326003843.GA2602091@embeddedor>
 <871qym1vck.fsf@kernel.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <871qym1vck.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1nYif0-000lJi-7y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.9]) [187.162.31.110]:38018
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/28/22 00:47, Kalle Valo wrote:
> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
> 
>> On Wed, Feb 16, 2022 at 12:35:14PM -0800, Kees Cook wrote:
>>> On Wed, Feb 16, 2022 at 01:50:15PM -0600, Gustavo A. R. Silva wrote:
>>>> There is a regular need in the kernel to provide a way to declare
>>>> having a dynamically sized set of trailing elements in a structure.
>>>> Kernel code should always use “flexible array members”[1] for these
>>>> cases. The older style of one-element or zero-length arrays should
>>>> no longer be used[2].
>>>>
>>>> [1] https://en.wikipedia.org/wiki/Flexible_array_member
>>>> [2]
>>>> https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
>>>>
>>>> Link: https://github.com/KSPP/linux/issues/78
>>>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>>
>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>
>> Hi all,
>>
>> Friendly ping: can someone take this, please?
>>
>> ...I can take this in my -next tree in the meantime.
> 
> Like we have discussed before, please don't take any wireless patches to
> your tree. The conflicts just cause more work of us.

Sure thing. I just removed it from my tree.

I didn't get any reply from wireless people in more than a month, and
that's why I temporarily took it in my tree so it doesn't get lost. :)

> I assigned this patch to me on patchwork and I'm planning to take it to
> wireless-next once it opens. Luca, ack?

Awesome.

Thanks
--
Gustavo
