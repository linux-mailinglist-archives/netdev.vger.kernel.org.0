Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660B7DF796
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 23:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbfJUVpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 17:45:17 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41678 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729388AbfJUVpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 17:45:17 -0400
Received: by mail-pl1-f195.google.com with SMTP id t10so7269906plr.8
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 14:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=sM7bGGhshxU6DSzLqCJMwqozRLpxzUDFA4cU/gywtcg=;
        b=AwadvmmN8bqrWmhVWdCkkQH/aLrI7IYqy4IyPraJIxYKOcv38JjAOlFrpPkZYosiHH
         tzYi8pm0pc9EVWiSS+enwkDHIPddJyiXdHxbR9u4dew/kfBGvpcFmNeqccpUq9GZxiJL
         c1OgvqVHBHUnUXDBGDAPkxaRF/U0KXF1nsjrRAg7QTe//zGC7XbemCOnVZU1CKzsNd99
         aLZfBLAj6FgwUBmzhhyYvbVCxOOZVe4lKXpqbf5o0ZzHp6bBUzt2vD7m4YdaIivnQhR+
         d7HzWzg+mND+IDG/VgHbKUK1of7uanJHReX9ocS+zV1zC9rYuS9334eZnOi+Ffgn9HIA
         +zJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=sM7bGGhshxU6DSzLqCJMwqozRLpxzUDFA4cU/gywtcg=;
        b=ouaCeAw1JM/llEfNyvnVdAobK2hKriDo7kbYLUNBXdYSCj5xCavPdb6XfpF2oowtID
         icFJFxVkiH/A8kJURk1oO6eerN/F7vEYO20CzXQyJnWLWocj4aWzzXT1fhYaWpej/jgI
         wkb+MfJKvrMH9FJzWBstTNC8s1rgVEbT/2goJK2kPFtpR5gWrj0kU6izU44MpV2uIIGj
         E1oEaxLiccEwwayGitN3NxmGRmGw+zjMGITb6gsG7QOOSv2kbNbAfzW0gTDTW88cArsI
         HBGG6rN0Lfs8TzflGokzvoDyDN+3CEsAxXwZmRHD/ZDkNS3nW3j3b08T+BuNZcLqtofU
         T58Q==
X-Gm-Message-State: APjAAAXLM6MuPyIky9eA9QJKMP/zWm5dLbETlysBOx7bT9F0NDCcJ7lU
        au8Av3pRUxgL5E5FZhuozus=
X-Google-Smtp-Source: APXvYqwJV+RM7Q76JxkaNeOv6RByvlV2xet/3hMcMyXHmpZ8e4oJVhiLKBAwVB0WWiPTmCjzK+/LvQ==
X-Received: by 2002:a17:902:8d89:: with SMTP id v9mr130725plo.247.1571694316766;
        Mon, 21 Oct 2019 14:45:16 -0700 (PDT)
Received: from [172.20.54.239] ([2620:10d:c090:200::3:102c])
        by smtp.gmail.com with ESMTPSA id l23sm15633996pjy.12.2019.10.21.14.45.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 14:45:16 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Saeed Mahameed" <saeedm@mellanox.com>
Cc:     kernel-team@fb.com, ilias.apalodimas@linaro.org,
        "Tariq Toukan" <tariqt@mellanox.com>, brouer@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/10 net-next] page_pool cleanups
Date:   Mon, 21 Oct 2019 14:45:15 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <97F9C936-576A-4051-B435-4A901FFD1575@gmail.com>
In-Reply-To: <a82be17dbaa84d4868d6825967b8a87afa3551ba.camel@mellanox.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
 <1df61f9dedf2e26bbc94298cc2605002a4700ce6.camel@mellanox.com>
 <A6D1D7E1-56F4-4474-A7E7-68627AEE528D@gmail.com>
 <a82be17dbaa84d4868d6825967b8a87afa3551ba.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21 Oct 2019, at 12:08, Saeed Mahameed wrote:

> On Fri, 2019-10-18 at 16:32 -0700, Jonathan Lemon wrote:
>>
>> On 18 Oct 2019, at 13:50, Saeed Mahameed wrote:
>>
>>> On Wed, 2019-10-16 at 15:50 -0700, Jonathan Lemon wrote:
>>>> This patch combines work from various people:
>>>> - part of Tariq's work to move the DMA mapping from
>>>>   the mlx5 driver into the page pool.  This does not
>>>>   include later patches which remove the dma address
>>>>   from the driver, as this conflicts with AF_XDP.
>>>>
>>>> - Saeed's changes to check the numa node before
>>>>   including the page in the pool, and flushing the
>>>>   pool on a node change.
>>>>
>>>
>>> Hi Jonathan, thanks for submitting this,
>>> the patches you have are not up to date, i have new ones with
>>> tracing
>>> support and some fixes from offlist review iterations, plus
>>> performance
>>> numbers and a  cover letter.
>>>
>>> I will send it to you and you can post it as v2 ?
>>
>> Sure, I have some other cleanups to do and have a concern about
>> the cache effectiveness for some workloads.
>
> Ok then, I will submit the page pool NUMA change patches separately.
> I will remove the flush mechanism and will add your changes.
>
> for the other patches, mlx5 cache and page pool statistics, i think
> they need some more work and a lot of pieces are still WIP. I don't
> want to block the NUMA change API patches.

Sounds good - the stats are only really needed once the mlx5 private
cache goes away, and it doesn't look like that will happen immediately.

The private cache and the page pool are performing two different functions
at the moment.
-- 
Jonathan
