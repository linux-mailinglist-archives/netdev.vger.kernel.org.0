Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D301DD690
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgEUTDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbgEUTDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:03:52 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1951C061A0E;
        Thu, 21 May 2020 12:03:52 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d3so3249699pln.1;
        Thu, 21 May 2020 12:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=YG/Rd93DgDyZiJme5K9Qkk13z1FQo+t3Cuv8eEz4qLg=;
        b=Pq8e21/qB0ru0tBwkmJD0CtlecIvnV97VErj/kiCdcrq3kb4Zkx79jGEMOVAMCvlaH
         mUUQkdVz0ZZ+qjETJ+JBVOlxt1qv4mi7lwh42YywcZDUtfhFTX3Xob49LRVSu43lJNjz
         Nwn2NYGpYti+7Nhrec6Rse7rT0G2Ph23YEKUki2JI9kJzC78DKFKYmIED9gz0eTqXk/Y
         DXnT8aXeBkd/PKSWi0JHPsEY5zEjV/N2/oJ4i+eThSVM9Pcw12kHhDPrJtosyFnbkrTX
         /A8UJuU9rWDoERDenP9DmNS2y7CA0ylchw2G2W3p+KCZbN5WUUdr2hAstLRodqgePG+u
         mNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=YG/Rd93DgDyZiJme5K9Qkk13z1FQo+t3Cuv8eEz4qLg=;
        b=L27wAc9lRKnZrkx8rC+wXvylZb85tBbENKU1pRQ/Tbyt2LPEcfXIMPBr6AQCNJnM1X
         PvLZMHln2Vsyon5hcwjorD2yydm5CbcwLM+ja2Vsa5nlfvDKPiUIxfTbgahJDJfB0g2P
         rYd5VAcLQvz8Tpoh0mHHkemKuF84F+QaT9qzn0Qsiz/beBQt2WSbCkKLDcY9jpJJmlWO
         WJqdV1mzXpeOg8NL0TpYeui5xNqqZHDcRQrHX8sM8ejn+qt1oJQWowHhIBImIYov0R5u
         /R7aWIe5B9Bvb/x6RnR5IEJokUNDLneLuVuYrMwYBiU66AeI9yKq5Z6Mxot8+lKXJyGR
         sIAw==
X-Gm-Message-State: AOAM530YnDxRl574FXVz+Jit12Sbm9Tcb3FoY+ORYnGlpQSBh/Cl3OyQ
        /D8ymAokUc4lXHOx58cZMyc=
X-Google-Smtp-Source: ABdhPJywlixTcd/UxFpQF2whwi4YKPT1oJHNUzVMfq5eLzyBsy12LYWlMEHFG/jELHG08mEP1iSx4Q==
X-Received: by 2002:a17:902:9004:: with SMTP id a4mr10990473plp.126.1590087832140;
        Thu, 21 May 2020 12:03:52 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id gg8sm5012470pjb.39.2020.05.21.12.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 12:03:51 -0700 (PDT)
Date:   Thu, 21 May 2020 12:03:44 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Networking <netdev@vger.kernel.org>
Message-ID: <5ec6d090627d0_75322ab85d4a45bcf6@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzZpZ5_Mn66h9a+VE0UtrXUcYdNe-Fj0zEvfDbhUG7Z=sw@mail.gmail.com>
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
 <159007175735.10695.9639519610473734809.stgit@john-Precision-5820-Tower>
 <CAEf4BzZpZ5_Mn66h9a+VE0UtrXUcYdNe-Fj0zEvfDbhUG7Z=sw@mail.gmail.com>
Subject: Re: [bpf-next PATCH v3 4/5] bpf: selftests, add sk_msg helpers load
 and attach test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Thu, May 21, 2020 at 7:36 AM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > The test itself is not particularly useful but it encodes a common
> > pattern we have.
> >
> > Namely do a sk storage lookup then depending on data here decide if
> > we need to do more work or alternatively allow packet to PASS. Then
> > if we need to do more work consult task_struct for more information
> > about the running task. Finally based on this additional information
> > drop or pass the data. In this case the suspicious check is not so
> > realisitic but it encodes the general pattern and uses the helpers
> > so we test the workflow.
> >
> > This is a load test to ensure verifier correctly handles this case.
> >
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  .../selftests/bpf/prog_tests/sockmap_basic.c       |   57 ++++++++++++++++++++
> >  .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   48 +++++++++++++++++
> >  2 files changed, 105 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > index aa43e0b..cacb4ad 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > @@ -1,13 +1,46 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  // Copyright (c) 2020 Cloudflare
> > +#include <error.h>
> >
> >  #include "test_progs.h"
> > +#include "test_skmsg_load_helpers.skel.h"
> >
> >  #define TCP_REPAIR             19      /* TCP sock is under repair right now */
> >
> >  #define TCP_REPAIR_ON          1
> >  #define TCP_REPAIR_OFF_NO_WP   -1      /* Turn off without window probes */
> >
> > +#define _FAIL(errnum, fmt...)                                                  \
> > +       ({                                                                     \
> > +               error_at_line(0, (errnum), __func__, __LINE__, fmt);           \
> > +               CHECK_FAIL(true);                                              \
> > +       })
> > +#define FAIL(fmt...) _FAIL(0, fmt)
> > +#define FAIL_ERRNO(fmt...) _FAIL(errno, fmt)
> > +#define FAIL_LIBBPF(err, msg)                                                  \
> > +       ({                                                                     \
> > +               char __buf[MAX_STRERR_LEN];                                    \
> > +               libbpf_strerror((err), __buf, sizeof(__buf));                  \
> > +               FAIL("%s: %s", (msg), __buf);                                  \
> > +       })
> > +
> > +#define xbpf_prog_attach(prog, target, type, flags)                            \
> > +       ({                                                                     \
> > +               int __ret =                                                    \
> > +                       bpf_prog_attach((prog), (target), (type), (flags));    \
> > +               if (__ret == -1)                                               \
> > +                       FAIL_ERRNO("prog_attach(" #type ")");                  \
> > +               __ret;                                                         \
> > +       })
> > +
> > +#define xbpf_prog_detach2(prog, target, type)                                  \
> > +       ({                                                                     \
> > +               int __ret = bpf_prog_detach2((prog), (target), (type));        \
> > +               if (__ret == -1)                                               \
> > +                       FAIL_ERRNO("prog_detach2(" #type ")");                 \
> > +               __ret;                                                         \
> > +       })
> 
> I'm not convinced we need these macro, can you please just use CHECKs?
> I'd rather not learn each specific test's custom macros.

Will just remove the entire block above.

> 
> > +
> >  static int connected_socket_v4(void)
> >  {
> >         struct sockaddr_in addr = {
> > @@ -70,10 +103,34 @@ static void test_sockmap_create_update_free(enum bpf_map_type map_type)
> >         close(s);
> >  }
> >
> > +static void test_skmsg_helpers(enum bpf_map_type map_type)
> > +{
> > +       struct test_skmsg_load_helpers *skel;
> > +       int err, map, verdict;
> > +
> > +       skel = test_skmsg_load_helpers__open_and_load();
> > +       if (!skel) {
> > +               FAIL("skeleton open/load failed");
> > +               return;
> > +       }
> > +
> > +       verdict = bpf_program__fd(skel->progs.prog_msg_verdict);
> > +       map = bpf_map__fd(skel->maps.sock_map);
> > +
> > +       err = xbpf_prog_attach(verdict, map, BPF_SK_MSG_VERDICT, 0);
> > +       if (err)
> > +               return;
> > +       xbpf_prog_detach2(verdict, map, BPF_SK_MSG_VERDICT);
> 
> no cleanup in this test, at all

Guess we need __destroy(skel) here.

As an aside how come if the program closes and refcnt drops the entire
thing isn't destroyed. I didn't think there was any pinning happening
in the __open_and_load piece.

> 
> > +}
> > +
> 
> [...]
> 
> > +
> > +int _version SEC("version") = 1;
> 
> version not needed
> 
> > +char _license[] SEC("license") = "GPL";
> >


