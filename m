Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5B61D2107
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 23:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgEMV2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 17:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728879AbgEMV2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 17:28:43 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A9FC061A0C;
        Wed, 13 May 2020 14:28:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v63so299437pfb.10;
        Wed, 13 May 2020 14:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xnR1o8e6GrJUlcLBagqxgMSa9ZV+ikEI6N+aKL3bczA=;
        b=rxvRVlHN1qGe8LG9nbGbfGSBg8GyJ+zRtse4IS3pMrU3+ANh5sZHfy/dbtIDsFQ+VA
         tNKuWn3L8+Jn4Deck1kwBcAXpA09flhGIdqixas9Z7zuuozhTi2B8TZnED5OH/vqGyFv
         JIZWyvLDJ410IYAbsnH5KiFpASx2lxPR+CLHtlVcnG/wqP+bVqHabn3lsyS+mILiRWTO
         H0SQeav/Wq8bpm3+ttoIogBUP+JZjjftgdEGniGjEC26wXMYnUIMoynIhgSBYnM22EoX
         QiDZ1QoO5E4eA+np1yLbDzCukZPSpHpHe3iQam85QmMV83qePnDse8KJD0N8K/EuLRw5
         JrQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xnR1o8e6GrJUlcLBagqxgMSa9ZV+ikEI6N+aKL3bczA=;
        b=szBSq+PRAGK/sI1z+0Uh1XodOJ7DdRU4MfU9Qn72u2pQ7Vk3CiKwJMXhOKjmQBX2Z9
         AqDL27LY1c6Gbo+BVb4Jhg6vrKUW9bltEBrQ4YhhYaz+TEoPrg4RM/NJzCzegSJvuOVb
         msfkUj8gPBSLc57U/0/PkvyVa14TuntyKRMTjPC81oMDzwM4SRspSrZRzIsVMRx7Y26Q
         580PRxjmliZc4Gm7K2UH8lRzL93V6lXjfCwgN2IgUITEBk3P90JaszMlnUxSzam/OtlS
         p2xhLTh6HNR1x9Jokg1tbcnBu7pzBA2hbo8Z8ojZdORDd8G94mb+4ZRC7/dlLdE3r4Z1
         nhyg==
X-Gm-Message-State: AOAM5316dmuWJtcAoknucMkQbuw47c86d/3XRryVPAT7gdnt6oF2aBAa
        4CeKWxSub4pjDItdBiwnz7UBhNeh
X-Google-Smtp-Source: ABdhPJwR/hgWZXPjSgQPUKSOLsX3mawpGS8wwLAOdDpKasNaLwHgTnUBeUYAb3rQn2WUSp90UIJaoQ==
X-Received: by 2002:a63:9258:: with SMTP id s24mr1193360pgn.362.1589405321958;
        Wed, 13 May 2020 14:28:41 -0700 (PDT)
Received: from [10.230.191.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d126sm432098pfc.81.2020.05.13.14.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 14:28:41 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
 <20200512004714.GD409897@lunn.ch>
 <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
 <20200512185503.GD1551@shell.armlinux.org.uk>
 <0cf740ed-bd13-89d5-0f36-1e5305210e97@gmail.com>
 <20200513053405.GE1551@shell.armlinux.org.uk>
 <20200513092050.GB1605@shell.armlinux.org.uk>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <fc97d47d-71ee-53e4-4239-17ad9685177a@gmail.com>
Date:   Wed, 13 May 2020 14:31:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513092050.GB1605@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/2020 2:20 AM, Russell King - ARM Linux admin wrote:
> On Wed, May 13, 2020 at 06:34:05AM +0100, Russell King - ARM Linux admin wrote:
>> On Tue, May 12, 2020 at 08:48:22PM -0700, Doug Berger wrote:
>>> On 5/12/2020 11:55 AM, Russell King - ARM Linux admin wrote:
>>>> On Tue, May 12, 2020 at 11:31:39AM -0700, Doug Berger wrote:
>>>>> This was intended as a fix, but I thought it would be better to keep it
>>>>> as part of this set for context and since net-next is currently open.
>>>>>
>>>>> The context is trying to improve the phylib support for offloading
>>>>> ethtool pause configuration and this is something that could be checked
>>>>> in a single location rather than by individual drivers.
>>>>>
>>>>> I included it here to get feedback about its appropriateness as a common
>>>>> behavior. I should have been more explicit about that.
>>>>>
>>>>> Personally, I'm actually not that fond of this change since it can
>>>>> easily be a source of confusion with the ethtool interface because the
>>>>> link autonegotiation and the pause autonegotiation are controlled by
>>>>> different commands.
>>>>>
>>>>> Since the ethtool -A command performs a read/modify/write of pause
>>>>> parameters, you can get strange results like these:
>>>>> # ethtool -s eth0 speed 100 duplex full autoneg off
>>>>> # ethtool -A eth0 tx off
>>>>> Cannot set device pause parameters: Invalid argument
>>>>> #
>>>>> Because, the get read pause autoneg as enabled and only the tx_pause
>>>>> member of the structure was updated.
>>>>
>>>> This looks like the same argument I've been having with Heiner over
>>>> the EEE interface, except there's a difference here.
>>>>
>>>> # ethtool -A eth0 autoneg on
>>>> # ethtool -s eth0 autoneg off speed 100 duplex full
>>>>
>>>> After those two commands, what is the state of pause mode?  The answer
>>>> is, it's disabled.
>>>>
>>>> # ethtool -A eth0 autoneg off rx on tx on
>>>>
>>>> is perfectly acceptable, as we are forcing pause modes at the local
>>>> end of the link.
>>>>
>>>> # ethtool -A eth0 autoneg on
>>>>
>>>> Now, the question is whether that should be allowed or not - but this
>>>> is merely restoring the "pause" settings that were in effect prior
>>>> to the previous command.  It does not enable pause negotiation,
>>>> because autoneg as a whole is disabled, but it _allows_ pause
>>>> negotiation to occur when autoneg is enabled at some point in the
>>>> future.
>>>>
>>>> Also, allowing "ethtool -A eth0 autoneg on" when "ethtool -s eth0
>>>> autoneg off" means you can configure the negotiation parameters
>>>> _before_ triggering a negotiation cycle on the link.  In other words,
>>>> it would avoid:
>>>>
>>>> # ethtool -s eth0 autoneg on
>>>> # # Link renegotiates
>>>> # ethtool -A eth0 autoneg on
>>>> # # Link renegotiates a second time
>>>>
>>>> and it also means that if stuff has already been scripted to avoid
>>>> this, nothing breaks.
>>>>
>>>> If we start rejecting ethtool -A because autoneg is disabled, then
>>>> things get difficult to configure - we would need ethtool documentation
>>>> to state that autoneg must be enabled before configuration of pause
>>>> and EEE can be done.  IMHO, that hurts usability, and adds confusion.
>>>>
>>> Thanks for your input and I agree with what you have said here. I will
>>> remove this commit from the set when I resubmit and I assume that, like
>>> Michal, you would like to see the comment in ethtool.h revised.
>>>
>>> I think the crux of the matter is that the meaning of the autoneg pause
>>> parameter is not well specified, and that is fundamentally what I am
>>> trying to clarify in a common implementation that might help unify a
>>> consistent behavior across network drivers.
>>>
>>> My interpretation is that the link autonegotiation and the pause
>>> autonegotiation can be meaningfully set independently from each other
>>> and that the interplay between the two has easily overlooked subtleties.
>>>
>>> My opinion (which is at least in part drawn from my interpretation of
>>> your opinion) is as follows with regard to pause behaviors:
>>>
>>> The link autonegotiation parameter concerns itself with whether the
>>> Pause capabilities are advertised as part of autonegotiation of link
>>> parameters.
>>>
>>> The pause autonegotiation parameter concerns itself with whether the
>>> local node is willing to accept the advertised capabilities of its peer
>>> as input into its pause configuration.
>>>
>>> The Tx_Pause and Rx_Pause parameters indicate in which directions pause
>>> frames should be supported.
>>
>> This is where the ethtool interface breaks down - they are unable
>> to sanely define which should be supported, as what you end up with
>> could be wildly different from what you thought.  See the
>> documentation against linkmode_set_pause() where I detail the issues
>> in this API.
>>
>> For example, if you specify Tx_Pause = 0, Rx_Pause = 1, you can end
>> up with the pause negotiating transmit and receive pause.
>>
>> If you specify Tx_Pause = 1, Rx_Pause = 1, and the far end supports
>> only AsymPause, then you end up with pause disabled, despite the
>> link actually being able to support receive pause at the local end.
>> Whereas if you specified Tx_Pause = 0, Rx_Pause=1 in this scenario,
>> you would get receive pause.  That's very counter intuitive.
>>
>>> If the pause autonegotiation is off, the MAC is allowed to act
>>> exclusively according to the Tx_Pause and Rx_Pause parameters. If
>>> Tx_Pause is on the MAC should send pause control frames whenever it
>>> needs to assert back pressure to ease the load on its receiver. If
>>> Tx_Pause is off the MAC should not transmit any pause control frames. If
>>> Rx_Pause is on the MAC should delay its transmissions in response to any
>>> pause control frames it receives. If Rx_Pause is off received pause
>>> control frames should be ignored. If link autonegotiation is on the
>>> Tx_Pause and Rx_Pause values should be advertised in the PHY Pause and
>>> AsymPause bits for informational purposes according to the following
>>> mapping:
>>>     tx rx  Pause AsymPause
>>>     0  0   0     0
>>>     0  1   1     1
>>>     1  0   0     1
>>>     1  1   1     0
>>
>> That is what is presently implemented by the helpers, and leads to
>> the above counter intuitive behaviour.
>>
>>> If the pause autonegotiation is on, and the link autonegotiation is also
>>> on then the Tx_Pause and Rx_Pause values should be advertised in the PHY
>>> Pause and AsymPause bits according to the IEEE 802.3 spec according to
>>> the following mapping:
>>>     tx rx  Pause AsymPause
>>>     0  0   0     0
>>>     0  1   1     1
>>>     1  0   0     1
>>>     1  1   1     1
>>
>> That would be an API change - and note that in the case of 'tx=0
>> rx=1' and the result of negotiation being used, you can still end
>> up with transmit and receive pause being enabled.
>>
>> Basically, trying to define the pause advertisment in terms of
>> desired TX and RX pause enablement is *very* problematical - they
>> really do not mean anything as we can see if we work through the
>> various settings and results.
>>
>> You're much better using the raw advertisment mask to set the
>> pause and asym pause bits manually.
>>
>>> If link autonegotiation succeeds the peer's advertised Pause and
>>> AsymPause bits should be used in combination with the local Pause and
>>> Pause Asym bits to determine in which directions pause frames are
>>> supported. However, regardless of the negotiated result, if the Tx_Pause
>>> is off no pause frames should be sent and if the Rx_Pause is off
>>> received pause frames should be ignored. If Tx_Pause is on and the
>>> negotiated result allows pause frames to be sent then pause frames may
>>> be sent by the local node to apply back pressure to reduce the load on
>>> its receive path. If Rx_Pause is on and the negotiated result allows
>>> pause frames to be received then the local node should delay its
>>> transmission in response to received pause frames. In this way the local
>>> settings can only override the negotiated settings to disable the use of
>>> pause frames.
>>>
>>> If the pause autonegotiation is on, and the link autonegotiation is off
>>> then the values of the peer's Pause and AsymPause bits are forced to 0
>>> (because they can't be exchanged without link autonegotiation) which
>>> always produces the negotiated result of pause frame use being disabled
>>> in both directions. Since the local Tx_Pause and Rx_Pause parameters can
>>> only override the negotiation when they are off, pause frames should not
>>> be sent or received.
>>>
>>> This is the behavior I have attempted to implement by this patch set for
>>> the bcmgenet driver, but I see now that I made an error in this last
>>> case since I made the negotiation also dependent on the link
>>> autonegotiation being enabled. I will correct that in a re-submission.
>>>
>>> I would appreciate if you can confirm that you agree that this is a good
>>> general behavior for all network devices before I resubmit, or please
>>> help me understand what could be done better.
>>
>> It's gratifying that someone else has run into the same issue I did a
>> while back, has put thought into it, and come up with a similar idea
>> that I did.  You'll find your idea already spelt out in the comments
>> in phylink_ethtool_set_pauseparam().
>>
>> However, as I say, it's an API change.
>>
>> I've long considered the ethtool APIs to be very deficient in its
>> pause handling in many ways.  Another example is:
>>
>>         Supported pause frame use: Symmetric Receive-only
>>
>> which leads to the obvious observation: the link can negotiate that
>> this end should transmit only, but the terminology used here does
>> not seem to permit it (there's no "Transmit-only" indicated.) In
>> reality, one shold read "Asymmetric" for "Receive-only" in this
>> output, because that is exactly what the bit that controls that
>> indication is.
> 
> One thing I didn't mention is - although I identified the same problem
> w.r.t interpretation of pause tx/rx to advertisement, I regard that
> it's more important for a user interface to behave consistently.
> phylib implements generic code that converts the set_pauseparam method
> parameters to the PHY advertisement using the "very-odd" behaviour.
> 
> Since phylink uses phylib, phylink has to follow phylib, otherwise we
> end up with the API having different behaviours depending on which SFP
> modules are plugged in, or whether the network driver is connected to
> a PHY or SFP.
> 
> So, I think consistency of implementation is more important than fixing
> this; the current behaviour has been established for many years now.
> 
I agree that consistency is important. I had just hoped that since there
really is surprisingly little support for this feature among network
drivers (I assume largely because of this lack of basic support in the
phylib) that there might still be a chance to get it changed.
