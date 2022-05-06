Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58AE51DE40
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377312AbiEFRVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237371AbiEFRVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:21:16 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988274F465
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 10:17:32 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso7397961pjb.5
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 10:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3aGQD+TPJjdgVH2l0L30KOa3TpZnrckIwUjFO1cFGYE=;
        b=lW2gDRveYM1R9uX7XurI8BuRjzEEQ1u4BFlMYCKx5MXqYxcfZb0oa1RiQtW9aPtY8I
         Q2aTAkDyKbZTMWiZC4qYsgnAB5Wd0mAUk3qvpk8mn9lyK/CFvf5k8LYuCLQyWHQTF63s
         evA4PQfXbsfdj6UivndqCvNqN3bcLoZktjC3kf35LJ1dJzCnXw0y5djbWMG3fN7pzoys
         lKV+Hddmm8i4O44DUsCa5ydRHk7SEehyGhORx96m76QPXFkhk0QU4SZs3ia6x/UXzOig
         SkjqdcKCA3Bt8a3y6/+Hqoys+QyIyIQgsoTZOAovQ/eOzfAHFDumbOkk/4GYoFTWcLgD
         WLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3aGQD+TPJjdgVH2l0L30KOa3TpZnrckIwUjFO1cFGYE=;
        b=t18uBJRA9PHrY3wiNKyu2a17N/aASU73nOh41Trn5L5lA5U9ZBOpsGYq0Z7E9aIXCA
         m9QudKL+Mt4wA8UnVNU3u7NrTqsOPyOF9GtJHtX4mL9warsIzn+5oJi4eoYYP2E17bBR
         msBQhfCRV7G4Z+NGNM2b/IAKo7whuJSXvt2MLgMvd6DkM5pu0SUiXWab8sdJiov/zb53
         B8m7QlCE9sIaOktjGxycXoi0GTJlt/CAPqxEhEEzK015S6GUq1xcjOWEqGw58b0DZbfx
         DPmnSQUm5JLUWmcP+DpHE1DSKmfudxgfDkSOMANqK/A1vChCeu8WVImVO4BVtsnuNIUA
         KUFg==
X-Gm-Message-State: AOAM533k277CvIWJHNbY26dEfpGZLBEcbwgMAkpoz1u4Kx72Acz98PgV
        W+gggBkmj7mSYqeNL/+wWsY=
X-Google-Smtp-Source: ABdhPJxDSwfh59hLADp3FsOlK/sax9e7TVeTmebb+LvP0goxbshSLiucGyD11nW5KVpdksnc35Xa/w==
X-Received: by 2002:a17:90b:1e05:b0:1dc:575e:6211 with SMTP id pg5-20020a17090b1e0500b001dc575e6211mr13259095pjb.120.1651857451985;
        Fri, 06 May 2022 10:17:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pj11-20020a17090b4f4b00b001cd4989ff70sm3835821pjb.55.2022.05.06.10.17.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 10:17:31 -0700 (PDT)
Message-ID: <ed3c3eec-a79d-0d8a-09ad-4a2c6c5507eb@gmail.com>
Date:   Fri, 6 May 2022 10:17:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v3 1/3] net: phy: broadcom: Add Broadcom PTP
 hooks to bcm-phy-lib
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, richardcochran@gmail.com, lasse@timebeat.app
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
References: <20220504224356.1128644-1-jonathan.lemon@gmail.com>
 <20220504224356.1128644-2-jonathan.lemon@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220504224356.1128644-2-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 15:43, Jonathan Lemon wrote:
> Add the public bcm_ptp_probe() and bcm_ptp_config_init() functions
> to the bcm-phy library.  The PTP functions are contained in a separate
> file for clarity, and also to simplify the PTP clock dependencies.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

This could really be squashed into the next patch since you do not 
introduce the ability to build that code until patch #3.

I would also re-order patches #2 and #3 thus making it ultimately a 2 
patch series only.
-- 
Florian
