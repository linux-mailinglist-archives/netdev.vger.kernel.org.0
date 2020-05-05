Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F4B1C5C7F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgEEPuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbgEEPuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:50:07 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917D9C061A0F;
        Tue,  5 May 2020 08:50:07 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id k81so2772876qke.5;
        Tue, 05 May 2020 08:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yJr8RqITkDOSGCYSWIKgpqgvoSgqR2F95IvJn3b0ji4=;
        b=jc0CkDP2R64dQQyGSslB9qk/kYm/zxhSNRdlUNAK+ACzkAtWZbgvmHATjia5aFel8o
         ElMXA5x7gAZLp3+uLkYOhyRcrFWJzBB/UbPMP13/+JUlYldi3ceOhNrLPAIajFuWghfe
         4abpBFl5979n9mX1uHFxWoL3nV6mUZe8yOGN+Bl8VdaKGIiqUGLfZujSE7nvS5iT3xK+
         V0jzCJNs2wlkSo9P7QPvg/3iAR3omJKATAltVkVslcBb+lVAdSBiXwGwpJFPfRMQb+c8
         alpJv9gVvRJeXd7dOw9ON+bWn+LD7wulFhfsvjoZHRydZtGMgT+f6giTXOtbUq8aipyo
         EjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yJr8RqITkDOSGCYSWIKgpqgvoSgqR2F95IvJn3b0ji4=;
        b=FKE5K/jP9Os0M2xLZoHVTcicVYTS2f7r4kNV/mIL8eTiJwOGdOAtaVrLt4/JJauTr0
         uW2iBeaQ5IO0kUpPuYSXsSgmL332TZPTe/rGJEhkMcDgvN60c9EeykTr0sAR0ScwNC0f
         Kz9bZbUXrhGf2t3OH7cF1o/EKz5e1rFgTzKQMru0T6SAaDUr2kZjcXuzCTn8I8HrlPUa
         rAEdILAV6u+G8Q4itEJ78rJU5Z/XupPQ0mXdwn4uPX7lprdSeGsB+bb81uWkaeBuphsH
         Xxyu5nFXkhXjYTtUo8SJhvlD+0YKpDA6UhFoh7jh3H15UgezSO+knOLjQ3lmDmz+fbb/
         Eyrw==
X-Gm-Message-State: AGi0PuZZBYftyGxdrda3YkMIrRIn+TXPMI34HQSK62uRrt32M0rid9Zw
        7JOQDkifAER6vJVTcnabb4w4aYbK
X-Google-Smtp-Source: APiQypLCqoomdHCwWQgejNHDdpI6LwLVKABF7LU6TEhgRnJJpXSiw5kVu5AcqucNL0BygHBTCKCInA==
X-Received: by 2002:a37:5846:: with SMTP id m67mr3829421qkb.78.1588693806656;
        Tue, 05 May 2020 08:50:06 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19:a884:3b89:d8b6? ([2601:282:803:7700:c19:a884:3b89:d8b6])
        by smtp.googlemail.com with ESMTPSA id f68sm2192226qke.74.2020.05.05.08.50.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 08:50:06 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 2/2] ss: add support for cgroup v2
 information and filtering
To:     Dmitry Yakunin <zeil@yandex-team.ru>, netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200430155245.83364-1-zeil@yandex-team.ru>
 <20200430155245.83364-3-zeil@yandex-team.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <72f12b35-0dd2-81b2-aeb1-52822c7fe03a@gmail.com>
Date:   Tue, 5 May 2020 09:50:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430155245.83364-3-zeil@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 9:52 AM, Dmitry Yakunin wrote:
> This patch introduces two new features: obtaining cgroup information and
> filtering sockets by cgroups. These features work based on cgroup v2 ID
> field in the socket (kernel should be compiled with CONFIG_SOCK_CGROUP_DATA).
> 
> Cgroup information can be obtained by specifying --cgroup flag and now contains
> only pathname. For faster pathname lookups cgroup cache is implemented. This
> cache is filled on ss startup and missed entries are resolved and saved
> on the fly.
> 
> Cgroup filter extends EXPRESSION and allows to specify cgroup pathname
> (relative or absolute) to obtain sockets attached only to this cgroup.
> Filter syntax: ss [ cgroup PATHNAME ]
> Examples:
>     ss -a cgroup /sys/fs/cgroup/unified (or ss -a cgroup .)
>     ss -a cgroup /sys/fs/cgroup/unified/cgroup1 (or ss -a cgroup cgroup1)
> 

on a kernel without support for this feature:

$ misc/ss -a cgroup /sys/fs/cgroup/unified
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
Netid    State    Recv-Q    Send-Q       Local Address:Port         Peer
Address:Port    Process

New iproute2 can be run on older kernels, so errors should be cleanly
handled.
