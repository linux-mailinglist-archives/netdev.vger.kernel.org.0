Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F519375625
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 17:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbhEFPBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 11:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbhEFPBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 11:01:54 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D10C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 08:00:55 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso5120482otm.4
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 08:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wFWwf2vIaU/A61x58YBGKHgSTFlnYRIUtDEKfvp8+4w=;
        b=CW3il9xjx1R0RTfYFGYx69U2hFm5xYRj7TxBSWWLF7HtCcH6G+CAHJcsLnxLez3F/M
         I4ZS0UPzU8MW7yBJ5sqpNsmX+B2WeVdx5P8qQC2XqzkZjHkzc/FteunbSBNnVxqzTdIT
         OWSjyX0HUJSi4IvT6fpKjpPDWThT2Y2H8Foq1evqLNYZCjRGUDo8Rd1Z4L6d5PxEH81t
         era+NvBDvNVLDc40JJDfiiP1Dq+YZj0n3F40cLmPItWkaX1nGkBid+EHCzwfoL3umf1Z
         Hq3CSxvAE+x4ATBlx5nLjTEYzE+VHv8Kt+wdYUaEypFUqFXHDmgxLcQ1fuIu2SG1e8Cp
         cDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wFWwf2vIaU/A61x58YBGKHgSTFlnYRIUtDEKfvp8+4w=;
        b=fKdjZsoiIMIv/6O2xAMbrypQHo6cbYV2Dl1zV38V23DAMMRHAkPtJT/SCp6gPer2u6
         SRSarT0isa1NU7NnOhcsges22a9HRx1szxYxWIw5HANrY4E78DN7MayIO+BAi0BrDKkI
         ZqDyV7ZABud8jNbzoUi9Zt+x2twbFDNIptDf3rmoYaHG0wLR+6siOn1IqDZaA2fd6CYF
         Q3Ub80mgiVk5FnJGk7p0qjhnT0nmghPWamud6VAt+S7cP55ZRQIYoRmdqi44McppuPkG
         wmnByxvqHwi44aNJmT1hf7k4HHBuZ8Bk5O4z7TI+pv13mg6TlwEaQu9OT06HAHU64QFX
         ibJg==
X-Gm-Message-State: AOAM530hZCjfY+iA9KClBMiRXdxUPn15p8C3RUFFLC1DhsNOI7leHC8y
        5pelFSE/skqc9uc9bzh90HpAFaOW3jA=
X-Google-Smtp-Source: ABdhPJwox2xiPGCg52HIRWZJ9HddQ0S7vTi+DSODtX1wuM2gqrkYLhZkvd/H0AT13nM8uWdkl3hsYg==
X-Received: by 2002:a9d:4911:: with SMTP id e17mr4048623otf.38.1620313255212;
        Thu, 06 May 2021 08:00:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:73:7507:ad79:a013])
        by smtp.googlemail.com with ESMTPSA id h12sm614917otk.55.2021.05.06.08.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 08:00:55 -0700 (PDT)
Subject: Re: [PATCH iproute2] tc-cake: update docs to include LE diffserv
To:     Tyson Moore <tyson@tyson.me>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <20210429182847.10892-1-tyson@tyson.me>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a5dadc39-1ede-15e5-3d62-f904d4528e0d@gmail.com>
Date:   Thu, 6 May 2021 09:00:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210429182847.10892-1-tyson@tyson.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 12:28 PM, Tyson Moore wrote:
> Linux kernel commit b8392808eb3fc28e ("sch_cake: add RFC 8622 LE PHB
> support to CAKE diffserv handling") added packets with LE diffserv to
> the Bulk priority tin. Update the documentation to reflect this change.
> 
> Signed-off-by: Tyson Moore <tyson@tyson.me>
> ---
>  man/man8/tc-cake.8 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

applied. Thanks,

