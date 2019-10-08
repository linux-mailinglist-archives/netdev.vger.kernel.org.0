Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE63CF253
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 07:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbfJHF6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 01:58:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38080 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbfJHF6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 01:58:46 -0400
Received: by mail-pg1-f195.google.com with SMTP id x10so9667569pgi.5
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 22:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8LFQvAE524JS1+AAXneceXPOA6KJMPCeo2ATJ42QgOM=;
        b=ajXqTJHntfq9KSCpKRrVScAJoeTMV+M6j1uXWbnKzo2r/yegaynayIOhECgkQM/m7V
         LUdvOPNYfFtfRN0KY6GDvsfJ0bzNZcDwxEjMNVOoEw0JRbCZtidB0jjM5dBLB25Z/2a9
         FLY2ihIz1aKVPHx306jqokk/ZG4B1fYH7QhhVVoRJVu7xbsbKZ0rQYZoF9+CQavRgjs+
         MEtuTGBW7aVxj3+izyEnBwTKkdFMka+Mv6+Oe621AoMN2Zsawq5Be9WglXU7+ELJ6G2C
         OKkd73C2u2f8VJMn9Ba1BP9v6g50szbgTCG2bI2onrHZf8MoEg7BdcsGf352WuluH0WQ
         7crA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8LFQvAE524JS1+AAXneceXPOA6KJMPCeo2ATJ42QgOM=;
        b=Ba+sKLly5pwf7EdCftNujOAlxnBL329Hs+rkxg7SlD/bUOQ5vqndaQwK0Si8LEEMcv
         3R0LZ6spVJKlYPE/qjLjsLO9Ub8CxCRTNABUqlR/eahEKbPkqPBPEdGxlm0IjTYhiigO
         wVbbccHl0WSGpTgfGylTJ65QkursLoEj9M3jt2hBpDUZ5GIU1LvYmCysPSf25h68Uxdn
         xoegKT3dyQSenlo50gluz+KwOxRGJoMcR0Rg+urG2B1ZxItJ60sc10iQofifPOAfjXKU
         iMYNpFu9NMxz4WYUSmSBs2ujV/iQpK3yJSsY16MVWVfC/zFcMM0GRWsNUJMbtsoji/Jr
         s4+A==
X-Gm-Message-State: APjAAAW/yl2XjQXxm47AvJShriOLg8+5chfsLp8duUtgpNHhJw+UjWNG
        OUIFSWDr3rrOXlzZAiCtK5gxvCcSKylL+9RkC8A=
X-Google-Smtp-Source: APXvYqyvpEwANUTV3pFaxdx1N8A/p7NROc1n09VO1yDCPKJWBVC4ED0sMGAz/05L2t2ok4xhB4Mr5hPpjo5kaR6kDOQ=
X-Received: by 2002:a63:cd10:: with SMTP id i16mr5844175pgg.104.1570514325218;
 Mon, 07 Oct 2019 22:58:45 -0700 (PDT)
MIME-Version: 1.0
References: <20191008053507.252202-1-zenczykowski@gmail.com> <20191008053507.252202-2-zenczykowski@gmail.com>
In-Reply-To: <20191008053507.252202-2-zenczykowski@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 7 Oct 2019 22:58:33 -0700
Message-ID: <CAM_iQpVBrHy9-UP2ycHd0vXgtpfC1sVgJY8C+SMDoM98f3NVcQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] netfilter: revert "conntrack: silent a memory leak warning"
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 10:35 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> This reverts commit 114aa35d06d4920c537b72f9fa935de5dd205260.
>
> By my understanding of kmemleak the reasoning for this patch
> is incorrect.  If kmemleak couldn't handle rcu we'd have it
> reporting leaks all over the place.  My belief is that this
> was instead papering over a real leak.

If you have this belief, please:

1. Explain in details why you believe it or what supports it. For
example, did you see any kernel memory continue growing?

2. You want to fix the comment right above __krealloc() before fixing
anything else.

Thanks.
