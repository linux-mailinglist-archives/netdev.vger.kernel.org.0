Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B91140C364
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237347AbhIOKN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbhIOKNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:13:21 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A00C061574;
        Wed, 15 Sep 2021 03:12:03 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id bi4so3454252oib.9;
        Wed, 15 Sep 2021 03:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=70gsDuYlrJH7pHDgz8msDCSyfViuZkTIcdK8Iw5ZLgI=;
        b=REbFIYtag9UPWO8o4gpMVTx58unEkBbVpfQUv+HE3SyD4ePUeyDG0a6nbr1+8yiD9Z
         uGncX1lnXT6ceZ2AJWYTdILlEZ7B0K9yxnKHNv1LS6k5N1Bhk1mpRUV3q7CAwXagK35x
         rzgVpMiXk7Bo8fipq8PLRzdK42O4i4LzyilQ1voaDvmLoGjmjgYut0zZJUqotpQ4snA7
         7qGrQfMWWoe2A5cS8r1bk6iKBeoZcyBkbRhrenamoXXHogyF4JPx3yeI2G7FT2+e8Y01
         OWtUBCeZ50NhiR5A8+i0Dtjux3UFGyGhYnX6yA6mC+n8abB++pX34BeffZQv1aRolI9I
         kFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=70gsDuYlrJH7pHDgz8msDCSyfViuZkTIcdK8Iw5ZLgI=;
        b=ya+TolMEiBdTpCpp9MrwfHeuQgob4qj4/9cF/VjeUYKnFrcsp+3CR0igusKrojRc/o
         zhbtdmWCQsJBMjZHdlR4dwrReZHsu41yGG40XyArzVYadv6kLkd2y0xaRk72Gg/vjtOt
         sMEbM0Mb9bEhY+eha5T2aKLLS/Oliz0OxRPUhpxUd2/co1Qban5KEvS1SRmBmMFrSYOw
         nKCdYDHUGh7HbARf2eGMeoha9sbNXalifGkrk+iAAbjQScllf7tJ6v0RPL7jllLn5aKp
         pHAZxm5QgP8mvKwmRpmXrkNAuyHVyE2N6X5rheJPZ3Il449DudJ6xC2qjzJ+4T38NAz/
         0PEg==
X-Gm-Message-State: AOAM530/0Q3ZXs9wkwn4kfxsCM+sDUNepiibdpzGnC3xCAt+jRdacNw6
        nFyjYfBYS7lZ4OCcdwtN4Yjt3RG/HAgaiEnfhvUAmJ4F08UlIQ==
X-Google-Smtp-Source: ABdhPJw6ZwCT1e6l1oGjcvU/MhBsT4PAtv1xG3T6l1p4uMLsPQzutee3ZEwosPeV186K3U4AM6gsxd1/oWu0ykbJids=
X-Received: by 2002:a05:6808:1918:: with SMTP id bf24mr4563671oib.50.1631700722473;
 Wed, 15 Sep 2021 03:12:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6830:1294:0:0:0:0 with HTTP; Wed, 15 Sep 2021 03:12:02
 -0700 (PDT)
In-Reply-To: <20210915095650.GG25110@breakpoint.cc>
References: <20210811084908.14744-10-pablo@netfilter.org> <20210915095116.14686-1-youling257@gmail.com>
 <20210915095650.GG25110@breakpoint.cc>
From:   youling 257 <youling257@gmail.com>
Date:   Wed, 15 Sep 2021 18:12:02 +0800
Message-ID: <CAOzgRdb_Agb=vNcAc=TDjyB_vSjB8Jua_TPtWYcXZF0G3+pRAg@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] netfilter: x_tables: never register tables
 by default
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

record video screenshot, http://s7tu.com/images/2021/09/15/chBnr0.jpg

2021-09-15 17:56 GMT+08:00, Florian Westphal <fw@strlen.de>:
> youling257 <youling257@gmail.com> wrote:
>> This patch cause kernel panic on my userspace, my userspace is androidx86
>> 7.
>
> You need to provide kernel panic backtrace or reproducer, else I can't do
> anything
> about this.
>
