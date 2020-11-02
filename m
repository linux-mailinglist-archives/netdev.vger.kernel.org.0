Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2322A25E7
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 09:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgKBIO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 03:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgKBION (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 03:14:13 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BA9C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 00:14:13 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 33so2641428wrl.7
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 00:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=O5GOyUIxXz28PsstTdZ2miQXR8iTJbYvbl6yBHVU9nc=;
        b=PN788bOfPHcLJH7wFHuBziPW5UsobCNUVV1yGtCXIQpJU7UO78lMe0jMgtIsMcT+Zg
         CUJ8CG4wfFZgboOFixTj++7GkHT7XMpicOivbSrvqFEjtcV7ROBcfd2KtO/zLsOu/DDd
         2eHvmmIeDZMSiB/LpUKjPshiHloo3O5e/6BeJ7kmF9Ig/BIAcN9UqhPvAMznNvHGXi4m
         TsC6iDJNn/JiIupI+Ue6kGmk+loBrsV8kQovCsm8QI4zCMrLj/MwJ14JQRiCBMtXKS+o
         AgKdKrHmZR81PD3/Y/SVpiQai8IeZnbxDLcsShdP0PaeCcBiLIiUZ33Bu9qiTITg/5oH
         FfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O5GOyUIxXz28PsstTdZ2miQXR8iTJbYvbl6yBHVU9nc=;
        b=ZYCPYaB91AFSCHuC8XgzTrFT7aTk3IQQPqWEAwHDkZiCLL32eiZokz68EsSDwJsQUU
         tdSJ2eKl8XFBj56euqZGpUJAoMTGSi59t+INIKg7G8g/lYkY8sJY6JiVDcn536u0f/ym
         cAJVRBQ6dThyu/gZzs+REfgyhSCrj+6qiLT65QwIqC9eE7QnC8Gm08c1klvuZZ1GdtW4
         59O978dDJ/RdBaT0a3PajEUa2cq32W/3SpZYtTblEvUCi1eQHiDNgEcYS4rOYOAXBM8H
         jmM/Yx9NLNsV0r3MRNYeXw4kFi4mDXH44KwcADGfiI0mHGhogR94xq1AwE3kPaqkaMi+
         7XOw==
X-Gm-Message-State: AOAM532Ov2ovKzMS4b0D+08OOQwzli77bw24e84f/uPf5NiRbEqyFTDV
        kwQNQQECqmqWICYONipP1eFuWCLdB8Y=
X-Google-Smtp-Source: ABdhPJyG9TAW9vaIufHm77MXgbaCkaxj8zIdnIGHZ93n6M/JTn8dDpIu1ptajSlp8paTpmcQNiFfLg==
X-Received: by 2002:adf:e582:: with SMTP id l2mr18571818wrm.293.1604304851790;
        Mon, 02 Nov 2020 00:14:11 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7ce1:60e1:9597:1002? (p200300ea8f2328007ce160e195971002.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7ce1:60e1:9597:1002])
        by smtp.googlemail.com with ESMTPSA id n4sm5541530wrv.13.2020.11.02.00.14.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 00:14:11 -0800 (PST)
Subject: Re: Fwd: Problem with r8169 module
To:     Gilberto Nunes <gilberto.nunes32@gmail.com>, netdev@vger.kernel.org
References: <CAOKSTBtcsqFZTzvgF-HQGRmvcd=Qanq7r2PREB2qGmnSQZJ_-A@mail.gmail.com>
 <CAOKSTBuRw-H2VbADd6b0dw=cLBz+wwOCc7Bwz_pGve6_XHrqfw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c743770c-93a4-ad72-c883-faa0df4fa372@gmail.com>
Date:   Mon, 2 Nov 2020 09:14:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOKSTBuRw-H2VbADd6b0dw=cLBz+wwOCc7Bwz_pGve6_XHrqfw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.11.2020 04:36, Gilberto Nunes wrote:
> Hi there
> 
> I am in trouble when using newer kernels than 5.4.x regarding Realtek NIC r8169
> 
> Kernel 5.9.2-050902-lowlatency (from
> https://kernel.ubuntu.com/~kernel-ppa/mainline/ and also compiled from
> kernel.org)
> 
> Generic FE-GE Realtek PHY r8169-101:00: Downshift occurred from
> negotiated speed 1Gbps to actual speed 100Mbps, check cabling!
> r8169 0000:01:00.1 enp1s0f1: Link is Up - 100Mbps/Full (downshifted) -
> flow control rx/tx
> 
> Kernel 5.4.73-050473-lowlatency (from
> https://kernel.ubuntu.com/~kernel-ppa/mainline/)
> 
> IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0f1: link becomes ready
> r8169 0000:01:00.1 enp1s0f1: Link is Up - 1Gbps/Full - flow control rx/tx
> 
> Cable is ok! I double check it....
> 
The downshift hint didn't exist yet in 5.4. Can you check what the actual
link speed is under 5.4 (e.g. using iperf3).

Under 5.9:
Does the downshift happen directly when the link is initially established,
or after some time?

If link speed actually differs, then please:
- provide full dmesg log
- ideally do a git bisect to find the offending commit
  (as issue most likely is chip version / system dependent)

> 
> 
> 
> 
> ---
> Gilberto Nunes Ferreira
> 

