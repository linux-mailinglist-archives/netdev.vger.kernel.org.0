Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F9D287E66
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 00:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgJHWAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 18:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgJHWAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 18:00:15 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4AAC0613D2;
        Thu,  8 Oct 2020 15:00:14 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q123so5131873pfb.0;
        Thu, 08 Oct 2020 15:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7meT9blhhIOMw3DH+pB0nW6avOsYmvAuQbKycAZ7ZZ0=;
        b=TV1O81CnPWaSreuuiZRGbdKPvbrlhXSBBXoSRaWMetyIduqpzeyaACae1HmLKQkhVz
         uiPwnx92v8ZLHTdoU5wpg7nXqzhg+ZR+OiCCijMSJKRaBoGhI1qfYEltKkTKAe8QA/wS
         PVZOuEv983jC1ml4uELQcFw8dLYfizFUNQ2UZ3irwURM636k/IgdeHadrYs7Tkt51qKu
         RDC19CMMv8ONyMw/kv4aMa7oK2PLzh+8RYvQTACNnf7MTAfLs8PDH2hyC8oCgktwC9D0
         c5Tij2SWqWV4hbHzQMIZslt8AwFSo0/6BG8khrB+/N+T6OoSCJFlVuc/vCjskNXk9n8v
         CYsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7meT9blhhIOMw3DH+pB0nW6avOsYmvAuQbKycAZ7ZZ0=;
        b=oenkBbWCvMQWNg4HAuRNWYSXzOOJxarpaCsiSzG7OE2kO/PZTT7TRmOcITRmUjH9JV
         q7FaIkjW2ENlaljBgoq/Xkr6eYF6uEng/SbjttiFgpXyoUlGHAuJ/PfJoPESuUZLcOuN
         lL8Q3sSxDADhpqxZDctGhvcLqJSEW8jLfYAgwngRxlm6u5FxKMJYRV4nskAzchl1NK83
         98ArGX0YOu+jUYxSpaZKDzH3Dhx0GHTqf6xukfzPb52w1z4JogodfC/R0jAAu4d7FmpO
         q4kfc8V+SlyV5Zsu3EO0aW5VZLLuV2C7Hq3lKWsXZC6LeEAZolhmd82+IqvWWVb+Bn55
         HrOg==
X-Gm-Message-State: AOAM531Si5XVh0nuzvhLECBOOeTU5v7b0pQOZtfpeege81Oewsl013Ru
        trltOKCYodnUqPebpxV9046qIYm5Umg=
X-Google-Smtp-Source: ABdhPJwfAhRP06BAnSElv3Oprcono5cgpdJ5oJjAmO5AmPNkeQFciagBGtI4ZEBIoJw9UytSZlPPaw==
X-Received: by 2002:a63:1958:: with SMTP id 24mr817621pgz.420.1602194414376;
        Thu, 08 Oct 2020 15:00:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id 63sm8017130pfw.42.2020.10.08.15.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 15:00:13 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/6] bpf: improve bpf_redirect_neigh helper
 description
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20201008213148.26848-1-daniel@iogearbox.net>
 <20201008213148.26848-2-daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c57b1ea5-019e-af07-2307-6837ba7233aa@gmail.com>
Date:   Thu, 8 Oct 2020 15:00:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201008213148.26848-2-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/20 2:31 PM, Daniel Borkmann wrote:
> Follow-up to address David's feedback that we should better describe internals
> of the bpf_redirect_neigh() helper.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  include/uapi/linux/bpf.h       | 10 +++++++---
>  tools/include/uapi/linux/bpf.h | 10 +++++++---
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 

Looks good to me. Thanks,

Reviewed-by: David Ahern <dsahern@gmail.com>


