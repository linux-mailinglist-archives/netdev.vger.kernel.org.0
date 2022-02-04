Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BEC4A97C9
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 11:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357305AbiBDKaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 05:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355714AbiBDKaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 05:30:04 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E2FC061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 02:30:04 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id f17so10456508wrx.1
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 02:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=O0IhaDE2lAkgh1vz985YsOMgdwQutpfFWZR3lCpOpRY=;
        b=Fyw+bAWIYyxNUByXlnijwzsNdmHTIWI9bfTgQpfTFFIGN/VcTn1WXOAE90se49qzAZ
         d9d641zs7eUiVvmv5oxANYOohSyXa7WLvxmhHMTirQsQ8WI2d/HFrvFsmWfhNT2q4+5C
         lsJIJq2eepsI4beFs81BVJTSWNzN6pKJzLrSNVV/J4IxiarKgLIAG3+0+VpGaeLBMzPV
         th0s/XNFifZbnJsMtc7XP6iJePGDr6W4E/Y6+HRpMEGF/95xLwgC4mSxmThF8tvYzy9n
         XNc4wUI2GxnjyzmDlScCAEFVg3z6ZfPmZTRU/fRWFODX4koqfkz3GCkWvZ5VHiXYi8QI
         zCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=O0IhaDE2lAkgh1vz985YsOMgdwQutpfFWZR3lCpOpRY=;
        b=Tejgr+7sbIMM7Fj4vC+nktwgnAE/NkquWRUJt7aBWDknC7+Af6KNJaGkDMRdeNz/Tv
         4JmkPaJYhfH/TjuYysDddzJKmSjDe/xo+/XSP5M95PpjHvuOI5Wsq2QHiVp5xUaJ6rD3
         +VmfQEI8iscYdRxYH+waqzOWhKXJ5RyT2Gif/tYLz1JlhuOrslljeg5VDKLSd6asEske
         dNZ3qX/wGk3AQV0t10UqJTOL7XYRyXby4C+QBVIMR9UbCYldxG0cmySYzHGwdD0+DOCH
         YDofTYbgrywiKe2EzE9LLW1KnPU4VerEQH5/eI2hBVJVCR3nJsxGaKXPxpYdwFCkLW7+
         AZ5w==
X-Gm-Message-State: AOAM533+Lupz7DnF+th1d28EADsuTf0GJT295riK/F3yUwlyhZ1EyKva
        m5YhVok2UeGM4CEBsTcaQZsSgw==
X-Google-Smtp-Source: ABdhPJwoK8fN303VHC9osBEabKC9KTJTcj56wkXbsB2g7ZUzqTVb5p2xLtTtAUaHRuehD6n1JGM/Lw==
X-Received: by 2002:a05:6000:1861:: with SMTP id d1mr1898246wri.92.1643970603139;
        Fri, 04 Feb 2022 02:30:03 -0800 (PST)
Received: from ?IPV6:2a01:e0a:b41:c160:6954:fe60:5398:2a42? ([2a01:e0a:b41:c160:6954:fe60:5398:2a42])
        by smtp.gmail.com with ESMTPSA id n10sm1854466wrf.96.2022.02.04.02.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 02:30:02 -0800 (PST)
Message-ID: <8c08a4e0-83a0-9fc1-798b-dbd6a53f7231@6wind.com>
Date:   Fri, 4 Feb 2022 11:30:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH libnetfilter_queue] libnetfilter_queue: add support of
 skb->priority
Content-Language: en-US
To:     pablo@netfilter.org
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <Yfy2YxiwvDLtLvTo@salvia>
 <20220204102637.4272-1-nicolas.dichtel@6wind.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220204102637.4272-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 04/02/2022 à 11:26, Nicolas Dichtel a écrit :
> Available since linux v5.18.
> 
> Link: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---

Should I send another patch for the 'set' part?
In this case, a nfq_set_verdict3(). The name is a bit ugly ;-)
Any suggestions?
