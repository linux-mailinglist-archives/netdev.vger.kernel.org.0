Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48921DD6B4
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgEUTJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729593AbgEUTJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:10 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A39C061A0E;
        Thu, 21 May 2020 12:09:10 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d10so3654647pgn.4;
        Thu, 21 May 2020 12:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Td9oRZ/EdU9EA9Q/tvPbh8QoTRGQgOI3SUK00wRHOzY=;
        b=P9banwXRqWG1JAT5ea/8Nc02r185ahUHVmv80yhvk8vAPvpV6UF5NdqKtU6L7GM0r/
         xq8qAN1SrqTsf4xqHWIIRw6qXrt7s0/0T7XveCnowQpgxsDufUNmbsZN1tSF1XugY7+o
         QvmDlex0uBIs/RSco8aNyaFbL8bVsQK//5vHKmelIFciRZFvPoCObgxkkRj3tDCaSDqz
         ug02zofY4QymEzD/+JYURSDroPPJo208F2nZ459v+hGzl4sn5mYtDCOPvqcqcxTC8rgI
         LQJn+Y/9dnS7eB9yfVqDVbDBqWdw4ZCAhSHDmpMIO/8PPFb76jJI8qeL/R74o73HaHoR
         WARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Td9oRZ/EdU9EA9Q/tvPbh8QoTRGQgOI3SUK00wRHOzY=;
        b=aGkl83vUmx48yNgBJLCFu2CV4gYw6Ogbau7TXgUl+yxxpAv39ONz3OLt6+0J4M2dIZ
         NdGGVUrI/4P1vMb+q5+A8mx3ojxd3TAClDQu6+4ETMKQIXj2faS9iDQA8hR/QIl0OqyI
         NWxSgcFJYF56LUpZ2YWz6vgkwxKdVZragmuFtHG/5T2BkSG2J4NKTut6ZC7A126eo8cg
         70t+rzu+WJb5Lz1Ua/csPGTSPcseni9TAKwuzRlTGFR0ilg/EzH1F3SFIiXQGLRHhZkv
         CmHbaSVEjBaK2Y0Id2qcXTC8zpqupbzi3qoNB2T0MueaxD8pOD4iACRMFyDwqz8QbTrF
         u3UQ==
X-Gm-Message-State: AOAM533K8IRyFw3gPrwXd3eK3ELEWvbeA8+B69g5qFATXXxdxXjmp8TV
        Q/l+BlqVjpOccFZvylPzi+o=
X-Google-Smtp-Source: ABdhPJxH8FchI7ZV9C5zJ3Zhrx0QI3+15KxXbrgNDvCgzVMQr1KGrpAIix9U1Aje3SlJAuR4OQC4kA==
X-Received: by 2002:a63:4b42:: with SMTP id k2mr9634101pgl.288.1590088150080;
        Thu, 21 May 2020 12:09:10 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i128sm5050221pfc.149.2020.05.21.12.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 12:09:09 -0700 (PDT)
Date:   Thu, 21 May 2020 12:09:01 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Networking <netdev@vger.kernel.org>
Message-ID: <5ec6d1cdbc900_7d832ae77617e5c0ce@john-XPS-13-9370.notmuch>
In-Reply-To: <5ec6d090627d0_75322ab85d4a45bcf6@john-XPS-13-9370.notmuch>
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
 <159007175735.10695.9639519610473734809.stgit@john-Precision-5820-Tower>
 <CAEf4BzZpZ5_Mn66h9a+VE0UtrXUcYdNe-Fj0zEvfDbhUG7Z=sw@mail.gmail.com>
 <5ec6d090627d0_75322ab85d4a45bcf6@john-XPS-13-9370.notmuch>
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

John Fastabend wrote:
> Andrii Nakryiko wrote:
> > On Thu, May 21, 2020 at 7:36 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > The test itself is not particularly useful but it encodes a common
> > > pattern we have.
> > >
> > > Namely do a sk storage lookup then depending on data here decide if
> > > we need to do more work or alternatively allow packet to PASS. Then
> > > if we need to do more work consult task_struct for more information
> > > about the running task. Finally based on this additional information
> > > drop or pass the data. In this case the suspicious check is not so
> > > realisitic but it encodes the general pattern and uses the helpers
> > > so we test the workflow.
> > >
> > > This is a load test to ensure verifier correctly handles this case.
> > >
> > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > ---

[...]

> > > +static void test_skmsg_helpers(enum bpf_map_type map_type)
> > > +{
> > > +       struct test_skmsg_load_helpers *skel;
> > > +       int err, map, verdict;
> > > +
> > > +       skel = test_skmsg_load_helpers__open_and_load();
> > > +       if (!skel) {
> > > +               FAIL("skeleton open/load failed");
> > > +               return;
> > > +       }
> > > +
> > > +       verdict = bpf_program__fd(skel->progs.prog_msg_verdict);
> > > +       map = bpf_map__fd(skel->maps.sock_map);
> > > +
> > > +       err = xbpf_prog_attach(verdict, map, BPF_SK_MSG_VERDICT, 0);
> > > +       if (err)
> > > +               return;
> > > +       xbpf_prog_detach2(verdict, map, BPF_SK_MSG_VERDICT);
> > 
> > no cleanup in this test, at all
> 
> Guess we need __destroy(skel) here.
> 
> As an aside how come if the program closes and refcnt drops the entire
> thing isn't destroyed. I didn't think there was any pinning happening
> in the __open_and_load piece.

I guess these are in progs_test so we can't leave these around for
any following tests to trip over. OK. Same thing for patch 3 fwiw.
