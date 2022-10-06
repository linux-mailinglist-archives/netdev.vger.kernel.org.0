Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDC85F63D3
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 11:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiJFJxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 05:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiJFJxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 05:53:12 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE007C19E
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 02:53:11 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 130-20020a1c0288000000b003b494ffc00bso2492002wmc.0
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 02:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bphhd7Awjoc3NQEdFzDoMtlMg4bRB53D4Ma5ph57UZI=;
        b=dXZHuzJLesvnQWC50z+mtCOvj3LddKIG4R4mMBwIK8xsJyS3yVBqSj1bu3Lbvgk4hD
         oI68XRc7AdXxc6KQaHuzHDlMMhePNYralOXgtfymdynVP8fXpeCxTg2jE61zYKRS2DrW
         yjX8XLgaYtq2yalXgJVkSYBfNA6ZU7MY82T3C0UK1xaXhylqRvSCxXuNZotrGN5ZaVJ1
         JgjLZir4swp/i0HxPAgBlCdQw2El9/0lemVu8DCmt4rm8N80kqp5qvzfJSzVGJ1W/Tet
         ey87EyW1Fmdhf1uk3pG6Z1TrZbzX6GjT9egMTkitGbMibIUHZAaH0bOlGe0n5YNvXlX0
         XP/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bphhd7Awjoc3NQEdFzDoMtlMg4bRB53D4Ma5ph57UZI=;
        b=YPulHkT9FrLqt+inrSSqJ3XHfv+VYGUrdw8wm/M7bG6OdPS7UihqFPBmnNZqbifSHw
         lZ4RswjhYlZM4qcHUtnonoQ/D2N7q3NAs3x99tW8xOGdpStz7+BeiMnSXZvNXU/VsrJh
         PLjoUlCNg5UhVwbTbeFdfbOFOt7YxyozDqAl8sv2GaX7Mth7Bo7aUJQg5afwiZJ7QdaV
         7+D7OCWMF/k43ZalCrMOlZoYnllV+OBX2Q9KFT/otpLxcpC7u0OMwrMw2hGRJ1dK0RbS
         jKXxTiV+7gmOL0soO59bEmc9aw5GePKctDRpE9ymGTP7NvcKdq3zbqSy8aItAyccMN52
         qU2g==
X-Gm-Message-State: ACrzQf2SBr2fQz2mHPqfzokA/O0EyZrgcv75JsJ4a+Y9xXZ01gcsCzm9
        eyfiF7fZDmetLOJOaIN9nVE=
X-Google-Smtp-Source: AMsMyM4Rr0FtaXU4yfYbLSrLea69JEurRGvEGTTfGk9kuQBGdy4pxf4urc2Fr4c9eQdIIAZkz3rsGg==
X-Received: by 2002:a05:600c:2b88:b0:3b4:8680:165b with SMTP id j8-20020a05600c2b8800b003b48680165bmr6513091wmc.113.1665049989792;
        Thu, 06 Oct 2022 02:53:09 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id h10-20020a1c210a000000b003b4935f04a4sm6313585wmh.5.2022.10.06.02.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 02:53:09 -0700 (PDT)
Subject: Re: [ RFC net-next v2 2/2] net: flow_offload: add action stats api
To:     Oz Shlomo <ozsh@nvidia.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20221003061743.28171-1-ozsh@nvidia.com>
 <20221003061743.28171-3-ozsh@nvidia.com>
 <0d15ac22-df7f-241a-52eb-a6dcf0a67385@nvidia.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <c3868497-a299-3796-fe79-439dfb0653d2@gmail.com>
Date:   Thu, 6 Oct 2022 10:53:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0d15ac22-df7f-241a-52eb-a6dcf0a67385@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/10/2022 09:22, Oz Shlomo wrote:
>> @@ -588,6 +596,8 @@ struct flow_cls_offload {
>>       unsigned long cookie;
>>       struct flow_rule *rule;
>>       struct flow_stats stats;
>> +    struct flow_act_stat act_stats[FLOW_OFFLOAD_MAX_ACT_STATS];
> 
> Apparently this array can exceed the stack frame size for several archs (reported by the kernel test bot).

Seems to me like yet another sign this array shouldn't exist in the
 first place and you should be calling a driver offload function per
 action and not trying to squeeze all this through the existing
 flow-rule-centric API.
Why can't the action stats be stored in struct flow_action_entry,
 inside struct flow_rule?  Then, if you really want a single call
 for performance reasons, action-stats-aware drivers could just walk
 through flow_action_for_each(..., &flow_rule->action) and update
 each action's stats based on action->act_cookie.  That should still
 allow proper shared action handling, and seems far more elegant
 than this array.  (Any time you have two arrays and there's a close
 connection between a[i] and b[i], that's a good sign one's elements
 should be a struct member of the other's, rather than them being
 tied together only by index.)

-ed
