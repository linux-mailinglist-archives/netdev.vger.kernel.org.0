Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D0119B55E
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 20:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733041AbgDASYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 14:24:30 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:39388 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732435AbgDASYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 14:24:30 -0400
Received: by mail-il1-f195.google.com with SMTP id r5so950758ilq.6
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 11:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vQ2OyByzCNPUOg0UszgwsKtMo04SQLJBapqaLXtjWnk=;
        b=k/jEVm8/97i0AU5APIrMERozBG0z33+ERySRtF6V3Ed8Q/R1ScSNaPjjpir8Lst9Rb
         ITEuS3so5umcVLTXlH354yEcgDJhN4Asbt+qhUmiJS+U3wDVVsbqb0sSH06OyotIYgQ5
         xi4FoJhjl3siq0lVVaDPhFDSDaUiVsnOfHI7XpcSlYbP1dbRVQYGWrpc/SnQ5ykWKSJN
         pBPJxbjV5HVphQJRb2rvcy0yOQBZxef59x3c/eHU/0nvSOPURSLjtoMSXGCVgTC0daRP
         GfMhX/V7fzT7Dwrk1/1KtM83ZC2vFHnZ7FHYB7TkG1wiFMWFWgtoaQ19N0DrwQaWXYyO
         EUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vQ2OyByzCNPUOg0UszgwsKtMo04SQLJBapqaLXtjWnk=;
        b=duBKud4waxVCcuUqCNUldX5YH6751iBvua0oIjfxmq8ad9mmjFo2zy13uTZEfXeKkV
         1Ky9RFHGQakgRWFavl9kmfiuYh+Lngo0Nv9hQiK1DMPqZnWlY90h7JKIfSkfmU0cYFMs
         FEl2cRQIJu/0OLWZbaPWRunEse0cHY7h8xaieQdQ6txe6/bskTk811uHXnVxxbi+iNAV
         8ZbDF3vodqYhjGTlVLSTmDsvt3HYIycoo3QV3pJRZMFuYTUVYrcDLqgefjS+VCUKl3oa
         codF1MVdePdkdCbBhgS7juYSIYqzxq4G67d5QXqgdDYK5/7XE+HIwKaReBT1rWrHBncc
         Re/g==
X-Gm-Message-State: ANhLgQ3MbMwZi89NP84vILfbGsOK9RY05Bk1BYGzYOEKdLQPnfqjGUaE
        ++GTmt1yuAEnNTgsCR2iaGTh+EhhC2xQuw==
X-Google-Smtp-Source: ADFU+vukZGP0hzU64V9y6R8syZHafkHQwCYEAtP1NJmC+l2nXhoJ4SG1gh7oMAqqy7JM3DbiPT4YAw==
X-Received: by 2002:a92:5b56:: with SMTP id p83mr23368972ilb.70.1585765467664;
        Wed, 01 Apr 2020 11:24:27 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id i18sm208082ioh.12.2020.04.01.11.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 11:24:27 -0700 (PDT)
Subject: Re: [PATCH v3] bitfield.h: add FIELD_MAX() and field_max()
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>
Cc:     arnd@arndb.de, bjorn.andersson@linaro.org, davem@davemloft.net,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, masahiroy@kernel.org,
        natechancellor@gmail.com, netdev@vger.kernel.org,
        viro@zeniv.linux.org.uk
References: <20200311024240.26834-1-elder@linaro.org>
 <20200401173515.142249-1-ndesaulniers@google.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <3659efd7-4e72-6bff-5657-c1270e8553f4@linaro.org>
Date:   Wed, 1 Apr 2020 13:24:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200401173515.142249-1-ndesaulniers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/20 12:35 PM, Nick Desaulniers wrote:
>> Define FIELD_MAX(), which supplies the maximum value that can be
>> represented by a field value.  Define field_max() as well, to go
>> along with the lower-case forms of the field mask functions.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> Acked-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>> v3: Rebased on latest netdev-next/master.
>>
>> David, please take this into net-next as soon as possible.  When the
>> IPA code was merged the other day this prerequisite patch was not
>> included, and as a result the IPA driver fails to build.  Thank you.
>>
>>   See: https://lkml.org/lkml/2020/3/10/1839
>>
>> 					-Alex
> 
> In particular, this seems to now have regressed into mainline for the 5.7
> merge window as reported by Linaro's ToolChain Working Group's CI.
> Link: https://github.com/ClangBuiltLinux/linux/issues/963

Is the problem you're referring to the result of a build done
in the midst of a bisect?

The fix for this build error is currently present in the
torvalds/linux.git master branch:
    6fcd42242ebc soc: qcom: ipa: kill IPA_RX_BUFFER_ORDER

I may be mistaken, but I believe this is the same problem I discussed
with Maxim Kuvyrkov this morning.  A different build problem led to
an automated bisect, which conluded this was the cause because it
landed somewhere between the initial pull of the IPA code and the fix
I reference above.

					-Alex
