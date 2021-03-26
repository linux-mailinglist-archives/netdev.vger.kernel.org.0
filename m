Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886F934A115
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 06:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhCZFiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 01:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhCZFhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 01:37:47 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785F0C0613AA;
        Thu, 25 Mar 2021 22:37:47 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id s2so3491506qtx.10;
        Thu, 25 Mar 2021 22:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=h4nP/hW2IjsV9gBeIhITMEtfKuipqQCrxcC+20/BgXk=;
        b=W5JQbo1ZSR8/xcePz/vI7NIkq7xmA3fcS3Ettjk1X7eXteJUqf9d+ettnAQVHMxElG
         RPZdKwmjgMPZs7H2M5H2M/GWASYLX13rZIz2SZztqc6U81K+MaF/8lq73feQG2TOI6ms
         dwZp9qS69wV0NJZoHvLXoTbkP85StBzCasj0P2/vhScRxn9xYLprBgI//ZdMnM/5nPGS
         rRdX4mgcbB4eso5LFRURJg1OqGjkTEzs7Tem/hcol3MmzMxGw4BIfNyIETqvjNZYOyex
         Urk4jMPCy340RXLG/ad1NL6FYUATogMf4u1aDE9SS93rh2EevSvw2javeIienK9o+JD8
         wo7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=h4nP/hW2IjsV9gBeIhITMEtfKuipqQCrxcC+20/BgXk=;
        b=dqnwatVsYLtlRjZO8sXZrm//xwH0zcATUjTyKaCnmhUf0WGhzyNGpYaftq2r25d0FW
         PXKmtiDqd/AG/AKNPjpfJ4mHYicygP2ftZ1qfe7hEzOj1SKw53xV2t65dNr1k6mBT8xC
         KRy4vfuARmtE/mO5BZajQVLoCPzrJZohCgjOWcP4T29keQhTIknxaRPzdxPEybfgIbv8
         prYpQXdFXMZ+ZeKXbdWKiarV/gJPz7zywpKZuNv6becdtshKYuxLtHbFoAayjQwRged1
         Swy3MvlIIJddHAWl03XXpijdfIFOZCO1P3ov/bpkp0bL7ImLLiFJhkpttqqAbWLxWpu/
         De9Q==
X-Gm-Message-State: AOAM532hTFV1G2g05yOgXQduW/AowM6nqVtBYIuJSRXLqqVKkAu5AYG1
        XqRGLQw/mvTGY2qZFQA4IDE=
X-Google-Smtp-Source: ABdhPJzkwVO2xEYSUZuseymSRMxn3v9UzfR9mLYe9dGOUb9AXSfGocDawr/n4bzITyDlPD3isMilsw==
X-Received: by 2002:ac8:4602:: with SMTP id p2mr11165199qtn.377.1616737066819;
        Thu, 25 Mar 2021 22:37:46 -0700 (PDT)
Received: from Gentoo ([37.19.198.107])
        by smtp.gmail.com with ESMTPSA id y9sm5820069qkm.19.2021.03.25.22.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 22:37:46 -0700 (PDT)
Date:   Fri, 26 Mar 2021 11:07:38 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: kinldy see the V2 ..just sent [PATCH] fddi: skfp: Rudimentary
 spello fixes
Message-ID: <YF1zImGzPwPsOSu9@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
References: <20210325070835.32041-1-unixbhaskar@gmail.com>
 <20210325.170911.1934364756284082401.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210325.170911.1934364756284082401.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17:09 Thu 25 Mar 2021, David Miller wrote:
>From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>Date: Thu, 25 Mar 2021 12:38:35 +0530
>
>>
>> s/autohorized/authorized/
>> s/recsource/resource/
>> s/measuered/measured/
>> sauthoriziation/authorization/
>>
>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>
>Does not apply cleanly to net-next please respin.
>

Kindly look in ,sending a V2 of this patch, hoping, that works!

>Thank you.
