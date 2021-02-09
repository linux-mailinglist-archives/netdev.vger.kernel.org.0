Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F8931461F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhBICTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhBICTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 21:19:23 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D02C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 18:18:42 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id t25so16196160otc.5
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 18:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KYYkN1iKcJLp9g5sWk02Nh+O1Qz56/IuMldHy06D97o=;
        b=Nilm3zXkGRJlgGoTEMdxzb8e36dFUL2L24XP1g8UfBBG7jtnLy5+B6WPzuhZjxRF/W
         H9uvvuHdO5ftn6I32gSO4Gqhq2obP+pyjtITwAkrOzXUwrQe45mrudDmUAlzzULv8eTk
         /UXb4PhNqaYEK7fKf3wAn/5oNZBe9X2BqLYzPNUvczMHVmmLWZlEnXfvgSetJKWq00bI
         C1qy71zFIGFmqmAEBP+QS8ZFEKZ1ixBMiDweZsvLSBuKcNsNsct6o17TP7dF8kWL1Wo5
         13GgNm5fpjOnZehomz97s0Xe88cf7hJ08UktepzRm6L9IV2Zxg7E5rtuAn7Phz7YJ5Gj
         O7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KYYkN1iKcJLp9g5sWk02Nh+O1Qz56/IuMldHy06D97o=;
        b=IHs8ipuk9ziBj3SODb+2XAm1+LcdY3PUTn8Kjm+2At6+0HDF+/DQXGJs8GLIhXXO5n
         zzqYXZ0QZr2uvNi+Uq0tjdUmdrUUtdtmBViqHZ7L3NbDiMUpCBrVXN54wn0dIedmpvbm
         wx/D4ylnTSueMCFcsfxX0ZXN6OHj/66gNHREyADIMmCLkgiwG7V2P2lFqnHi5HU9Fy0l
         Ixr1nKUFIrzkENw3xPYH9h0KSWRsrTEre8Pwpn+HF3tIlYeBz1ybyQgLJSYcHyBjgUPL
         G71LHt/HRQHo8/byHgJZ6dSYPp7Hv5pibGuQ1f1Gl6frcz4sjvG68vYSZcdBi6LFtMgV
         NP1A==
X-Gm-Message-State: AOAM531CNmXgQSQ1D3ODayYfSy2BKkJqHmkD1snHqd57qcf1DMTKeXWi
        yuPpUJNepR2gUw+fVmz5Rkk=
X-Google-Smtp-Source: ABdhPJznNuBvBowi01JgWKONkRZLMohAsQ7w2M7ynsasrk/1/mDXf4TFr2psaMHyP/24w4SUC8HCaw==
X-Received: by 2002:a05:6830:4121:: with SMTP id w33mr13941649ott.361.1612837122440;
        Mon, 08 Feb 2021 18:18:42 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id x7sm3982388oot.15.2021.02.08.18.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 18:18:41 -0800 (PST)
Subject: Re: [PATCH net-next 7/8] mld: convert ip6_sf_socklist to list macros
To:     Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, dsahern@kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <20210208175820.5690-1-ap420073@gmail.com>
 <8633a76b-84c1-44c1-f532-ce66c1502b5c@gmail.com>
 <CAMArcTVdhDZ-4yETx1mGnULfKU5uGdAKsLbXKSBi-ZmVMHbvfQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8e1d588c-e9a4-04d2-62c3-138d5af21a32@gmail.com>
Date:   Mon, 8 Feb 2021 19:18:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAMArcTVdhDZ-4yETx1mGnULfKU5uGdAKsLbXKSBi-ZmVMHbvfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 7:05 PM, Taehee Yoo wrote:
> Thanks, I understand why the arrays have been using.
> I will send a v2 patch, which contains only the necessary changes.

please send v2 as a patch series and not 8 individual patches + cover
letter.

Thanks,
