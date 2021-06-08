Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A357039ECAF
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhFHDG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhFHDG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 23:06:27 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938F6C061574;
        Mon,  7 Jun 2021 20:04:27 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 131so24993101ljj.3;
        Mon, 07 Jun 2021 20:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m82KiBKX5qk29fmxWKD5zTJ6phmL6QfB1KLgqjZgjnk=;
        b=oTf7Dw1CBl9w7lIv7NXMfYBNT+zs6XDymTBcBF5UCr+wfrZv1iBd2HC3nQhYExvRGB
         SsZPBgoLGCYyOHdNnePhyy7jC5tLT4uWy9qCda3j8D4MWB4d1l0nwrj6GlovZCqwzfrs
         kU/Q6+9hcsscLLt8pcm6vdOjGbWv0xJQIRjpj+Xzyqv9d5riAITBqZHYciQWQHWglbTi
         k3iduwra9DCs8xZ+ojPCBibLRJ7lANb1jK1O2c4gkycmirca3XzJs7koIbwuRdrGYfJ7
         Ts9RU7YnYPF94R3YgvHyb68xA9nUPiVKDO8W50Xf0u8Tnix33NWM6hGXj70S1AZWgb9h
         EydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m82KiBKX5qk29fmxWKD5zTJ6phmL6QfB1KLgqjZgjnk=;
        b=TI96UoezudCoLk8s8ixzx2UCjgxLSiOMDaNc3071uYMVfCPE5F+W6LSOZhsoVMtQMC
         nQzTcVlWCBgHZYgHyVsg1rD1ujrZEJ2XnAqYGL3YyTb4kb6xnvNno/ukmzT4C5k0I9nY
         Oiyz0HeCKw2h+JgipucvlUZQsF4CUoSRgzmxTBFYZ7FH+ZjL4i+w1/rt42llMHtNT60R
         KI8sgUPqew/KyVk9swM0EnYQlkUSa9rJxEWQe/NsUbGSebrx6xfYLeyLxUyRRKLT+Era
         A97AjTufb1+Whe7MQ1/X8tO4WY82Kk0GeXxbWiVJ2LEjWYuPDhb/S4a4FEiN7Ql/UcNR
         toRg==
X-Gm-Message-State: AOAM532ASXfkxAZPPxjtiB1wvAKBalyLpoazE0d6IhmA2a6DE6kXPrvw
        TeEJDOYty1+w0/1gUgXCN3owEilXSjFJIiXmG20=
X-Google-Smtp-Source: ABdhPJwpx7U2S6QZGs1NSIDBmHkjX+ap88j9ZEP+8OAQ1yQxpsj8M/6JWxAixkiQMwnI+tMuSd7Yhbwu58rqC38GBFc=
X-Received: by 2002:a2e:9a87:: with SMTP id p7mr12088387lji.477.1623121465844;
 Mon, 07 Jun 2021 20:04:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
 <87pmwxsjxm.fsf@suse.com>
In-Reply-To: <87pmwxsjxm.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 7 Jun 2021 22:04:15 -0500
Message-ID: <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
Subject: Re: quic in-kernel implementation?
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Alexander Ahring Oder Aring <aahringo@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 11:45 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Alexander Ahring Oder Aring <aahringo@redhat.com> writes:
> > as I notice there exists several quic user space implementations, is
> > there any interest or process of doing an in-kernel implementation? I
> > am asking because I would like to try out quic with an in-kernel
> > application protocol like DLM. Besides DLM I've heard that the SMB
> > community is also interested into such implementation.
>
> Yes SMB can work over QUIC. It would be nice if there was an in-kernel
> implementation that cifs.ko could use. Many firewall block port 445
> (SMB) despite the newer version of the protocol now having encryption,
> signing, etc. Using QUIC (UDP port 443) would allow for more reliable
> connectivity to cloud storage like azure.
>
> There are already multiple well-tested C QUIC implementation out there
> (Microsoft one for example, has a lot of extra code annotation to allow
> for deep static analysis) but I'm not sure how we would go about porting
> it to linux.
>
> https://github.com/microsoft/msquic

Since the Windows implementation of SMB3.1.1 over QUIC appears stable
(for quite a while now) and well tested, and even wireshark can now decode =
it, a
possible sequence of steps has been discussed similar to the below:

1) using a userspace port of QUIC (e.g. msquic since is one of the more tes=
ted
ports, and apparently similar to what already works well for QUIC on Window=
s
with SMB3.1.1) finish up the SMB3.1.1 kernel pieces needed for running over
QUIC
2) then switch focus to porting a smaller C userspace implementation of
QUIC to Linux (probably not msquic since it is larger and doesn't
follow kernel style)
to kernel in fs/cifs  (since currently SMB3.1.1 is the only protocol
that uses QUIC,
and the Windows server target is quite stable and can be used to test again=
st)
3) use the userspace upcall example from step 1 for
comparison/testing/debugging etc.
since we know the userspace version is stable
4) Once SMB3.1.1 over QUIC is no longer experimental, remove, and
we are convinced it (kernel QUIC port) works well with SMB3.1.1
to servers which support QUIC, then move the quic code from fs/cifs to the =
/net
tree




--=20
Thanks,

Steve
