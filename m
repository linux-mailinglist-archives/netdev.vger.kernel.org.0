Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1F42DFF8E
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgLUSUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgLUSUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 13:20:23 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4D0C0613D6;
        Mon, 21 Dec 2020 10:19:43 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id h22so16394543lfu.2;
        Mon, 21 Dec 2020 10:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nhDe/BCMy1bpe8hCLM6n7IPRX35zLkRkFl/2FWYE0uw=;
        b=bBWPTdcOWNF92BGCJhlfyeagaCyjwJYP95MUzWvg0Gq5sFv/Nn3W+7XFNn6f8U1l5E
         O6oow7bVnCet+4KRcT0unKxhsfttaHpCf8Ck/L69YMdklnTPer4Lma9jJeoV4D4lxqsP
         qtBoi9B8v0pga1/ZYkv8jclxyLY/4mycCF9vllLy1gojO/LYzCRRmhARFHwwmKvAo7zD
         8fOcyU7UZDv0XpQWaYCwb7Wrhhjmhtwzxc9TLGPo84Skw1QLRXrtoU++iPZF72FG+ep1
         Bf4AUtJ0G7Q9+nj0MI5Yn2jewwtXe/5yKnw1O8nXOrGtGOymS6Ag1g2Q/gtlhEnIL8di
         tSSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nhDe/BCMy1bpe8hCLM6n7IPRX35zLkRkFl/2FWYE0uw=;
        b=fPe4pNeEKuA0pzTSbF8LbM5/vXMofYdBX8+RtdEBMdwKzIqVLXaEd6sUNUy4Tsj8AM
         NVtgsPrXcFuinHVhvnU9DqIZHMkCz2Bm60HiOsDaO4/wIZt3nn9bIDqaFVsh0Mhk3Yzn
         t6TeqPnMBDIapQ44Z1u46a0+tcYGNW2BEjCxSo5p7wgPPwy+7EWtDjJ5yfwAQBDJ4rmF
         uUtCSRfrtnSUHyZNhaZFwlZGwlLsJCX1Wejjr+iCuqRn/CP8ZeZPwE5Ky1DLQPiUxat/
         qvD0QAhbpC9Upnbh0Hn7FjzyFvTEw+P+OsZHnIe7Ubma1UO3vyKXa2eigNH4mYCmebAQ
         pzKw==
X-Gm-Message-State: AOAM5328PuVYOu8cThWyT5omiiV8yzvBfG8C9Ar765U6DuJRtfxS9iEe
        6Bdk2GlPYUnuDu0+MdgzOqJZIfFz9j8=
X-Google-Smtp-Source: ABdhPJxypbmeb2XpRvaDP4/ZTe6ZZFdYrqnoeS28/f9lmNV2Gx1Bp3LzPG7EKopUAU6W1XKav2M5eg==
X-Received: by 2002:ac2:5f06:: with SMTP id 6mr7275073lfq.135.1608574781591;
        Mon, 21 Dec 2020 10:19:41 -0800 (PST)
Received: from [192.168.2.145] (109-252-192-57.dynamic.spd-mgts.ru. [109.252.192.57])
        by smtp.googlemail.com with ESMTPSA id c5sm2292599ljj.67.2020.12.21.10.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 10:19:40 -0800 (PST)
Subject: Re: [PATCH v1] Bluetooth: Set missing suspend task bits
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc:     Howard Chung <howardchung@google.com>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>, apusaka@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20201204111038.v1.1.I4557a89427f61427e65d85bc51cca9e65607488e@changeid>
 <ec27a562-d53b-a947-1a93-bd55a2dfcc91@gmail.com>
 <CANFp7mXdz8jYB0=tkj-mzWETo+M-Tx9ecTwEquh-JoDXRT54qw@mail.gmail.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <ff05fc01-3976-060f-ea68-8adf0f9321a2@gmail.com>
Date:   Mon, 21 Dec 2020 21:19:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <CANFp7mXdz8jYB0=tkj-mzWETo+M-Tx9ecTwEquh-JoDXRT54qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

21.12.2020 20:58, Abhishek Pandit-Subedi пишет:
> Hi Dmitry,
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=295fa2a5647b13681594bb1bcc76c74619035218
> should fix this issue.
> 
> Your issue seems the same as the one I encountered -- the
> SUSPEND_DISABLE bit (0x4) wasn't being cleared by the request
> completion handler.

Hello Abhishek,

It fixes the problem using today's linux-next, which already includes
that commit, thank you.
