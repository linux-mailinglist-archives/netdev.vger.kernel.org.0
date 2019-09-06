Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF30ABDE2
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392161AbfIFQkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:40:11 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44999 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387986AbfIFQkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:40:11 -0400
Received: by mail-io1-f66.google.com with SMTP id j4so14095304iog.11
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R6MINmE3+g2drNEsLwkhk7TZOmpFCX+5Jlnpgltlm6o=;
        b=Zc6UmHmhaa7nZrtpdR26hgvqFf1viOoL6tcAsKVrvbhhw73Tz0WWbsYeGlzoUKDDDk
         Nr6eJkw4oTdlvjofbNgh82qFkESWYdeFMRAq65SqIoKexz8zVV7Re8JS+JTdZxVWwLgN
         Z1LknZthdUkfmb/OyvTtQWglXprtSMEULn8H1xPNljffIUph6dKgfLJLxnVPukl/YFc9
         vwnSf8BgDtfJnxiAMOj5r/pm0je0+/SvOFvKMhtDZSRPL3ZZnCu3E9orRyM9yBIivY+k
         LK9ki01KOvbd/Ul1vDjHpQC3ry8e7x08Q8V4uLaUm1R5jqdAPCgA8pkFOeLxEgE6al42
         cd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R6MINmE3+g2drNEsLwkhk7TZOmpFCX+5Jlnpgltlm6o=;
        b=fJgg7awBf6x8uc2Q8kwE3mMiKwzsAciwUBk/BEr7jBMWtVNSNye36jLnyKMp0A/qjd
         zdE/y7j0AkhEnrxcmP+gg/FZOrzEjj2ZKnpJdbXWU6OIH/q/HuA8ZxaOEmYFe46egU3b
         9hKYPZs+yYV65R4dFIDBzofQR8iO876KuuRAAxyv2PLUGNqgpIYH7fiyaMqthz7g22M1
         eAxVeU6ImM/IB1C5gNkSgkg7T53SbJUhsHhYtDUFjqkHwdYFGw9aPOvt37ORGvYpzBhE
         sdKhhfExf7U1iWDjxU7sQyVCQKp8FjQiwx665wvnkoc1Up14xgNh1X23w9CBN5oFNmHd
         +w2A==
X-Gm-Message-State: APjAAAVrceJy2h9jiZBmW6j7D/gssXqD+PU1U599Juxct6ZtDZzSuoXk
        gbtIckGprqYam4vgW/NzRcoTE2HDSsPRKeinNmmtejlF
X-Google-Smtp-Source: APXvYqxtwNx4db/1rLuTUxuDI6uFN0uYfyu+jGrbvo6yUi7QmKHLGV1rxxTNOtbUKbMm5ykUCMYDNWIJdBcW15uW+jk=
X-Received: by 2002:a6b:6303:: with SMTP id p3mr5015526iog.169.1567788010071;
 Fri, 06 Sep 2019 09:40:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAMvS6vYbphKKM4evbV6Vre7vaR8r+oJgZ8TuQU6VtBSjVqH7dA@mail.gmail.com>
 <CAMvS6vbeo5tBADNmLvkXUuSSHmxVpt3UW+jZtxY2Le9nXRbNDw@mail.gmail.com> <16579c2d-d0b7-179f-5381-3803118a8972@6wind.com>
In-Reply-To: <16579c2d-d0b7-179f-5381-3803118a8972@6wind.com>
From:   dhan lin <dhan.lin1989@gmail.com>
Date:   Fri, 6 Sep 2019 22:09:58 +0530
Message-ID: <CAMvS6vbR5mJE6EWTmPH7+SU86LYgX1FvxD2zO+S2CET36Y_EWQ@mail.gmail.com>
Subject: Re: Need more information on "ifi_change" in "struct ifinfomsg"
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolas,
Thanks a lot, for the clarification.

On Fri, 6 Sep 2019 at 20:26, Nicolas Dichtel <nicolas.dichtel@6wind.com> wr=
ote:
>
> Le 06/09/2019 =C3=A0 07:08, dhan lin a =C3=A9crit :
> > Hi All,
> >
> > There is a field called ifi_change in "struct ifinfomsg". man page for
> > rtnetlink says its for future use and should be always set to
> > 0xFFFFFFFF.
> >
> > But ive run some sample tests, to confirm the value is not as per man
> > pages explanation.
> > Its 0 most of the times and non-zero sometimes.
> >
> > I've the following question,
> >
> > Is ifi_change set only when there is a state change in interface values=
?
> ifi_change indicates which flags (ifi_flags) have changed.
> It does not cover other changes.
>
>
> Regards,
> Nicolas
