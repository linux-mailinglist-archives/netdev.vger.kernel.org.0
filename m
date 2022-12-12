Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CB6649E44
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbiLLLzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiLLLzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:55:43 -0500
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE74FF596;
        Mon, 12 Dec 2022 03:55:39 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id n20so27387557ejh.0;
        Mon, 12 Dec 2022 03:55:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9agZglOKPdWwX0fuJjm0Z+bcOfHu+FauaBqawzsErgU=;
        b=QQOMybWZQL7u+hMQ3143TUFYReZDuQZBEqaV/J4yO4alduBlN0CxXiayzdw/Y2ZvqR
         ri6tIUlMWNdROBK769g273cNPKkoBqAnT9OROFHyycZ/r2Z4hVorT3sF1hK9q8hdPNNp
         znaAL+fX4xMgbfCyzf0GfMHg4BcjsCZm6foXi0Pf2zGm26tmgKZBQxiCezMzgEdRDskX
         IB7z7ZYqkTMNbgi45HAf5pQsheZBkE8O1XS+HF/TqutkAOp/H1HTXSr6ord2DsObzCWh
         SFvxXIUJc6Y4/JsCnwlz3OjJ/DDgQkxPZ05ZbyUtFtui7/lusdEwqZQXe5d9BOZE9v+x
         yPDg==
X-Gm-Message-State: ANoB5pk2jybHbg1oLXeYgmTwlvIVH6uM7updY4w3px4tGvoECpRMmSvM
        Waj1XR+pXDBwWL7q1f8mgaivlLPyXKA=
X-Google-Smtp-Source: AA0mqf4ZIX1732j+6YhMn9QhXq8AGAnZTjX5jhF114NHcHM0q0+s9okxNdxs5OhjYtxDzMhQzfnxlg==
X-Received: by 2002:a17:906:8543:b0:7c0:d88e:4b37 with SMTP id h3-20020a170906854300b007c0d88e4b37mr11320312ejy.52.1670846138130;
        Mon, 12 Dec 2022 03:55:38 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id kz21-20020a17090777d500b007b2a58e31dasm3242433ejc.145.2022.12.12.03.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 03:55:37 -0800 (PST)
Message-ID: <5fb6ba13-3300-917a-4e7b-e8b7a1e71e45@kernel.org>
Date:   Mon, 12 Dec 2022 12:55:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] i40e (gcc13): synchronize allocate/free functions return
 type & values
Content-Language: en-US
To:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org,
        Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
References: <20221031114456.10482-1-jirislaby@kernel.org>
 <20221102204110.26a6f021@kernel.org>
 <bf584d22-8aca-3867-5e3a-489d62a61929@kernel.org>
 <003bc385-dc14-12ba-d3d6-53de3712a5dc@intel.com>
 <20221104114730.42294e1c@kernel.org>
 <eb9c26db-d265-33c1-5c25-daf9f06f91d4@intel.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <eb9c26db-d265-33c1-5c25-daf9f06f91d4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04. 11. 22, 21:28, Tony Nguyen wrote:
> 
> 
> On 11/4/2022 11:47 AM, Jakub Kicinski wrote:
>> On Fri, 4 Nov 2022 11:33:07 -0700 Tony Nguyen wrote:
>>> As Jiri mentioned, this is propagated up throughout the driver. We could
>>> change this function to return int but all the callers would then need
>>> to convert these errors to i40e_status to propagate. This doesn't really
>>> gain much other than having this function return int. To adjust the
>>> entire call chain is going to take more work. As this is resolving a
>>> valid warning and returning what is currently expected, what are your
>>> thoughts on taking this now to resolve the issue and our i40e team will
>>> take the work on to convert the functions to use the standard errnos?
>>
>> My thoughts on your OS abstraction layers should be pretty evident.
>> If anything I'd like to be more vigilant about less flagrant cases.
>>
>> I don't think this is particularly difficult, let's patch it up
>> best we can without letting the "status" usage grow.
> 
> Ok thanks will do.

Just heads-up: have you managed to remove the abstraction yet?

thanks,
-- 
js
suse labs

