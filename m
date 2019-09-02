Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F07A4EB2
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 06:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbfIBEoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 00:44:03 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:40686 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfIBEoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 00:44:03 -0400
Received: by mail-yw1-f67.google.com with SMTP id k200so141687ywa.7
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 21:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aKoJ+LaCvnVpPwDl5kwNo0LaTSn5NTE8656xAo7GLOU=;
        b=EbGM/qY8tcJETmnvGxguHwXt5WslO+IaXJ1dP+bbX5MHHXSlQoeCqt5FVZw3lbHE5a
         EKCHfhiyFx2G4FyLJwZwUIFxiMXbrPHbSBgy1zgCEUfuT3kch8hFs89LK8yRPx4T1voP
         COzTqbGz7KyDIazC6cUvwz7gt8zxNaVp4gOu7eLPAi9oRy2Z7eLUG9CN+0KeZg2tFrQg
         aarjJT3Px0QqneVObmMNn7F/Frwd0ljmk03rW0Hai+OQAEWtWYNnzf/5NqbmBhjPKPrC
         qSSX1+K4pBMRxHV8QlhBrFkBmsS+7CBZUzhimoh+ePAPKzy3/hIgBUcfUysYWUjRsv6B
         gx1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aKoJ+LaCvnVpPwDl5kwNo0LaTSn5NTE8656xAo7GLOU=;
        b=KJl1vVkIhFqzYY4LsXjBJlxo4hupJx6L5/E1v3W6HcQFcqfjXqS0LSLPrqJcMRkaOC
         0lKbYTwToGufU1FoZBwESuDzK5JqLQViwasEzTkgWkwHl/zta1xCxBZ1ciK2uRY/4UOe
         ac/rVFiAbwWW3AuEePdzspXCMcZFgb+xR1zagFlK4j2BzFK2lj0Mp/WOxj2qRmgU3Epc
         6wKddyqSPLM/cbKu9/UPxKji1k5+Io4O8EaJfGcQHvuRIqFLx//0H/p/TBDv85tOYpkl
         MHZfb9LQdGkIZaSL2gwG3bkUT4LA6FpxdQucMQjrX6IwvFMPLWN4nkzVU+sMUh/40IrD
         Fg9w==
X-Gm-Message-State: APjAAAU6dhSS9vA2MyiIylDEhgb9mZr84KjorQgvShZbPENTv2iK1b15
        681NEpvMKEiixa5kg0VqZJMFXx46HBX6BVUtww==
X-Google-Smtp-Source: APXvYqznwlh+2CU8mwf89Y2S/OdH7I+pPa+XBtlkRH9n74FELeDeQcNF9e7DzkD141efq+l4cSFprlB5vKc8eIXvvuU=
X-Received: by 2002:a81:3b09:: with SMTP id i9mr7273783ywa.166.1567399442764;
 Sun, 01 Sep 2019 21:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190826162517.8082-1-danieltimlee@gmail.com> <CAPhsuW6dnbwtCxf5AO6gJe07qu4ewvO1NQ+ZiQVBR8jUVfQ9uQ@mail.gmail.com>
 <CAEKGpzhGkLGswP3G9BzY1YErVOuNQRRBD2y=4g7u7dfh1by3aA@mail.gmail.com>
In-Reply-To: <CAEKGpzhGkLGswP3G9BzY1YErVOuNQRRBD2y=4g7u7dfh1by3aA@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Mon, 2 Sep 2019 13:43:46 +0900
Message-ID: <CAEKGpzjmCj4Fjt1e0ztnPW2xjvK1ea9oMFLs8GyOaqpryDKkLA@mail.gmail.com>
Subject: Re: [bpf-next, v2] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 3:23 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> On Fri, Aug 30, 2019 at 5:42 AM Song Liu <liu.song.a23@gmail.com> wrote:
> >
> > On Mon, Aug 26, 2019 at 9:52 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> > > to 600. To make this size flexible, a new map 'pcktsz' is added.
> > >
> > > By updating new packet size to this map from the userland,
> > > xdp_adjust_tail_kern.o will use this value as a new max_pckt_size.
> > >
> > > If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> > > will be 600 as a default.
> >
> > Please also cc bpf@vger.kernel.org for bpf patches.
> >
>
> I'll make sure to have it included next time.
>
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> >
> > Acked-by: Song Liu <songliubraving@fb.com>
> >
> > With a nit below.
> >
> > [...]
> >
> > > diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
> > > index a3596b617c4c..29ade7caf841 100644
> > > --- a/samples/bpf/xdp_adjust_tail_user.c
> > > +++ b/samples/bpf/xdp_adjust_tail_user.c
> > > @@ -72,6 +72,7 @@ static void usage(const char *cmd)
> > >         printf("Usage: %s [...]\n", cmd);
> > >         printf("    -i <ifname|ifindex> Interface\n");
> > >         printf("    -T <stop-after-X-seconds> Default: 0 (forever)\n");
> > > +       printf("    -P <MAX_PCKT_SIZE> Default: 600\n");
> >
> > nit: printf("    -P <MAX_PCKT_SIZE> Default: %u\n", MAX_PCKT_SIZE);
>
> With all due respect, I'm afraid that MAX_PCKT_SIZE constant is only
> defined at '_kern.c'.
> Are you saying that it should be defined at '_user.c' either?
>
> Thanks for the review!

Ping?
