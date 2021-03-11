Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4863377E8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbhCKPe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhCKPeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:34:10 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B74C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:34:10 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id r24so1808051otp.12
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xYyhSvxm6J/RRX2yh8qS1lhrC9qeAd8re4tLM6qPRkc=;
        b=HC1bM1ymI9B6zUIpGW8mBabW8BlncyTrqLHNuMhbmegcJEnZ3Uz2f5534IJKp8fE+T
         o1FF1gmpeNP8CtpSqzJmtJ3yHTHvxO3CEXhgwxs58zuyQyaehyHCobzPuNgnk/pUJJuJ
         QK1yO+AH80A3XzKVYqS/Ndf4sC1FR8959GeoE/II8XN45XFyZA2einir/hHsfUQO8Muy
         2oxGnLW+bHG400Yv2EEP/FYXgOnXZveQWjES4gidsgyjNWbHsgiqQUydYcitUTwvaHVd
         SnaDd8JCcFI5cSceB2bKbRbzDl7PZoEnXxzt9EKji5X73HN0zkUBaQqVWLyYdgEiHmAE
         DvJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xYyhSvxm6J/RRX2yh8qS1lhrC9qeAd8re4tLM6qPRkc=;
        b=tmPlzkdjSiIT1TYny+t5Nxnvh4wipKggK12C863zKewVkYBjX68RgTfpHWyumBAbyv
         R4swEZGDhBNGlGUFOOGcohxzVO+pc/fTzVV9f1nKTWDL53PtMUjvK6Eb0awI1Xe3y08Y
         cASRBjaSpkK7X2kzCiLOGSqOp5Xj40M/sU/DmTx9ksf81C+krsOL7a8eT9j68vxh9rxu
         EjjMs6l2+3InzaKXSpcSIxGsJxah0jkf51KScXxEjjwULdts2BbO/7T7N06gCPLzDjYT
         e0HeaQUyIN9vunocsHGY8LYNda+nlnadWUk5v8DbFGeLc6KqyN3OCREVLuu2/0WUwKxR
         SBCA==
X-Gm-Message-State: AOAM533ikR9ZWQEuE0htbi+OiNsREoTgsM/qZLcpAoHMShHmdGrKq4xP
        qLUuGuSF340EP8Pte03ys6k=
X-Google-Smtp-Source: ABdhPJwvW60FPnSFWma3xUWiSrNUwUM7SYj4H+PJzxsaj8Z6IdG4w0519kx5pxEiDOxMA+j97+yIJA==
X-Received: by 2002:a9d:823:: with SMTP id 32mr7081798oty.306.1615476849955;
        Thu, 11 Mar 2021 07:34:09 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id 67sm686426otv.5.2021.03.11.07.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:34:09 -0800 (PST)
Subject: Re: [PATCH net-next 04/14] nexthop: Add netlink defines and
 enumerators for resilient NH groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <674ece8e7d2fcdad3538d34e1db641e0b616cfae.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b42999d9-1be3-203b-e143-e4ac5e7d268b@gmail.com>
Date:   Thu, 11 Mar 2021 08:34:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <674ece8e7d2fcdad3538d34e1db641e0b616cfae.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:02 AM, Petr Machata wrote:
> diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
> index 2d4a1e784cf0..8efebf3cb9c7 100644
> --- a/include/uapi/linux/nexthop.h
> +++ b/include/uapi/linux/nexthop.h
> @@ -22,6 +22,7 @@ struct nexthop_grp {
>  
>  enum {
>  	NEXTHOP_GRP_TYPE_MPATH,  /* default type if not specified */

Update the above comment that it is for legacy, hash based multipath.

> +	NEXTHOP_GRP_TYPE_RES,    /* resilient nexthop group */
>  	__NEXTHOP_GRP_TYPE_MAX,
>  };
>  

besides the request for an updated comment, this looks fine:
Reviewed-by: David Ahern <dsahern@kernel.org>
