Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1559E35E725
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346157AbhDMTgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbhDMTgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 15:36:12 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C048C061574;
        Tue, 13 Apr 2021 12:35:52 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 10so3226726pfl.1;
        Tue, 13 Apr 2021 12:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NSQLqcQIP4We++UbzEFXxCyo4aVGb7LfzEhcZ574DGs=;
        b=avIbIxvDT416GJ7tSkJbDJcQviNJJAhGyo2KhdSYzvkspDBFX2PuA6Ga2p9IXgYxSb
         +j2pqn/mNrpSSYrgOMMvReYxp8WiDJo93lea7tALAk9sIdaYG/yiDT2O4tWldHXVp6HU
         q5QR5zp0FI+1lfBVIPAUJQA0DzqWdBGeurQTbopK/hfBLgjUV8fkLDfD6+GizDfior7e
         xOKMRWqNcNDkPJWHe2isdTUgl1sww0/2kv286wH7z3HXWCzfEOJZeXtFAJi5zPWWBPGY
         SmzxbhsvjBkeYKRx2CHcpr9LId+oTXi7MSlowRL07Cj8ISIYRFQH6KBu3N+BS0Nf+5YO
         jorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NSQLqcQIP4We++UbzEFXxCyo4aVGb7LfzEhcZ574DGs=;
        b=aOC0N962JYu5eIqVdvS3kkahYN8s3KsxX21vxH7cTyFhMlcAXbH8BvLHnt9y4qHV6n
         Hy+USMl40YJGXsuSc3KuXPF+gB9d4ZLbTSnzZ3NAznC4Hgn2DEMuOWtxuly5j2CDqR1v
         hZCvnqzVpFmaYXJ3QGR17V8uOCq06ZTPchSaO+Xug0sB6/qRo+xe3+M4N2f6yrRkQPMq
         0D4G3kjP/6MGfyea3ReACj8JIhwm87v3fCpEEiIYihf6V6aVjFvBZjgRIyFwIKpOJf0j
         x/LXuDsYR2aPWB/MJ7RWibg2Qnm1v3McPxEQXfqsGsoC76RhhXUjgHaIJgpFljlFI+GF
         iKHQ==
X-Gm-Message-State: AOAM531enL8ShcR3tDciIrhxQExJQDQsgNzIcMpZYYksMHgz2RA9itav
        NjvpMCb4RnSIeLCSqpZvLLQ=
X-Google-Smtp-Source: ABdhPJx6ezo1Shhl8rtl19zuEZ65dkLmNOfbVkHvB8cFh6RYPNOn866ph8ZYwz87sj7YEGCCkBf3lA==
X-Received: by 2002:a63:1717:: with SMTP id x23mr33361708pgl.89.1618342552008;
        Tue, 13 Apr 2021 12:35:52 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 33sm14663484pgq.21.2021.04.13.12.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 12:35:51 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: lantiq_gswip: Add support for dumping
 the registers
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, olteanv@gmail.com,
        vivien.didelot@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
References: <20210411205511.417085-1-martin.blumenstingl@googlemail.com>
 <YHODYWgHQOuwoTf4@lunn.ch>
 <CAFBinCD9TV3F_AEMwH8WvqH=g2vw+1YAwGBr4M9_mnNwVuhwBw@mail.gmail.com>
 <YHTbk3g2rM8zZZ5h@lunn.ch>
 <CAFBinCDvQNhyxdPo4=q7b5E6oe3_wVGG0g-QFvNRz2BQ41S-Lg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e77c8dc1-aaa2-077c-790c-4bcefdde7479@gmail.com>
Date:   Tue, 13 Apr 2021 12:35:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAFBinCDvQNhyxdPo4=q7b5E6oe3_wVGG0g-QFvNRz2BQ41S-Lg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2021 12:25 PM, Martin Blumenstingl wrote:
> On Tue, Apr 13, 2021 at 1:45 AM Andrew Lunn <andrew@lunn.ch> wrote:
> [...]
>>>> and a few people have forked it and modified it for other DSA
>>>> switches. At some point we might want to try to merge the forks back
>>>> together so we have one tool to dump any switch.
>>> actually I was wondering if there is some way to make the registers
>>> "easier to read" in userspace.
>>
>> You can add decoding to ethtool. The marvell chips have this, to some
>> extent. But the ethtool API is limited to just port registers, and
>> there can be a lot more registers which are not associated to a
>> port. devlink gives you access to these additional registers.
> oh, then that's actually also a problem with my patch:
> the .get_regs implementation currently also uses five registers which
> are not related to the specific port.
> noted in case I re-send this as .get_regs patch instead of moving over
> to devlink.

In premise there is nothing that prevents you from returning the port
registers as well as the global registers for any .get_regs() call. This
is not really beautiful or clean but as far as register dumping goes it
would get the job done. devlink is better organized in that you can dump
global and per-port registers and they show up as separate regions.
--
Florian
