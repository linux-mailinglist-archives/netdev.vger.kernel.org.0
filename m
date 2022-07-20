Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4638D57BE07
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiGTSqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiGTSqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:46:00 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA8ED12F;
        Wed, 20 Jul 2022 11:45:59 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id e69so7473909iof.5;
        Wed, 20 Jul 2022 11:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2LK8F5ZSsPnBcm/4jB4pma/7mcqTjmwHh+wdqzoUzzg=;
        b=ZYskmkp8G6g54cRNXo+nJkNAMDyvNzRm9SNiqr3hDz/CSIGZtgkOaTEwqpKvj0ZLsz
         mRMZ07I4v8FCG2lqlJemyZildX2xKShjeBMTYEUz72GEPcldfuOebVOCsSeTqWGv0UjK
         1oRb7Beb+TJK1Otg35hUNcigLxFUmZG0p9Pv/sDtUEzo8is1Yk2s2J1EmIWExv/CHum6
         ACXKzokYxmEbL6XzE0FooOIRLMwa6NLxWXhTl6W7BErf9PVSr2HzY9YkOvxI7aTnnHdv
         XLR7XAPRsRPMvmaCVnO0LdfVE8OB98zk6yLEdjHf1myupfFxB7r+gLRVnTRcEmzupuTH
         5CjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2LK8F5ZSsPnBcm/4jB4pma/7mcqTjmwHh+wdqzoUzzg=;
        b=FmZe+ADMUb1PTLmyNnNR3y4hd7TbltR80d8J3P1geFCzIT2BaET88oehcmG8MbxEZ8
         UIVRSjckLPNpjxLlBqBdt4Z07zZlfIzuTIx73jXOBjcXjNI5xI6AUWBwcRU/NPwe5OZU
         Ozgf6IwdVcsS3W5FuK8+ZJjLEgWwEKclh6NrjeNiutEhK45wH2tfJppAIpbr3BpiF7Ms
         MMM+Ymi/Rw3CpI2JjtQwKCtpLApl9qRPF/eut42RGjKd/mgq/lcxUb9u2Z2ZdKGrzcs3
         oKlaqxqeQU207zTwJMfluu089cxeGD6M68ZuQSi898GjW3HbDKj4EN1FWpkP96lVwbab
         gTZA==
X-Gm-Message-State: AJIora+aTzeUp7GgWkaDFYiCSrOT0Gm2tS4ixkQNV2UphRLFp7ri5gH5
        FbsNPAzlTf1orvwqLC7I6U7lJYTg7DUCZlsnqgM=
X-Google-Smtp-Source: AGRyM1tPLOik40B2XMaikpgoLKIvDQbQMLVJdaaHPVcFrSW8KatIfHNapYYuttC1//FXHe6x1a7KTOTI7ABXvJTITtI=
X-Received: by 2002:a05:6602:150c:b0:67c:149b:a349 with SMTP id
 g12-20020a056602150c00b0067c149ba349mr7261371iow.168.1658342759251; Wed, 20
 Jul 2022 11:45:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220719132430.19993-1-memxor@gmail.com> <20220719132430.19993-6-memxor@gmail.com>
 <878ronu35z.fsf@toke.dk>
In-Reply-To: <878ronu35z.fsf@toke.dk>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 20 Jul 2022 20:45:23 +0200
Message-ID: <CAP01T77j2Lm7RgKoi0XwgpX_vLgoO1Lfr1E9mxYMVxCGM9L9Cg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 05/13] bpf: Add documentation for kfuncs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, KP Singh <kpsingh@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jul 2022 at 19:03, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>
> > As the usage of kfuncs grows, we are starting to form consensus on the
> > kinds of attributes and annotations that kfuncs can have. To better hel=
p
> > developers make sense of the various options available at their disposa=
l
> > to present an unstable API to the BPF users, document the various kfunc
> > flags and annotations, their expected usage, and explain the process of
> > defining and registering a kfunc set.
>
> [...]
>
> > +2.4.2 KF_RET_NULL flag
> > +----------------------
> > +
> > +The KF_RET_NULL flag is used to indicate that the pointer returned by =
the kfunc
> > +may be NULL. Hence, it forces the user to do a NULL check on the point=
er
> > +returned from the kfunc before making use of it (dereferencing or pass=
ing to
> > +another helper). This flag is often used in pairing with KF_ACQUIRE fl=
ag, but
> > +both are mutually exclusive.
>
> That last sentence is contradicting itself. "Mutually exclusive" means
> "can't be used together". I think you mean "orthogonal" or something to
> that effect?

Right, my bad. Mutually exclusive is totally incorrect here. I will
use 'orthogonal' instead.

>
> -Toke
>
