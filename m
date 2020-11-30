Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2354B2C8F34
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 21:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388498AbgK3UaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 15:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729186AbgK3UaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 15:30:08 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382BCC0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:29:28 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id t13so12642659ilp.2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tlKH9ZsHnktc93nLaVwQyj6ALW8QVTADNOn47kCgmBQ=;
        b=a7ApsNYGJNGnouy5cDT5PepwNqpwDeV+1H8FsUbwmr49urgi0GowlGZrCM+OHOqbxC
         keoeLTGyg1tZhgvazL7v8rMOay5iLex3zgBN56BDmUj99I1564KI9B6Ral/Y2GqXSRd9
         +LqHWWVD3cgf6FZPYTMRmD9Q1Rgkzonfd57haQk9hDukEicYmOMzVENnPl+mMOvw1ruu
         CWCddCELkNTjZVCE7SIeoW0S4SudWeTHRH7eMaUYzwwyProcw4AtFlyWk6rgsWkMAPxM
         rXZj43laN2cPp9i4rXWsK3YvfKn8b9OLJl4h27BOXBjlorenS4p+YD3bGnrobSGqzlX7
         w8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tlKH9ZsHnktc93nLaVwQyj6ALW8QVTADNOn47kCgmBQ=;
        b=eZ5F92nXN3AiPG9uPHJ/V+dCpcQVLvErLLcij2NfSZGGUKelT1H4uSASuUDiIiUHxq
         2wEiaBfbfuM676FmTS/QuRU8mG4r4TJNwb7I4bEG8/JtPBZfWtlnAfuZRq1/MolV+vXK
         /CpI8WKPfe/C0P7RbpMUQRDF6cc9MpijA8VlZn1WRr/dza49w5I4wNN2uFAo8m+AjhVf
         7m5mTM4qJn3tkQy/+VidcvbxAD51OhN2h/2meXPbYK6/D1nWhaR+AHby31F/ddFkLoZL
         AnM21ylyzM3GNhkYYuqGj8+4qV/yx+h6zPzevT+lweRqPcNV+OqmnNCENFTTumoObJIJ
         4zKA==
X-Gm-Message-State: AOAM533Z+l9HFZrhNb15eQbQgnWKI9OwYJqFHOAibiM9xyiV1W0XXBEc
        4wnVlv8S2OANU9jBkFdGItxEF14vknYbReXFNY6/Tg==
X-Google-Smtp-Source: ABdhPJwvc+Z3ttFFsrcgUF/bZK64yrtqA+VyziP0mR8R6PzM9I0Gu5ZFvt7ZYCocYFxRM2FDPBI6oqRf7urgNUSWoDA=
X-Received: by 2002:a92:da82:: with SMTP id u2mr21176829iln.137.1606768167298;
 Mon, 30 Nov 2020 12:29:27 -0800 (PST)
MIME-Version: 1.0
References: <20201129205817.hti2l4hm2fbp2iwy@skbuf> <20201129211230.4d704931@hermes.local>
 <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf> <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
 <20201130190348.ayg7yn5fieyr4ksy@skbuf> <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
 <20201130194617.kzfltaqccbbfq6jr@skbuf> <20201130122129.21f9a910@hermes.local>
 <20201130202626.cnwzvzc6yhd745si@skbuf>
In-Reply-To: <20201130202626.cnwzvzc6yhd745si@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 30 Nov 2020 21:29:15 +0100
Message-ID: <CANn89i+H9dVgVE0NbucHizZX2une+bjscjcCT+ZvVNj5YFHYpg@mail.gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 9:26 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Nov 30, 2020 at 12:21:29PM -0800, Stephen Hemminger wrote:
> > if device is in a private list (in bond device), the way to handle
> > this is to use dev_hold() to keep a ref count.
>
> Correct, dev_hold is a tool that can also be used. But it is a tool that
> does not solve the general problem - only particular ones. See the other
> interesting callers of dev_get_stats in parisc, appldata, net_failover.
> We can't ignore that RTNL is used for write-side locking forever.

dev_base_lock is used to protect the list of devices (eg for /proc/net/devices),
so this will need to be replaced by something. dev_hold() won't
protect the 'list' from changing under us.
