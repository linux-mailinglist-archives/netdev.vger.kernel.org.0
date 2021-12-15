Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BED475FB9
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238088AbhLORsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237968AbhLORsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 12:48:07 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9154AC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 09:48:07 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id o4so21303673pfp.13
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 09:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yrd4lkTV9DiSvQPr2i9XEjwkvyjfqJBCXXzEbk7PJ80=;
        b=acMHkFV2QH82vF0Nqk9S47wfy53MLA+W5h0OJGOpoRfZtTHGTbo0cDLh2WJBugRaU6
         j1q7jNp7wesvLwjllDNNF1s5ZALJLji/LHWrzzvk0sYAy5sR2i+/rym1T9c0IjB1KyBj
         EwIwyRSXLGz51bl1pJ6Ji6Q3oSPkWrQKlOvb2ua2l7LZn3tlzSC6RdQE1xc41CDe+Fbh
         OGUBb7fgGFCzO4cOSJjZU4E1N9o7evQjLLP41NKGNsmx6kiqcROMrMMxDRlwhmtzHs13
         xqZLlCaigT0RcTfQklXOxRxhoIiVyaS6kLJVG/9k6EfBiyFtCTKWYcdWy3oSFdfSrBxh
         AMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yrd4lkTV9DiSvQPr2i9XEjwkvyjfqJBCXXzEbk7PJ80=;
        b=gQsVC3YPhq5ECxTogdLyEQahbT4lDLvKWC6fTvRSJnuFv7lU8ONpthic1ry/yEjH5O
         n1u7++bD+KqOtziGoZmCSRwPZqSmXLADpHTsTgRJ9WmuJzLxHNo2w5Q+6mjqzyHX1uu1
         9e4Bb/KL5sViJS0H2fp4x4E+007ABc2me3i3r1iXzKmsMoXUyMzts4ot1lYgWC8kapEg
         JhizkCiqLRdeGf9gz6hJKGL00baup4MHmj+76+OakQv9B5qq7XEICT5RkulvyEZQ2riQ
         Mc1p7sFOuZsapfVfPPduGodM7awJ5EtzvTcb8UiKJ84qwguNGkQ1bJjQisHPVbK1Py3M
         Aiag==
X-Gm-Message-State: AOAM532xcngYQvO4KAXs+VqpXv7T9W+ShmLzcMNmlMC8CFNVyzkiG61c
        FUYVCd17GO+FofRa7wRkPkFq0/h6Spc=
X-Google-Smtp-Source: ABdhPJxLE0TDQF30KPjzhzihZuC3EV9/X5z0yPhtmmOD7u0D65nQ5hyT/Gi5AWDVCCOLpsrzyElMkA==
X-Received: by 2002:a05:6a00:b8a:b0:49f:ed97:16be with SMTP id g10-20020a056a000b8a00b0049fed9716bemr10114858pfj.16.1639590487001;
        Wed, 15 Dec 2021 09:48:07 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s31sm3691979pfg.22.2021.12.15.09.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 09:48:06 -0800 (PST)
Subject: Re: Port mirroring (RFC)
To:     Alex Elder <elder@linaro.org>,
        Network Development <netdev@vger.kernel.org>
Cc:     "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7cf5a995-8e59-93cd-ccab-243a4c24cedc@gmail.com>
Date:   Wed, 15 Dec 2021 09:48:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/21 6:47 AM, Alex Elder wrote:
> I am implementing what amounts to port mirroring functionality
> for the IPA driver.
> 
> The IPA hardware isn't exactly a network switch (it's sort of
> more than that), but it has the ability to supply replicas of
> packets transferred within it to a special (read only) interface.
> 
> My plan is to implement this using a new "ipa_mirror" network
> device, so it could be used with a raw socket to capture the
> arriving packets.  There currently exists one other netdev,
> which represents access through a modem to a WWAN network.
> 
> I would like some advice on how to proceed with this.  I want
> the result to match "best practice" upstream, and would like
> this to be as well integrated possible with existing network
> tools.
> 
> A few details about the stream of packets that arrive on
> this hardware interface:
> - Packet data is truncated if it's larger than a certain size
> - Each packet is preceded by a fixed-size header describing it
> - Packets (and their headers) are aggregated into a buffer; i.e.
>   a single receive might carry a dozen (truncated) packets

Andrew has already responded, but there are currently sort of two ways
that mirroring is implemented in upstream supported drivers:

- for "classic" Ethernet switches mirroring is typically from one port,
or a set of ports, to another with a choice in whether you want to
capture ingress, egress, or both towards that port. Because each port is
a netdev already you just run tcpdump/pcap the way you normally do on
your Ethernet NIC and get the captured packets. Configuration is via
offloading the tc_mired action.

- mlxsw implements devlink traps which is not exaclty designed for
capturing mirrored packets but more like management events such as why
the packet was trapped etc. You could however imagine using devlink
traps for that purpose of capturing mirrored packets in the absence of a
suitable network device

Not sure if this helps, but that is the situation.

> 
> Here are a few specific questions, but I would love to get
> *any* feedback about what I'm doing.
> - Is representing this as a separate netdev a reasonable
>   thing to do?

I would think so, given this allows standard tools to work.

> - Is there anything wrong with making a netdev read-only?
>   (Any packets supplied for transmit would be dropped)

This looks reasonable.

> - Are there things I should do so it's clear this interface
>   does not carry IP traffic (or even UDP, etc.)?

There were various patches in the past to prevent a network device from
getting any IP stack to be configured:

https://yhbt.net/lore/all/20150825232021.GA8482@Alexeis-MacBook-Pro-2.local/t/

I forgot whether as a driver you can just refuse to have an IP address
assigned to your network device, AFAIR it requires changes to the
network stack as proposed in the patch set.

> - Should the driver de-aggregate the received packets, i.e.
>   separating each into a separate SKB for reading?

If this is truly a mirroring device, you would expect it to "render" the
mirrored packets exactly the way they are, maybe add an ethtool private
option to de-aggregate packets if this helps debugging?

> 
> I might have *many* more questions, but I'd just like to make
> sure I'm on the right track, and would like both specific and
> general suggestions about how to do this the right way.
> 
> Thanks.
>                     -Alex


-- 
Florian
