Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F9444BDB5
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 10:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhKJJVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 04:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhKJJVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 04:21:30 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6A2C061764
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 01:18:43 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u17so2447878plg.9
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 01:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hW8WE5YUPzr7TGNB9PPX5OsFjHHZaLkfWH5vDaAw6Jw=;
        b=UidmtHMHXGGa/Ix6cnTCxCKCmoeM1paDd21KMsrr3ysHPUl/NVEghpmo/av2THj7P6
         yFWmaC9ZmXrP/G6ZIBXzwc9nRuifeCJIBAvIRGX6MZeIa1YpEQjFh7/lUfKiSlITYmjv
         /0kDDD1yIWGiNzf7zvSVLTb/9m/23HrwRsdeNjmttk+tOt1qkhcmVcwlDKXz84xvtPIp
         o2eGf986QH2mbOx2jcXvtgC1+gPEfTu1pv3wK2HnrqxO0+XefR4S3CKe/KDmzC+TuphZ
         mJPT/xWrQFPltRU8tCz35aYNIn9jWkIQeJj9SkqIm6ltAmn7cA1+dgQ9LtZCGB+re3g+
         8VVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hW8WE5YUPzr7TGNB9PPX5OsFjHHZaLkfWH5vDaAw6Jw=;
        b=gI6FcbECExoCEwhHxB4dGUyNVslrZeBjAYRciCYYFqcUS2ZAcuTUh6iapaqPp9GbXV
         4y+VfAGLLMNoHlSVh0FuFekr5lLEz5Dnmuh9xmif7s3l529+KGxJECLiXbBD33fb4ghk
         tM+EDBgeZor6VB5oRDPeWcECgiMwdDZit0o2N+yeWI00LgzY2OIeGNSJSBstCguXl5SR
         t+wZQSW9FLKbArThxEANUGj0Z/FR/10NPhYp9g1aAz6kZcXbxCnkfcu4fMLy5H9vgBm3
         GGLX3Gx1J2JF0CbWJieHtzHjdrCULEd+ASlPqax0LC3LkUaskqkgAffKQEwOzFHXKQMH
         oZZg==
X-Gm-Message-State: AOAM5332gXXDuaCBSDRugo6QqkaQKIzcWMivWUZ0mgJypQUajQaCF0pI
        +WkRYsRZGmrBHfyI+c4yydY=
X-Google-Smtp-Source: ABdhPJwM8T5yl7ta7femEzxn7lOg+ChROSwYyaztSYYycI6OTeUvr831YiHYocMypt6RGVm3gVUi/w==
X-Received: by 2002:a17:90a:c58f:: with SMTP id l15mr15409178pjt.75.1636535923060;
        Wed, 10 Nov 2021 01:18:43 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m12sm5076796pjr.14.2021.11.10.01.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 01:18:42 -0800 (PST)
Date:   Wed, 10 Nov 2021 17:18:38 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [Patch net v3 2/2] selftests: add a test case for rp_filter
Message-ID: <YYuObqtyYUuWLarX@Laptop-X1>
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
 <20190717214159.25959-3-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717214159.25959-3-xiyou.wangcong@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 02:41:59PM -0700, Cong Wang wrote:
> Add a test case to simulate the loopback packet case fixed
> in the previous patch.
> 
> This test gets passed after the fix:
> 
> IPv4 rp_filter tests
>     TEST: rp_filter passes local packets                                [ OK ]
>     TEST: rp_filter passes loopback packets                             [ OK ]

Hi Wang Cong,

Have you tried this test recently? I got this test failed for a long time.
Do you have any idea?

IPv4 rp_filter tests
    TEST: rp_filter passes local packets                                [FAIL]
    TEST: rp_filter passes loopback packets                             [FAIL]

Task result:
https://datawarehouse.cki-project.org/kcidb/tests/1789355
Task log:
https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2021/11/04/401644508/build_x86_64_redhat:1746652818/tests/kselftests_upstream_net/10924465_x86_64_2_resultoutputfile.log
Build log:
https://gitlab.com/redhat/red-hat-ci-tools/kernel/cki-internal-pipelines/cki-trusted-contributors/-/jobs/1746652817/artifacts/browse/artifacts/

Thanks
Hangbin
