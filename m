Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2B93D6870
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhGZU2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 16:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbhGZU2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 16:28:36 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2711C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:09:03 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 21so12549943oin.8
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oXkMDnOqq/DPcnD7mfVR6UB5DY1khlo7ja70QYQxWc8=;
        b=gfViN/N9eGxcDKOrblBLQ7nnVWvwqzAS9/IGAXTq8FDpwpUAa6PGesnxEOKbbd/YCm
         yk43teWcFYrFzQTl5Ugg+5cByqPdSXvEyp3/NRzYojuG94Tu+4RIj0u+sb1QbB/Cmpfe
         KzYRIvGhAkdTd1s6j0yovB9td9Ih5KejJaVHQDsJP14UXwLNLtr23xvl4PuKc8cLvxyx
         3vjdQj+n37w08i+iXA8M8/03XX6YUCn0iPNMe2zfmP0rpYLWhSLLRN1Unz1rOG/n3BHw
         1WcTxQMcZdQL0Rv15vAWlqPwkVfVRQTenKQdfgm6m4DiMvJe8t7lIkVSfgOCEB7bS6Bi
         LWiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oXkMDnOqq/DPcnD7mfVR6UB5DY1khlo7ja70QYQxWc8=;
        b=Up8Eh4D5PZV8tWft+CGLewtb8BY2q1hV+CYmWucN2UegLm2WIBkTU9Dgo2sQXizXpv
         Vk3FAUMnRokDtbUJDZx0U/knxJap7ZoeXZeHK3ESrCkHvD8PeQCTYycynYvgS6tXhCNJ
         yMG1+s7dlZXPcRP+60RqnlwdSdbfTdJv1BJ++QOrpxk4GsCgIxI8C5eXsW/mrfZAVXhJ
         /STmNx2rw/vprpEu4aaCitW6D3yWEi3JnHfzpuQHrS1dpwTDt2px4Bodn1Lz0jJINmPW
         G8iEyaP8b/tPUtW+4q+99jLeuC8J0lkHRTcNwxXk8ATwOayFDmHvQWLwgj7dQQI8fEKi
         dXXA==
X-Gm-Message-State: AOAM533XicETAwyujsZ3K5n5EEA8suzyUrCSYasvggJuNlF6k7l98kCc
        2bG6njXzcWOiNDZzPoqynQuB4DJ11pk=
X-Google-Smtp-Source: ABdhPJy/zi0Rg9voQWsq6PubqTHxcdAbLwL79/3ZahNEWOxPANLcawwvuyudkQbHHoyE1ROsB0VW/w==
X-Received: by 2002:aca:3502:: with SMTP id c2mr678948oia.157.1627333743170;
        Mon, 26 Jul 2021 14:09:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id a19sm201941oic.38.2021.07.26.14.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 14:09:02 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ipneigh: add support to print brief output
 of neigh cache in tabular format
To:     Gokul Sivakumar <gokulkumar792@gmail.com>, netdev@vger.kernel.org
References: <20210725153913.3316181-1-gokulkumar792@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <390278ce-2405-ae9e-9b07-ea8c699d762c@gmail.com>
Date:   Mon, 26 Jul 2021 15:09:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210725153913.3316181-1-gokulkumar792@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/21 9:39 AM, Gokul Sivakumar wrote:
> Make use of the already available brief flag and print the basic details of
> the IPv4 or IPv6 neighbour cache in a tabular format for better readability
> when the brief output is expected.
> 
> $ ip -br neigh
> bridge0          172.16.12.100                           b0:fc:36:2f:07:43
> bridge0          172.16.12.174                           8c:16:45:2f:bc:1c
> bridge0          172.16.12.250                           04:d9:f5:c1:0c:74
> bridge0          fe80::267b:9f70:745e:d54d               b0:fc:36:2f:07:43
> bridge0          fd16:a115:6a62:0:8744:efa1:9933:2c4c    8c:16:45:2f:bc:1c
> bridge0          fe80::6d9:f5ff:fec1:c74                 04:d9:f5:c1:0c:74

I am guessing you put the device first to be consistent with the output
for the other 2 commands.

In this case I think the network address should be first then device and
lladdr which is consistent with existing output just removing 'dev'
keyword and flags.


