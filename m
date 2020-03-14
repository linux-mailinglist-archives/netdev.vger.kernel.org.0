Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B27185425
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 04:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgCNDG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 23:06:29 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36524 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgCNDG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 23:06:29 -0400
Received: by mail-oi1-f194.google.com with SMTP id k18so11697082oib.3;
        Fri, 13 Mar 2020 20:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FIpHicZ3t9iIlvAbQDoq7yMgDqITyaH5TIJrz/BqXnM=;
        b=NAAimfC0p9VaenVIBoNc/nXoUJmTfCBBHj9MpZpCP7nHRHcLBzmm6zUeHIBZvVtWRt
         mJ5R3vyondjX/f0i3lscFfQ5x2Nbau1h3IfKZw4q6ejGhglYAXNCxRJZe1YV1MOxukPD
         +FayuF/OqdlrlnEVzzfre8Yaok9gij1C3LmCcUAZJZw79Akd04ifEGqhJM50bffXCVnl
         vEQrcXfsuKn07yLI80azzBdAtJmEdMQ+LXmejItwaKiwjuKjcnpaZXMtPHsxQdi69Pqj
         XNCoZWP8/2wQORG18Y9CcYRNpe+2SQwNRpDZTAq+8lpGZlKJUphCV0fEjr0plp3buouR
         YITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FIpHicZ3t9iIlvAbQDoq7yMgDqITyaH5TIJrz/BqXnM=;
        b=ugHzi2zA2tsQGLvRER3WGtAIYDIO7Mw7eKptjM8isy7aWMbl5858v646QBqAvNvKR7
         dbDzDNl2FCQJMQeBp9D90cD1oXjLp+4/zBhkQxMypYIUonKLfc3c5X+mfhR8DEb6q1Nj
         d4o4HjXToDswQXB5KQTS8qYggb0Hoc7VdJEXZbfDLqGcQNJ57D8qpaIoeljypAGkysG9
         eZmVjnpP8HHpVzNTjTfdoJYJe2KdxLrfNhqCfVrrYb0c4ilnzTulNHtcaL4IYQe36UzH
         IyBvMrMKCVqxrn9SpD8ZCB3k46IogAVLVxMBHyIpRmDVTN0HMG3Pum2N1yKUYe6xCkIQ
         TMwQ==
X-Gm-Message-State: ANhLgQ1D1O+0jmumXK+PBn4Ttk77QE81oTR0LDS6i0cAPT88zoaXOAyY
        GXxMqbvxTlnzobirdwOPg2NtV1/0R2IcQPf8HjQ=
X-Google-Smtp-Source: ADFU+vv+zz6mLJGMtBLZeG/y3TyjgadbSgFd0aMkwIDIez8u0HV/7xNg+u9i1KofFi51L+0wEWOj9FIqxKLcdYC4LuU=
X-Received: by 2002:aca:d489:: with SMTP id l131mr9876433oig.5.1584155189018;
 Fri, 13 Mar 2020 20:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000bf5ff105a01fef33@google.com>
In-Reply-To: <000000000000bf5ff105a01fef33@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 13 Mar 2020 20:06:18 -0700
Message-ID: <CAM_iQpUo0L0+J7aGTvUsBWZ=A8cGxyN7oJVjqyent+9OCbJ_Jg@mail.gmail.com>
Subject: Re: WARNING: ODEBUG bug in tcf_queue_work
To:     syzbot <syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/congwang/linux.git tcindex
