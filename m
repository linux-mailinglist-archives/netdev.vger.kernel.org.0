Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931CB42FF58
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbhJPAGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbhJPAGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 20:06:35 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D6AC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:04:28 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so181923otq.12
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4/iylAugV3LdmU4TvzAuM19NopCOvOZ+RsYIdcERlXg=;
        b=NsHs684w/VANWgOXHfLiL/skgg8r/vhArjIUiBOj66nV8Zj4cKuy7YHijSiYD9mdVt
         2jXsf6cLNNqS+38z1tiSMCl9kUQ0AWgPgY6ctIuVQt6cZ2LUlpcBla6MDRM445KnopR+
         nTFc09zuRn8vjTYYUqDrA+KEqFQg8vxSmAYnZgS9jfm6Ua9hwTW3b1dIvykAaKn1gSOB
         MecWIP4IvMW6THJSegG3adQwy7ourk11U/Hssj5LMBnQeklNIRN1QdnOzx2VyZpRozRN
         fLzyZM6dAjECRe8HPKsow3bHBPGtLCgqpjZqplxdNE3cRICOzzsFNKnkdvtsgcwNkbjj
         /3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4/iylAugV3LdmU4TvzAuM19NopCOvOZ+RsYIdcERlXg=;
        b=bctrMkZWAUnC/6UPstJKoWajuQ5vOsOpjJWBKUASblID+P5ToiSW35x62tXkIyS0JM
         /gyYGYD5pUXNKqw0iadcM59u9c2qUzz3HR67WfuEyEiKwUiFZex1q22FdqfYk88Us8Hp
         WHVmvjjuXyMnPfSuhRQTZ0QliAnuarHFQBJ1PsB7v72VIfmV+/klNU/lwSMUf/uvygBJ
         1589qng69bAhHe3Wjflf33dVrYQr0ppIGnVBpz13iPskQ61vVndI2l0oJlC4WKXKb9T2
         KfGP1NbHuN9uVtYJ2dX5+KaJi5BlQpHNZpuXLxFnd27IDyjiSwDtR2d5oIV2pCBV4JT3
         6VMQ==
X-Gm-Message-State: AOAM532GcpeMoRqZ3ghID3VHQHCQBk8fVqaMf2rSYDXyHr8kP5E/TNki
        uSfQB6iOxB222+l7DB40Jl8=
X-Google-Smtp-Source: ABdhPJxzT8RqgGBlo4EBCwRSGHnusG0Cz9sBOlhtfcIG12apx+zndRQ3TvWB1+YQ0TjU/mY/6JhIrg==
X-Received: by 2002:a05:6830:236b:: with SMTP id r11mr10601610oth.145.1634342667580;
        Fri, 15 Oct 2021 17:04:27 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id c9sm1494236otn.77.2021.10.15.17.04.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 17:04:27 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] mptcp: cleanup include section.
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        mptcp@lists.linux.dev
References: <30bdb5729425940823e87450c29bfdcff918d62e.1634053020.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ea8eb254-287c-f6a6-04ed-26aa50c299bb@gmail.com>
Date:   Fri, 15 Oct 2021 18:04:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <30bdb5729425940823e87450c29bfdcff918d62e.1634053020.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 9:39 AM, Paolo Abeni wrote:
> From: Stephen Hemminger <stephen@networkplumber.org>
> 
> David reported ipmptcp breaks hard the build when updating the
> relevant kernel headers.
> 
> We should be more careful in the header section, explicitly
> including all the required dependencies respecting the usual order
> between systems and local headers.
> 
> Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> Notes:
> - sorry for the long turn-around time
> - all English errors added by me
> - I [mis]understood Stephen's patch was the preferred one, and I took
>   the liberty to send the patch on his behalf. Please educate me if
>   I somewhat screwed-up this badly
> ---
>  ip/ipmptcp.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 

applied before the latest sync and it worked before and after. thank you!

