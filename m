Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AD822E5EF
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 08:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgG0GgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 02:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgG0GgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 02:36:08 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B33C0619D2;
        Sun, 26 Jul 2020 23:36:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o8so13028799wmh.4;
        Sun, 26 Jul 2020 23:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OHzWojCxrKrB8BGpLNoziZDorIb++5odiZ1mDIW87iQ=;
        b=DiaSbjFnxUycLjnJnZJmUUe+TraoJsVubRWcwFLVd6DIPq/emFzZtldY7w9xpsD3tJ
         PjbHYtuVwdikhgUcoEqEpH8DQEteJZPZLshbjN6QD+Aph5WGveZ3/x2wDFrFbLiQgi8O
         dROPdfO7vfbbLzI5FirvSCnszhsbkdV+zQSlR4rKaIf1It2BgvcaYLcfX8EDYIBHUJBn
         l+C9eSyVc+7psUwvhIFpmZKsjrxKGxUU6YOkY3It8QRomHTTnleW0xwjPAVTN4GLn2qd
         m+h8O6USFYkmFKaiWSP0NlwTyvV2+Gd6qeRodURlOaG0qd4qLPLXZNow7PUpEsYISHE1
         Tm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OHzWojCxrKrB8BGpLNoziZDorIb++5odiZ1mDIW87iQ=;
        b=LS0E1RRjDqk4hh23URbE5nIhKYPoHKPONJWEQ77izGS+AXpCmoXW77qQ5IYk1i2QgC
         kVZfFFX3ow/ggXnDxriVup1+vCsd5bmiH3zEMs/OdL+Oi23D0cTx+CeGz/owBYfSt6WN
         J3jKxZoROMQMl7O0eE7+m+UfFd1vQqqmY276YCThXhVUFHRa0lZo0nz6E47YsCcXmCF7
         ivqyiHzOvNECSGLUQ/8gk5UFjk+al+shJyaeWN74AEC4XlpfMg2BeMjsvWDM6UtB3o79
         At1nWZdTH1EX2IRVf6sNIe5knW9OU5M2fik21S6NyXDhSU2fWAFgUxvz6DJQxhTng7nc
         dmoQ==
X-Gm-Message-State: AOAM530Obyxw/aR8MgEucjH9YoVFZqvlPfuAB7vkIqikJ0NmE1Sdx55/
        N3X9TD1dhNiAEi/VWHI527/baQYz6lJiidOqIdg=
X-Google-Smtp-Source: ABdhPJxD5LoZzgODNFDNnMfqDrfUDLsPKlOSywKXX9R2o9p68CIr3y91senhVTdcBSgtOxsfK1DUerOiuOYKtUa6NFg=
X-Received: by 2002:a7b:cf2f:: with SMTP id m15mr18470412wmg.122.1595831766093;
 Sun, 26 Jul 2020 23:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <001a11405628bb07410565279f4a@google.com> <0000000000004251b005ab5dce75@google.com>
In-Reply-To: <0000000000004251b005ab5dce75@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 27 Jul 2020 14:47:11 +0800
Message-ID: <CADvbK_cq=90axvohTHW6b=9pGSf9MDCHvpn76hWDmOWh91jWdQ@mail.gmail.com>
Subject: Re: WARNING in xfrm_policy_insert
To:     syzbot <syzbot+5cfc132a76d844973259@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 4:11 AM syzbot
<syzbot+5cfc132a76d844973259@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit ed17b8d377eaf6b4a01d46942b4c647378a79bdd
> Author: Xin Long <lucien.xin@gmail.com>
> Date:   Mon May 25 05:53:37 2020 +0000
>
>     xfrm: fix a warning in xfrm_policy_insert_list
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1774b9df100000
> start commit:   6c677750 mlxsw: spectrum: Use NL_SET_ERR_MSG_MOD
> git tree:       net-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=82a189bf69e089b5
> dashboard link: https://syzkaller.appspot.com/bug?extid=5cfc132a76d844973259
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f8821d800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ec3c63800000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: xfrm: fix a warning in xfrm_policy_insert_list
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
#syz fix: xfrm: fix a warning in xfrm_policy_insert_list
