Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4652A380827
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 13:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhENLJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 07:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhENLJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 07:09:50 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39449C061574;
        Fri, 14 May 2021 04:08:39 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so1248684wmk.1;
        Fri, 14 May 2021 04:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DnsDrIqkWnYf7da8HpIWFBQQt2XImu+6ZyHWBvjrfcE=;
        b=sDX/4vOZ59ic93Kj1k7EQHH5H75TwRxFQdfU97NsB2/Y+xVttZgCu6VcmdiZBbTXV4
         Yd9dS94Y1asR2VIYZN7NEerfwgmtEUFK3NZSUIzeY6J/4AmyVofgnwxiuO5puvulkCHX
         zAH+iCNJUU2yLFhQkplxklOlcyZUbrmQbTIThNq4BukYbZy9X610Bla24hpoPnMCKKtF
         HaX7GWwtAjZyjiNuvWcCoIBPkXTf9xY5aCFfjMGcrbRCdRoMLY/c+VX1+t1XGHSYNqtQ
         /vEAS8jymBn+QTD3oR/5dtU3nH62pPJpzKh6iPn38AjBb8Fr8EpkCArPsjTRrMSNZ8n3
         9CtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DnsDrIqkWnYf7da8HpIWFBQQt2XImu+6ZyHWBvjrfcE=;
        b=TD856n5ZaQSeJHGEx9lBl3DYJwSrmzWVHV1McUmXOwhUBLbSBNiZ/6VlNVh199g9Ri
         9ldmsRKsgTpW0jJKu8wKKq9vTGxH8oYk1RYzr0pjjLyUXEWToFutGV6NHvDxrr3dRNcd
         xpI6drJa0q8KxQI7Q383NhY5taZvAWG0bu4SH+Vv8KsL8GmXv+26WjLv17OjGJIsC9KP
         zFk3FPiWWaCXwZzHBuEalGXketW02Jwpz/pzIJrrM7hhmVXx0ONOcWgQH31a0goO2DN0
         0t4ahJ7da1+KepMU+CFz4Dgi5zZsjD3BtWZd2x/DzFYx57euWgcPya3+ADCpQXiDX1a0
         9KEw==
X-Gm-Message-State: AOAM530kBEY1aeTl7/fqP01xjKBxsG+XUhMJjIAC3GW4JTFpOAA74x2o
        06yceDCYnkP+PZ9QsYvx+4mADfV1+btBCg==
X-Google-Smtp-Source: ABdhPJwViz0BDPUuVH349RqXP0p4zCVFhrVjXNorTYnm55dAjMiaqH0FajvtM+sJwCYcinjBh5k1qQ==
X-Received: by 2002:a7b:c005:: with SMTP id c5mr21007074wmb.113.1620990517974;
        Fri, 14 May 2021 04:08:37 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id b10sm7116349wrr.27.2021.05.14.04.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 04:08:37 -0700 (PDT)
Subject: Re: [PATCH v2 00/40] Use ASCII subset instead of UTF-8 alternate
 symbols
To:     David Woodhouse <dwmw2@infradead.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mali DP Maintainers <malidp@foss.arm.com>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
 <d2fed242fbe200706b8d23a53512f0311d900297.camel@infradead.org>
 <20210514102118.1b71bec3@coco.lan>
 <61c286b7afd6c4acf71418feee4eecca2e6c80c8.camel@infradead.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <8b8bc929-2f07-049d-f24c-cb1f1d85bbaa@gmail.com>
Date:   Fri, 14 May 2021 12:08:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <61c286b7afd6c4acf71418feee4eecca2e6c80c8.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, 2021-05-14 at 10:21 +0200, Mauro Carvalho Chehab wrote:
>> I do use a lot of UTF-8 here, as I type texts in Portuguese, but I rely
>> on the US-intl keyboard settings, that allow me to type as "'a" for á.
>> However, there's no shortcut for non-Latin UTF-codes, as far as I know.
>>
>> So, if would need to type a curly comma on the text editors I normally 
>> use for development (vim, nano, kate), I would need to cut-and-paste
>> it from somewhere

For anyone who doesn't know about it: X has this wonderful thing called
 the Compose key[1].  For instance, type ⎄--- to get —, or ⎄<" for “.
Much more mnemonic than Unicode codepoints; and you can extend it with
 user-defined sequences in your ~/.XCompose file.
(I assume Wayland supports all this too, but don't know the details.)

On 14/05/2021 10:06, David Woodhouse wrote:
> Again, if you want to make specific fixes like removing non-breaking
> spaces and byte order marks, with specific reasons, then those make
> sense. But it's got very little to do with UTF-8 and how easy it is to
> type them. And the excuse you've put in the commit comment for your
> patches is utterly bogus.

+1

-ed

[1] https://en.wikipedia.org/wiki/Compose_key
