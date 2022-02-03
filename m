Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3872B4A830A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 12:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240602AbiBCLW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 06:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240206AbiBCLW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 06:22:27 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615DBC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 03:22:26 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id h16so2227923qvk.10
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 03:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VFgYrjPaXbaCyhiJtjuKM14hRfwmOgSRClt+H9UQLmM=;
        b=Rs0L00p9DTqKBRCpB5LQwSRqcoStwt4JefJjetRROuDj99tI4OJD14ySouAxTzRCx5
         hiUmfmcqoEW5sXcI/8d2+lekHOzMEoHAkXfT/ePaorxBq+3tiO0cCvl+4PQ5QwOt/vlG
         D1MYEkgg5VEzuZQPUPss1HOxHTTUsNvAQV4lKgp8aSczf8qiLNe6bjKrx6vZjIlSyA4a
         l6OPGgpIvAurUPA+yfMIeH4jquVSnVRkAvoy66PJMFvLyOyPS72ouOo+gQHk81V0hIqN
         pS5JY6xaVH2H0fbZkbSMUW3j+LCt5hWMrpeY7KqNIOGOHVPPgsJz5ihI+tSAmlhQnpvJ
         K0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VFgYrjPaXbaCyhiJtjuKM14hRfwmOgSRClt+H9UQLmM=;
        b=8MuQHC9GtVNOJseIqnfcWaZSeCDC4L9x5KUMkzFIiPqf6Icb4JJnmEOh8EK3lnbYO0
         kJ8/gnxxwk9UB1sdD0sXb9DhmnHa+wjFQuv7mlujTk2XyvsV52cfELfDkdWkRAZDrHpG
         S9v0ZeuldOeFILpncOaUPQAp4Uo2IOM51mS59jwteTDQDrRtU4AX/X6eB6LWERexvaHj
         jHUFse4U7khvg6stJyozJCudF6wSc+v+XF6IhOdGoEB77zGqCmLpshQ2YvbQNH2WPq0d
         V5ipWgFxlaiHo59saH9nHV4W3YqtPgqlHgkmaLHkaxhpOASO/WwVW5ba9oDocpiDj4HY
         reBQ==
X-Gm-Message-State: AOAM532cXkBbrSnSVeuf6PY5vzNMr/cdI/VlrgtGYBkJlk+RaeJFMIGf
        pc9PWuMl7IjmInvK/Eim/xkN3CB1L1Q4HzcJ
X-Google-Smtp-Source: ABdhPJzKYiRB01G1IrJ36Wu5AeAMpjN8WUwgRuzoB5Tjgwh1/Ur32+CaEBwWaGPCMhSAfOe37748/g==
X-Received: by 2002:ad4:5969:: with SMTP id eq9mr30207343qvb.93.1643887345503;
        Thu, 03 Feb 2022 03:22:25 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id c14sm12586791qtc.31.2022.02.03.03.22.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 03:22:24 -0800 (PST)
Message-ID: <6d303dbb-bdbc-bac1-526d-be593f329d23@linaro.org>
Date:   Thu, 3 Feb 2022 05:22:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net 2/2] net: ipa: request IPA register values be retained
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, robh+dt@kernel.org,
        bjorn.andersson@linaro.org, agross@kernel.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220201140412.467233-1-elder@linaro.org>
 <20220201140412.467233-3-elder@linaro.org>
 <20220202210248.6e3f92ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220202210248.6e3f92ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 11:02 PM, Jakub Kicinski wrote:
> On Tue,  1 Feb 2022 08:04:12 -0600 Alex Elder wrote:
>> Fixes: 2775cbc5afeb6 ("net: ipa: rename "ipa_clock.c"")
> 
> The Fixes tag should point at the place the code was introduced,
> even if it moved or otherwise the patch won't apply as far back.

The problem was not "activated" until this commit:
   1aac309d32075 net: ipa: use autosuspend


And that commit was merged together in a series that
included the one I mentioned above:
   2775cbc5afeb6 net: ipa: rename "ipa_clock.c"

The rename commit is two commits after "use autosuspend".

The merge commit was:
   863434886497d Merge branch 'ipa-autosuspend'


Until autosuspend is enabled, this new code is
completely unnecessary, so back-porting it beyond
that is pointless.  I supplied the commit in the
"Fixes" tag because I thought it would be close
to equivalent and would avoid some trouble back-porting.

Perhaps the "use autosuspend" commit is the one that
should be in the "Fixes" tag, but I don't believe it
should be back-ported any further than that.

Re-spinning the series to fix the tag is trivial, but
before I do that, can you tell me which commit you
recommend I use in the "Fixes" tag?

The original commit that introduced the microcontroller
code (and also included the clock/power code) is:
   a646d6ec90983 soc: qcom: ipa: modem and microcontroller

Thanks.

					-Alex
