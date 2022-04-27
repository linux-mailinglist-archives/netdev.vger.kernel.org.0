Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386C4511FB7
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242302AbiD0QQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242878AbiD0QOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:14:38 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B55740DC94
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:09:44 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id bd19-20020a17090b0b9300b001d98af6dcd1so5369960pjb.4
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3YNqFR8noR736LtRHihRxBj49EsCpoO8u5l7SY4VZvY=;
        b=PbV71gMQpaq1XwPAj95hEOHFslDlM13BLnsFm0Op2njYvn0K0xuoG2/twsyuXtHIfX
         Th+9Xt/RSi8vblOCeF2AXtSNN1DCue79MtE6zLbH3O4zOl9UIqG7GrxdKiIVwc/e024e
         OMb5yjHx13bepexVE20MwqnA0lBQfBwhk6aOTUNjsNLBdhzxKjXcH5gwwXDxPuSWaPI2
         25X8W8PjsR12BeQgVo7CpwBZ7dU3B7clRBLNHaErS85jLL4wQIGAC+sf6a33WbLQSD1l
         Li05QVdT/3BfOPScIfM0q339QSgLMvFD1tX37vCjJrNYYMSqu8Ea9qhvCEcuinZ1jj35
         GwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3YNqFR8noR736LtRHihRxBj49EsCpoO8u5l7SY4VZvY=;
        b=TWZdzUWCGaHEelRrtbcBWhhDgtIJHuryPm3Fko3/kFoa26cJ1h+chnIYQUNALeR6yB
         SSo8oIrT+yhU9JERPENXJB9VX9Ub4dGdL1nZnvJjUbkAoYYyyHuCH6L3uNQPaXU2wDvv
         /IK9RnwKMBLwpSadj6UnJsdLiNfO3VTi9Px4ExGlGUKlYgDnKJQd1cKSvmNQrzuTB0O2
         4Mt7wIqBpsCkhnAp8/MBT4cpd0OYy4ckZ8bitoyr7dyZNpVVZmz3Vnsx3/qsswBtE40J
         trvMjDzK5ZPbRj3YaAZ13d69i95WgXRA4hiDL4KxeuFBFgqRDmZ3A5xdmVMeUzyOKqAd
         MF0w==
X-Gm-Message-State: AOAM530YcAIZPUxDGRtYlHp7ratbH9Wk/VB1d8lkBC5GefqGF6xR4jFO
        8WY0Mitu/7yYMjXkXQD4AWY=
X-Google-Smtp-Source: ABdhPJwp5H79hcsB0/li81KS9IIVxqHu29qVAm7HpcArsKMK0+lMTVZ8tgYqcA8SBFNaL6Li5XoWJA==
X-Received: by 2002:a17:90b:4d82:b0:1d9:5c18:b749 with SMTP id oj2-20020a17090b4d8200b001d95c18b749mr21215064pjb.27.1651075778257;
        Wed, 27 Apr 2022 09:09:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n12-20020a17090ade8c00b001d25dfb9d39sm7505647pjv.14.2022.04.27.09.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:09:37 -0700 (PDT)
Message-ID: <56654c2f-d144-5bcf-0d2c-db3f891169cb@gmail.com>
Date:   Wed, 27 Apr 2022 09:09:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 08/14] eth: bgnet: remove a copy of the
 NAPI_POLL_WEIGHT define
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, rafal@milecki.pl,
        bcm-kernel-feedback-list@broadcom.com
References: <20220427154111.529975-1-kuba@kernel.org>
 <20220427154111.529975-9-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220427154111.529975-9-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/22 08:41, Jakub Kicinski wrote:
> Defining local versions of NAPI_POLL_WEIGHT with the same
> values in the drivers just makes refactoring harder.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Looks fine, however this is a new subject prefix, do you mind using:

net: bgmac: remove a copy of the NAPI_POLL_WEIGHT define

to be somewhat consistent with past submission? With that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
