Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E19179949
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 20:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbgCDTsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 14:48:25 -0500
Received: from mail-qk1-f176.google.com ([209.85.222.176]:35047 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbgCDTsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 14:48:25 -0500
Received: by mail-qk1-f176.google.com with SMTP id 145so2907223qkl.2
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 11:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BDbAoZCU4CF1Xc1/Z3o6zncXTC2btEluKbsYePNNU48=;
        b=ZdyPu2hTPh602kEFaunLfeaoc0b2/87uFzEANLellNJZFXI/T0KyvJBV8YX4rFZaQw
         KNvlGKeUrJtpWNpVMkLz/RhnFzVhL7uwBrxMxuUmn1V4yV/7tM6YdUeh6mZEHkMZ3SIx
         34iMfg/VH/wjxOIwWfHgRvvNga5ai7W78OXsMaaFsOvo2o17vVqUze4r07FPVy3gJ96u
         prqUe7NbYjPWR6nra3CMVnOcAhO4SfnS4exmx/je76ilufognVR7fHZxSBPh8/l+4592
         ZQWqydyBhDQ9MrSxpIJKRjCUHki2SwU0mHdN6HWbJBq6L97GoXbVYKEiHQA2HNQuK9Hl
         gUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BDbAoZCU4CF1Xc1/Z3o6zncXTC2btEluKbsYePNNU48=;
        b=GI5i2+fVbjO2gvv6L8PqBDmbnacm9JaY1zy6bmkQ/jSwWstpNcKRyeHcu6Wchx+5DL
         E2+hVq1Z7C2+sna7Api9AfZfLXzVEi2TAeEEWitX0RMON0TNy3utrssH96oRdy5nZe+Q
         ZyCIQ8NXKIEWesFB/n6doM6aeTMZZ85FFip+ZhHvsfWz16wBHPJh6mixsoMknqbWHuSb
         SNU47QJcIya8NQEEHcC9ZAuWDVjWSizxyJhHYadlRyOfnTxm5HN5keg++YH5fpLKixFL
         35Lb7aSXf1FM/7WVsk1XRqat3VlMPKDG0dFBFvzStNYOnMFYxj2yFkVeNfCSkCWhKOu4
         QtSA==
X-Gm-Message-State: ANhLgQ1KzfrjU83EZ4STzSmu2MfyULs2kgj8ze7kk+Rj8uotQXvs2rmc
        oaFeg1m+S1NsaYHA41O74jo=
X-Google-Smtp-Source: ADFU+vuhhdANFG7t6xDbNh3Y4ACHFKz20e4r9SgYkluPlFH9j1oC1AgJYb9+7sUiqB4rds116dlGFw==
X-Received: by 2002:a37:a00e:: with SMTP id j14mr4628971qke.464.1583351304397;
        Wed, 04 Mar 2020 11:48:24 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:95f4:82ed:fbec:d0a2? ([2601:282:803:7700:95f4:82ed:fbec:d0a2])
        by smtp.googlemail.com with ESMTPSA id w11sm10710767qti.54.2020.03.04.11.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 11:48:23 -0800 (PST)
Subject: Re: [patch iproute2/net-next] devlink: add trap metadata type for
 flow action cookie
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, idosch@mellanox.com, mlxsw@mellanox.com
References: <20200303132742.13243-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <91218fa7-01b9-a9ee-cd53-66c12f885580@gmail.com>
Date:   Wed, 4 Mar 2020 12:48:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303132742.13243-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 6:27 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Flow action cookie has been recently added to kernel, print it out.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  devlink/devlink.c            | 2 ++
>  include/uapi/linux/devlink.h | 2 ++
>  2 files changed, 4 insertions(+)
> 

applied to iproute2-next. Thanks


