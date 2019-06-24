Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09DAC51A2B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732690AbfFXR7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:59:30 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38168 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXR7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:59:30 -0400
Received: by mail-pf1-f195.google.com with SMTP id y15so3323708pfn.5
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 10:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fEmCOTdlFiVp6d7o5tBYwoy5c/juxhBnuZsqJDLRHoc=;
        b=bjZCQyZfXU5QMXZzQhDV0MQ0arRs6JNw7VhEHjM2ySQuIoWqFCGlrzPiaBf9diYxbC
         xGi1yXxmIslwbGPI8XdQCFafUkx//qXIvmtMRB00BmKRR0yjFJWwaBSx1iYCIqqrbih0
         zBJQ6vxicO8uZL9jE1x8asxeEc01uhN7EEHv6LC0yckk1NLPSyuhODfukKen+U/gVQTF
         OV6cSQeoalr223KXNAubNQHW8pgADmBvzRMkqW4tmUoSqYUV6m1HseXPGjF00SznjHaP
         8O+NGWVCrVrxKTBw6Iavj0SlCfmHdORjnhx/FbYf0KrmPmG2xhkiQagggtSiWmiHTcur
         apGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fEmCOTdlFiVp6d7o5tBYwoy5c/juxhBnuZsqJDLRHoc=;
        b=DSnwIOVQPRcXjzsg2dJi9Wj6tmiFGldXdjZZLftvHQlX5arNbmkD3A2JPla7wdYv3g
         MfFJxjfs6adJY+1jKExutlIGb+rn2icltxhY6mT8e+iYIDjCkv44GcxNfD7VuZTMJ/Pc
         fu49eK1pcfItnDZ11GSsxFHi5jNnfRy2mGC68L/W+ObotrBdmO8GWzbV4Z4BfgkfE1qh
         Vo+XCU4lm8i2IV72oksWfGwzB6C0Chwe9laQNIZXAOJDVW/74ulaOVZpssNHKl8Ey8PX
         tAej2+b4HMIIGc4z5vRVpZeJyEWls/9AcemhRZoBbdk3KbuzrnV7TMbdJG+4/ENLkS5r
         zkgw==
X-Gm-Message-State: APjAAAWs/XfhBmzK+jSgtFfLhKrnnjhrvZuPHAVUyD13hvkvYjS4X6qb
        fDepCbV9ucdc4csjwHVjproM7GkceeT4FI+2d88=
X-Google-Smtp-Source: APXvYqwjWkg0xnTNk0Bed+9+KnOBnAXg2H+RDXrHDAOZhW5Tbm7n5fzk+WVkO+QYhAfWfqrd88J0KqsGqTwqbhmrdqg=
X-Received: by 2002:a17:90a:634a:: with SMTP id v10mr24319663pjs.16.1561399170069;
 Mon, 24 Jun 2019 10:59:30 -0700 (PDT)
MIME-Version: 1.0
References: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
In-Reply-To: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 24 Jun 2019 10:59:19 -0700
Message-ID: <CAM_iQpU+EojoF-qOZ3gVB28+Hp-HE=tHTcC7uUh3b3XwMwWJ=w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] net/sched: Introduce tc connection tracking
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 6:43 AM Paul Blakey <paulb@mellanox.com> wrote:
>
> Hi,
>
> This patch series add connection tracking capabilities in tc sw datapath.
> It does so via a new tc action, called act_ct, and new tc flower classifier matching
> on conntrack state, mark and label.

Thanks for more detailed description here.

I still don't see why we have to do this in L2, mind to be more specific?

IOW, if you really want to manipulate conntrack info and use it for
matching, why not do it in netfilter layer as it is where conntrack is?

BTW, if the cls_flower ct_state matching is not in upstream yet, please
try to push it first, as it is a justification of this patchset.

Thanks.
