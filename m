Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160606235D5
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbiKIVay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIVax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:30:53 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226497659;
        Wed,  9 Nov 2022 13:30:52 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso2226978wmo.1;
        Wed, 09 Nov 2022 13:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=InpZuUPAqdLNRZfUvkFqKxqkR/PtlXfF3L7vmxZzkAM=;
        b=o2OxATjDf+ddXmI+ZuHWylIuDNXI/Q3lJI1hgIb5Hw1zNvqU8sPS3yrHEj7/xH1kJr
         KnAIyHlE9RRxhLvGurvT8fOf4SLmodCrLFbhfUUoVN1LmNfsbqy3x+GKEurhn51cYcTO
         4ygzySO3nm6rCI1FHC7Hyw6CQ/+RdEOOt9XS0vOjpWrvTcouSr129TH53UlUc/S229CZ
         /v6Tp0nQvfIjfHNGt3yvUtp0bwAd4qnNwfYYB/7c5itgkPlxoaUIK+UTTw3paZq88+Y9
         sKFxzKzj76BXyW5DUAhZi1FgFSjghhu384isFZpqFoL1GJNQ5sHjDSrZty5WFYJyulRg
         QeGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=InpZuUPAqdLNRZfUvkFqKxqkR/PtlXfF3L7vmxZzkAM=;
        b=YdmoCSfwE9vZa0UnyO1C65/rsiRRNdGW5IIDoIvwAaDzw+Be/XHkAeLMtNbtn6zlQo
         5nS3Gz/sinKE1itiFDgrIoA3Od8clv9x+yRg0ct6bcJnivPAu77w1EnbuEY6LnR/SUZu
         A9oVj32iQ0I3RCHfizrff0h/kl2FY5lwlI6j/plVpqPJ5ASW/9cO6krSm9WfDn4oAEC6
         8W1EUumx5xB16JVdloMn4z3gh4hyosk3jaFZ3M1U3qlNYZQmB2jI4UEDWLEGiDSXPAb2
         /55J0vtY+RRfUvCLGYqIyimWeE8vQlRMrEgk+ga8JjDlUylN+FZR6t8cROBmp91ufbYx
         kgBw==
X-Gm-Message-State: ACrzQf3T1sGfG5LitNRi4aLX/kTMblfCGSZaFPr/ArayVPlOcUMlnnPK
        H1DeH74XTeGOOZwq6CP8lGw=
X-Google-Smtp-Source: AMsMyM7Xg0MQAqTploaku9/TLb3oH1G1wJzYoLJf+jJZ3pmA1+Corva73B/qa9wvKlcZ7YytJnh4qg==
X-Received: by 2002:a05:600c:491c:b0:3cf:7336:8704 with SMTP id f28-20020a05600c491c00b003cf73368704mr34363578wmp.101.1668029450528;
        Wed, 09 Nov 2022 13:30:50 -0800 (PST)
Received: from 168.52.45.77 (201.ip-51-68-45.eu. [51.68.45.201])
        by smtp.gmail.com with ESMTPSA id e8-20020a5d5948000000b0023657e1b97esm14304813wri.11.2022.11.09.13.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 13:30:49 -0800 (PST)
Message-ID: <ac1d556f-fe51-1644-0e49-f7b8cf628969@gmail.com>
Date:   Wed, 9 Nov 2022 22:30:46 +0100
MIME-Version: 1.0
User-Agent: nano 6.4
Subject: Re: [PATCH 3/3] Bluetooth: btusb: Add a parameter to let users
 disable the fake CSR force-suspend hack
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, luiz.von.dentz@intel.com,
        quic_zijuhu@quicinc.com, hdegoede@redhat.com,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, Jack <ostroffjh@users.sourceforge.net>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <20221029202454.25651-1-swyterzone@gmail.com>
 <20221029202454.25651-3-swyterzone@gmail.com>
 <CABBYNZKnw+b+KE2=M=gGV+rR_KBJLvrxRrtEc8x12W6PY=LKMw@mail.gmail.com>
From:   Swyter <swyterzone@gmail.com>
In-Reply-To: <CABBYNZKnw+b+KE2=M=gGV+rR_KBJLvrxRrtEc8x12W6PY=LKMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_HELO_IP_MISMATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2022 21:49, Luiz Augusto von Dentz wrote:
> Hi Ismael,
> 
> On Sat, Oct 29, 2022 at 1:25 PM Ismael Ferreras Morezuelas
> <swyterzone@gmail.com> wrote:
>>
>> A few users have reported that their cloned Chinese dongle doesn't
>> work well with the hack Hans de Goede added, that tries this
>> off-on mechanism as a way to unfreeze them.
>>
>> It's still more than worthwhile to have it, as in the vast majority
>> of cases it either completely brings dongles to life or just resets
>> them harmlessly as it already happens during normal USB operation.
>>
>> This is nothing new and the controllers are expected to behave
>> correctly. But yeah, go figure. :)
>>
>> For that unhappy minority we can easily handle this edge case by letting
>> users disable it via our «btusb.disable_fake_csr_forcesuspend_hack=1» kernel option.
> 
> Don't really like the idea of adding module parameter for device
> specific problem.

It's not for a single device, it's for a whole class of unnamed devices
that are currently screwed even after all this.


>> -               ret = pm_runtime_suspend(&data->udev->dev);
>> -               if (ret >= 0)
>> -                       msleep(200);
>> -               else
>> -                       bt_dev_warn(hdev, "CSR: Couldn't suspend the device for our Barrot 8041a02 receive-issue workaround");
>> +                       ret = pm_runtime_suspend(&data->udev->dev);
>> +                       if (ret >= 0)
>> +                               msleep(200);
>> +                       else
>> +                               bt_dev_warn(hdev, "CSR: Couldn't suspend the device for our Barrot 8041a02 receive-issue workaround");
> 
> Is this specific to Barrot 8041a02? Why don't we add a quirk then?
> 

We don't know how specific it is, we suspect the getting stuck thing happens with Barrot controllers,
but in this world of lasered-out counterfeit chip IDs you can never be sure. Unless someone decaps them.

Hans added that name because it's the closest thing we have, but this applies to a lot of chips.
So much that now we do the hack by default, for very good reasons.

So please reconsider, this closes the gap.

With this last patch we go from ~+90% to almost ~100%, as the rest of generic quirks we added
don't really hurt; even if a particular dongle only needs a few of the zoo of quirks we set,
it's alright if we vaccinate them against all of these, except some are "allergic"
against this particular "vaccine". Let people skip this one. :-)

You know how normal BT controllers are utterly and inconsistently broken, now imagine you have a whole host
of vendors reusing a VID/PID/version/subversion, masking as a CSR for bizarre reasons to avoid paying
any USB-IF fees, or whatever. That's what we are fighting against here.
