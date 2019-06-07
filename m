Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3A939387
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731639AbfFGRne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:43:34 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:37602 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730716AbfFGRnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 13:43:33 -0400
Received: by mail-it1-f194.google.com with SMTP id x22so4015564itl.2
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 10:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L8Igv0c1kKwXXNn7veRB/74fSSY4c41NnqxruUQUijA=;
        b=ULzubESKs6yWyTO1zfeKq3G6Nq9xzHsM2OnKkPgQEsyEZTlGMdRlATFbdFeu4Shw2I
         UoTa4OmuP82t/QmuA215jTqrWDirqfr+3CZEruaA9pubDukMpsh0UktiDXbxqK46Uv4Z
         ucHcId6UaJgMLbGn6b/lZAH1naIeByMpFAXueqW7QJma4l3auNckJrHlw02gg3kk0uOH
         ckPMQYdQ8DxpQ/4Vk5gg+DaDFaqMREPnKb6re7paarLwDg2xpOvKJnflqnzGEn5LucM+
         lL34QDBsfkQNwdMPzg93yeB6a701oUvFZNXsWMD9nutwq4CBHH8Bf5boK98J8MbtwBDf
         25ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L8Igv0c1kKwXXNn7veRB/74fSSY4c41NnqxruUQUijA=;
        b=DgKUMAylF+Ip9TB49IEIJkRyXyAfVUcGMn9ZAkwxazpPbX4GlC6I+ptSiqUMvvKhaE
         /mjoAORi+z9d3jei5Uldyb0DOyZRe6e1ZJD7A0SCCpWpSTC8dmS/n1qnnM7vjb3u8sMV
         au6wWo5Krn99CD4zNQGa8xpp2/LVXXHd5gPu49mGqScRqN7PYb+SeekQe5cNOKTxgwc/
         1inKN9wRcapWSKL7bDdQ8asHC6Fr3Gu8O3yTbK4Lwx4X2Ierjq3KkrQInpYkVDiu1DK4
         d+3v9Gb9QsR3PrL9/Ne0O1uKvowQ4mKLlJwu1vBisdkiqgMM7Rt0iY+Xs96K96chdwcK
         ogWw==
X-Gm-Message-State: APjAAAX1yIbLbLox5xrqAwjM+rCC/AO+1ryzDaIdQzh4Ze3OLefa2yYH
        Uq2MW5Jo9Ziep/gvNu8gw6O+5Q==
X-Google-Smtp-Source: APXvYqz5GAioF1jaAZlXaE9bF6pA/rBJ+Whdl1/UGL1j0bmacQDXQiLgL6o+fLiBjQwUbVx4mCXHuQ==
X-Received: by 2002:a02:bb83:: with SMTP id g3mr36416773jan.139.1559929412746;
        Fri, 07 Jun 2019 10:43:32 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id z17sm879253iol.73.2019.06.07.10.43.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 10:43:32 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Alex Elder <elder@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Dan Williams <dcbw@redhat.com>, David Miller <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        evgreen@chromium.org, Ben Chan <benchan@google.com>,
        Eric Caruso <ejcaruso@google.com>, cpratapa@codeaurora.org,
        syadagir@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Networking <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
References: <20190531035348.7194-1-elder@linaro.org>
 <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
 <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org>
 <CAK8P3a05CevRBV3ym+pnKmxv+A0_T+AtURW2L4doPAFzu3QcJw@mail.gmail.com>
 <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org>
 <CAK8P3a2rkQd3t-yNdNGePW8E7rhObjAvUpW6Ga9AM6rJJ27BOw@mail.gmail.com>
 <5ebccdbe-479d-2b7d-693c-0c412060d687@linaro.org>
Message-ID: <cd408ff3-2884-3fc7-6154-4675bc865e0d@linaro.org>
Date:   Fri, 7 Jun 2019 12:43:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <5ebccdbe-479d-2b7d-693c-0c412060d687@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/19 5:08 PM, Alex Elder wrote:
> On 5/31/19 4:12 PM, Arnd Bergmann wrote:
>> On Fri, May 31, 2019 at 10:47 PM Alex Elder <elder@linaro.org> wrote:
>>> On 5/31/19 2:19 PM, Arnd Bergmann wrote:
>>>> On Fri, May 31, 2019 at 6:36 PM Alex Elder <elder@linaro.org> wrote:
>>>>> On 5/31/19 9:58 AM, Dan Williams wrote:
>>>>>> On Thu, 2019-05-30 at 22:53 -0500, Alex Elder wrote:
>>>>
>>>> Does this mean that IPA can only be used to back rmnet, and rmnet
>>>> can only be used on top of IPA, or can or both of them be combined
>>>> with another driver to talk to instead?
>>>
>>> No it does not mean that.
>>>
>>> As I understand it, one reason for the rmnet layer was to abstract
>>> the back end, which would allow using a modem, or using something
>>> else (a LAN?), without exposing certain details of the hardware.
>>> (Perhaps to support multiplexing, etc. without duplicating that
>>> logic in two "back-end" drivers?)
>>>
>>> To be perfectly honest, at first I thought having IPA use rmnet
>>> was a cargo cult thing like Dan suggested, because I didn't see
>>> the benefit.  I now see why one would use that pass-through layer
>>> to handle the QMAP features.
>>>
>>> But back to your question.  The other thing is that I see no
>>> reason the IPA couldn't present a "normal" (non QMAP) interface
>>> for a modem.  It's something I'd really like to be able to do,
>>> but I can't do it without having the modem firmware change its
>>> configuration for these endpoints.  My access to the people who
>>> implement the modem firmware has been very limited (something
>>> I hope to improve), and unless and until I can get corresponding
>>> changes on the modem side to implement connections that don't
>>> use QMAP, I can't implement such a thing.
>>
>> Why would that require firmware changes? What I was thinking
>> here is to turn the bits of the rmnet driver that actually do anything
>> interesting on the headers into a library module (or a header file
>> with inline functions) that can be called directly by the ipa driver,
>> keeping the protocol unchanged.

OK, I follow up below, but now that I re-read this I think I
misunderstood what you were saying.  I now think you were just
talking about having the QMAP parsing functionality provided
by rmnet be put into a library that the IPA driver (and others)
could use, rather than having them be two separate but stacked
drivers.

That seems like a very reasonable idea, and I don't think rmnet
does anything particularly special that would preclude it.
But:
- I have not reviewed the rmnet driver in any detail
- It's possible this wouldn't work with other back ends
- This would also need to be considered as part of any
  effort to create a generic WWAN framework (though it
  wouldn't pose any problem as far as I can tell)

> You know, it's possible you're right about not needing
> firmware changes.  But it has always been my impression
> they would be needed.  Here's why.

Now I'm just following up on the above statement.

First, what I was saying initially is that I would like to
be able to configure a simple network device that does not
implement any of the QMAP (rmnet) protocol.  That would
allow IPA to be used standalone, without any need for what
the rmnet driver provides.  This would suffice for the
current use, because the driver currently supports *only*
a single fixed-configuration data connection to the modem,
and has no need for the logical channels (or aggregation)
that QMAP provides.

I have not done that, because it would require both the AP
side and modem side endpoints to change their configuration
to *not* use QMAP.  I can configure the AP endpoint, but I
have no control over how the modem configures its endpoint.

Something about your question made me think I might have
been misunderstanding that requirement though.  I.e., I
thought it might be possible for the local (AP side)
endpoint to be configured to not use QMAP, regardless of
what the modem side does.

I didn't inquire, but I reviewed some documents, and I now
conclude that my previous understanding was correct.  I
can't configure an AP endpoint to not use QMAP without also
having the modem configure its corresponding endpoint to
not use QMAP.  The AP and modem need to agree on how their
respective "connected" endpoints are configured.

					-Alex

> It looks like this:
> 
>            GSI Channel   GSI Channel
>                |             |         
>   ----------   v   -------   v   -------------
>   | AP (ep)|=======| IPA |=======|(ep) Modem |
>   ----------       -------       -------------
> 
> The AP and Modem each have IPA endpoints (ep), which use GSI channels,
> to communicate with the IPA. Each endpoint has configuration options
> (such as checksum offload).  I *thought* that the configurations of
> the two endpoints need to be compatible (e.g., they need to agree on
> whether they're aggregating).  But with your questioning I now think
> you may be right, that only the local endpoint's configuration matters.
> 
> I will inquire further on this.  I *know* that the AP and modem
> exchange some information about IPA configuration, but looking more
> closely that looks like it's all about the configuration of shared
> IPA resources, not endpoints.
> 
> That said, the broader design (including the user space code)
> surely assumes rmnet, and I don't have any sense of what impact
> changing that would make.  I am sure that changing it would not
> be well received.
> 
> 					-Alex
> 
>>>> Always passing data from one netdev to another both ways
>>>> sounds like it introduces both direct CPU overhead, and
>>>> problems with flow control when data gets buffered inbetween.
>>>
>>> My impression is the rmnet driver is a pretty thin layer,
>>> so the CPU overhead is probably not that great (though
>>> deaggregating a message is expensive).  I agree with you
>>> on the flow control.
>>
>> The CPU overhead I mean is not from executing code in the
>> rmnet driver, but from passing packets through the network
>> stack between the two drivers, i.e. adding each frame to
>> a queue and taking it back out. I'm not sure how this ends
>> up working in reality but from a first look it seems like
>> we might bounce in an out of the softirq handler inbetween.
>>
>>           Arnd
>>
> 

