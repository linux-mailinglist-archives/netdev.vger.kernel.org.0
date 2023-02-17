Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4566E69AC13
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjBQNEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjBQNEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:04:37 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568635BD87
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:04:36 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id f26so467804ion.7
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wdl/SpUPlb/U52R7GvMwyRHh/0Baz6rZpVw8VtW8CnQ=;
        b=XpmbE8Irs3q7xMve6YGTddAjYQxNxTlEKNZkeSOUkHC/u1WyXxgAd0f+75xOrYdnQo
         uXSLCIvn4acIKl7S1dpPjIHVqX9oXnnjMB2iHR51KL2+Fsjem2FQyeWgCOreTxgEL3wh
         hoErY9eHUDB16pBxN44JRqhs1iS7w5VW6bFr2rt9h4d8cEBv367+8L/cNJph4tcuQHi1
         zV8LGS1iJ57U5qAujkFVWZtB25CCBbyWNlSRwRxi9irSP9CO0EXlcavzUzbcvaoExEhW
         KP9NkHblbe8yj7OvX9F54kt3WCmea9+z4HVsMtIoJBqMAin5RQeUPMlpUAGtfuhy7W6S
         oSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wdl/SpUPlb/U52R7GvMwyRHh/0Baz6rZpVw8VtW8CnQ=;
        b=HIjE6EWo0FsVIwx8xuardPgZpGRGLCRGEXaZroXJdtKauVQ+Ze6yXI/BT1279fFvy5
         hKeTrp+r4oimX4gip9ou+/WCq4G0Z3dJYbO6OxfrKaclwXbN02SahbrT3X52ARrQ8XGF
         SWx18ArjnqCemBhD3zQPonygdOaCBpnXcRgyyRzKcTmfMmoxc8LXcC2919tNjzpC+8J1
         Ic0IvssFMKrDMv+UTTiq9MgmwksFgJ4c36exViEP96ELm7pltwi/xWfc0XRrVhnq8brS
         SDSlMZpw6wmCS3mMdS3tCWczsM8Yh+gCswuGbHZcSQK232m/S678ccv0HUwMxleGEg8z
         Gxog==
X-Gm-Message-State: AO0yUKUxMVblrXbV1Lm5XoZS8j2yy1Iy71ZfHpSz0CHNW9+hqs9xo2S+
        IXZKNxLvFKe/GHy1ldnmafr/jg==
X-Google-Smtp-Source: AK7set+jE0uAmbggiM6MP/n4LRSqM7MGZwFBMs6Z7+7XtogVNAj4ucU8FAZ4Byr33K6z0uVOGk8ONg==
X-Received: by 2002:a5e:d801:0:b0:71f:c924:69ba with SMTP id l1-20020a5ed801000000b0071fc92469bamr802567iok.19.1676639075679;
        Fri, 17 Feb 2023 05:04:35 -0800 (PST)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id g4-20020a6be604000000b0074555814e73sm1022471ioh.32.2023.02.17.05.04.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 05:04:35 -0800 (PST)
Message-ID: <a919afca-d33e-618d-5db3-17a08d90e8af@linaro.org>
Date:   Fri, 17 Feb 2023 07:04:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/6] net: ipa: kill gsi->virt_raw
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230215195352.755744-1-elder@linaro.org>
 <20230215195352.755744-3-elder@linaro.org>
 <b0b2ae77-3311-34c8-d1a2-c6f30eca3f1e@intel.com>
 <c76bbb06-b6b0-8dae-965f-95e8af3634b6@linaro.org>
 <4c92160f-b2ea-c5ef-5647-6078ab47e518@intel.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <4c92160f-b2ea-c5ef-5647-6078ab47e518@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/23 5:57 AM, Alexander Lobakin wrote:
>>> just devm_platform_ioremap_resource_byname() be used here for simplicity?
>> Previously, virt_raw would be the "real" re-mapped pointer, and then
>> virt would be adjusted downward from that.  It was a weird thing to
>> do, because the result pointed to a non-mapped address.  But all uses
>> of the virt pointer added an offset that was enough to put the result
>> into the mapped range.
>>
>> The new code updates all offsets to account for what the adjustment
>> previously did.  The test that got removed isn't necessary any more.
> Yeah I got it, just asked that maybe you can now use
> platform_ioremap_resource_byname() instead of
> platform_get_resource_byname() + ioremap() :)

Sorry, I focused on the "devm" part and not this part.
Yes I like that, but let me do that as a follow-on
patch, and I think I can do it in more than this
spot (possibly three, but I have to look closely).

Thanks.

					-Alex


