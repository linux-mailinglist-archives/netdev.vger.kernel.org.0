Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66AB367937
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 07:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhDVFYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 01:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhDVFYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 01:24:05 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2666FC06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:23:30 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so320274pjb.4
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TrGjSqinnkCbNMxpeyr0DfODoargIAwuwPx/KOpbkXk=;
        b=SQZGDAtoB5VdL23YwytwE3oqqEUow2elqZLVazg3hC3vi/Jw8wRY1r7bAj7MNl+rT3
         Z4Ne9jUR0HTAWbD+FjEu4b4Tpe+1SbMex77ZCI7vQGyKAY7HhXzS4JQAf7OwEv2HwXOy
         ZDV5P3IE5Na9YXXGnGbgFx2RiFkcmIMaopOuvGDXHZrwiXhnuvtUCMm8LWE1UwosB9fx
         XTF9WqPZG3PA7KNEwj1XMCzYOvIyt7+sNIH2xgAPvzdcrQEj9tu5TiC0pljsT5m1Ri9y
         LZsxwBt/eXM625yPExa9LYyRcq26EM3tXju6oT1SArNqeXgaPq+uoP7QwnqvcPFGurjd
         T8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TrGjSqinnkCbNMxpeyr0DfODoargIAwuwPx/KOpbkXk=;
        b=HL4TDzUOL2HcEhfnYrrfhLSRUwGL8k59jWX/2E/HfIWnfuOMYcYRVHONoZmEjpjp0V
         OzUwO9lzpGYCNAd5DIxOGfB96wcdHrcnMt3CsWOZ3jHcPEEpgcwngu2Sz1TDmB1hMIuN
         VnUH7pzVn+pE9V3wriJSHbEfJqmqZd8hJIj3iAQ5kuZ+IpjQS3j9ihb0inv+Hy+Nj0QC
         IXqWDIoXa4iP6nN1CxcHjj77w8HS/YiuOYzPjLjb93Zjtawgxw/25og0scXwQBp9LK3H
         aXy0z+uoxZlfd2/loOW/UghsCcwXrDrNCk6AGCmay0t5kg4mZAWqAVLWyIBRP5Z/C5qA
         AqEg==
X-Gm-Message-State: AOAM531WGF7gDPBAZrTGYMzCJKkKQeEV9H9HLJtn3hwTZWs1VPD3lmtj
        FKejUNFhkkcBev/DLQF9Ggw=
X-Google-Smtp-Source: ABdhPJxykES6T+0eWcRAOAC7pxWyuwQr5kJBKo0ZWLmDqoAmqcspQXEaQzbItP4NeFIJ/L3/BppKVQ==
X-Received: by 2002:a17:90a:f195:: with SMTP id bv21mr15431269pjb.56.1619069009565;
        Wed, 21 Apr 2021 22:23:29 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.15])
        by smtp.googlemail.com with ESMTPSA id j27sm1038238pgb.54.2021.04.21.22.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 22:23:29 -0700 (PDT)
Subject: Re: [PATCH iproute2] lib: move get_task_name() from rdma
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
References: <a41d23aa24bbe5b4acfc2465feca582c6e355e0d.1618839246.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <35a2896f-a6bc-961b-5807-fb83059e3dd0@gmail.com>
Date:   Wed, 21 Apr 2021 22:23:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <a41d23aa24bbe5b4acfc2465feca582c6e355e0d.1618839246.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/21 6:34 AM, Andrea Claudi wrote:
> The function get_task_name() is used to get the name of a process from
> its pid, and its implementation is similar to ip/iptuntap.c:pid_name().
> 
> Move it to lib/fs.c to use a single implementation and make it easily
> reusable.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  include/utils.h |  1 +
>  ip/iptuntap.c   | 31 +------------------------------
>  lib/fs.c        | 24 ++++++++++++++++++++++++
>  rdma/res.c      | 24 ------------------------
>  rdma/res.h      |  1 -
>  5 files changed, 26 insertions(+), 55 deletions(-)
> 

applied to iproute2-next. Thanks,

