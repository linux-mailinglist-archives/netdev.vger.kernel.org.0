Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915264A694D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243435AbiBBAlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiBBAls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:41:48 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347C4C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 16:41:48 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id e79so23403225iof.13
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 16:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Z3YfcE0O70ahEFtWdxsdPNPSuf2lkAj+HbIgBHrwfAY=;
        b=z26GnIRJRCu8XOs/4V81gAqzi0BwF3MXwld6alRjs0t1u8ipdm4mmfTqDumgz1JJlE
         Y1jm66QEztAKOjQQblVr0EQQ9Nxl7RkJu6QtM84TBdQw0baCcAv6gPrXw/qU3iy2+pem
         UTkIzDlwSeQV8i0P/yrjpXPa4A9N8CKhCbVDj0g+aJIs8d9UaaVbRNl07o1tx6J/hc8f
         yBbKYOEg7Rpqc0BJeje9BUy9af7HN4OgyDPXvqpGubvfvN6g0/HQHCfanLiAHTke1/kP
         NFnC8CTgKMnPw+Wa7td0pwno59WD5Hfiq8mDaE2Knd9j4KfQ876/XeqW48xQC3Q0dlbB
         uSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z3YfcE0O70ahEFtWdxsdPNPSuf2lkAj+HbIgBHrwfAY=;
        b=efRk7scLvWJDdxO53yKVYZffKZl95rJwCjNeSYodN+FHEy2JsEEtYZCzeMb5WTaY3f
         O6gX2yY3gIWkdtCW8i7rAvUjw1vMHgTf/uHiguWon7aBK7FNcOKwfeO5o9OtKmV5f6rt
         sQsbO0tSt8zIzApnEK+j9z2z8GpLiNXpfhuAFM28XHFScpI3kC/HraDgolDeEeaquP6Z
         pwGLlBBUvuK8MisFm/mQbmYuS9HR8EqA69Abx96rbtItkC+e5uzOvJP3yvyKf/XNnfKt
         hW7wqGkQOCmt4Ja8tPO2nnuFn8Sh/qwr0AGYsumsARcGWgSc99o0w6hgQ0MTbs+lm8GR
         nYgw==
X-Gm-Message-State: AOAM530VKT8ITbzkMTHDOwrv62WiJjqzo9Hkl3BzezF7YN1mt/91eMQf
        YF1PVnUv4lOePTl3bCfruFrYBQ==
X-Google-Smtp-Source: ABdhPJwWXyIZ4cAVqVtlBqGLMNwLZqKGZzkkXchanMNyqg4mOq5LJ2pDJE8nmftAJ+1tFFEGP5H8Ww==
X-Received: by 2002:a05:6638:2050:: with SMTP id t16mr11498892jaj.144.1643762507514;
        Tue, 01 Feb 2022 16:41:47 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k8sm4598520ilu.58.2022.02.01.16.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 16:41:46 -0800 (PST)
Message-ID: <cadf424a-6d67-cfd0-03e8-810233f7712d@linaro.org>
Date:   Tue, 1 Feb 2022 18:41:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: IPA monitor (Final RFC)
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
 <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org> <YeLk3STfx2DO4+FO@lunn.ch>
 <c9db7b36-3855-1ac1-41b6-f7e9b91e2074@linaro.org>
 <20220118103017.158ede27@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <f02ad768-2c8e-c8ed-e5f6-6ee79bf97c06@linaro.org>
 <36491c9e-c9fb-6740-9e51-58c23737318f@linaro.org> <YfnOFpUcOgAGeqln@lunn.ch>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <YfnOFpUcOgAGeqln@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/22 6:19 PM, Andrew Lunn wrote:
> Hi Alex
> 
> This looks good in general.
> 
> 
>>      - If any monitor packet received from hardware is bad, it--along
>>
>>        with everything beyond it in its page--will be discarded.
>>
>>          - The received data must be big enough to hold a status
>>
>>            header.
>>
>>          - The received data must contain the packet data, meaning
>>
>>            packet length in the status header lies within range.
>   
> So bad in just the sense that capturing the packet and passing it to
> the application processor somehow went wrong.

All I'm saying is that the driver will take a little responsibility
for ensuring the stuff delivered to user space isn't complete crap.
To a certain extent that's to protect itself.  It would be easiest
to pass exactly what was received up to user space, without doing
any interpretation of it whatsoever.  But I think the kernel can
add this value at very little net cost.

The reality is, this should not happen.

> What about packets with bad CRC? Since the application processor is
> not involved, i assume something in the APA architecture is validating
> L2 and L3 CRCs. Do they get dropped, or can they be seen in the

The hardware can offload things like CRC calculation, but in that case
it's up to the receiving code to be told "this has a bad CRC" and
then decide to drop the received packet.  I think the replication
occurs early--possibly before hardware CRC calculations, so the
replica just gets delivered out this special endpoint just the way
it arrived.

> monitor stream? Does the header contain any indication of CRC errors,
> since if the packet has been truncated, it won't be possible to
> validate them. And you said L2 headers are not present anyway.

 From what I can tell, CRC errors are not indicated in the status
header.  The status seems to be more oriented toward "this is
the processing that the IPA hardware performed on this packet."
Including "it entered IPA on this 'port' and matched this
filter rule and got routed out this other 'port'."  But to be
honest my focus has been more on providing the feature than
what exactly those bits represent...

> Do you look at various libpcap-ng implementations? Since this is
> debugfs you are not defining a stable ABI, you can change it any time
> you want and break userspace. But maybe there could be small changes
> in the API which make it easier to feed to wireshark via libpcap.

I considered that.  That was really the interface I was envisioning
at first.  Those things don't really align perfectly with the
information that's made available here though.  This is more like
"what is the hardware doing to each packet" (so we can maybe
understand behavior, or identify a bug).  Rather than "what is
the content of packets flowing through?"  It might be useful
to use the powerful capabilities of things like wireshark for
analysis, but I kind of concluded the purpose of exposing this
information is a little different.

I've got most of the code buffering received data and making
it available through a file interface done.  But I have some
fine tuning to do before I'll be ready to post it for review.

Yes, the non-stable API means I can tweak it a bit even after
it's merged.  But we'll see.  It might be reasonable as-is.

Thanks a lot.

					-Alex

> 
> 	Andrew

