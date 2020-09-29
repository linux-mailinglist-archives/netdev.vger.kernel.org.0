Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C61627D2D8
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgI2Pdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgI2Pdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:33:53 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DCAC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:33:53 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x123so4899292pfc.7
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=75Wtqt4lyWjdgHnzmMKcLoHHW511LYAPmeWuH2PwaTE=;
        b=C5XnqBADNg+dHeTJ1FfeSip5kMSFAHCyAGfgQ7dv4+KKFDjI2Y28xOJCX9iZoc5Sqv
         c7LVRO2keBrZnfp1JH03G3+dW/vTlRo2BT9He2Y/lMegDDAKZZ22E5p97B+/r8H/5F9e
         cT2k8sIjNSiLSIQSqD/UHqbKoA/3SvrqOiAMr8gP1a+63wseQ7ZSU96BCa0r8QOcwYHM
         Lw5sZ8pAP+7Fz/KQwJ0I/rF7jI3PuA98gfZGz9Bp3sOEfhU9PUtwAzzm5zLxNUn4Vxp2
         AcL7FO2yzudI/TEMhUHcP067GDg5rKelzDwiW4M3YgRC8le62OA5HIwX8WBWiV0022vA
         NP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=75Wtqt4lyWjdgHnzmMKcLoHHW511LYAPmeWuH2PwaTE=;
        b=AiSuBrEUcmOdbmqnv8he9OoC11FVmwteCj+jbOYPFmAus/IxtAQHIHdDd6RHcPFkTt
         yZjr7h2ZF3GF16cnx2TvEqMqQS0oKFcahIlckrTpvHWI7fQLLScekxG5w9M/0FJXC8ST
         id2RtzF7HHDVg/BW22EAFa2BocdvrHgJILBi6U7zPDCB5ypmEUK15s01O1gnrt3TlO/G
         oleSVQrQuOF6ry7rePM+B3SIq43RKThSs/sDa7qBAlvIe8AazatcyEcENiaIIU5hSA0l
         SAQuB2RrhkbBxuwB8Yyb9D4ITbsV22RJ5PRUTQrr1m5BxwqOzENLWTlBD1Wc80g5hRzC
         WnFw==
X-Gm-Message-State: AOAM533zvNsV7Iv9ty4nzS4leGHX4+ZC624JLwTAHIjsMY0949UTIhrq
        7LD1C/hSsWuwwcBNp6MkSLQ=
X-Google-Smtp-Source: ABdhPJyu7HSjZC0Saw9lgl+CiUBOYGDPIogF2ZsAMx3feb5S4Q7t025ZdetfPMpFivF258zmoRIefA==
X-Received: by 2002:a65:5185:: with SMTP id h5mr3762091pgq.37.1601393633049;
        Tue, 29 Sep 2020 08:33:53 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-24-23-181-79.hsd1.ca.comcast.net. [24.23.181.79])
        by smtp.googlemail.com with ESMTPSA id ca6sm5016479pjb.53.2020.09.29.08.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 08:33:52 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ss: add support for xdp statistics
To:     Ciara Loftus <ciara.loftus@intel.com>, netdev@vger.kernel.org
Cc:     bjorn.topel@intel.com
References: <20200924070327.28182-1-ciara.loftus@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6f7983e8-776f-4d8a-2f25-a03f15ce7d6b@gmail.com>
Date:   Tue, 29 Sep 2020 08:33:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200924070327.28182-1-ciara.loftus@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 12:03 AM, Ciara Loftus wrote:
> The patch exposes statistics for XDP sockets which can be useful for
> debugging purposes.
> 
> The stats exposed are:
>     rx dropped
>     rx invalid
>     rx queue full
>     rx fill ring empty
>     tx invalid
>     tx ring empty
> 
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  misc/ss.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 

applied to iproute2-next. Thanks,

