Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C883A39F9
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 04:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhFKC4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 22:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhFKC4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 22:56:45 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194A7C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 19:54:48 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id q5-20020a9d66450000b02903f18d65089fso1757791otm.11
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 19:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DINKFOqOMhxxSvYAQRZTNA7fBlEmiuST1PHK60SsnSg=;
        b=oCXZL/gaa9F4fKQDVopQ1sJgDPYR0URxfq7ygPAp2IjBOszlgnK9sq/GuQoV2kwVBY
         BJIsvdoWjkDAs9FJpvW4GLmHsoyFETq9eiKwn1ari0fHSZQWB39YWlETpsoAKf58XOwE
         fOzbLanzJF7ySbjd2bm65odG3TIU/DPjq37KXsc+nJgkT1agofpg8q6NNo6MjgYnNUqZ
         wuE32j4bjEubYd6m8oKlZZnfn4yE5IxIIKVcFP6TUdUYYbrdW+S0DPQL0lMeyVlWGVUY
         2d4eRfNpNOd6M3q7X/X8YewfMLnAMPReH5d5UYSLRoAz/ZJH9tIX7WrVWIjhNNKl9aiq
         I24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DINKFOqOMhxxSvYAQRZTNA7fBlEmiuST1PHK60SsnSg=;
        b=Ut+Lcq1r+hbPlU7iWLob1E8Gjmc5AaaLoIKLg5OalsrnPOMinfsZtT0v9mnOWfHuNl
         6tC6cah9x3ZjRNMyxlBnVRsXuiDaORU6JwkVwm1SWAM9bFVuEM7AMAGKBdFs/1s7TX8T
         iyHM+p/FgqNpTt4HuRT3+x/7hx/STjVob+UckeysY7IpRyAEZu5Sr3jKvpo5sWJRgS1Z
         PuYQp0XVBZMgQBPdHUh5UBgGHoV2p3EgnGxpTCegBI6gl9FewzRMWoBArI7bYgkZKuYk
         70j4EAgyJMSpkpk8V0f/Sacz7HchVIRw25FC8q4zAyzekwtv5BPMCSZV6aSbQ8NYMFuX
         FPzQ==
X-Gm-Message-State: AOAM530366jVZ4SDzWjiPLxsecQ1AuiSDGWDAnFxA1nc7++a/H0XAzqd
        Wo3NxNoHk6bf/Mpx5TlGsvDHZnVyCII=
X-Google-Smtp-Source: ABdhPJxjiJ0+viBqQ3t1i9e0c+YoE71ojhp6DFZbI8mbRP0QJ3AAMPAbAWHN4PCUYkCds38zuvMGIw==
X-Received: by 2002:a05:6830:154b:: with SMTP id l11mr1175522otp.66.1623380087306;
        Thu, 10 Jun 2021 19:54:47 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id 102sm1017120otf.37.2021.06.10.19.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 19:54:46 -0700 (PDT)
Subject: Re: [PATCH iproute2] uapi: add missing virtio related headers
To:     Parav Pandit <parav@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210423174011.11309-1-stephen@networkplumber.org>
 <DM8PR12MB5480D92EE39584EDCFF2ECFBDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <41c8cf83-6b7d-1d55-fd88-5b84732f9d70@gmail.com>
Date:   Thu, 10 Jun 2021 20:54:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM8PR12MB5480D92EE39584EDCFF2ECFBDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/21 11:15 PM, Parav Pandit wrote:
> Hi Stephen,
> 
> vdpa headers were present in commit c2ecc82b9d4c at [1].
> 
> I added them at [1] after David's recommendation in [2].
> 
> Should we remove [1]?
> Did you face compilation problem without this fix?
> 
> [1] ./vdpa/include/uapi/linux/vdpa.h
> [2] https://lore.kernel.org/netdev/abc71731-012e-eaa4-0274-5347fc99c249@gmail.com/
> 
> Parav

Stephen: Did you hit a compile issue? vdpa goes beyond networking and
features go through other trees AIUI so the decision was to put the uapi
file under the vdpa command similar to what rdma is doing.

