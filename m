Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B5657A0F9
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbiGSOPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbiGSON4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:13:56 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FE84D831
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 06:39:33 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id v5so240899wmj.0
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 06:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KONa5hhvN+GEcaKOh6NGQ1A1+67pCrrMmeNhx6n3Awc=;
        b=L6bdzKh4BCXFgcN2hmfTS05h7DDQzFbqye8n8wviCQ1qAC91KYU+wpXZ91mpV35LX/
         WZrjyghZRaQzQkwh5jUJ9tVisHzBtu6O18ESJe86fGSVpz4ezEsh+iWC8Spwr2vIPzdx
         XHjBkVoEZ4NVYa7FKED7BrU4C7xvtMt7yxw1c32oCRRJfxjca4ggjtqhhBu/juwgY78Q
         5scDQz1wIzywOgX6QAWikP704nOZupx2bdu0N9+8eCMfIo9li8IR25so4pTCCYKqGGCd
         oFFQOi1+taSFpsdi8inEiz3s89n4juBA4I/jKzxOyWHKslxsBeKeP4jRMSWh7oReBOr8
         VYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KONa5hhvN+GEcaKOh6NGQ1A1+67pCrrMmeNhx6n3Awc=;
        b=UIjggB1rGSQO6BFkjmKQH7espwBXig4J74uW2YWV3M9l0a4VMWPjqJEy1iGrYfHQl5
         StQGtKwKEfC1IaxTlGUzSirSkmVrnT0Y2AqDOCPVDKpbsSx7xvpoqi6ThXQCnwKzDA/h
         jYuVGfi0Tb4lz3iU2PYw+3Zs46PIKN8gewvfjw3hZcYKDMoChtMo9J8dpf2H0qAOzjQI
         hi5NS1DeghhwyMUOfyn4OXrfjuvaZKVLu4FDPU8+T6SldSIjpIqQDbxlf+gEhXlLHTYB
         Q2M6VnVAHP8B/NbUwa8Dafrct1dxwvqcn4nPw1bhqcBN2HNnbXfbkBfdvzVVvKYZoJKZ
         JsOQ==
X-Gm-Message-State: AJIora/bEzukLp0QFOxRmgRD224wHNdJH82BSSKXnp5HOPPRqQUEELkA
        jythci36xKfQa3UQty+gpywhYw==
X-Google-Smtp-Source: AGRyM1tdgUzR+4E5x+hP9vrrMXDkfYFgyHt78xLXzr2wJynVMOUq+N3uDGE1R+5+9sCcV6t5AZOnPA==
X-Received: by 2002:a05:600c:4f48:b0:3a0:45dd:8bd5 with SMTP id m8-20020a05600c4f4800b003a045dd8bd5mr37810429wmq.80.1658237972187;
        Tue, 19 Jul 2022 06:39:32 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id a15-20020adffb8f000000b0021dbac444a7sm13546186wrr.59.2022.07.19.06.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 06:39:31 -0700 (PDT)
Message-ID: <6a20c273-d6f3-4e69-3de6-9d6b44a1b29d@linaro.org>
Date:   Tue, 19 Jul 2022 14:39:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 0/4] wcn36xx: Add in debugfs export of firmware feature
 bits
Content-Language: en-US
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20220719121600.1847440-1-bryan.odonoghue@linaro.org>
 <CAMZdPi-TUafosjJ_pwQ4F-N3WnnM5_0P7snB1qmgmzBeqkZu3A@mail.gmail.com>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
In-Reply-To: <CAMZdPi-TUafosjJ_pwQ4F-N3WnnM5_0P7snB1qmgmzBeqkZu3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/07/2022 14:06, Loic Poulain wrote:
> Nice, but why prepending with 'FW Cap = ' string, we already know it's
> a list of firmware features.

I literally just copied the debug printout which also prefixes with FW Cap..

I can drop
