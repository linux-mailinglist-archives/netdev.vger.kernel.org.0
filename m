Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4941340EB3B
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 22:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbhIPUCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 16:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbhIPUB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 16:01:58 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7825EC061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 13:00:37 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id i6so21172929edu.1
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 13:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PUlBsXWLQI3xF7Ki3gLU76vKvNLhprLFMV21x56O/qo=;
        b=JURE9Vsg6x3nEL5CQabGQEzwPLzMelsYQ7/GzAx0CmRQxKZ32omVWkDrXUi57xea39
         yg5RCvzLP4ttnp16Bj7Gd8DNs9DEwhGPhgaibtEeBrPzMcRaon55UACuQfnNDlfRGBME
         A9OfUSHh9fEUC07eo2noJeMMGaD20xjYyAp6vqmG3S4jGe9NksQWVvNYPUssAhtOsW7r
         CTQSPrBPVPmZyEAsRmL44ROSRT96XGaqIZOj5/fyWa8436qx0r+TbQSZy8j33tqlb9g2
         1DbdL0yypy5VJ6fT5xZ4pxzo/1Sn0u93nNKcJYUUWAoD4SfEVKFSfZvOJKP+vhifMFqS
         wEdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PUlBsXWLQI3xF7Ki3gLU76vKvNLhprLFMV21x56O/qo=;
        b=07NSHTESHs8PnRjG4OGUm1QD+6T+apKvD2xorO+eZcHRsN6lTE59DTbID6SiPbp2l6
         6APO0CiPF+mP3Nncljd7h3s8xGttO5NDvsKJgXEXuaqaCZrc3MxR7EhKXzc3ABK8ahYz
         29RJYgH7y7UApM2YknhL3YdOwhBlnsgke2/yjV7zHPs/NLnZ/vpQQmuhknXOcpwHjS9M
         aNxF5LBApKFKFALOlGUIbXjgxKCoCzNzb1WacIu5XGmPKFoX1B3ZpxyiPSVKwe6kv9By
         JN1NGfbm6y0Wicw5jeeDXc8AMkfkxtQm8o0XkHmh6bEoRjBrBX9t39eEmm0w3tWS+W7A
         x00Q==
X-Gm-Message-State: AOAM532SDbuCJKxwYp9NyNUVcsveYv8PcOPFz3c9kO7Bk7d5DQR423AV
        CycutUNXdEz0wO2uNmTIW1dPL1AU17g=
X-Google-Smtp-Source: ABdhPJxGXMVu24ehNOHPZRFFZ+GJyb0RjQmo22wCV7ZecSzger22JRne7Vbrd3PCPbqXB6nOoqbTBg==
X-Received: by 2002:a17:906:3a57:: with SMTP id a23mr8155506ejf.469.1631822435878;
        Thu, 16 Sep 2021 13:00:35 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id m15sm1496920ejx.73.2021.09.16.13.00.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Sep 2021 13:00:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20210914110038.GA25110@breakpoint.cc>
Date:   Thu, 16 Sep 2021 23:00:34 +0300
Cc:     Guillaume Nault <gnault@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1DC90AD0-9235-4D18-B7A6-DFB586275549@gmail.com>
References: <20210809151529.ymbq53f633253loz@pali>
 <FFD368DF-4C89-494B-8E7B-35C2A139E277@gmail.com>
 <20210811164835.GB15488@pc-32.home>
 <81FD1346-8CE6-4080-84C9-705E2E5E69C0@gmail.com>
 <6A3B4C11-EF48-4CE9-9EC7-5882E330D7EA@gmail.com>
 <A16DCD3E-43AA-4D50-97FC-EBB776481840@gmail.com>
 <E95FDB1D-488B-4780-96A1-A2D5C9616A7A@gmail.com>
 <20210914080206.GA20454@pc-4.home> <20210914095015.GA9076@breakpoint.cc>
 <1724F1B4-5048-4625-88A5-1193D4445D5A@gmail.com>
 <20210914110038.GA25110@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small Updates

After switch from frr to bird bgp reduce load from frr
but still when have disconnect 5k+ users have slow pppoe_flush_dev




   PerfTop:   15606 irqs/sec  kernel:77.7%  exact: 100.0% lost: 0/0 =
drop: 0/0 [4000Hz cycles],  (all, 12 CPUs)
=
--------------------------------------------------------------------------=
--------------------------------------------------------------------------=
-----------------------------------------------------------

     8.24%  [kernel]              [k] osq_lock
     7.55%  [kernel]              [k] mutex_spin_on_owner
     7.04%  [pppoe]               [k] pppoe_flush_dev
     2.77%  libteam.so.5.6.1      [.] 0x0000000000009e7d
     2.67%  libteam.so.5.6.1      [.] 0x0000000000006470
     1.90%  [kernel]              [k] fib_table_flush
     1.73%  [kernel]              [k] queued_read_lock_slowpath
     1.68%  [kernel]              [k] next_uptodate_page
     1.36%  ip                    [.] 0x0000000000011b74
     1.23%  ip                    [.] 0x00000000000121b0
     1.09%  [kernel]              [k] zap_pte_range
     0.99%  libteam.so.5.6.1      [.] 0x0000000000006501
     0.88%  dtvbras               [.] 0x0000000000014be8
     0.87%  [kernel]              [k] inet_dump_ifaddr
     0.74%  [kernel]              [k] filemap_map_pages
     0.72%  [kernel]              [k] neigh_flush_dev.isra.0
     0.66%  [kernel]              [k] snmp_get_cpu_field
     0.65%  [kernel]              [k] fib_table_insert
     0.63%  [kernel]              [k] native_irq_return_iret
     0.63%  libteam.so.5.6.1      [.] 0x0000000000005c78
     0.60%  [kernel]              [k] copy_page
     0.52%  libteam.so.5.6.1      [.] 0x000000000000647f
     0.50%  [kernel]              [k] _raw_spin_lock
     0.48%  libc.so.6             [.] 0x00000000000965a2
     0.45%  [kernel]              [k] _raw_read_lock_bh
     0.44%  [kernel]              [k] release_pages
     0.42%  [kernel]              [k] clear_page_erms
     0.42%  [kernel]              [k] page_remove_rmap
     0.41%  [kernel]              [k] queued_spin_lock_slowpath
     0.38%  [kernel]              [k] kmem_cache_alloc
     0.36%  [kernel]              [k] vma_interval_tree_insert
     0.36%  libteam.so.5.6.1      [.] 0x0000000000009e6f
     0.36%  [kernel]              [k] do_set_pte


sessions:
  starting: 296
  active: 3868
  finishing: 6748



> On 14 Sep 2021, at 14:00, Florian Westphal <fw@strlen.de> wrote:
>=20
> Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> [ Trimming CC list ]
>=20
>> Florian:=20
>>=20
>> If you make patch send to test please.
>=20
> Attached.  No idea if it helps, but 'ip' should stay responsive
> even when masquerade processes netdevice events.
> <defer_masq_work.diff>

