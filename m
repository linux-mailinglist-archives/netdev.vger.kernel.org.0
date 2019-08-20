Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0011C953A4
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfHTBoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:44:16 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34603 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbfHTBoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:44:15 -0400
Received: by mail-lf1-f66.google.com with SMTP id b29so2822653lfq.1;
        Mon, 19 Aug 2019 18:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CYWxUX1vpEww7/1YIONK0k9ZNL+tZIt9zpqrqMYzPGk=;
        b=TYQzz9JxxXXhXCQUQ8SjFBqVHlYuQf0gqBE7COCZXSHzWy5/0js0TBJGfHWOP572tz
         sOggfNXiLxBB3rD/l2nsdlh0cdy9+TrNGR+6QoMS1CNEVgIolMnXtsZ9vufRHZrUBH4g
         JOTt4Rdzd4PvSFCPIT5wRXB7JZZ8t4mVblJ/RFEpEh1eXIvkRwZK6Q6ueQ0y7Sf6p8uu
         X0YAZ8hOQnZLXkVWwL86nMu1lb03W22owvJrdIn+N2m71cSUMNJrqnzjfFJi28VPH64Q
         7Qshu7SUD+2CPOi+6V7b0S8ivfh0wlOLNe5dnTbQTHf80yZLqf1V9xFNmWu81LL3Ydv7
         3APw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CYWxUX1vpEww7/1YIONK0k9ZNL+tZIt9zpqrqMYzPGk=;
        b=J6j3n0g3qNPuq5Zie65w88LQiO9kttjaq1IjUB+4jL+TGetMHDFim5TyrNhYis30ql
         4HzfFnJx+qs4y7cKNkyxb/x/GKcn27M7wMSOf3AFOW1y05yG6yvwxwhbNP/kvIr3CgAJ
         oZr/ik3oWck4NphsnJVqXDp0UmTTU2YR5b2aHCTr5lj32ftwySiAMYHJdCJRShThiyNX
         rQd4o6Fx7mtg7qDlXk7TBIULHs/zDaVB1Flvh3kNjH00MI7AYJrFhsZeYraCv5xZ4YVE
         6a3hhmGfucmOIqlE7HBpA/uqXbG68tqzBBnVEEypZCnLVGM+pd6JH1LXMQmbdpCicjjV
         cGvw==
X-Gm-Message-State: APjAAAVdynuuy7TXekoBh92EdOzdYe1wWltj5t1lntS5AMe0Xbube6gV
        ogFxhYAX14JrPxa8GIj1vAoP5qXi4Kplma0jLGI=
X-Google-Smtp-Source: APXvYqytZ6JZNsZH29nW53E+MumiqVM9AwWIIVG7N/2kw5cvKJ7k2ErH2hZFQc8haXdJkACf1HP0KJEGYvYtq0OCTyE=
X-Received: by 2002:a05:6512:288:: with SMTP id j8mr15114665lfp.181.1566265453391;
 Mon, 19 Aug 2019 18:44:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190819212122.10286-1-peter@lekensteyn.nl> <20190819212122.10286-2-peter@lekensteyn.nl>
In-Reply-To: <20190819212122.10286-2-peter@lekensteyn.nl>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 19 Aug 2019 18:44:02 -0700
Message-ID: <CAADnVQ+-d0UKhhHx2btiMq804aHD77sN0tiDGobzHQEuWsWJKg@mail.gmail.com>
Subject: Re: [PATCH 1/2] bpf: fix 'struct pt_reg' typo in documentation
To:     Peter Wu <peter@lekensteyn.nl>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 2:21 PM Peter Wu <peter@lekensteyn.nl> wrote:
>
> There is no 'struct pt_reg'.
>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>  include/uapi/linux/bpf.h       | 6 +++---
>  tools/include/uapi/linux/bpf.h | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)

please split it into two patches. One for kernel and one for user.
We need tools/* to be updated separately due to auto-sync
of libbpf into github.
