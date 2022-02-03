Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7364A8319
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 12:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243664AbiBCL1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 06:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbiBCL1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 06:27:52 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B24C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 03:27:52 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id r144so2800408iod.9
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 03:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0yHWvoIVyRskwxVvMR4JJwddiDqQA33hRIgPIj2/Ibg=;
        b=boGuAuKD1DcIUNXyfWoVTikePU9kREHUYw5iQsooZAnLYmyqHRKJlSKAOecd/gSQVb
         /QIm+Ix3qXzubxkstR5mUGVer9Sf3h2iMv27G1zgZAs5+aYlzOpTYlQroiWBrXo//I3p
         h+NqasxDe4m90nO15qfwQHdyE6r3Tcvv2JBiuRw3Ud0zZhosizU20KvLN3PNeiMPOO33
         FfZfyk81GcU2ozzM39C9QXUoSWpQZdvIXde//BcRzxEhBlWSvwDZSnkhdq8FZwzxX52P
         aSmSM6n58lVN+qh8lsMDHYNhgMr0zYINml23pWGGxNOvi+DzHeZtlHHei1gHn7O3SouC
         otmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0yHWvoIVyRskwxVvMR4JJwddiDqQA33hRIgPIj2/Ibg=;
        b=PjiKSvuGkLbJ5I+Z8FCcXocHC+XpY7ZDl5tm87owZ3OzSUx8CXAbVNvQGn0qfGrVgN
         aHdfgBF56aSV8Otfn5/P0AhywH4clp+jOWkdWI1O3u5m9WDI9aqIpiElxS5xIt2DcuQB
         af0kCnuq4hP/u+2gAL33G7SemUA9WI8fnjcRtYUHbr4ru1WAhStko0CeLvPPqFwKZSjI
         6b7hRfD9T77PP8rnIDDOpiaH7zWSWZ24D1Uex18jcgu0NzyjL/jBZ5VnKLAtt5PTlmTg
         t2r4eTA3OI49VRHHrgE8zlGwaVmy8xmL9iunwwzjWfKA9biQLnPUUUjinCYxfEHObSwA
         Mhjg==
X-Gm-Message-State: AOAM531mDGpgINwAYTguimHRVZVTSOFBMp24YI2i6//b9nMyywHPzQmk
        rRQtrPE5rndZMOb3RLy+8gZg7w==
X-Google-Smtp-Source: ABdhPJyAas9HPXykhr7Zmbjkxob3REfXS6IcM5zxfSyHhuUyaIPcwJZMhN0LFpgC2MPGFU0oWlXR1Q==
X-Received: by 2002:a5e:8406:: with SMTP id h6mr18428130ioj.144.1643887671664;
        Thu, 03 Feb 2022 03:27:51 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id y3sm24576165iov.29.2022.02.03.03.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 03:27:51 -0800 (PST)
Message-ID: <eb09c869-c5c6-4be8-5265-072849f1ecd0@linaro.org>
Date:   Thu, 3 Feb 2022 05:27:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] arm64: dts: qcom: add IPA qcom,qmp property
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, robh+dt@kernel.org,
        davem@davemloft.net, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220201140723.467431-1-elder@linaro.org>
 <20220202210638.07b83d41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220202210638.07b83d41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 11:06 PM, Jakub Kicinski wrote:
> On Tue,  1 Feb 2022 08:07:23 -0600 Alex Elder wrote:
>> At least three platforms require the "qcom,qmp" property to be
>> specified, so the IPA driver can request register retention across
>> power collapse.  Update DTS files accordingly.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>
>> Dave, Jakub, please let Bjorn take this through the Qualcomm tree.
> 
> I don't know much about DT but the patch defining the property is
> targeting net - will it not cause validation errors? Or Bjorn knows
> to wait for the fixes to propagate? Or it doesn't matter? :)

It might matter sometimes, but in this case it does not.

If the DT property is present but never referenced by the
code, it doesn't matter.

The code in this patch looks up the DT property, and its
behavior is affected by whether the property is there
or not.  If it's not there, it's treated as an error
that can be safely ignored.

In the case this fix is actually needed, we'll need
both the code present and DT property defined.  If
the code is there but not the property, it's OK, but
the bug won't be fixed quite yet.

					-Alex
