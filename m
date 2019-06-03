Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0724A3340A
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbfFCPwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:52:53 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:35099 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729642AbfFCPwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 11:52:50 -0400
Received: by mail-it1-f194.google.com with SMTP id n189so8929340itd.0
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 08:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GpFzEpr1ezfAmPIG1U95ynZ5Rh+k9URxN/mncQwbUQk=;
        b=oBApCORx2TVaSa216x4E5fWeNliHwLcHKgzvAiwAQj8dhZ1r9t956omEZF1QQfS9Qn
         L4GYcQEFUI2hVJ5He6pUDQDUNyPznBtxjBYhYgWqf0fpncq8kFEDs/+HOYrnAP6r9obM
         T9qxjp1J8zHbaJiaXN6PDoLBGISs83YZyJ8Usa30SQiYXgwfXXGbF1s6FibOLcl34SKl
         vmBvNMOVYyW8K4XlWvfPG76wjQWDeeqOPEjNgfG57tXvxOLi3EN0fasmt5IWrPSqUfvx
         8DX+S2kyo+AAwLnSKCV0MFxSNOmOYqzTkLSHwEUJsGuBY6OmAel+brYjn8OUNx7Xym6d
         +xdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GpFzEpr1ezfAmPIG1U95ynZ5Rh+k9URxN/mncQwbUQk=;
        b=A5Sw9Ddd/X3pMpGoPWFDjBVFq5Z2Ag537rtfurNGWJdEAYsCw3uNhP8+Jr81Yjy6Yf
         Hj2TiSsQpsYnPwzoEDbNjHoNZKh27KnDi5giZSO8oJVSN6YR4oKp/lLzMKY3YqAe75po
         NqENIVSA2EKgpol7xiMd+lTRLuDTE/V2EilQ5f9j2FosH71woUgAziD2RZPpqPLss18c
         71wQqgtyzHmqZcUAR9b5olEnLMWNo4jbpGUM7YkPMdApsA3LZYI2hN9Ewdw1slEDp3l3
         x5Dv6zV67glSoi53qkHsrksg4E6JbEdJeJ0ghXlBESzKnXvnbk7qunYDWIv+bityGz6D
         h41g==
X-Gm-Message-State: APjAAAV4KctQNhzqXXCDUAvjRJvmb/i2gn1REtE06uHLHGkvNEU3mB//
        my2ze8UjdNlQIoc5THUxKQiRmw==
X-Google-Smtp-Source: APXvYqzo9/FdjdMy/rm+ux/zzuCDzs64hnhuS0f9Cbu5oq0R0BChyY/kjFKdvtNpy1Rib9l/GhHFOQ==
X-Received: by 2002:a24:e943:: with SMTP id f64mr17241456ith.32.1559577169293;
        Mon, 03 Jun 2019 08:52:49 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id j23sm2301492ioo.6.2019.06.03.08.52.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 08:52:48 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Dan Williams <dcbw@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>,
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
 <3b1e12b145a273dd3ded2864d976bdc5fa90e68a.camel@redhat.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <87f98f81-8f77-3bc5-374c-f498e07cb1bd@linaro.org>
Date:   Mon, 3 Jun 2019 10:52:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <3b1e12b145a273dd3ded2864d976bdc5fa90e68a.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/19 9:54 AM, Dan Williams wrote:
>> To be perfectly honest, at first I thought having IPA use rmnet
>> was a cargo cult thing like Dan suggested, because I didn't see
> To be clear I only meant cargo-culting the naming, not any
> functionality. Clearly IPA/rmnet/QMAP are pretty intimately connected
> at this point. But this goes back to whether IPA needs a netdev itself
> or whether you need an rmnet device created on top. If the former then
> I'd say no cargo-culting, if the later then it's a moot point because
> the device name will be rmnet%d anyway.

OK I thought you weren't sure why rmnet was a layer at all.  As I
said, I didn't have a very good understanding of why it was even
needed when I first started working on this.

I can't (or won't) comment right now on whether IPA needs its own
netdev for rmnet to use.  The IPA endpoints used for the modem
network interfaces are enabled when the netdev is opened and
disabled when closed.  Outside of that, TX and RX are pretty
much immediately passed through to the layer below or above.
IPA currently has no other net device operations.

					-Alex
