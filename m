Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516B59A1DA
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 23:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390056AbfHVVNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:13:22 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44119 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729718AbfHVVNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:13:22 -0400
Received: by mail-qt1-f194.google.com with SMTP id 44so9284286qtg.11;
        Thu, 22 Aug 2019 14:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tVYGZF98cbwCuEnSEO1Hots0hv8R+WSge8zW0ooPbuk=;
        b=O8leEuBYlqsOe/lClx0gekw2F1TuK5mIxCus51wwMx1g0I4yslglKjMsVWwhuis/R2
         xJMkzHGBxGbvSRol1pOgOSxokHmAPmcbghciCuP00mBQxH+wGx7WpjanUSyVWm8PmLdV
         xBjyd/J3cindAzLQJosmkpaI4erGlBzGELqic9Y/h3slZgHd9wQIqnEFpNZnph2Zb0lW
         GnZ0zokq71rhJkwSdWfQ5iPkJ+4BDrklRBJG+QQ+VPWPz8HHJWCX/I6XTbvpGbpUpVNd
         9nAKzfhvVosDtl3swmpYHHjXAMsFGES6cS/dQLjrnS/xXezmoW8z/axMpJZKsHEuppnt
         Nvow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tVYGZF98cbwCuEnSEO1Hots0hv8R+WSge8zW0ooPbuk=;
        b=fmxoB1DbPO4UslUStIGXCeWD8z9kjb6aWnMZUFW0rGuOHHtnl0X3FtV1ane85yb2F9
         Gflt4YKtvpjO0cWYcDt5Vk9cef1KTaraQscngo4DQiyLuMp08pE2l8Jb7qqXdSFa4YDj
         T619QPOaWz8h4Qpo8d+cNauoFbhagQUbe53TgkG7tE4Xvo8TVNzz3ieYiwSTZIUz9Tsg
         oTL6jt4YaJNG79Yw2J6pIyLWm5hnt2e0ykB2HnaqSon7QIT+MhE8vC4+EAyvLUKTGRgv
         w+e64h2PcTTwGW2EwTWK7+cF003vfMd6P9idz4llIv3BmWIAZIPCJrLOvFaaFGRhb1n0
         dttw==
X-Gm-Message-State: APjAAAXvy+atzf16Zk7k2G4avjb7dIeqdCFhW9KfJt17euiKmu6oYJkt
        c0L/P/N5cMgRKfp96Wh/CtcHxnuIvHdRnn2tzW4=
X-Google-Smtp-Source: APXvYqzabskoAr859ElJLB/1NTl9lcAlIyr0pZ6JF+n8KfqYiXfinYi4g1g8nmSaWxuXRxu+M4uvCzB5uOEvEw1AWps=
X-Received: by 2002:ac8:358e:: with SMTP id k14mr1675089qtb.83.1566508400887;
 Thu, 22 Aug 2019 14:13:20 -0700 (PDT)
MIME-Version: 1.0
References: <2755f638-7846-91f2-74f4-61031f3e34c8@web.de>
In-Reply-To: <2755f638-7846-91f2-74f4-61031f3e34c8@web.de>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 22 Aug 2019 14:13:10 -0700
Message-ID: <CAPhsuW4aH_kPc5NnWXQp5jgdvOZjq+eDWpUQGBgyZ9USEA6LKA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_net=2Fcore=2Fskmsg=3A_Delete_an_unnecessary_ch?=
        =?UTF-8?Q?eck_before_the_function_call_=E2=80=9Cconsume=5Fskb=E2=80=9D?=
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 10:18 AM Markus Elfring <Markus.Elfring@web.de> wrote:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 22 Aug 2019 18:00:40 +0200
>
> The consume_skb() function performs also input parameter validation.
> Thus the test around the call is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Acked-by: Song Liu <songliubraving@fb.com>
