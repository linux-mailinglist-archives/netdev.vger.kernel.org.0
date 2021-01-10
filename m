Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9BA2F089A
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbhAJRTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbhAJRTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 12:19:00 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359CBC061786
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 09:18:20 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id s2so17724995oij.2
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 09:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rYIZCJ9+nK8p9m3nr9ziXwFG2BrKDGcbY92fFQPvlw8=;
        b=kQ4su1FnMm2tQCelALOJ2fn+JXnl+mps3qtPl3EU+jhuDsfAvpL2DvKvKxtPqrjsTg
         NsFAW1NEevoApENRZrOzQQGZawHTQpS9HwU6gDAh674vGbZvZQT1AZGUi+hCC15cIMPt
         O04YXn2I1bRRs2RWkj4WHTzd86/ikYYFwarF386YzQKbc0mTJG7DyegbLvft/f+95aCQ
         /bAdif0HgG2AU/1ZEU0TF9TKgumstVbkXQ+ypbeDlcQCHnrO6JFFryQWUbM9imqgU/C7
         tIjDi+RB0Nsj8QMmEn8L2OrrT0y1YjJave2IF9oKsJVpmavKIqHexXqT6RfoR7CTzNmK
         anEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rYIZCJ9+nK8p9m3nr9ziXwFG2BrKDGcbY92fFQPvlw8=;
        b=ccQHOHbGh/qBiftWQlioWzvFusRTsjqcFybZndTrA0zmJJY1gijjVwdfX1md2J7ILL
         twgOp6iTUouaYXSj26qCk4Zbei1vmQgqPzt2RypH1pT1zvtWjniKGzsxihXL9K3UsS7m
         uB5lpbWwNo0mEaMd47YriaRQHGjAkgD1UWqsWXM5MURHdycJVoI/iAeoHgOAU0eEXINJ
         XsAjkNqCC7L+7UzruyMUfPr+joqtJrGbyL4hDgyDkEgpBD0I2FL3RP6asFcXfNxK1OXq
         7FaF/DPEOYOL67NN7IfBxrVrwRuNOaK0dQ6geSBul+ExUso3Dng6ff2z3tnKwD4RcSp6
         xYTA==
X-Gm-Message-State: AOAM532t2vSK1ucQ7T2v0IkixpSgcjrSMP1jG9P2sov8SH8+y1WEG58E
        /iSXvufQAGD2vIKdkwDSXySs3cbzknc=
X-Google-Smtp-Source: ABdhPJzDOQg05HqrhPFYnrAU9YdvcQTr79pbI0bojHHKGM5X29dZTMHPu0o36llO2h96iaiyy38fOA==
X-Received: by 2002:aca:f5d3:: with SMTP id t202mr8337192oih.25.1610299099679;
        Sun, 10 Jan 2021 09:18:19 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id e1sm3442470oib.11.2021.01.10.09.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 09:18:18 -0800 (PST)
Subject: Re: [PATCH iproute2 0/2] nexthop: Small usage improvements
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210107152327.1141060-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2aa899e4-3c79-59e4-adce-4d33bb822097@gmail.com>
Date:   Sun, 10 Jan 2021 10:18:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210107152327.1141060-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 8:23 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Two small usage improvements in ip-nexthop and ip-monitor. Noticed while
> adding support for resilient nexthop groups.
> 
> Ido Schimmel (2):
>   nexthop: Fix usage output
>   ipmonitor: Mention "nexthop" object in help and man page
> 
>  ip/ipmonitor.c        | 2 +-
>  ip/ipnexthop.c        | 6 +++---
>  man/man8/ip-monitor.8 | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 

applied to iproute2-next. Thanks
