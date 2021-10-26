Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3554D43B3CA
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbhJZOUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbhJZOUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:20:09 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA069C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:17:45 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id n67so1548828iod.9
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=760ZElop6ZLsQ88z+YqPOpJFTUrugLm2l1ikv3lUPKE=;
        b=cu/RKYxnwzW3x8m/UFGetYR/dPqlR1mmPEFE7NVkJgedNQX1zAonFkRRMpZkTLXmB6
         qMWatzgemSDh25dKIXhJQ8jo+IGA7cREO2B88PbhGVzwB57c4lkwu/HNecHtR7i6uubE
         2By5Ctfba1wIoFYe2rtNrlXkaC7G13kqqhq7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=760ZElop6ZLsQ88z+YqPOpJFTUrugLm2l1ikv3lUPKE=;
        b=JmWfJkO9G812dUNQYauv2sR5iqguRp9yIADtOShMiX+SP9yNm0PiwR0HaRp7N7gxFB
         jZ0U9Eri33+e47qON6GBQtDaY71YTydxTtz5zkb3XGR88yc4zGZSwQhOQIPFiewXqZif
         5rF/XX28UXIHKajDz8c9wMRqIPHftH5mbu6dgSAAZ1R1ztf0X/mVsJsNqb2pGQEFELGW
         YUt+UMmHiflLqGkWoRL9vqoIexr+v72Qfber5lfb280B17uljpbdsWsaPRa+Jo/npMZZ
         lx3OCJv5EuAeSEX52RE2Hm+TS1XWYwi3aFIzL6D4oOt2/j/S8fP+Te8LpdQWtHMsMv6O
         P6Bw==
X-Gm-Message-State: AOAM532Fb1eNjRh6SFfvElMxym4SBe8KnJ43tTzQXocbsXtSC1n35so2
        MkGYvAk/tw2tgn0dWOfr9OHmQg==
X-Google-Smtp-Source: ABdhPJw+vuHb4SnbwrgIFtuOrWJsylVX+xHOd8CFggfyuK3BnxNMbdiCVQJFjmy+HXybBe7wmw0gkg==
X-Received: by 2002:a05:6638:1505:: with SMTP id b5mr16017331jat.99.1635257865169;
        Tue, 26 Oct 2021 07:17:45 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id l3sm4682381ilv.46.2021.10.26.07.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 07:17:44 -0700 (PDT)
Subject: Re: [PATCH 1/2] dt-bindings: net: qcom,ipa: describe IPA v4.5
 interconnects
To:     David Heidelberg <david@ixit.cz>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     ~okias/devicetree@lists.sr.ht, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211020225435.274628-1-david@ixit.cz>
 <05b2cc69-d8a4-750d-d98d-db8580546a15@ieee.org>
 <C9217CCA-1A9B-40DC-9A96-13655270BA8F@ixit.cz>
From:   Alex Elder <elder@ieee.org>
Message-ID: <52362729-032b-e9e2-bbb9-663b1d566b37@ieee.org>
Date:   Tue, 26 Oct 2021 09:17:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <C9217CCA-1A9B-40DC-9A96-13655270BA8F@ixit.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/21 5:11 PM, David Heidelberg wrote:
> Hello Alex,
> 
> it's make dtbs_check (for me with ARCH=arm)
> 
> David

Thank you, I see the errors now.  I am gathering information
so I can fix the interconnect issue for IPA v4.5 (SDX55).

Your other suggested change (increasing the allowed number of
iommus) is the right thing to do, but it seems you need to
specify "minItems = 1" as well to avoid the error Rob pointed
out.  You should post version two of that patch (only), or if
you would prefer I do that, say so.

Another error that shows up is that no "qcom,smp2p" schema
matches.  I'm pretty sure that's simply because the binding
"soc/qcom/qcom,smp2p.txt" has not bee converted to YAML.

					-Alex
