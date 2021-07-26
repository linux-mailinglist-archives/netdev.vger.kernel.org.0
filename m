Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DA63D5DFC
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 17:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbhGZPEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 11:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbhGZPEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 11:04:30 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C271C061765
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 08:44:59 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id r6so12404015ioj.8
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 08:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pbRvFeE3V8H7xDoGykMRI3aEDOBUlE9euyeCQx8JWcU=;
        b=ZLPTBrBaqdFweht2hYWT414CbI1wA994+4yGI5mDqtyzYoYttzxRJOUkULAtmnvu0S
         sQAQ85ltSEVq94oC4e7vInWp4wFALfZ0AB2EXpL89NR2eEEzXBcJJ4QVVCS8IfpIlvji
         ABHdaebki48MiXLSArnt77v6H9NhzXaeVqgrY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pbRvFeE3V8H7xDoGykMRI3aEDOBUlE9euyeCQx8JWcU=;
        b=pW2aKRrDRfhpCv3TnWMDcJJNAGe0LOnC7lH1CR4rF4XiDMcJyIShLP/T4/Mhr2KaTP
         9gY87wV/j3COZAFE23/VdXYtAF/WGIWdX477/uJrG/Xecyoa/D8o2iECiLhkx2Q4Ifkc
         XlCemNwqZg4j8Z0C0gHdFudM0HhGX5KthvMtFk7Bm6ot+Z4/go/buRAt66t4tDGv0X8L
         5+cwZIjTmUXDTiJ7knOs3XOciKcD8UBKi5R5TMzluRfwWw2GPiJ2KT8f9fz7rz+CwCS6
         Mj+EldADGTdwlDUgWVfoYYouvvlQMrTgq/cZ9XMvhl6YQC+dPG+nfY0GeKR4365rrXmC
         wivQ==
X-Gm-Message-State: AOAM532TKMysfXOiFJqEJkrJ69Qk5br+0UHGAk3/9D6cuSBbW/iKpjQe
        M3QjhDnNK3v4eMHFgstBSf6YxQ==
X-Google-Smtp-Source: ABdhPJwbAAipgxvf4CJ2zY0+vEwMgJvuywJpYy7Riel+0d9+gmasyJdYUyXwDFsmxESgFmkuj7qepQ==
X-Received: by 2002:a6b:c90f:: with SMTP id z15mr14867286iof.183.1627314298767;
        Mon, 26 Jul 2021 08:44:58 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id i4sm122034iom.21.2021.07.26.08.44.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 08:44:58 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] arm64: dts: qcom: DTS updates
To:     Bjorn Andersson <bjorn.andersson@linaro.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Alex Elder <elder@linaro.org>, agross@kernel.org,
        robh+dt@kernel.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210719212456.3176086-1-elder@linaro.org>
 <162679080524.18101.16626774349145809936.git-patchwork-notify@kernel.org>
 <YPby3eJmDmNlESC8@yoga>
From:   Alex Elder <elder@ieee.org>
Message-ID: <01beb264-0f25-fb50-29fc-15b6941de422@ieee.org>
Date:   Mon, 26 Jul 2021 10:44:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPby3eJmDmNlESC8@yoga>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/21 10:59 AM, Bjorn Andersson wrote:
> On Tue 20 Jul 09:20 CDT 2021, patchwork-bot+netdevbpf@kernel.org wrote:
> 
>> Hello:
>>
>> This series was applied to netdev/net-next.git (refs/heads/master):
>>
> 
> David, Jakub, can you please revert/drop the two "arm64: dts" patches
> from the net-next tree?

David, I intended for this series to go through the Qualcomm repository
rather than net-next, to avoid any conflicts with other updates to the
affected DTS file.  The only indication I made was by having you and
Jakub in the "Cc" list rather than "To" list; in the future I will be
more obvious in the cover page.

Would you please revert the entire merge, so that these commits can
go through the Qualcomm repository?  These are the commits (in order):
   6a0eb6c9d9341 dt-bindings: net: qcom,ipa: make imem interconnect optional
   f8bd3c82bf7d7 arm64: dts: qcom: sc7280: add IPA information
   fd0f72c34bd96 arm64: dts: qcom: sc7180: define ipa_fw_mem node
   b79c6fba6cd7c Merge branch 'qcom-dts-updates'

If there is another way you think this should be handled, please
explain.  Thanks.

					-Alex


> 
> DTS patches are generally merged through the qcom and ultimately soc
> tree and I have a number of patches queued up in both sc7180 and sc7280
> that will cause merge conflicts down the road, so I would prefer to pick
> these up as well.
> 
> Regards,
> Bjorn
> 
>> On Mon, 19 Jul 2021 16:24:53 -0500 you wrote:
>>> This series updates some IPA-related DT nodes.
>>>
>>> Newer versions of IPA do not require an interconnect between IPA
>>> and SoC internal memory.  The first patch updates the DT binding
>>> to reflect this.
>>>
>>> The second patch adds IPA information to "sc7280.dtsi", using only
>>> two interconnects.  It includes the definition of the reserved
>>> memory area used to hold IPA firmware.
>>>
>>> [...]
>>
>> Here is the summary with links:
>>    - [net-next,1/3] dt-bindings: net: qcom,ipa: make imem interconnect optional
>>      https://git.kernel.org/netdev/net-next/c/6a0eb6c9d934
>>    - [net-next,2/3] arm64: dts: qcom: sc7280: add IPA information
>>      https://git.kernel.org/netdev/net-next/c/f8bd3c82bf7d
>>    - [net-next,3/3] arm64: dts: qcom: sc7180: define ipa_fw_mem node
>>      https://git.kernel.org/netdev/net-next/c/fd0f72c34bd9
>>
>> You are awesome, thank you!
>> --
>> Deet-doot-dot, I am a bot.
>> https://korg.docs.kernel.org/patchwork/pwbot.html
>>
>>

