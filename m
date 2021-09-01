Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7702E3FD14A
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241627AbhIACZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241613AbhIACZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:25:16 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E0AC061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 19:24:20 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j1so860078pjv.3
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 19:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mQLrqHw3gxNguOCpiRwK9G7MjTliUb+CD7mPtY4fIYc=;
        b=nqhNkTATiygEDYegBaHmsO82y5SDtZdswliGzuCr2dtQf7aA2poJYKbTWkJOI2fkM2
         Brj79KxjX3suDUghO0muYlkGrgLIsQbrRN/3XYXEbUBEWjMG92LTWpgAumlsF9jSBODm
         kIgFw/lAo6dU5CCigSTBl+p0Z6DrMwDC4S4p01TJhZmOqECWqrzQyBbW4LndAwrgTIhZ
         NrJDfuKphh0sMZ0VP/zfesFRO2EX7iKMMA5+IkYNu6vZqIAg04JzRbLDpKhiBGLFxaI+
         0OCA3HodXdTTGnJG62zClirL6ij+4i8krYtJ+4x7DhetOVjmiNaQPxO2V0JDtJzkANf5
         Cn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mQLrqHw3gxNguOCpiRwK9G7MjTliUb+CD7mPtY4fIYc=;
        b=COW83KGDO0mlvK6HtNIn2/xncQ4+a4St6Iv6cnEwu0TXnvFOUx4BehNoUs5b96hzyt
         DjR+HqIf2e75tifjw8KX3TOi8ZZ6NNpodJjyzdrwTP3haTexXAW/ZRyZyRhLC/gtjKkM
         gmzdrNJwlml5fVTViH9pGgexPvw41HsCKOSO8ypRLXHzAgmnzP43bI8q+NifHMk+ZFfH
         iIE3GOerW3n5E8Yhl4HR4oDl5fIK0pxJhstCM0f2te2UIbSucvQX+iQYFkExWFnQx5vc
         c4SRGkQqxzGoblQM6iUfKVldDWiPjJKQBlocWw6K6gMSQISdKA23e9d4I7sB6CNXLUlP
         mLuA==
X-Gm-Message-State: AOAM5335bp3LUBPh2Lfmz+2kUp10gPm8BqC8F7F0kSSXbWrzriQRDTz9
        GNxAfz1F77KFGdVu8AehHo6sQyQZ6vE=
X-Google-Smtp-Source: ABdhPJzcf+ai9dhdnlbzJTaqrAqWX4JFJxRLJbktSFVSF6XyenyrAeSFI8mszUjos4bwX0FFTO2PGQ==
X-Received: by 2002:a17:903:41cf:b0:138:9b83:b598 with SMTP id u15-20020a17090341cf00b001389b83b598mr7385704ple.37.1630463060003;
        Tue, 31 Aug 2021 19:24:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id 143sm18512586pfx.1.2021.08.31.19.24.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 19:24:19 -0700 (PDT)
Subject: Re: [iproute2] Time to retire ifcfg script?
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20210831115619.294cf192@hermes.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f2a5f2fd-6206-031a-a6c1-54a558e03fe7@gmail.com>
Date:   Tue, 31 Aug 2021 19:24:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210831115619.294cf192@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/21 11:56 AM, Stephen Hemminger wrote:
> The ifcfg script in iproute2 is quite limited (no IPv6) and
> doesn't really fit into any of the management frameworks.
> 

I did not even know that script existed.


> At this point, it looks like a dusty old script that needs
> to be retired.
> 

agreed.
