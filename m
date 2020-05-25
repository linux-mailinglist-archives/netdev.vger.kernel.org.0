Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E501E0699
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 08:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388579AbgEYGA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 02:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388320AbgEYGA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 02:00:26 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512B2C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 23:00:26 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id i15so15903747wrx.10
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 23:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=x/n/hAVqDniu1TSHMHVCMBBJ/xkBeSVDE0RYNdvNfLc=;
        b=BTGF0PoRn9yfhZOXsGtRCBzmasMSCYNDOr4STh0cEzAgxRyWItnopaonI13llw4/2z
         Rnd/djXd4Uk6mTwve2gHO9HNgPprWg8nE8Zf1/cBBf697IvP/0jW2nfkZEHka1PxhNZN
         KXF1oQswxsEU5S55djoD3l4cjB2N+YRf6TE9klbaKi1xiZRgueYNXfogD3wVFjYN+yAp
         GUchwJAw/+pT1T7fnv9jg/5HobJHNhW11NjAqZrRXkYW+P7buCbcR0nswC2NEiyBEVhQ
         TQSmUD8F+MLltyIZiEGUT86gluGQ/Faz2pNdFBQpnCZYOj+BXZWFuaPaRLnz79QIz/90
         81Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x/n/hAVqDniu1TSHMHVCMBBJ/xkBeSVDE0RYNdvNfLc=;
        b=TktCEz/fcW+QXNvaAWwNXLzTxpjg4x+vuYLT46cVOn8rFm6Y0hQWCmHz5uFHVEgV5/
         5c5M8HqbKMTv01TuWWWz7axuUzzD4lkQ1eVip0c31ou762FC8pnzS9QLstaPcPYfVk9w
         4KtGSNFVNFlcNTDjEW+B/3xQwlT6Z1oAtmjs6Yrfcglkk807QYKC4kuPC7RjIerL00+W
         KXU73CHGSLXee42rqaVWgCZKXMw7GC8nRYaaDyN71eJojoHMsoMd0A8kv4KlFKeVJodQ
         MWL6CE9VY2CrLHZ2S6qmMeMd+0h4V7yIVfstaBJ9+lRA8Rjla09g8K1ov46GwhSAfzb7
         S5fA==
X-Gm-Message-State: AOAM5302mCEByK2o5WHDqZu149gvChyEKT1bwMtnbG+OMtGcZ9y5LvgI
        zmacJj6PLe/CdpgRSU5VbTawIOZX
X-Google-Smtp-Source: ABdhPJx6t0KPN7N/4IRDCgDJY4mX4OqwQCk7ayh+hI71k8dtGaOgU7ql/0Mkqp4kgMBLPdTeyumqZg==
X-Received: by 2002:adf:9f48:: with SMTP id f8mr13684520wrg.228.1590386423900;
        Sun, 24 May 2020 23:00:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:5075:1b4e:3fbf:e7ef? (p200300ea8f28520050751b4e3fbfe7ef.dip0.t-ipconnect.de. [2003:ea:8f28:5200:5075:1b4e:3fbf:e7ef])
        by smtp.googlemail.com with ESMTPSA id m6sm16527819wrq.5.2020.05.24.23.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2020 23:00:23 -0700 (PDT)
Subject: Re: 8111F issue
To:     =?UTF-8?Q?=c5=81ukasz_Kalisz?= <chemiczny.kali@gmail.com>,
        netdev@vger.kernel.org
References: <93361356-3700-5d3e-34d0-559421e81532@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f7327eaa-daf6-2b89-14f5-463b0f0f4aa3@gmail.com>
Date:   Mon, 25 May 2020 08:00:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <93361356-3700-5d3e-34d0-559421e81532@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.05.2020 21:54, Łukasz Kalisz wrote:
> Hello
> 
> 
> 
> I have been using several boards with reraltek ethernet
> 
> and everyone was just working
> 
> now I got board wirh 8111F (previous working was 8111E) and I'm loosing connection once a week or even earlier
> 
> I tried using 8169 and 8168 modules (gentoo, 4.9.120 kernel atm)
> 
> 
> Is there something I do wrong about it?
> 
> Appretiate for any help
> 
> 
> Lucas
> 
At first the question is what "loosing connection" means in detail:
- anything in dmesg log?
- physical link breaks?
- MAC stops sending in RX and/or TX direction?
- packet errors? (ethtool -S)

Try a recent kernel, and if it turns out to be a regression,
then best bisect.
