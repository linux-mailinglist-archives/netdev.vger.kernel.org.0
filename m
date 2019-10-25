Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1EBE5059
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 17:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395491AbfJYPnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 11:43:42 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:37313 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395487AbfJYPnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 11:43:42 -0400
Received: by mail-io1-f54.google.com with SMTP id 1so2941496iou.4
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 08:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9d6MtBA15KZXUAEIR0Hw7tX8JBdeRzkfqnEI2d7XCns=;
        b=koqTrEtbtkBTmtCQVQdlIKnnvzyN28LQf8hdf67wA61tvas8bqhk+I0eT44uhnDoVY
         DY3VtMxgyPZHNJGtN/L1/XUuFm7oVJ8sx2rc0h/HZiBVlaPm9QHeGBxLJs/odXoC6YA1
         MPYEuAl4RxIv6rgUI/nw5Rzh01NEWCu3rRTQViSrCPPVZIriaBxaPR8R7EMsKo/Qjuui
         mdONwGuBnpexBZnTMKkV2ktwVVaQxPDW0ERU9JYprZHiKA1PiI741mfbUWtTvS5/rf2w
         bkRF5y2xpiltEGBRLyda2cUtG/VEz2YbsrRdGjglYp5UOed7k5lhERoTOUN+zuDEvv9H
         OonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9d6MtBA15KZXUAEIR0Hw7tX8JBdeRzkfqnEI2d7XCns=;
        b=W9b24ePJuQhUgkbueKJdM1Opa7ZCxBq09DhvNxIO5FINEpiDjjaT8ug52KkcNgWY0B
         Wd6jvbHvjgH2VbaJIHr6Br+Kerly4MUxZSDZKWvsHD9NJ78qm5MJKhS7rLNnsLLpeToH
         2+BKSXq6Lqku17gqNEJs3g7q5op4j4CvZmik0H6CzAMDZh/pksy1ZAU96MMs5KiRE3Fm
         Inngu6UwYNJgXGPhyorZq6D5cs9kadNokmmTxXgcYTfxme/k7M56DMH8tF03XOfwGnin
         r8WAZ/042LWDGvG3ZwHHniGCji3iBcHG3v5YydPAFXP13qQtVCfOMQGEnogDhUyFwBx1
         mTug==
X-Gm-Message-State: APjAAAW42L0H4quQsbOyeezMNM7Nsc+3rcChZzArrRlw2OIr07KDilxT
        KfYfBnCp9erz0Ih8AkOJI2/wtg==
X-Google-Smtp-Source: APXvYqyxLP/HcsKDhieO9bIwnt5kNb4+z6eQ4YBkAIzo+zaPklJvlcSLqQWhpXAQ1uotu7Egrba4Ow==
X-Received: by 2002:a5e:8f0a:: with SMTP id c10mr4418253iok.173.1572018221294;
        Fri, 25 Oct 2019 08:43:41 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id d2sm308015iob.22.2019.10.25.08.43.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 08:43:39 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
 <vbfsgngua3p.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
Date:   Fri, 25 Oct 2019 11:43:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbfsgngua3p.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-25 11:18 a.m., Vlad Buslov wrote:
> 

> The problem with this approach is that it only works when actions are
> created through act API, and not when they are created together with
> filter by cls API which doesn't expect or parse TCA_ROOT. That is why I
> wanted to have something in tcf_action_init_1() which is called by both
> of them.
> 

Aha. So the call path for tcf_action_init_1() via cls_api also needs
to have this infra. I think i understand better what you wanted
to do earlier with changing those enums.

This is fixable - we just need to have the classifier side also take a
new action root flags bitfield (I can send a sample). To your original
comment, it is ugly. But maybe "fixing it" is pushing the boundaries
and we should just go on and let your original approach in.
My only worry is, given this is uapi, if we go back to your original
idea we continue to propagate the bad design and we cant take it back
(all the tooling etc would be cast for the next 5 years even if we
did fix it in a month). Thoughts?

cheers,
jamal
