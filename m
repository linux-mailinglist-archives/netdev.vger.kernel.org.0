Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6654ED03D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 01:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiC3XmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 19:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiC3XmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 19:42:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332DD59A79;
        Wed, 30 Mar 2022 16:40:28 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so1867666pjm.0;
        Wed, 30 Mar 2022 16:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ESNpQhzFSLsOcth58annqGYG18Nay0vUW1K+23pWJtA=;
        b=XISyYeGgzdKF8UVxXO+7u26KDVp17Fl9ATmlBo7Byz7vZI6aHQnhDPwvJNRXREVQ+E
         5t5KAgwoKJRqC2P1TndECW3XGy+2PLJQExOYL7wOU0o3sAmZulMveCdCWHH27XwNcGvj
         wi/Y0a+xe+4phvUX/6gdbUPif7qDKuzW/Im69e944WnpMTJbdR5nqIbjxU1cDCSdFbnS
         nB5h1zvF0ZDg8V7DI1o17crsv4j6kC+eBN9Pi42ju5UcJO1hvqKE1vlUSBSc1VF6rad6
         SH9AnRM1Uy6f4+KvowvQQ1+/CqWFiV9a2PFLv3WWXSuIdmEMPMHhY9V81lyFvIiFGC7X
         ZPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ESNpQhzFSLsOcth58annqGYG18Nay0vUW1K+23pWJtA=;
        b=taRfaKRsJtHN6BHms+cZS1KYALnbnvamjrW8GWy7hngEd0zIzmhWnFYwbW36TcG++A
         1q0njmg/zJdSz6shxKTgomL15fPNg1a7+NrzVwlemQb/rwFbvjbBWCXtydLqS6yvp8iY
         0MD/+a4dRPBAy+/Zz+XFNnrhG4MvfZ4JL4wBwW7ozzQuol/Q0ZRZPKi5F3kfA/z2PqZK
         3tAeFt39bRSVne+0AIEQwy3hLQv8eQjFRtxxVAMQDo8CM24sF29mP8DG2Bmd7UEhmSbd
         B2RE650zDf4X5WLxJuAfwmqosErh8qx5G3vtn7uiC/MhveAwu7JYC82Me5XosVZQfhdF
         vKag==
X-Gm-Message-State: AOAM532aowspeD9sMYA2s8oBtu0N6/wpCjcyt4EWIwemDmw53unlu1/3
        fLFP54TftITRc6iPHsapOfM=
X-Google-Smtp-Source: ABdhPJzijuWQmZqQ+YXRg4Y6AH8a2MzUA94cNLI5J1zE6HtWoOfwXcFWwLdNnZBUvM6pqce98I7MzQ==
X-Received: by 2002:a17:90b:4b89:b0:1c8:105a:2262 with SMTP id lr9-20020a17090b4b8900b001c8105a2262mr2488044pjb.225.1648683627664;
        Wed, 30 Mar 2022 16:40:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h2-20020a056a00170200b004fae65cf154sm24808745pfc.219.2022.03.30.16.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 16:40:26 -0700 (PDT)
Message-ID: <620db39a-d634-9a35-26b2-d348953482d9@gmail.com>
Date:   Wed, 30 Mar 2022 16:40:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net v3 08/14] docs: netdev: rephrase the 'should I update
 patchwork' question
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220330042505.2902770-1-kuba@kernel.org>
 <20220330042505.2902770-9-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220330042505.2902770-9-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/22 21:24, Jakub Kicinski wrote:
> Make the question shorter and adjust the start of the answer accordingly.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
