Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5004C575145
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 16:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbiGNO7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 10:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239750AbiGNO65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 10:58:57 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36F725C51
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 07:58:55 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id g4so1816795pgc.1
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 07:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=+w0E9Mzv9UOdvf4/lfE/bl5hp4LDDjOsqau2aqmfLBY=;
        b=VPVJozxaDKIDt3A0Jcb8MP1CNwP7F1N4FLudzxG7b7GQ0JL0S/gT87VQmz9FGtIbDA
         dpLPMXXbAqTBsmB/2qiJSwQpMmnaJ8DmG9NWDiDpoty1g12dMY5SEVF0ZwI+O199360F
         dM6YyHgZTbfvK91Z4Yu9HsGSEGtXSdhQSLSri6Uxa0IIyKC8dlq4MBYR8CmrhDTuGuRP
         bMgumMGzqNNysgyClU6ewDrPF6Z1cFyLzOKRGJtNUWoqimtRaR5+hiEojX+bikBSQ7XG
         mS69vCL24nHThaXxEB+5RWbSYV80/2c66zfQ1ybi84ZIqHyzHbDLMoJkdOJsbRWyZlHW
         4YSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+w0E9Mzv9UOdvf4/lfE/bl5hp4LDDjOsqau2aqmfLBY=;
        b=GlM5TAuyA8BJORjFkcvmRJEHB1jBEgzY9+lMB/JCkey4Vy8OWtoTsz/dFtGYYO/tND
         Q/xgLwxc5dwTOnCCZtohn9zLOWK4oHE4GS2iyGTBZZrdQDMz9/Pfe1ZGG7xY7HM1A5kO
         8rjOCwKJB1zgqVNf1jA4k5kLHGKM0wKhFBEhH1PHnteP4hU13OZz07G4yjjkPsP8fmR4
         9EYSVi1BTlxmK6GPIJ884ka2L8xuYul4FPkPsGd0t1UmzZnK4PFHeYnVZqRRJ6pMMuQd
         ovJf6ho2JClQhnGyVlAMMTK/WUDWt+GEat42+OcQfm/OY+iAxlIZbrUPar4IBNYTEzQE
         mSHA==
X-Gm-Message-State: AJIora9Ym9BF0kOnJxvBi+lnaOAxXkm9Gnwb9Jew69vnPFPW9DXEPmnM
        uZ0tcBTDgLpwFlVvCYyX1QAyQSfJNtQ=
X-Google-Smtp-Source: AGRyM1tyXx+LgoidGKruVWZh68EimrmDQ+Z5PFsugDS44hy9IvoXkD7GY/CuemMl1D+7pNqM39V/CQ==
X-Received: by 2002:a63:2c47:0:b0:411:54ab:97b6 with SMTP id s68-20020a632c47000000b0041154ab97b6mr7905622pgs.173.1657810735374;
        Thu, 14 Jul 2022 07:58:55 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id v11-20020a1709029a0b00b0016bfea13321sm1541149plp.243.2022.07.14.07.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 07:58:54 -0700 (PDT)
Message-ID: <191adc26-28d3-758a-7c9a-53e71a62b0fa@gmail.com>
Date:   Thu, 14 Jul 2022 07:58:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: network driver takedown at reboof -f ?
Content-Language: en-US
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <997525652c8b256234741713c2117f5211b4b103.camel@infinera.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <997525652c8b256234741713c2117f5211b4b103.camel@infinera.com>
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



On 7/14/2022 7:21 AM, Joakim Tjernlund wrote:
> Doing a fast reboot -f I notice that the ethernet I/Fs are NOT shutdown/stopped.
> Is this expected? I sort of expected kernel to do ifconfig down automatically.
> 
> Is there some function in netdev I can hook into to make reboot shutdown my eth I/Fs?

If you want that to happen you typically have to implement a ->shutdown 
callback in your network driver registered via platform/pci/bus, if 
nothing else to turn off all DMAs and prevent, e.g.: a kexec'd kernel to 
be corrupted by a wild DMA engine still running.

There is no generic provision in the network stack to deal with those cases.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d9f45ab9e671166004b75427f10389e1f70cfc30
-- 
Florian
