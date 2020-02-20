Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B58F16635C
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 17:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgBTQpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 11:45:06 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39624 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbgBTQpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 11:45:06 -0500
Received: by mail-qk1-f195.google.com with SMTP id a141so4154187qkg.6
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 08:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gGm+UKWx6ZF2qNYZ46/Lq5NNTT/chvIPYcorvsXdNuU=;
        b=PikFMO+0eiRF3K1xcv/08g+Zu7hxosSNnpCQQ0556QO0UO/RQJmOcH35kMc8Dr8kvh
         VICtlz8PT29aaFB9ASgwemvgzhOeuDsWTpi8cTuoNx1uNejeB6BNz3IAMXzfWCQiPkYi
         t5GvKuiAjhsNs62ZM9Q8vohsA8tEf4bCOKKwmFUkcu2KfOiVVxR4Qn6pUC1IzDZpH6Fm
         uvgHinxW9Ifq371RINhqO7BqiJFVBfJq7sTpOPK3vtvAgIFHHK9N82DYzQdTPvzTdaX5
         Op5L9yqRKGLqPrmQL3x4+fRGmsvitWFtMAnmujx5/HPQGabJlxRd8f+SwTemukDeJ3Yf
         WBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gGm+UKWx6ZF2qNYZ46/Lq5NNTT/chvIPYcorvsXdNuU=;
        b=d9gf7iTj+z2qb19RFeZrPFi+4mZkFPpKlctQItKBniSQxZoUzPgVukI5lenfjwrz9n
         HQvkU8wWIKAoCybm9VF0IczZ25PT1QOqJbANN+WEZK/KQJD9yfVHcFqhSKS3yZWXlnaT
         knfFKz9SIrLMnJLgHOQXYZ3o1cLDh/VCHayuH2EPDO3PEaOvtFuy7JaAfs/ybkEbEqRE
         RwADqBxiL7ZoaIIFxBbY19zwtTILo8jhP2qOqKxmAuDQ73Y+O5ZvBxdRcO16jgVrc6Qm
         ohO0yQIBGKb6renK+Nz7ap0Mk9mbXhNSBXp9yyVdbDYviWNfA/e0u6vP37nIYQxRpJdK
         ekpA==
X-Gm-Message-State: APjAAAUPDRodzq3o8+orylpmjTJUdpEUUaUQFe8a4+VtIjxE/FOxVadr
        XtbM0Mjwn1EHMsP5zOUHvqOUNIZtPrV/j4KJs3GJww==
X-Google-Smtp-Source: APXvYqzM8HDfBAB2xZqnGvzOg2b9sY1jGLIVJKJiXzpptOYMkx0twIr+yw/ee8edtEpULxErHHiPBY3txfmStT/BoyY=
X-Received: by 2002:ae9:e003:: with SMTP id m3mr8593858qkk.250.1582217105020;
 Thu, 20 Feb 2020 08:45:05 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
 <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
 <CAHmME9qUWr69o0r+Mtm8tRSeQq3P780DhWAhpJkNWBfZ+J5OYA@mail.gmail.com>
 <CACT4Y+YfBDvQHdK24ybyyy5p07MXNMnLA7+gq9axq-EizN6jhA@mail.gmail.com>
 <CAHmME9qcv5izLz-_Z2fQefhgxDKwgVU=MkkJmAkAn3O_dXs5fA@mail.gmail.com>
 <CACT4Y+arVNCYpJZsY7vMhBEKQsaig_o6j7E=ib4tF5d25c-cjw@mail.gmail.com>
 <CAHmME9ofmwig2=G+8vc1fbOCawuRzv+CcAE=85spadtbneqGag@mail.gmail.com>
 <CACT4Y+awD47=Q3taT_-yQPfQ4uyW-DRpeWBbSHcG6_=b20PPwg@mail.gmail.com>
 <CAHmME9q3_p_BX0BC6=urj4KeWLN2PvPgvGy3vQLFmd=qkNEkpQ@mail.gmail.com>
 <CACT4Y+bSBD_=rmGCF3mngiRKOfa7cv0odFaadF1wyEV9NVhQcg@mail.gmail.com>
 <CAHmME9pQQhQtg8JymxMbSMgnhZ9BpjEoTb=sSNndjp1rXnzi_Q@mail.gmail.com>
 <CAHmME9or-Wwx63ZtwYzOWV9KQJY1aarx2Eh8iF2P--BXfz6u+g@mail.gmail.com>
 <CACT4Y+a8N7_n4t_vxezKJVkd1+gDHaMzpeG18MuDE04+r3341A@mail.gmail.com>
 <CACT4Y+atqrSfZuquPZcRUKNtVbLdu+B5YN3=YmDb38Ruzj3Pzw@mail.gmail.com>
 <CACT4Y+bMzYZeMvv2DdTuTKtJFzTcHhinp7N7VmSiXqSBDyj8Ug@mail.gmail.com>
 <CACT4Y+bUXAstk41RPSF-EQDh7A8-XkTbc53nQTHt4DS5AUhr-A@mail.gmail.com>
 <CAHmME9pr4=cn5ijSNs05=fjdfQon49kyEzymkUREJ=xzTZ7Q7w@mail.gmail.com>
 <CACT4Y+aTBNZAekX_D+QdofqBdUuG9BkzLq+TFDxr8-sSqL9hdQ@mail.gmail.com> <CAHmME9pSWRe8k3+4G45tWE9V+N3A9APN5KFq65S5D0JNvR2xxQ@mail.gmail.com>
In-Reply-To: <CAHmME9pSWRe8k3+4G45tWE9V+N3A9APN5KFq65S5D0JNvR2xxQ@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 20 Feb 2020 17:44:53 +0100
Message-ID: <CACT4Y+ZZM-nW--q6kzKpw4tJ+tmsS=SK13SChtD__r5-k5hH_Q@mail.gmail.com>
Subject: Re: syzkaller wireguard key situation [was: Re: [PATCH net-next v2]
 net: WireGuard secure network tunnel]
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 5:34 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Dmitry,
>
> On Thu, Feb 20, 2020 at 5:14 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > I got some coverage in wg_netdevice_notification:
> > https://imgur.com/a/1sJZKtp
> >
> > Or you mean the parts that are still red?
>
> Yes, it's the red parts that interest me. Intermixing those with
> various wireguard-specific netlink calls and setting devices up and
> down and putting traffic through those sockets, in weird ways, could
> dig up bugs.
>
> > I think theoretically these parts should be reachable too because
> > syzkaller can do unshare and obtain net ns fd's.
> >
> > It's quite hard to test because it just crashes all the time on known bugs.
> > So maybe the most profitable way to get more coverage throughout the
> > networking subsystem now is to fix the top layer of crashers ;)
>
> Ahhh, interesting, so the issue is that syzkaller is finding too many
> other networking stack bugs before it gets to being able to play with
> wireguard. Shucks.


If it's aimed only at, say, wireguard netlink interface, then it's not
distracted by bugs in other parts. But as you add some ipv4/6 tcp/udp
sockets, more netlink to change these net namespaces, namespaces
related syscalls, packet injection, etc, in the end it covers quite a
significant part of kernel. You know how fuzzing works, right. You
really need to fix the current layer of bugs to get to the next one.
And we accumulated 600+ open bugs. It still finds some new ones, but I
guess these are really primitive ones (as compared to its full bug
finding potential).
