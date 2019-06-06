Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC20D37B4B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbfFFRmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:42:13 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:38162 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728930AbfFFRmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:42:13 -0400
Received: by mail-it1-f196.google.com with SMTP id h9so1291697itk.3
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 10:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DF4dQA1gIkFVgXztlpdKk3n/BViiehMxIhYhE4VnkR4=;
        b=KGwtj9UC89wRdT3HsyRr12bThebYmDfsZJLgMxmjyHJL6J0r1yu8j6LLOkmKKtV8+2
         LtMASJ9SNxz8cGVSnVadhgYrVuHX5vP5Rj6FzMvKlYbnf1WXI2U6Aq+4d/X5v+enclMW
         qyPz3cJLedz31HfbmBxP6SozodQSt6dQGgKYp9d0DOR76o0JG3gRD5plHn+vju/Z506J
         HmQvDw/OvXHk7t1DQeoX5VJOoZLLbMLWvCH0nffebEdvjYK4aVzJqqqcqlBstw8jEq9d
         dAigjLdXABVs0DH2S5SsWxRv+JXmjNJEQNoaq/ad9dFBxgK3gUbDKzbkR/YWf/oie3Mm
         YH1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DF4dQA1gIkFVgXztlpdKk3n/BViiehMxIhYhE4VnkR4=;
        b=eyn34+pN/lNfitsnx8OVqBafUIIwzu6/BZEIoOnFk7G40BlQNVmMa2eYtgAwA+V7z8
         mCZvgU4orzpcElCOJO7AeuFkgdJ98AAGGD4MYd+aUK95+1NqjxmPDatn8sHc+yTLAdkt
         Qyk4Xg+Dx8v75qXbOF/esX83+uq4Cxr18gXcpgkGXNa6L3h/zlPVTuGFOgNhqiNFl6cr
         KOCbAVyKKi0iye9fgCKb71qLquxjKpccfr/EFcbyXnO7JRz7vPYC8AaSigCvGGtFdlKC
         UnQY6WS7YZaoJ7Ke5Oeqa68GId1Mcf7I8eIiitLtGeuAztAWos0x0gm4V4eePkp66pRg
         16+Q==
X-Gm-Message-State: APjAAAVrOw3RcyuYZfGUcgmJiMh16y2Ov7zkmwx7/hrKtE1qJGtAWrE6
        aEYj2WC/CDU9TSnJQ2VBCB+bUw==
X-Google-Smtp-Source: APXvYqyHNwNKPxbwqRyI0UzRFRYI0LNnqNSA5yyN+XT3MtdTA8IDyJ5LpmKk0rHZQuPmLw0mXxlWnA==
X-Received: by 2002:a02:a493:: with SMTP id d19mr28473646jam.22.1559842931946;
        Thu, 06 Jun 2019 10:42:11 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id a7sm855158iok.19.2019.06.06.10.42.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 10:42:11 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Dan Williams <dcbw@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        David Miller <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        evgreen@chromium.org, Ben Chan <benchan@google.com>,
        Eric Caruso <ejcaruso@google.com>, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, abhishek.esse@gmail.com,
        Networking <netdev@vger.kernel.org>,
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
 <20190531233306.GB25597@minitux>
 <d76a710d45dd7df3a28afb12fc62cf14@codeaurora.org>
 <CAK8P3a0brT0zyZGNWiS2R0RMHHFF2JG=_ixQyvjhj3Ky39o0UA@mail.gmail.com>
 <040ce9cc-7173-d10a-a82c-5186d2fcd737@linaro.org>
 <CAK8P3a2U=RzfpVaAgRP1QwPhRpZiBNsG5qdWjzwG=tCKZefYHA@mail.gmail.com>
 <b26cf34c0d3fa1a7a700cee935244d7a2a7e1388.camel@redhat.com>
 <CAK8P3a3pQpSpH4q=CL6gr_YzjYgoyD6-eyiLrvnZsqqjpcRxtQ@mail.gmail.com>
 <0264d7f9a35430201a89c068bb13c84c622af11a.camel@redhat.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
Date:   Thu, 6 Jun 2019 12:42:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <0264d7f9a35430201a89c068bb13c84c622af11a.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/19 4:29 PM, Dan Williams wrote:
> On Tue, 2019-06-04 at 22:04 +0200, Arnd Bergmann wrote:
>> On Tue, Jun 4, 2019 at 5:18 PM Dan Williams <dcbw@redhat.com> wrote:
>>> On Tue, 2019-06-04 at 10:13 +0200, Arnd Bergmann wrote:
>>>> Can you describe what kind of multiplexing is actually going on?
>>>> I'm still unclear about what we actually use multiple logical
>>>> interfaces for here, and how they relate to one another.
>>>
>>> Each logical interface represents a different "connection" (PDP/EPS
>>> context) to the provider network with a distinct IP address and
>>> QoS.
>>> VLANs may be a suitable analogy but here they are L3+QoS.
>>>
>>> In realistic example the main interface (say rmnet0) would be used
>>> for
>>> web browsing and have best-effort QoS. A second interface (say
>>> rmnet1)
>>> would be used for VOIP and have certain QoS guarantees from both
>>> the
>>> modem and the network itself.
>>>
>>> QMAP can also aggregate frames for a given channel
>>> (connection/EPS/PDP
>>> context/rmnet interface/etc) to better support LTE speeds.
>>
>> Thanks, that's a very helpful explanation!
>>
>> Is it correct to say then that the concept of having those separate
>> connections would be required for any proper LTE modem
>> implementation,
>> but the QMAP protocol (and based on that, the rmnet implementation)
>> is Qualcomm specific and shared only among several generations of
>> modems from that one vendor?
> 
> Exactly correct.  This is what Johannes is discussing in his "cellular
> modem APIs - take 2" thread about how this should all be organized at
> the driver level and I think we should figure that out before we commit
> to IPA-with-a-useless-netdev that requires rmnets to be created on top.
> That may end up being the solution but let's have that discussion.

I looked at Johannes' message and the follow-on discussion.  As I've
made clear before, my work on this has been focused on the IPA transport,
and some of this higher-level LTE architecture is new to me.  But it
seems pretty clear that an abstracted WWAN subsystem is a good plan,
because these devices represent a superset of what a "normal" netdev
implements.

HOWEVER I disagree with your suggestion that the IPA code should
not be committed until after that is all sorted out.  In part it's
for selfish reasons, but I think there are legitimate reasons to
commit IPA now *knowing* that it will need to be adapted to fit
into the generic model that gets defined and developed.  Here
are some reasons why.

First, the layer of the IPA code that actually interacts with rmnet
is very small--less than 3% if you simply do a word count of the
source files.  Arnd actually suggested eliminating the "ipa_netdev"
files and merging their content elsewhere.  This suggests two things:
- The interface to rmnet is isolated, so the effect of whatever
  updates are made to support a WWAN (rather than netdev) model will
  be focused
- The vast majority of the driver has nothing to do with that upper
  layer, and deals almost exclusively with managing the IPA hardware.
  The idea of a generic framework isn't minor, but it isn't the
  main focus of the IPA driver either, so I don't think it should
  hold it up.

Second, the IPA code has been out for review recently, and has been
the subject of some detailed discussion in the past few weeks.  Arnd
especially has invested considerable time in review and discussion.
Delaying things until after a better generic model is settled on
(which I'm guessing might be on the order of months) means the IPA
driver will have to be submitted for review again after that, at
which point it will no longer be "fresh"; it'll be a bit like
starting over.

Third, having the code upstream actually means the actual requirements
for rmnet-over-IPA are clear and explicit.  This might not be a huge
deal, but I think it's better to devise a generic WWAN scheme that
can refer to actual code than to do so with assumptions about what
will work with rmnet (and others).  As far as I know, the upstream
rmnet has no other upstream back end; IPA will make it "real."

I support the idea of developing a generic WWAN framework, and I
can assure you I'll be involved enough to perhaps be one of the
first to implement a new generic scheme.

Optimistically, the IPA code itself hasn't seen much feedback
for v2; maybe that means it's in good shape?

Anyway, I'd obviously like to get the IPA code accepted sooner
rather than later, and I think there are good reasons to do that.

					-Alex

>>> You mentioned the need to have a common user space interface
>> for configuration, and if the above is true, I agree that we should
>> try
>> to achieve that, either by ensuring rmnet is generic enough to
>> cover other vendors (and non-QMAP clients), or by creating a
>> new user level interface that IPA/rmnet can be adapted to.
> 
> I would not suggest making rmnet generic; it's pretty QMAP specific
> (but QMAP is spoken by many many modems both SoC, USB stick, and PCIe
> minicard).
> 
> Instead, I think what Johannes is discussing is a better approach. A
> kernel WWAN framework with consistent user API that
> rmnet/IPA/qmi_wwan/MBIM/QMI/serial/Sierra can all implement.
> 
> That wouldn't affect the core packet processing of IPA/rmnet but
> instead:
> 
> 1) when/how an rmnet device actually gets created on top of the IPA (or
> qmi_wwan) device
> 
> AND (one of these two)
> 
> a) whether IPA creates a netdev on probe
> 
> OR
> 
> b) whether there is some "WWAN device" kernel object which userspace
> interacts with create rmnet channels on top of IPA
> 
> Dan
> 

