Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC6024A5EC
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 20:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHSSZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 14:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgHSSZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 14:25:45 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F70C061757;
        Wed, 19 Aug 2020 11:25:45 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id x24so19842704otp.3;
        Wed, 19 Aug 2020 11:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Uj2G5qDhsm+bapptHCJ7Bq0u40iHl5V2rOPjbm76rTA=;
        b=hE17SsbRqQpRbkfOlDKQ7cHbfmXUCJ0VwlKiGbZoC2ttuB63xjWR6C00YVa12lip+H
         5Asa0XO6gTnbfwrYxuWZ3ol5YiA0QBQdkUPdpJ5TwkCl00rK0Sio3v6UDQCfl3a3OZRC
         nkVBzNoGfS+3q7RZy4Qep59FvFffEAvV1aMebFGXjGCN9CDSDpVmhHi3gE0WprXGlXir
         9JMn9lLil/9r56iq7V1W7A/CLbZkGasag9MGOaS7kt0J4tv0m5RzyRMpUXKPa3uYenzy
         7aHsknBx/m6nOLZBPz4cYKibvDOhl5BUwdrud2oKoxuv88+ERZIeymKB/LtV/hUoguCY
         Qitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Uj2G5qDhsm+bapptHCJ7Bq0u40iHl5V2rOPjbm76rTA=;
        b=N/Uoss4WLC/vRYkwLdIJTZy8FdlWVEUsS1pOXCt45bhTEl0CQ2neJ7pFXsiSSIU9ry
         KUJRLBCjZLhiJ8nDYF6n7OY+SR09jUqCvFJuvjAZLugZQJ2KTtZhZXam6pLvA0hWD1hf
         hjdbalHrwEi+fhcTi0g6gXRpPJR1+N7Aihqo8F+lGkyR9g1+u7fdKhGyLpN8u3+v3+AJ
         fQayyHsetHgSPuwRqgzgEFpK7naGy6KUsAm1e7Zkqy0BNu2FplEMWyFQvC/2obKnZUh7
         1bxcXhEbXhj93vnr4H77TcPRZCQqSy7CM8Ds4IchsmDas6wSOJ4T4oMMN6NK3HdMeCTp
         Yj3w==
X-Gm-Message-State: AOAM531GTGzzKhOzYS416T1AMdheOC1PWVdmCs4DGGKgY0iV9D6yxPGM
        aPR0bRp6/7bM1WVgzFATRoEuEVU2X4OjSah1lOs=
X-Google-Smtp-Source: ABdhPJwJR8sF/ZcOD7xlXzSk86ZIVJ765re8VslROHCqbVK/phzo2qOwJwntqdZES6IBnWgK5FawZmDnJIMv7glO6L8=
X-Received: by 2002:a9d:24e7:: with SMTP id z94mr19379061ota.91.1597861544816;
 Wed, 19 Aug 2020 11:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200813084129.332730-1-josephsih@chromium.org>
 <20200813164059.v1.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
 <CABBYNZJ-nBXeujF2WkMEPYPQhXAphqKCV39gr-QYFdTC3GvjXg@mail.gmail.com>
 <20200819143716.iimo4l3uul7lrpjn@pali> <CABBYNZJVDk6LWqyY7h8=KwpA4Oub+aCb3WEWnxk_AGWPvgmatg@mail.gmail.com>
 <20200819182306.wvyht6ocyqpo75tp@pali>
In-Reply-To: <20200819182306.wvyht6ocyqpo75tp@pali>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 19 Aug 2020 11:25:34 -0700
Message-ID: <CABBYNZ+F=-YsZoL4B9=XQvHSs9wU=0W3iqbYn4s65JMAJAmAKw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] Bluetooth: sco: expose WBS packet length in socket option
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Joseph Hwang <josephsih@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Joseph Hwang <josephsih@google.com>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 11:23 AM Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> On Wednesday 19 August 2020 11:21:00 Luiz Augusto von Dentz wrote:
> > Hi Pali,
> >
> > On Wed, Aug 19, 2020 at 7:37 AM Pali Roh=C3=A1r <pali@kernel.org> wrote=
:
> > >
> > > On Friday 14 August 2020 12:56:05 Luiz Augusto von Dentz wrote:
> > > > Hi Joseph,
> > > >
> > > > On Thu, Aug 13, 2020 at 1:42 AM Joseph Hwang <josephsih@chromium.or=
g> wrote:
> > > > >
> > > > > It is desirable to expose the wideband speech packet length via
> > > > > a socket option to the user space so that the user space can set
> > > > > the value correctly in configuring the sco connection.
> > > > >
> > > > > Reviewed-by: Alain Michaud <alainm@chromium.org>
> > > > > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > > > > Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> > > > > ---
> > > > >
> > > > >  include/net/bluetooth/bluetooth.h | 2 ++
> > > > >  net/bluetooth/sco.c               | 8 ++++++++
> > > > >  2 files changed, 10 insertions(+)
> > > > >
> > > > > diff --git a/include/net/bluetooth/bluetooth.h b/include/net/blue=
tooth/bluetooth.h
> > > > > index 9125effbf4483d..922cc03143def4 100644
> > > > > --- a/include/net/bluetooth/bluetooth.h
> > > > > +++ b/include/net/bluetooth/bluetooth.h
> > > > > @@ -153,6 +153,8 @@ struct bt_voice {
> > > > >
> > > > >  #define BT_SCM_PKT_STATUS      0x03
> > > > >
> > > > > +#define BT_SCO_PKT_LEN         17
> > > > > +
> > > > >  __printf(1, 2)
> > > > >  void bt_info(const char *fmt, ...);
> > > > >  __printf(1, 2)
> > > > > diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> > > > > index dcf7f96ff417e6..97e4e7c7b8cf62 100644
> > > > > --- a/net/bluetooth/sco.c
> > > > > +++ b/net/bluetooth/sco.c
> > > > > @@ -67,6 +67,7 @@ struct sco_pinfo {
> > > > >         __u32           flags;
> > > > >         __u16           setting;
> > > > >         __u8            cmsg_mask;
> > > > > +       __u32           pkt_len;
> > > > >         struct sco_conn *conn;
> > > > >  };
> > > > >
> > > > > @@ -267,6 +268,8 @@ static int sco_connect(struct sock *sk)
> > > > >                 sco_sock_set_timer(sk, sk->sk_sndtimeo);
> > > > >         }
> > > > >
> > > > > +       sco_pi(sk)->pkt_len =3D hdev->sco_pkt_len;
> > > > > +
> > > > >  done:
> > > > >         hci_dev_unlock(hdev);
> > > > >         hci_dev_put(hdev);
> > > > > @@ -1001,6 +1004,11 @@ static int sco_sock_getsockopt(struct sock=
et *sock, int level, int optname,
> > > > >                         err =3D -EFAULT;
> > > > >                 break;
> > > > >
> > > > > +       case BT_SCO_PKT_LEN:
> > > > > +               if (put_user(sco_pi(sk)->pkt_len, (u32 __user *)o=
ptval))
> > > > > +                       err =3D -EFAULT;
> > > > > +               break;
> > > >
> > > > Couldn't we expose this via BT_SNDMTU/BT_RCVMTU?
> > >
> > > Hello!
> > >
> > > There is already SCO_OPTIONS sock option, uses struct sco_options and
> > > contains 'mtu' member.
> > >
> > > I think that instead of adding new sock option, existing SCO_OPTIONS
> > > option should be used.
> >
> > We are moving away from type specific options to so options like
> > BT_SNDMTU/BT_RCVMTU should be supported in all socket types.
>
> Yes, this make sense.
>
> But I guess that SCO_OPTIONS should be provided for backward
> compatibility as it is already used by lot of userspace applications.
>
> So for me it looks like that BT_SNDMTU/BT_RCVMTU should return same
> value as SCO_OPTIONS.

Yep, luckily we can do this here because SCO MTU is symmetric.

> > >
> > > > >         default:
> > > > >                 err =3D -ENOPROTOOPT;
> > > > >                 break;
> > > > > --
> > > > > 2.28.0.236.gb10cc79966-goog
> > > > >
> > > >
> > > >
> > > > --
> > > > Luiz Augusto von Dentz
> >
> >
> >
> > --
> > Luiz Augusto von Dentz



--=20
Luiz Augusto von Dentz
