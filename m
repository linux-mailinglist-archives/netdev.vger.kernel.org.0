Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8889A518E2
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbfFXQme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:42:34 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38618 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfFXQmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:42:33 -0400
Received: by mail-qk1-f193.google.com with SMTP id a27so10235253qkk.5
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=56fsD3uh2/oJOv295hzKeLKxP6K7wvEdlnvDetuC6aY=;
        b=O6M211dZrSAzEdXidaUavRvYbBoZZSWPmW2pt4RtwxpPsE3Op/jYeELqTZ6dAB9stj
         PLgb917DEbj+kmnPuGM2GU3VagFQMI1K/I4KFgKW4JqVydIdt7kyqG07qw5vds8DDNmR
         +v4ei5h/KzuaxaDbWCBXvO+uRfTDOSFvcZcVdK+xQE+nXmOOfBEhGlNDfL4WmoljF8QQ
         W8aEqsM6CF0krvHLYfh20yGh36kceahX2S7oeHtlUVRn4PUFE+sejNyc5oFuPqL6OrJd
         2ic4ErMXjePn1kU1ZXNZF+hcFX4vQ99gaHibKRdBrokjncZLXjsU0i+hjq/AwIp7/f7D
         RWkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=56fsD3uh2/oJOv295hzKeLKxP6K7wvEdlnvDetuC6aY=;
        b=Jlbb3uy/3YJ6KwmV74wzVCnOw+kKP871xquiBC7Trh6n+rgDCMnAqJkLtwuy5wKSwZ
         +ynJ016KuTrqHOz6oON5aw+2JMNYGnqeQ9BuJcEeQ1wgrpTpPWacKmr6CzPtiAUcMNUe
         XsyljIOFfzuOAGFT19bIdaDi+HkW01LKKeyeQ6p0o8CmhUyWsL+llngn/92qyx7MTGKL
         6keITGPQ0Y0V6mgL4XHKidCQjy9YbEoTithYN65JH/r2grgTqFqY+k+ITAtmxm/xYiv4
         pEEazr9OVOV0nPpvOjlEe8ik3M/pTN53pNLo4dTZu/wBigTrTkp8AgacVnm722mMIikQ
         IhhA==
X-Gm-Message-State: APjAAAVSIzd/PxAZ0zI5AOKaYq5/BP1+oaOkl5fo83x9oaXt6N2rVzQC
        SZaMPv4tdBwjnh40oGgyK4u7xnUTI7nFadJtDdCzSSPS
X-Google-Smtp-Source: APXvYqxjmtQe3NnztJoDK3y4lBwkITTFkJ+X7PQr/2c7Dq9dwItl9tYsqHS7LA0grMX3X8lz8s37sYpfGbvDP7FpmIA=
X-Received: by 2002:a37:a095:: with SMTP id j143mr18691914qke.449.1561394552831;
 Mon, 24 Jun 2019 09:42:32 -0700 (PDT)
MIME-Version: 1.0
References: <49d3ddb42f531618584f60c740d9469e5406e114.1561130674.git.echaudro@redhat.com>
 <CAEf4BzZsmH+4A0dADeXYUDqeEK9N_-PVqzHW_=vPytjEX1hqTA@mail.gmail.com> <1C59E98E-7F4B-4FCA-AB95-68D3819C489C@redhat.com>
In-Reply-To: <1C59E98E-7F4B-4FCA-AB95-68D3819C489C@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 Jun 2019 09:42:21 -0700
Message-ID: <CAEf4Bzb7A5abJaxxrS5sudCE=Ca0C9rY0B23OjK8c2RCCx=Y6g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add xsk_ring_prod__free() function
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 2:37 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
>
>
> On 21 Jun 2019, at 21:13, Andrii Nakryiko wrote:
>
> > On Fri, Jun 21, 2019 at 8:26 AM Eelco Chaudron <echaudro@redhat.com>
> > wrote:
> >>
> >> When an AF_XDP application received X packets, it does not mean X
> >> frames can be stuffed into the producer ring. To make it easier for
> >> AF_XDP applications this API allows them to check how many frames can
> >> be added into the ring.
> >>
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> ---
> >>  tools/lib/bpf/xsk.h | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> >> index 82ea71a0f3ec..86f3d485e957 100644
> >> --- a/tools/lib/bpf/xsk.h
> >> +++ b/tools/lib/bpf/xsk.h
> >> @@ -95,6 +95,12 @@ static inline __u32 xsk_prod_nb_free(struct
> >> xsk_ring_prod *r, __u32 nb)
> >>         return r->cached_cons - r->cached_prod;
> >>  }
> >>
> >> +static inline __u32 xsk_ring_prod__free(struct xsk_ring_prod *r)
> >
> > This is a very bad name choice. __free is used for functions that free
> > memory and resources. One function below I see avail is used in the
> > name, why not xsk_ring_prog__avail?
>
> Must agree that free sound like you are freeing entries=E2=80=A6 However,=
 I
> just kept the naming already in the API/file (see above,
> xsk_prod_nb_free()).
> Reading the code there is a difference as xx_avail() means available
> filled entries, where xx_free() means available free entries.
>
> So I could rename it to xsk_ring_prod__nb_free() maybe?

I'm fine with __nb_free, yes. Thanks!


>
> Forgot to include Magnus in the email, so copied him in, for some
> comments.
>
> >> +{
> >> +       r->cached_cons =3D *r->consumer + r->size;
> >> +       return r->cached_cons - r->cached_prod;
> >> +}
> >> +
> >>  static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32
> >> nb)
> >>  {
> >>         __u32 entries =3D r->cached_prod - r->cached_cons;
> >> --
> >> 2.20.1
> >>
