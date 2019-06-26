Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3432E56B3D
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfFZNvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:51:05 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44115 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbfFZNvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:51:05 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so2165197iob.11
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 06:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qhiniuMba/JWZz4DtFdVyzygq/a6ifqx5axR5It0RV0=;
        b=dLE5440HlC3TTuDBSwEG78wHGjrHRqtO5Eko0Iz+zvSod51w0BiJ3Rmo/9TSrfqlfX
         L14L00JtFnYMz6Sqc11zCuvdgYAQc2oka2/2ApEb1wCtJao0yiiCROnCmzNRqXhtDx/2
         ACB8KAp3R2LJcPov5FkXzqBWnzBgcSL1+Cb5SEzUp2F1DHc3fmbEexu4WpZys9PqNIFJ
         RvpplLPDwvQb/wmJsaTiX1xZcx23HwvjLzRi2PpzhijQ/3SHMTMNh1Sb9AwDd6JTk1nj
         d3v7u3rGQ4cjlLm1S6QSGPgf+uLZCTSSm/JArvuSgbUA9nyVj2AvTHIl+1YIJJl8RiOA
         a8eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qhiniuMba/JWZz4DtFdVyzygq/a6ifqx5axR5It0RV0=;
        b=cy5VH/S0r9LHwjKMmD8Mr7B/rAoOufMwfm3wxVHn8j2TlVbNjXyZobGEZOMdn39AAA
         9Xuf5IbZpF0HA1FYJ6ZGIfemXbpnh7AcvAZXDSndPLK4s9FFjPmj1/RYOimSdqce4dKf
         7aLu2syA4LjxHsyOnH6NXIYZhCeicoNZFH9lbbGzjzr9xz9y3HA4xIsOxJLGerwUOcUe
         8LYqIeA6mGyukHtoXWBq/+6hKjsRKdNPK5WE8j3AgcYRN4ZFF6BKMvNxZfiSjxKc73FD
         w2GUgNwYksBHw/5LpHZHo+9xW/kDXt1LRkmtCUyBYzSdznMkKkkTI26jr8LBEZAMZJDH
         Nu6g==
X-Gm-Message-State: APjAAAWUbid1TV/rojMtnok9K2awJjbfemNEx4jRuwAFbQ/fCsermK7A
        2ZEPn5W9m1CWu9ysAP1V138gZA==
X-Google-Smtp-Source: APXvYqxnbvSw1FOj/CRECKm1NLwNrHD2AF6HsUr3uwNyBiLIRP0SF418WWmgo0Oqg5IvVF9PpTRmsw==
X-Received: by 2002:a02:b68f:: with SMTP id i15mr4922765jam.107.1561557064470;
        Wed, 26 Jun 2019 06:51:04 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id e22sm25713339iob.66.2019.06.26.06.51.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 06:51:03 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
 <36bca57c999f611353fd9741c55bb2a7@codeaurora.org>
 <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
 <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
 <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
 <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
 <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
 <d533b708-c97a-710d-1138-3ae79107f209@linaro.org>
 <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
 <db34aa39-6cf1-4844-1bfe-528e391c3729@linaro.org>
 <CAK8P3a1ixL9ZjYz=pWTxvMfeD89S6QxSeHt9ZCL9dkCNV5pMHQ@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <2d40bbcc-1d29-3aa7-e8cb-b0bc5835b8dc@linaro.org>
Date:   Wed, 26 Jun 2019 08:51:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1ixL9ZjYz=pWTxvMfeD89S6QxSeHt9ZCL9dkCNV5pMHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19 11:40 AM, Arnd Bergmann wrote:
> On Mon, Jun 24, 2019 at 6:21 PM Alex Elder <elder@linaro.org> wrote:
>> On 6/18/19 2:03 PM, Johannes Berg wrote:
>>
>>> Really there are two possible ways (and they intersect to some extent).

. . .

>>> The other is something like IPA or the Intel modem driver, where the
>>> device is actually a single (e.g. PCIe) device and just has a single
>>> driver, but that single driver offers different channels.
>>
>> What I don't like about this is that it's more monolithic.  It
>> seems better to have the low-level IPA or Intel modem driver (or
>> any other driver that can support communication between the AP
>> and WWAN device) present communication paths that other function-
>> specific drivers can attach to and use.
> 
> I did not understand Johannes description as two competing models
> for the same code, but rather two kinds of existing hardware that
> a new driver system would have to deal with.

Based on my understanding of what he said in a message I just
responded to, I think you are exactly right.

. . .

> What we should try to avoid though is a way to add driver private
> interfaces that risk having multiple drivers create similar functionality
> in incompatible ways.

Agreed.

					-Alex
