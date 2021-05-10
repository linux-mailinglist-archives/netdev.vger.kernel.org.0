Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E9A3790FA
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244851AbhEJOiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 10:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhEJOgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 10:36:14 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747A5C06125F;
        Mon, 10 May 2021 06:59:02 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id p14-20020a05600c358eb029015c01f207d7so3223283wmq.5;
        Mon, 10 May 2021 06:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oOiV5WgMi7Wi96u1A0j7aVHx72rSJUWKb9L7JASEw6U=;
        b=eI3N1Fpg9OGfxDYeN9CkM6JnUmUHl5WgQKsZJBAEe06N6eQIW+N/2eMqTIlrsyK/qM
         Xa35uzmXt4bi7Z5ExQmBDGcCmQr1UD910O1m2RozktwaOIV8OjhOXtuMqdS2t5KIlfV2
         /xSjuQtpNfwsgUMZT4YbuSWeEoVUpnkLWdYWx57GHC/JMnIbfeomB6X1EwhI6GqtNjJz
         5mS+m2iGgDDSAr7pACiBgtShvHO5CxZyag+ZmeEb/XAmakP22Iz1mAVAu5X4yPcneMls
         MNKS6aX+UYGYTiDpkPzh+zNyC5KsbwVbzbmTl9DNNLPJNUbSwFzwjXpWYoyfaT3bHk/5
         tcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oOiV5WgMi7Wi96u1A0j7aVHx72rSJUWKb9L7JASEw6U=;
        b=RE/Wygko9Mp3kdIWtWRpJqqPmeF+t4NsDu7B9pkIQBtIN3y8dEX3plIe+hsz5pCias
         cGEiXuSTxRSat2OG08sE4uAzNtk9mFihLdDtbeLCF3S0YFVfapUgED+Iy6C5TNNe23+A
         NjmtMikvBXBSffFOTvkhQpSTSltJuPkPqu8SBy/anL15FsMNCKo7rLpWrCr0vLV+yYVM
         amHozn+Pj5algJtq82JQLBOWD3Vj43ZdWpFRkm2PeVwkN2LB65tv/tPV13xCUOMon2PD
         q++0EbiRVw12g0cvWZIPGRzVhcUi2HYRJSRU3Te+GXiBLB4vY2mu7/tZHvMQVd2CkBwc
         d5rA==
X-Gm-Message-State: AOAM531B6vgcrgA/OugSAwakzk8lsc8kEb0Ilqb5rMR1ik1a2Og85K3p
        JhRd8ualkONJCPOOZh1BDd4=
X-Google-Smtp-Source: ABdhPJxuRWxshXLY3D3BIGKPZC8k+BUcpGElfoLV7AagS8fiv45gCBBhTdzQWkysFh21R1ZatES2dQ==
X-Received: by 2002:a1c:e38a:: with SMTP id a132mr26226331wmh.135.1620655141215;
        Mon, 10 May 2021 06:59:01 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id d127sm25703586wmd.14.2021.05.10.06.58.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 06:59:00 -0700 (PDT)
Subject: Re: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as ASCII
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org, x86@kernel.org
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
 <2ae366fdff4bd5910a2270823e8da70521c859af.camel@infradead.org>
 <20210510135518.305cc03d@coco.lan>
 <df6b4567-030c-a480-c5a6-fe579830e8c0@gmail.com>
 <20210510153807.4405695e@coco.lan>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <b3366f65-35e1-8f1a-d8d8-ebd444c9499d@gmail.com>
Date:   Mon, 10 May 2021 14:58:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210510153807.4405695e@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/05/2021 14:38, Mauro Carvalho Chehab wrote:
> Em Mon, 10 May 2021 14:16:16 +0100
> Edward Cree <ecree.xilinx@gmail.com> escreveu:
>> But what kinds of things with × or — in are going to be grept for?
> 
> Actually, on almost all places, those aren't used inside math formulae, but
> instead, they describe video some resolutions:
Ehh, those are also proper uses of ×.  It's still a multiplication,
 after all.

> it is a way more likely that, if someone wants to grep, they would be 
> doing something like this, in order to get video resolutions:
Why would someone be grepping for "all video resolutions mentioned in
 the documentation"?  That seems contrived to me.

-ed
