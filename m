Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E582ABE8E
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbgKIOWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:22:33 -0500
Received: from mail-vi1eur05on2133.outbound.protection.outlook.com ([40.107.21.133]:12157
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730597AbgKIOWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 09:22:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/uxkSYT1F5Vzj9uGAKGbC0te3rK4C/CYstDbSwFEFzPpH177QL14wQoR4Iz5MkFlvaAva5xO6k+UBYSoknHHBQS06Snjg9JEdVHZUOl57FN2Ci6Zyq5+CfRhocmzZf7bRpa/DUfgOkc9ai8juSjd6FdUK5YKXdXmn2+cFNEBCpmUCGbUd2dSzC5n1+Pr5jRkZVXSNM60TtaBfVqdq2Z197Gr2pl4GAW+kgJh5BweIzmKag/cvXsDa4/lrQwWmZb1S3+iea932AYNE7z6lIAiiD6P6EtJA15PSN0Yvm8pXhZIENzVNSaWzrxxVBSmnDQaVWHr/GmDDkxY5au30jyaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2+TyTktIoMTQnW0gGbnmJvzD+AqFGI4SVb5ZcWC5oA=;
 b=KZZcCArE4332fhPpBiZr9/f6Js0S+SmutHGOPKE2CbpRUzI3pRl38EWuiwP5C3uUQP8SO+7+wRMKMxgC0AQ2LVUOad7GnllP7/o1oF216HDyS1/ohhs8nCfcDxx8CXdVMtmoxWIuXI9MC2ZSxhOEL7msOyXjfM1qa+bs6xN5FdY4mZ3mhGRcRgPMaHfHrJcNJ9j+Eev0agg4xep/spytQnPVLWe0iaa4KBIhl6cq+tzUho1YW9MAHBJErNpBGccfipxAztIbdV0YN0mDbom1+MI6YyurxTPPJe8dTcX7lcWB/7TkHJkmNJHpwVTr3HhLkKvNqheXqlHu6nk3XNlpwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2+TyTktIoMTQnW0gGbnmJvzD+AqFGI4SVb5ZcWC5oA=;
 b=La5RFabVMgsvW2qveEIIGd1na9Mif6JcPHm8pOYLeSmdAUmvCcJXAryrbDqHHA/bwc0tJjZMoFOeIl9iu6QHYIRBHoxom2p3oBhiUZ4+zwf8Pe6WnrZln0tGVUqekm3/2KkX1cGBChtJNSRiWKxF5NW7MNYyJljTJHGa6juGUZM=
Received: from VI1PR8303MB0080.EURPRD83.prod.outlook.com
 (2603:10a6:820:1b::23) by VI1PR83MB0255.EURPRD83.prod.outlook.com
 (2603:10a6:802:78::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.6; Mon, 9 Nov
 2020 14:22:28 +0000
Received: from VI1PR8303MB0080.EURPRD83.prod.outlook.com
 ([fe80::c857:1a78:d155:fc99]) by VI1PR8303MB0080.EURPRD83.prod.outlook.com
 ([fe80::c857:1a78:d155:fc99%10]) with mapi id 15.20.3564.021; Mon, 9 Nov 2020
 14:22:28 +0000
From:   Kevin Sheldrake <Kevin.Sheldrake@microsoft.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Ingo Molnar <mingo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        KP Singh <kpsingh@google.com>
Subject: RE: [EXTERNAL] Re: [PATCH bpf-next v2] Update perf ring buffer to
 prevent corruption
Thread-Topic: [EXTERNAL] Re: [PATCH bpf-next v2] Update perf ring buffer to
 prevent corruption
Thread-Index: AdazhoRkdBnwMDAdQOy79mWG/v7W4wAbYtCAAKXegAAABY/VcA==
Date:   Mon, 9 Nov 2020 14:22:28 +0000
Message-ID: <VI1PR8303MB0080D892288E0137AA585778FBEA0@VI1PR8303MB0080.EURPRD83.prod.outlook.com>
References: <VI1PR8303MB00802FE5D289E0D7BA95B7DDFBEE0@VI1PR8303MB0080.EURPRD83.prod.outlook.com>
 <CAADnVQLNdDn1jfyEAeKO17vXQiN+VKAvq+VFkY2G_pvSbaPjFA@mail.gmail.com>
 <20201109112908.GG2594@hirez.programming.kicks-ass.net>
In-Reply-To: <20201109112908.GG2594@hirez.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-11-09T14:22:26Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=df0b9947-2fe4-46a8-b2c2-544596a9bfdf;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [149.12.0.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cb0ac336-2df1-430a-65fa-08d884bae381
x-ms-traffictypediagnostic: VI1PR83MB0255:
x-microsoft-antispam-prvs: <VI1PR83MB0255CC3A3EF264E09D080036FBEA0@VI1PR83MB0255.EURPRD83.prod.outlook.com>
x-o365-sonar-daas-pilot: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0LZ7VdPGdFPI6b7EiYX2AsJ9D+Sa6t0Wi8sRwjhaBbg9yO7qLRXBWhRwtFX9dxjwkhIA4AlOboX+68m2QwCxeY9swknlVcEbx14mChYGgTaUuQDDNq5GntO6DB/fXCsgvISMXQOBBPadiyf3pRzAKPbW6xdCbdnHzAHewwyfj0Gf2XFhfwZUg3S+wVxB5EaEnzB01cyYW8dG0PzxmLECfayxV6PZu3/AVBOhPL0cHZE1CBVZBV5t2Amc0AW2dldn3ytFG/kpLEvjE+2miSX7cO6efVl0B9tDtNkhufDbHTnqwf9OaziFgpK+p0Z9FiVszJi9o69tmiuvOyHurv37mmnYaZaJzYKpa/sqA+z53Ye5t/vtdQI4uGUhap65W/Of9c2QouL6YFZKeH0LHoslew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR8303MB0080.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(64756008)(66556008)(7696005)(66476007)(8990500004)(2906002)(5660300002)(966005)(9686003)(55016002)(53546011)(186003)(478600001)(76116006)(6506007)(8676002)(26005)(110136005)(66946007)(54906003)(83380400001)(4326008)(33656002)(15650500001)(52536014)(82960400001)(82950400001)(10290500003)(8936002)(316002)(71200400001)(66446008)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YEABrab9svkHvoihLV39/jMkz91BcaQzkJI3mdtvmPG2SX1pIVjz/3aHECRvCkF8GZySpS4C3D7JIT14vbdEGAsLwbnFQYJuY43faxKAar164+KrMicCk1L5poq3WC5LdmeSo2+1J4W0oJfXLCMCrWL8U9QuDrk+P4FaHgY5I4VIXXoXSdP8Bymm30L7wxBMJaoj1J8jvI+VqHQOmp2z2HfHNT1Tdg7uEaoI4aB5YQ19aw/A4ixJRuYO97kNZAT1nSdnkuOF/THdIoXOeqJ6JtYgOi1J5qfs3zoJNWUqd7KkCflqxv5wk6y3jBJqajWkwdlw8D8OX4T+0kB6wGFSTLl+AES2RIRqZ13tJQlkHolQWLt5zkZ6AlXTL04l6tvdMapdGPCcwWQVqyMIuVsz4XjicqPAU5LPV1cJQ4aOr44i1WWNbpnxGR3jGuWa0Fw+oC4HvmSWu1eTgdFfdd4MyxNzgBjOEKQ2m/4ZyXRHQXV+O6YpNg51bhEo3eA27RyKc18LCBFkB0Qs8laQdnVyrsY07nLvuwwSP/mr8f/UgItkCajIjPrkaGmZegLbTjeYT2jfVW0XHiP6jTEAeMlVrzxbsKvpge+CC6n4I0PD+5dkVOqaKWaY2Jbo8ICK4ZqX6w0wO4hzzNFSV729F0oBXkCFBSbo5aE01+gmqL680zu3gCq3edBJrstarJqGvWv3zTMTge5uEI8XhO6BepRK6sNBfpn2F8pHnMre04eyxUzqbKeD0qpmDGCx/1BC078Z8NUYL9QhxBr1tZcIThpqnQ0dAQmi8UY7jQ/l3HDbxGpFCpSjzeB3YonTy34kaXXJ9+0tG8mQMvy/rcsX1qmZZOuZVNWjB+IQk4ZywnnPOYw9+zk8SCdlJk6b1/XaJ/YCQhwtClc3Q2d78jRkyy6EZg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR8303MB0080.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb0ac336-2df1-430a-65fa-08d884bae381
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 14:22:28.5688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dCtHyR9nF/cepP5pa4Jlhz6y4flImqgm08Q/9qt7aKlYv0EvnTaAI/EIcyTBPtlJVnoSJU5zoXzwR5FtkZtRHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR83MB0255
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: 09 November 2020 11:29
> To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Kevin Sheldrake <Kevin.Sheldrake@microsoft.com>; Ingo Molnar
> <mingo@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; Network
> Development <netdev@vger.kernel.org>; bpf@vger.kernel.org; Andrii
> Nakryiko <andrii.nakryiko@gmail.com>; KP Singh <kpsingh@google.com>
> Subject: [EXTERNAL] Re: [PATCH bpf-next v2] Update perf ring buffer to
> prevent corruption
>=20
> On Thu, Nov 05, 2020 at 08:19:47PM -0800, Alexei Starovoitov wrote:
> > On Thu, Nov 5, 2020 at 7:18 AM Kevin Sheldrake
> > <Kevin.Sheldrake@microsoft.com> wrote:
> > >
> > > Resent due to some failure at my end.  Apologies if it arrives twice.
> > >
> > > From 63e34d4106b4dd767f9bfce951f8a35f14b52072 Mon Sep 17 00:00:00
> 2001
> > > From: Kevin Sheldrake <kevin.sheldrake@microsoft.com>
> > > Date: Thu, 5 Nov 2020 12:18:53 +0000
> > > Subject: [PATCH] Update perf ring buffer to prevent corruption from
> > >  bpf_perf_output_event()
> > >
> > > The bpf_perf_output_event() helper takes a sample size parameter of
> u64, but
> > > the underlying perf ring buffer uses a u16 internally. This 64KB maxi=
mum
> size
> > > has to also accommodate a variable sized header. Failure to observe t=
his
> > > restriction can result in corruption of the perf ring buffer as sampl=
es
> > > overlap.
> > >
> > > Track the sample size and return -E2BIG if too big to fit into the u1=
6
> > > size parameter.
> > >
> > > Signed-off-by: Kevin Sheldrake <kevin.sheldrake@microsoft.com>
> >
> > The fix makes sense to me.
> > Peter, Ingo,
> > should I take it through the bpf tree or you want to route via tip?
>=20
> What are you doing to trigger this? The Changelog is devoid of much
> useful information?

Hello

I triggered the corruption by sending samples larger than 64KB-24 bytes
to a perf ring buffer from eBPF using bpf_perf_event_output().  The u16
that holds the size in the struct perf_event_header is overflowed and
the distance between adjacent samples in the perf ring buffer is set
by this overflowed value; hence if samples of 64KB are sent, adjacent
samples are placed 24 bytes apart in the ring buffer, with the later ones
overwriting parts of the earlier ones.  If samples aren't read as quickly
as they are received, then they are corrupted by the time they are read.

Attempts to fix this in the eBPF verifier failed as the actual sample is
constructed from a variable sized header in addition to the raw data
supplied from eBPF.  The sample is constructed in perf_prepare_sample(),
outside of the eBPF engine.

My proposed fix is to check that the constructed size is <U16_MAX before
committing it to the struct perf_event_header::size variable.

A reproduction of the bug can be found at:
https://github.com/microsoft/OMS-Auditd-Plugin/tree/MSTIC-Research/ebpf_per=
f_output_poc

Thanks

Kevin Sheldrake

