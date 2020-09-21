Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D829B27320D
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 20:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgIUSgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 14:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727475AbgIUSgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 14:36:40 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CB3C061755;
        Mon, 21 Sep 2020 11:36:40 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id 185so18050980oie.11;
        Mon, 21 Sep 2020 11:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o6fJE2rXcZoLhOCDOkRbkEoFdgogw3N+fMcLGobMIIc=;
        b=VbO/8V4mCN0iGkPwWzGMXmP9a9+GKR4SV8TFfLZfsW682BdPCOC48NPh6KzhYSTuKn
         VnYhRBHoer4XNTljPDe0CVrAjrR2QkyjZ2Fzw1l4iI7tOuat93kF56dzz9MnHujKzLhy
         tt1f6avNCaW/Bo89NumzJbXZNdOHgv8e6dyJImY1YSzKh494WT8a28N9QUywOReBBJZ6
         6T4+nlV2c/LcxMwaylpwBjfZVYXdGcy5edJniVHJpiwb7WEK6hwQRT/0cbA45ZyRUIxr
         9TT+hVv5SAVwKG10dnTWiez2intz/ho390IeX/hC7wG/eSBIao4obz5f4mWdkMLVQE0y
         zGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o6fJE2rXcZoLhOCDOkRbkEoFdgogw3N+fMcLGobMIIc=;
        b=Mzfwsy06c+8bca8fnJCYtI55FPlSpes/WDQDAMuH7ME+0vb/XVokEdHFp9U0AFwwfk
         UWjsXAqzLdCMf/C2xuiHCg3Bm5wLl87IyUm+iXAPrlBSCuupu2RCvvP1Pm6NlyAUW0l9
         BWc+7/4Jc+hTTbe+OCKAhkdQEpsloQV88ASw/PZsh1n7VTlThHqsc3BohZK18A+hUfx8
         GLVLQbdk3LyzfxGhthevyf9xejZfVK6rQfOmDz0d+WQEyXOmD5eVWoQKXgGko5SdR1ZL
         MGabVmRbVGJ0iLxot2fBbPPKgtMbAcbfb4zVpa2T6mMdKiOVExLGLAPHpDcHW5qZ7+yo
         KGIA==
X-Gm-Message-State: AOAM530/+JmZiRyhuzqMRBtVcGiQFS26n9OEuyFt0zJClG+86cQefW+5
        xSIU5wfIa5mQ9erfBVHt0Qkmy4QthXng3w==
X-Google-Smtp-Source: ABdhPJw3lNjUiDdYfBe2yfJ93TJnu51S/KUHuceLOWq2SgTaBdA7DJble87PeJXZWB4G5vG6cqCyfA==
X-Received: by 2002:a54:440f:: with SMTP id k15mr436246oiw.131.1600713399168;
        Mon, 21 Sep 2020 11:36:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:55c1:8bf2:4210:9084])
        by smtp.googlemail.com with ESMTPSA id v14sm7077241oia.31.2020.09.21.11.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 11:36:38 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com>
Date:   Mon, 21 Sep 2020 12:36:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 12:17 PM, Mathieu Desnoyers wrote:
> Hi,
> 
> Here is an updated series of fixes for ipv4 and ipv6 which which ensure
> the route lookup is performed on the right routing table in VRF
> configurations when sending TTL expired icmp errors (useful for
> traceroute).
> 
> It includes tests for both ipv4 and ipv6.
> 
> These fixes address specifically address the code paths involved in
> sending TTL expired icmp errors. As detailed in the individual commit
> messages, those fixes do not address similar issues related to network
> namespaces and unreachable / fragmentation needed messages, which appear
> to use different code paths.
> 

New selftests are failing:
TEST: Ping received ICMP frag needed                       [FAIL]

Both IPv4 and IPv6 versions are failing.
