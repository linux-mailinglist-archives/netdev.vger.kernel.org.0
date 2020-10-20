Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B7A293EBF
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 16:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731020AbgJTOcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 10:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbgJTOcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 10:32:07 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BD7C061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 07:32:07 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id z2so2461050ilh.11
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 07:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cg6g8EUa9aMYsveNpphQSbwDB9pxfXJrBONsPnATloY=;
        b=SRnBAquT2Kf05gkBlFMVIoh73dSp4JCrV83QKC+a82Ym2dD3m6o2SUJx3Llh9fD/Fy
         RRS1JWUEn6LEROURpeBkuyHUTzWjIs5DP29e+WKLcvOIaD4dmTzOy8uM86vba7ZBXacn
         uJmm7jdeGPi6dOxaeC53kOnETjAVGEGMuJ4eBC0k8OQkrPn2jeefwCk24DxqgCWEFUBb
         gj98J1OTuVcZRX3pHSi0JJUV13lG2rIdTgNX0HqRjY3QRvhoqOtUYewTbbJyTlq8Fvcd
         PNRT1ciG18Zdj/z671eMuKXaV4sSCosdBykQlv1Kj7rhs0vK2uiA1IXxcAxCeEQckW9m
         7sLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cg6g8EUa9aMYsveNpphQSbwDB9pxfXJrBONsPnATloY=;
        b=Ro9llyynl9f0bpW2qa8F8MaFwq9MupEoWI5RBnys+ghI3GBnVlCf1wT+scZfB3ixLk
         HDMoBh3V8nL+wMtyqE9uBhBXKSr3X28vhd/qLnQ2/tIsrp0QbM+gYySJBOoZ96zmBZA2
         DhA8UpP6oRYv/DHDtq3WGGf3Y6wkFHC9itNBv5ZCc+vlR1FuAop2cB1TES/H2ABknc12
         eJYoPmpOjPBXVBGmDirX1SlK/ZLLHEtDldcEAIVq8bGztx8ojNRn9nfvN/rArmGXpjtY
         UPXjmr0jyh0l1ElR3uMs/l58eaAqjC6Xm2hecK8wMtTpZjEStdcWN6SA+mpHQaGq3gKb
         x1Eg==
X-Gm-Message-State: AOAM532P0bSWczQ3yZlRtHt5KMTnnIp7Clw5f+Z5ZS8jQzpXwgXWCNoT
        25sUiCSBTsNdeVj5Ovl9KkU=
X-Google-Smtp-Source: ABdhPJxfmUdV48LyolYdTt+23SYORwj0ljxDOms5eIXXAVN2jk9lxPKKqXJiFqvhNGFSkYRDh6TpNw==
X-Received: by 2002:a05:6e02:eeb:: with SMTP id j11mr2176394ilk.295.1603204325080;
        Tue, 20 Oct 2020 07:32:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9d8a:40ec:eef5:44b4])
        by smtp.googlemail.com with ESMTPSA id s10sm2065739ilh.33.2020.10.20.07.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 07:32:04 -0700 (PDT)
Subject: Re: [iproute2-next v3] devlink: display elapsed time during flash
 update
To:     Jiri Pirko <jiri@resnulli.us>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
References: <20201014223104.3494850-1-jacob.e.keller@intel.com>
 <f510e3b5-b856-e1a0-3c2b-149b85f9588f@gmail.com>
 <a6814a14af5c45fbad329b9a4f59b4a8@intel.com>
 <20201020064519.GD11282@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0ebae10f-60f7-8fff-86d6-00df5c72ecf2@gmail.com>
Date:   Tue, 20 Oct 2020 08:32:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201020064519.GD11282@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 12:45 AM, Jiri Pirko wrote:
> I prefer long and easy to understand.

and the code needs to be readable as well. There is middle ground here
and reasonable naming schemes.
