Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961C94B6DF7
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238407AbiBONrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:47:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238410AbiBONru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:47:50 -0500
X-Greylist: delayed 1751 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 05:47:39 PST
Received: from mx0b-00206401.pphosted.com (mx0b-00206401.pphosted.com [IPv6:2620:100:9005:15::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08DDDF1E;
        Tue, 15 Feb 2022 05:47:39 -0800 (PST)
Received: from pps.filterd (m0093025.ppops.net [127.0.0.1])
        by mx0b-00206401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21F6ASAY007341;
        Tue, 15 Feb 2022 05:18:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=default;
 bh=W6yoCectmQ4/K1pbGPJHpv21JoEXJ3arKNE0Hupp2Xw=;
 b=sanZ+RdOXmw3cKi6YBpL5ctXoOo/8Kjnj9ShgxjmBzf8oQukPgYt84QrYa2vGfPrvfQB
 I/GMVqsY3gZmpbU3NvniOy3ZezsNvMJ4tm6g3py0ObX7Lo6Rw2Rkjm7uV0+tndNn3URc
 0B2/bZ8nib7uLcFlGlyLZIQkbkEsOkv9HIlR2qle1Mruq48bqu9XPXBquwHyTUm0PV9Q
 lJIdr3PdgHHx0QTGNcCgoS7nCEhIhY4hJu6f5SDbZyNkFwXaDDyAR2YidtP9cPbemvoc
 iCnK5qGH9zmvw1o0iIgDYy2ZJuj3WxIB9I3fOqFdLyXmUBXi49vE1cvUnSplTKebIYe/ OQ== 
Received: from 04wpexch03.crowdstrike.sys (dragosx.crowdstrike.com [208.42.231.60])
        by mx0b-00206401.pphosted.com (PPS) with ESMTPS id 3e86p38gnt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 05:18:03 -0800
Received: from 04wpexch04.crowdstrike.sys (10.100.11.94) by
 04wpexch03.crowdstrike.sys (10.100.11.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.20; Tue, 15 Feb 2022 13:18:01 +0000
Received: from 04wpexch04.crowdstrike.sys ([fe80::f066:b5c1:cf22:763a]) by
 04wpexch04.crowdstrike.sys ([fe80::f066:b5c1:cf22:763a%5]) with mapi id
 15.02.0922.020; Tue, 15 Feb 2022 13:18:01 +0000
From:   Marco Vedovati <marco.vedovati@crowdstrike.com>
To:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Martin Kelly <martin.kelly@crowdstrike.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Andrii Nakryiko" <andrii@kernel.org>
Subject: Clarifications on linux/types.h used with libbpf
Thread-Topic: Clarifications on linux/types.h used with libbpf
Thread-Index: AQHYImtWLXmUZLJvoESUDAAgE80rXqyUlyIa
Date:   Tue, 15 Feb 2022 13:18:01 +0000
Message-ID: <7cc5e02742da482b9daf06ffe3218262@crowdstrike.com>
References: <7b2e447f6ae34022a56158fcbf8dc890@crowdstrike.com>
In-Reply-To: <7b2e447f6ae34022a56158fcbf8dc890@crowdstrike.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.100.11.84]
x-disclaimer: USA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(resending as my first email was sent without ml subscription)
Hi,

I have few questions about the linux/types.h file used to build bpf
applications. This file gets included by both userspace applications using
libbpf and by bpf programs. E.g., in a userspace application:
foo.c
=A0 foo.skel.h
=A0=A0=A0 bpf/libbpf.h
=A0=A0=A0=A0=A0 linux/bpf.h
=A0=A0=A0=A0=A0=A0=A0 linux/types.h

Or in a bpf program:
foo.bpf.c
=A0 linux/bpf.h
=A0=A0=A0 linux/types.h

libbpf provides its own copy of this file in include/linux/types.h.
As I could understand from the Git history, it was initially copied from
linux include/linux/types.h, but it is now maintained separately.

Both linux bpftool and bpf selftests however are built using another
types.h from tools/include/uapi/linux/types.h.
Is there a reason why bpftool and selftests aren't built using the same
types.h distributed by libbpf?

I also see that the license of the three files differs:
- (libbpf) include/linux/types.h is "LGPL-2.1 OR BSD-2-Clause"
- (linux) include/linux/types.h is "GPL-2.0"
- (linux) tools/include/uapi/linux/types.h is "GPL-2.0"
Is there a reason why tools/include/uapi/linux/types.h isn't licensed as
"GPL-2.0 WITH Linux-syscall-note"?

Finally, would it make sense to also have libbpf use
tools/include/uapi/linux/types.h instead of its own copy?
The advantages would be:
- consistency with linux use
- the only architecture specific header included is "asm/bitsperlong.h",
=A0 instead of all the ones currently included.

Thanks,
Marco
