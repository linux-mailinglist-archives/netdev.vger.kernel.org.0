Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B79E4C1D02
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 21:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240829AbiBWUTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 15:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiBWUTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 15:19:08 -0500
Received: from mx0b-00206401.pphosted.com (mx0a-00206401.pphosted.com [IPv6:2620:100:9001:15::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8220A4CD71;
        Wed, 23 Feb 2022 12:18:40 -0800 (PST)
Received: from pps.filterd (m0092946.ppops.net [127.0.0.1])
        by mx0a-00206401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21NFSeZH027308;
        Wed, 23 Feb 2022 12:18:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com; h=from : to : cc :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version : subject; s=default;
 bh=IomlPTfU5BRb/hM1CUTtNQ+6rpQUrWes54NVYKcz8kA=;
 b=yVmyv7gExK1jXWHkRvzyZoQoW/w7OrmuMXJ2MtqoFdHuJxToq5Q5G+oPJGcmDxyd0BhA
 PvZmEtJL8Im2btKdiE6OS3b2ZFTbpB220e0FqPqoPLxkQSvzZ9Cb8j8L3bmAmbjNGag2
 8XmWiluhuXXyHmp/ri8Eapy3fFRqaj0m0hajW2xOoW+k5A/8ZfvPUHOCexI+1E3JVNfl
 lVG+MUuu/zxffVgiZr2VkxGKdbjAIHsWH+TqaqMefPkxPL/QeXfHyfTrjK+uBWah0KlJ
 35OIKYG0rknnhZKl840ZVppZLgDH1LBO9y0tOtwdTfLqN+BFA1bssmf6ZyFxo3xRR0TR UA== 
Received: from 04wpexch03.crowdstrike.sys (dragosx.crowdstrike.com [208.42.231.60])
        by mx0a-00206401.pphosted.com (PPS) with ESMTPS id 3ed5279u9x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 12:18:11 -0800
Received: from 04wpexch04.crowdstrike.sys (10.100.11.94) by
 04wpexch03.crowdstrike.sys (10.100.11.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.20; Wed, 23 Feb 2022 20:18:10 +0000
Received: from 04wpexch04.crowdstrike.sys ([fe80::f066:b5c1:cf22:763a]) by
 04wpexch04.crowdstrike.sys ([fe80::f066:b5c1:cf22:763a%5]) with mapi id
 15.02.0922.020; Wed, 23 Feb 2022 20:18:10 +0000
From:   Marco Vedovati <marco.vedovati@crowdstrike.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Martin Kelly <martin.kelly@crowdstrike.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>
Thread-Topic: [External] Re: Clarifications on linux/types.h used with libbpf
Thread-Index: AQHYImtWLXmUZLJvoESUDAAgE80rXqyYUPmAgAlMbQA=
Date:   Wed, 23 Feb 2022 20:18:09 +0000
Message-ID: <35873e0695014029a290ceb8cc767a7d@crowdstrike.com>
References: <7b2e447f6ae34022a56158fcbf8dc890@crowdstrike.com>,<CAEf4BzbB6O=PRS7eDAszsVYEjxiTdR6g9XXSS4YDRh8e4Bgo0w@mail.gmail.com>
In-Reply-To: <CAEf4BzbB6O=PRS7eDAszsVYEjxiTdR6g9XXSS4YDRh8e4Bgo0w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.100.11.84]
x-disclaimer: USA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject:  Re: Clarifications on linux/types.h used with libbpf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_09,2022-02-23_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Sent: Thursday, February 17, 2022 11:08 PM
To: Marco Vedovati
Cc: bpf@vger.kernel.org; toke@redhat.com; netdev@vger.kernel.org; kernel-te=
am@fb.com; Martin Kelly; ast@kernel.org; daniel@iogearbox.net; davem@daveml=
oft.net; Andrii Nakryiko
Subject: [External] Re: Clarifications on linux/types.h used with libbpf
=A0  =20
> On Tue, Feb 15, 2022 at 4:58 AM Marco Vedovati
> <marco.vedovati@crowdstrike.com> wrote:
> >
> > Hi,
> >
> > I have few questions about the linux/types.h file used to build bpf
> [cut]=20
>=20
>=20
> include/uapi/linux/types.h (UAPI header) is different from
> include/linux/types.h (kernel-internal header). Libbpf has to
> reimplement minimum amount of declarations from kernel-internal
> include/linux/types.h to build outside of the kernel. But short answer
> is they are different headers, so I suspect that no, libbpf can't use
> just UAPI version.

Thank you for clarifying some of my confusions.

So if I understood correctly, the only use of libbpf:include/linux/types.h
is to allow building the library out of the kernel tree.

An ambiguity I have found is about what version of linux/types.h to use=20
use when building bpf source code (that includes <linux/bpf.h>).=20
I saw 2 options:

- do like libbpf-bootstrap C examples, that uses whatever linux/types.h
  version available on the building host. This is however adding more
  dependencies that are satisfied with extra "-idirafter" compiler options.

- do like bpftool's makefile, that builds bpf source code by including
  tools/include/uapi/. This does not require the "-idirafter" trick.

Anyway, checking the history of "tools/include/uapi/linux/types.h", I
believe that this file is mistakenly licensed as "GPL-2.0" instead of
"GPL-2.0 WITH Linux-syscall-note". I may come up with a patch to fix it.

>
> Thanks,
> Marco
    =
