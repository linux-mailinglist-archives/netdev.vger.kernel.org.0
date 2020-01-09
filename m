Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60AA13525E
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 06:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgAIFFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 00:05:04 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35625 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgAIFFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 00:05:03 -0500
Received: by mail-qt1-f195.google.com with SMTP id e12so4906008qto.2;
        Wed, 08 Jan 2020 21:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WO1xlXl3G5txspw5Zxg8/vsaEoLUt4YPZhmg0QyQivs=;
        b=RLxfFQ7M/T/ZbCqjir4TBUzKYBgg9YWFAKi8hd4yzJxvqnk7aX11giNLdOb4yiA+s2
         L2nN0f0o4/PGN66tzr40QzxTwXEY3Cpli72JymeHheikmKqpT1qvDahqKF9ZX0/ggRu/
         JRSU0KUHW8DK4LJIZRbM8fI/QSClcwdis1Zu6kQvhjjVNRRzgMwPMD2ePdmEz6ME30hL
         oDblcQPe4bh6je+CvppjP/rho4FV830S5SSRkxUFS23yO2GvgUHbMLkmv8P6/Y8aAs2n
         oHjP//U6IxCZbdkR/uAPg4EmFISeNl1OR2VoiGigO4x3fRysQVYI38mRTostN6WOaPHY
         O7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WO1xlXl3G5txspw5Zxg8/vsaEoLUt4YPZhmg0QyQivs=;
        b=B3xUpLRT9i01M+JEn/ymLXZyiLDo2Tlpv0g4uuAkolf0Dx+uCSTmbdn8P8gcY5cqQx
         7t3BoRDOUM30zq0ad2GyGKav6EkL2pe0tQUZzXUFguHqK/Kc8HYqY7JG5jiwaPmcZl76
         4QunlSJ2lB606Y9S4Cu60mZCcEp+DKsHz9n5fAC4gItexTaux7mXZ6ie/CFjUKt8J7Aa
         vETRzS3/A2QG573iJ9n0gs+ZfMMiKfJ6Q8PjxQrWxucYJ0K5G5GUdnUU2AAcEU6dEzyp
         Bw4TIT1Jd1KRLA2bOmoLHGB+Ti0AwD7V0zco1/p+eq6VZwSGIK2q45gKPirLCBD9KL9+
         EUFA==
X-Gm-Message-State: APjAAAWZBSdpQ5zqMATazJGufvEfkb+NoDnrFJC1ymRkDFd9GKuTfUoE
        3sXFfXEKfSfuisb1meR+I2dyaqoHpJnFw3MgN3s=
X-Google-Smtp-Source: APXvYqy1PyKYvW1h0mWCGJX++OryAXtuFYgYdjcjqp27sOiJ37F+M3jJQd9PEoG7OGiCitiVd90Etys+oCffX9UOuvI=
X-Received: by 2002:ac8:7b29:: with SMTP id l9mr6320386qtu.141.1578546302879;
 Wed, 08 Jan 2020 21:05:02 -0800 (PST)
MIME-Version: 1.0
References: <157675340354.60799.13351496736033615965.stgit@xdp-tutorial>
 <CAEf4BzYxDE5VoBiCaPwv=buUk87Cv0JF09usmQf0WvUceb8A5A@mail.gmail.com> <8F140E5A-2E29-4594-94BA-4D43B592A5B1@redhat.com>
In-Reply-To: <8F140E5A-2E29-4594-94BA-4D43B592A5B1@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Jan 2020 21:04:51 -0800
Message-ID: <CAEf4Bzb1pwv9a6pdY+Tjb17O-7YXhyRe3=nZuujoM5zjgq4SBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Add a test for attaching a bpf
 fentry/fexit trace to an XDP program
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 2, 2020 at 6:13 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
>
>
> On 20 Dec 2019, at 0:02, Andrii Nakryiko wrote:
>
> > On Thu, Dec 19, 2019 at 3:04 AM Eelco Chaudron <echaudro@redhat.com>
> > wrote:
> >>
> >> Add a test that will attach a FENTRY and FEXIT program to the XDP
> >> test
> >> program. It will also verify data from the XDP context on FENTRY and
> >> verifies the return code on exit.
> >>
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> ---
> >>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   95
> >> ++++++++++++++++++++
> >>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   44 +++++++++
> >>  2 files changed, 139 insertions(+)
> >>  create mode 100644
> >> tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> >>  create mode 100644
> >> tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> >>
> >
> > [...]
> >
> >> +       /* Load XDP program to introspect */
> >> +       err =3D bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd)=
;
> >
> > Please use BPF skeleton for this test. It will make it significantly
> > shorter and clearer. See other fentry_fexit selftest for example.
> >
>
> Trying to do this, however, I=E2=80=99m getting the following when trying=
 to
> execute the test:
>
> test_xdp_bpf2bpf:PASS:pkt_skel_load 0 nsec
> libbpf: fentry/_xdp_tx_iptunnel is not found in vmlinux BTF
> libbpf: failed to load object 'test_xdp_bpf2bpf'
> libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -2
> test_xdp_bpf2bpf:FAIL:ftrace_skel_load ftrace skeleton failed
>
>
> My program is straight forward following the fentry_fexit.c example:
>
>      pkt_skel =3D test_xdp__open_and_load()
>      if (CHECK(!pkt_skel, "pkt_skel_load", "test_xdp skeleton
> failed\n"))
>          return;
>
>      map_fd =3D bpf_map__fd(pkt_skel->maps.vip2tnl);
>      bpf_map_update_elem(map_fd, &key4, &value4, 0);
>
>      /* Load eBPF trace program */
>      ftrace_skel =3D test_xdp_bpf2bpf__open_and_load();
>      if (CHECK(!ftrace_skel, "ftrace_skel_load", "ftrace skeleton
> failed\n"))
>          goto out;
>
> I assume this is due to the missing link from the XDP program to the
> eBPF trace program.

yes, exactly

> Previously I did this trough:
>
> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
> +                           .attach_prog_fd =3D prog_fd,
> +                          );
> +
> +       tracer_obj =3D bpf_object__open_file("./test_xdp_bpf2bpf.o", &opt=
s);
>
>
> If I use this approach as before it works, i.e.:
>
>          DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
>                              .attach_prog_fd =3D pkt_fd,
>                             );
>
>          ftrace_skel =3D test_xdp_bpf2bpf__open_opts(&opts);
>          if (CHECK(!ftrace_skel, "__open_opts=E2=80=9D, "ftrace skeleton
> failed\n"))
>            goto out;
>          if (CHECK(test_xdp_bpf2bpf__load(ftrace_skel), "__load",
> "ftrace skeleton failed\n"))
>            goto out;
>
> But I do not see this in the fentry_fexit.c example, guess I might be
> missing something that is right in front of me :(

you are not missing anything, and this second variant is what you have
to do. __open_and_load() is just an convenience wrapper around
separate __open() followed by __load(), for cases where user doesn't
have to specify any extra options.

>
>
> [...]
>
