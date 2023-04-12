Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A95E6DFD30
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 20:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjDLSCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 14:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjDLSBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 14:01:48 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F07B72A9;
        Wed, 12 Apr 2023 11:01:42 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id E899E859AB;
        Wed, 12 Apr 2023 20:01:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1681322500;
        bh=1vvuWQtFH6Zro9A8GibwHmsUcF3+pDJyQ6oddJOWzBE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fvR/4YE5uBA9UPg7xISf11o8nZEDC03Ql252wm9er6TD0hytatWm9V8KdUP1bKBON
         oh4oT9dd0XMJj0ioyT2mvvpwLhCOTFix5wUFzMoXTWuQhO8hoHJvtvgrjW+OK3oWDN
         dKWvgMMa0dhMgZPAXnWsySUkGi6vQEENsX2e/1DEsy2Kd4lfBHRI6nGmx0p889kIZL
         ZwVvzdCuLJelykpSZAQ8yGgH454w+lErIlFQSIHOn1WPwmonPuWYt4kq0vsiDhXG2q
         +aVMSbfE35MC4DYVhbn2Gk8Fa2Beunk7FPHdhAQ8LpzoJZjin6U9LXCk8p1gAh6/Zk
         PRFUCpMM2zb3g==
Message-ID: <c46491fc-6853-7033-e913-c9da94d1e6a4@denx.de>
Date:   Wed, 12 Apr 2023 20:01:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2] wifi: brcmfmac: add Cypress 43439 SDIO ids
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
Cc:     linux-wireless@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        Eric Dumazet <edumazet@google.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Cercueil <paul@crapouillou.net>,
        SHA-cyfmac-dev-list@infineon.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        brcm80211-dev-list.pdl@broadcom.com, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230407203752.128539-1-marex@denx.de>
 <ZDGHF0dKwIjB1Mrj@corigine.com>
 <509e4308-9164-4131-4b93-75c42568d1e4@denx.de>
 <ZDHEI7tbjLJiRcBr@corigine.com> <87v8i18rpz.fsf@kernel.org>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <87v8i18rpz.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/23 09:50, Kalle Valo wrote:
> Simon Horman <simon.horman@corigine.com> writes:
> 
>> On Sat, Apr 08, 2023 at 06:44:40PM +0200, Marek Vasut wrote:
>>
>>> On 4/8/23 17:24, Simon Horman wrote:
>>>> On Fri, Apr 07, 2023 at 10:37:52PM +0200, Marek Vasut wrote:
>>>>
>>>>> NOTE: Please drop the Fixes tag if this is considered unjustified
>>>>
>>>> <2c>
>>>> Feels more like enablement than a fix to me.
>>>> </2c>
>>>
>>> I added it because
>>>
>>> Documentation/process/stable-kernel-rules.rst
>>>
>>> L24  - New device IDs and quirks are also accepted.
>>
>> Thanks. If I was aware of that, I had forgotten.
>>
>>> So, really, up to the maintainer whether they are fine with it being
>>> backported to stable releases or not. I don't really mind either way.
>>
>> Yes, I completely agree.
> 
> IIUC you are here mixing Fixes and Cc tags, if you want to get a commit
> to stable releases there should be "Cc: stable@...". So I'll remove the
> Fixes tag and add the Cc tag, ok?

Yes please, thank you!
