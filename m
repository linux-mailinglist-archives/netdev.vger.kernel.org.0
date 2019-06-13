Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF4344B50
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbfFMSyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:54:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47406 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729912AbfFMSyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 14:54:20 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DIrAPs025708;
        Thu, 13 Jun 2019 11:53:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NEehnZ1oq7kg2L6cSc/HoK45yjZHjvSHo8LIXLt/OtM=;
 b=Nc52KPJIrTrhZ/1VnwQkfnWjQoezhsMLxzg5iL0dbLWWknS4o6MwiDQ1JbJ+XHtx1gqS
 6I3tg9plCqtHge7RFYlP7zMhj2iDhe6IqN/cGQVyhcG9QX67yL9Z4QGm5xunDDZP5LLs
 jNJo2DCQwMkbXSli3Mf2HSKwW9Z7mB84P0M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3pr5h9ey-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 13 Jun 2019 11:53:13 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 13 Jun 2019 11:52:26 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 13 Jun 2019 11:52:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEehnZ1oq7kg2L6cSc/HoK45yjZHjvSHo8LIXLt/OtM=;
 b=IamdkZ2L01wgLNfPdRRKRmuzcca5Gm4uCD0cC9LJGgyip13uCiiRVzPRPsyyqL+JiXKLCw0qoGkuD1CY4KPcjpugB08ItuYjpz3b9Y24uRAV5npcc1+x4SpwpP2DZ5pYhQnv6HbvzDPmD+AKhRLY3xuFt5AH2zGfWLkIY8hv1wo=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1840.namprd15.prod.outlook.com (10.174.99.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 18:52:24 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 18:52:24 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
CC:     X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 8/9] x86/bpf: Convert asm comments to AT&T syntax
Thread-Topic: [PATCH 8/9] x86/bpf: Convert asm comments to AT&T syntax
Thread-Index: AQHVIetLPIU2acwXW0W72I9U+7dGQaaZ7m6A
Date:   Thu, 13 Jun 2019 18:52:24 +0000
Message-ID: <E8372F56-269A-48A4-B80B-14FA664F8D41@fb.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <77fe02f7d575091b06f68f8eed256da94aee653f.1560431531.git.jpoimboe@redhat.com>
In-Reply-To: <77fe02f7d575091b06f68f8eed256da94aee653f.1560431531.git.jpoimboe@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::706c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: faf37a31-94d4-4cc3-8d90-08d6f030465c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1840;
x-ms-traffictypediagnostic: MWHPR15MB1840:
x-microsoft-antispam-prvs: <MWHPR15MB18402592C53DE3239DD4A23FB3EF0@MWHPR15MB1840.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(346002)(39860400002)(396003)(199004)(189003)(2906002)(86362001)(66556008)(102836004)(76176011)(6246003)(11346002)(476003)(2616005)(36756003)(186003)(64756008)(57306001)(53936002)(6506007)(6512007)(66946007)(66446008)(99286004)(66476007)(71190400001)(71200400001)(73956011)(53546011)(68736007)(76116006)(53946003)(6486002)(6436002)(256004)(25786009)(6916009)(50226002)(229853002)(6116002)(8676002)(81156014)(46003)(30864003)(81166006)(5660300002)(54906003)(14454004)(4326008)(316002)(446003)(478600001)(8936002)(7736002)(305945005)(486006)(14444005)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1840;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Jf8WGEnbw8KBuzr2u/DdOUxZzRciUAl82UyRKhceluPFtSActOkhvJ3OxSHM4EEvZ1PDqDfi/XggmWkGbLTslZbT48c8koYvSXzjud8jWp2LXLB+SJa+mlCLyzv+H26U1iMhNHzEfyclSYHXhfyT/1yhb2u+PPV5yZxx6iQ3VGNg29nKzZEaMxOb2SjePF3BCv6DRPuYIWrOkBy51we7lCjr0ktI8cFCADPzqdUQhol+LIV6grAt5A0cnCBjqx+qghoct80cFq7lQfwq8mRte5LbWCDZhEwiYpoeMe8xSjgoEQVkIY/8PKIRKt0Fueur+A7H/sFWP8VNwHUX+bctrZQkx6+1uCZZKPOTRN6qiAbGW9FcpCDzCind/FiCEFt5ks1GQ3w1685kp1n4tQRKM7Vh+l1xNRnymc9a1KOlCHI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5E7EC7FC806F0442A13075AC10AE0EA3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: faf37a31-94d4-4cc3-8d90-08d6f030465c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 18:52:24.6408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1840
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 13, 2019, at 6:21 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>=20
> Convert the BPF JIT assembly comments to AT&T syntax to reduce
> confusion.  AT&T syntax is the default standard, used throughout Linux
> and by the GNU assembler.
>=20
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
> arch/x86/net/bpf_jit_comp.c | 156 ++++++++++++++++++------------------
> 1 file changed, 78 insertions(+), 78 deletions(-)
>=20
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index bb1968fea50a..a92c2445441d 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -58,7 +58,7 @@ static bool is_uimm32(u64 value)
> 	return value =3D=3D (u64)(u32)value;
> }
>=20
> -/* mov dst, src */
> +/* mov src, dst */
> #define EMIT_mov(DST, SRC)								 \
> 	do {										 \
> 		if (DST !=3D SRC)								 \
> @@ -202,21 +202,21 @@ static void emit_prologue(u8 **pprog, u32 stack_dep=
th)
> 	u8 *prog =3D *pprog;
> 	int cnt =3D 0;
>=20
> -	/* push rbp */
> +	/* push %rbp */
> 	EMIT1(0x55);
>=20
> -	/* mov rbp, rsp */
> +	/* mov %rsp, %rbp */
> 	EMIT3(0x48, 0x89, 0xE5);
>=20
> -	/* push r15 */
> +	/* push %r15 */
> 	EMIT2(0x41, 0x57);
> -	/* push r14 */
> +	/* push %r14 */
> 	EMIT2(0x41, 0x56);
> -	/* push r13 */
> +	/* push %r13 */
> 	EMIT2(0x41, 0x55);
> -	/* push r12 */
> +	/* push %r12 */
> 	EMIT2(0x41, 0x54);
> -	/* push rbx */
> +	/* push %rbx */
> 	EMIT1(0x53);
>=20
> 	/*
> @@ -231,11 +231,11 @@ static void emit_prologue(u8 **pprog, u32 stack_dep=
th)
> 	 * R12 is used for the BPF program's FP register.  It points to the end
> 	 * of the program's stack area.
> 	 *
> -	 * mov r12, rsp
> +	 * mov %rsp, %r12
> 	 */
> 	EMIT3(0x49, 0x89, 0xE4);
>=20
> -	/* sub rsp, rounded_stack_depth */
> +	/* sub rounded_stack_depth, %rsp */
> 	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
>=20
> 	BUILD_BUG_ON(cnt !=3D PROLOGUE_SIZE);
> @@ -248,20 +248,20 @@ static void emit_epilogue(u8 **pprog)
> 	u8 *prog =3D *pprog;
> 	int cnt =3D 0;
>=20
> -	/* lea rsp, [rbp-0x28] */
> +	/* lea -0x28(%rbp), %rsp */
> 	EMIT4(0x48, 0x8D, 0x65, 0xD8);
>=20
> -	/* pop rbx */
> +	/* pop %rbx */
> 	EMIT1(0x5B);
> -	/* pop r12 */
> +	/* pop %r12 */
> 	EMIT2(0x41, 0x5C);
> -	/* pop r13 */
> +	/* pop %r13 */
> 	EMIT2(0x41, 0x5D);
> -	/* pop r14 */
> +	/* pop %r14 */
> 	EMIT2(0x41, 0x5E);
> -	/* pop r15 */
> +	/* pop %r15 */
> 	EMIT2(0x41, 0x5F);
> -	/* pop rbp */
> +	/* pop %rbp */
> 	EMIT1(0x5D);
>=20
> 	/* ret */
> @@ -300,8 +300,8 @@ static void emit_bpf_tail_call(u8 **pprog)
> 	 * if (index >=3D array->map.max_entries)
> 	 *	goto out;
> 	 */
> -	EMIT2(0x89, 0xD2);                        /* mov edx, edx */
> -	EMIT3(0x39, 0x56,                         /* cmp dword ptr [rsi + 16], =
edx */
> +	EMIT2(0x89, 0xD2);                        /* mov %edx, %edx */
> +	EMIT3(0x39, 0x56,                         /* cmp %edx, 0x10(%rsi) */
> 	      offsetof(struct bpf_array, map.max_entries));
> #define OFFSET1 (35 + RETPOLINE_RAX_BPF_JIT_SIZE) /* Number of bytes to j=
ump */
> 	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
> @@ -311,31 +311,31 @@ static void emit_bpf_tail_call(u8 **pprog)
> 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> 	 *	goto out;
> 	 */
> -	EMIT3(0x8B, 0x45, 0xD4);                  /* mov eax, dword ptr [rbp - =
44] */
> -	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT=
 */
> +	EMIT3(0x8B, 0x45, 0xD4);                  /* mov -0x2c(%rbp), %eax */
> +	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp MAX_TAIL_CALL_CNT, %ea=
x */
> #define OFFSET2 (27 + RETPOLINE_RAX_BPF_JIT_SIZE)
> 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
> 	label2 =3D cnt;
> -	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
> -	EMIT3(0x89, 0x45, 0xD4);                  /* mov dword ptr [rbp - 44], =
eax */
> +	EMIT3(0x83, 0xC0, 0x01);                  /* add $0x1, %eax */
> +	EMIT3(0x89, 0x45, 0xD4);                  /* mov %eax, -0x2c(%rbp) */
>=20
> 	/* prog =3D array->ptrs[index]; */
> -	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + =
offsetof(...)] */
> +	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov offsetof(ptrs)(%rsi,%r=
dx,8), %rax */
> 		    offsetof(struct bpf_array, ptrs));
>=20
> 	/*
> 	 * if (prog =3D=3D NULL)
> 	 *	goto out;
> 	 */
> -	EMIT3(0x48, 0x85, 0xC0);		  /* test rax,rax */
> +	EMIT3(0x48, 0x85, 0xC0);		  /* test %rax, %rax */
> #define OFFSET3 (8 + RETPOLINE_RAX_BPF_JIT_SIZE)
> 	EMIT2(X86_JE, OFFSET3);                   /* je out */
> 	label3 =3D cnt;
>=20
> 	/* goto *(prog->bpf_func + prologue_size); */
> -	EMIT4(0x48, 0x8B, 0x40,                   /* mov rax, qword ptr [rax + =
32] */
> +	EMIT4(0x48, 0x8B, 0x40,                   /* mov offsetof(bpf_func)(%ra=
x), %rax */
> 	      offsetof(struct bpf_prog, bpf_func));
> -	EMIT4(0x48, 0x83, 0xC0, PROLOGUE_SIZE);   /* add rax, prologue_size */
> +	EMIT4(0x48, 0x83, 0xC0, PROLOGUE_SIZE);   /* add $PROLOGUE_SIZE, %rax *=
/
>=20
> 	/*
> 	 * Wow we're ready to jump into next BPF program
> @@ -359,11 +359,11 @@ static void emit_mov_imm32(u8 **pprog, bool sign_pr=
opagate,
> 	int cnt =3D 0;
>=20
> 	/*
> -	 * Optimization: if imm32 is positive, use 'mov %eax, imm32'
> +	 * Optimization: if imm32 is positive, use 'mov imm32, %eax'
> 	 * (which zero-extends imm32) to save 2 bytes.
> 	 */
> 	if (sign_propagate && (s32)imm32 < 0) {
> -		/* 'mov %rax, imm32' sign extends imm32 */
> +		/* 'mov imm32, %rax' sign extends imm32 */
> 		b1 =3D add_1mod(0x48, dst_reg);
> 		b2 =3D 0xC7;
> 		b3 =3D 0xC0;
> @@ -384,7 +384,7 @@ static void emit_mov_imm32(u8 **pprog, bool sign_prop=
agate,
> 		goto done;
> 	}
>=20
> -	/* mov %eax, imm32 */
> +	/* mov imm32, %eax */
> 	if (is_ereg(dst_reg))
> 		EMIT1(add_1mod(0x40, dst_reg));
> 	EMIT1_off32(add_1reg(0xB8, dst_reg), imm32);
> @@ -403,11 +403,11 @@ static void emit_mov_imm64(u8 **pprog, u32 dst_reg,
> 		 * For emitting plain u32, where sign bit must not be
> 		 * propagated LLVM tends to load imm64 over mov32
> 		 * directly, so save couple of bytes by just doing
> -		 * 'mov %eax, imm32' instead.
> +		 * 'mov imm32, %eax' instead.
> 		 */
> 		emit_mov_imm32(&prog, false, dst_reg, imm32_lo);
> 	} else {
> -		/* movabsq %rax, imm64 */
> +		/* movabs imm64, %rax */

		^^^^^ Should this be moveabsq?=20

> 		EMIT2(add_1mod(0x48, dst_reg), add_1reg(0xB8, dst_reg));
> 		EMIT(imm32_lo, 4);
> 		EMIT(imm32_hi, 4);
> @@ -422,10 +422,10 @@ static void emit_mov_reg(u8 **pprog, bool is64, u32=
 dst_reg, u32 src_reg)
> 	int cnt =3D 0;
>=20
> 	if (is64) {
> -		/* mov dst, src */
> +		/* mov src, dst */
> 		EMIT_mov(dst_reg, src_reg);
> 	} else {
> -		/* mov32 dst, src */
> +		/* mov32 src, dst */
> 		if (is_ereg(dst_reg) || is_ereg(src_reg))
> 			EMIT1(add_2mod(0x40, dst_reg, src_reg));
> 		EMIT2(0x89, add_2reg(0xC0, dst_reg, src_reg));
> @@ -571,43 +571,43 @@ static int do_jit(struct bpf_prog *bpf_prog, int *a=
ddrs, u8 *image,
> 		case BPF_ALU64 | BPF_DIV | BPF_X:
> 		case BPF_ALU64 | BPF_MOD | BPF_K:
> 		case BPF_ALU64 | BPF_DIV | BPF_K:
> -			EMIT1(0x50); /* push rax */
> -			EMIT1(0x52); /* push rdx */
> +			EMIT1(0x50); /* push %rax */
> +			EMIT1(0x52); /* push %rdx */
>=20
> 			if (BPF_SRC(insn->code) =3D=3D BPF_X)
> -				/* mov r11, src_reg */
> +				/* mov src_reg, %r11 */
> 				EMIT_mov(AUX_REG, src_reg);
> 			else
> -				/* mov r11, imm32 */
> +				/* mov imm32, %r11 */
> 				EMIT3_off32(0x49, 0xC7, 0xC3, imm32);
>=20
> -			/* mov rax, dst_reg */
> +			/* mov dst_reg, %rax */
> 			EMIT_mov(BPF_REG_0, dst_reg);
>=20
> 			/*
> -			 * xor edx, edx
> -			 * equivalent to 'xor rdx, rdx', but one byte less
> +			 * xor %edx, %edx
> +			 * equivalent to 'xor %rdx, %rdx', but one byte less
> 			 */
> 			EMIT2(0x31, 0xd2);
>=20
> 			if (BPF_CLASS(insn->code) =3D=3D BPF_ALU64)
> -				/* div r11 */
> +				/* div %r11 */
> 				EMIT3(0x49, 0xF7, 0xF3);
> 			else
> -				/* div r11d */
> +				/* div %r11d */
> 				EMIT3(0x41, 0xF7, 0xF3);
>=20
> 			if (BPF_OP(insn->code) =3D=3D BPF_MOD)
> -				/* mov r11, rdx */
> +				/* mov %r11, %rdx */
> 				EMIT3(0x49, 0x89, 0xD3);
> 			else
> -				/* mov r11, rax */
> +				/* mov %r11, %rax */
> 				EMIT3(0x49, 0x89, 0xC3);
>=20
> -			EMIT1(0x5A); /* pop rdx */
> -			EMIT1(0x58); /* pop rax */
> +			EMIT1(0x5A); /* pop %rdx */
> +			EMIT1(0x58); /* pop %rax */
>=20
> -			/* mov dst_reg, r11 */
> +			/* mov %r11, dst_reg */
> 			EMIT_mov(dst_reg, AUX_REG);
> 			break;
>=20
> @@ -619,11 +619,11 @@ static int do_jit(struct bpf_prog *bpf_prog, int *a=
ddrs, u8 *image,
> 			bool is64 =3D BPF_CLASS(insn->code) =3D=3D BPF_ALU64;
>=20
> 			if (dst_reg !=3D BPF_REG_0)
> -				EMIT1(0x50); /* push rax */
> +				EMIT1(0x50); /* push %rax */
> 			if (dst_reg !=3D BPF_REG_3)
> -				EMIT1(0x52); /* push rdx */
> +				EMIT1(0x52); /* push %rdx */
>=20
> -			/* mov r11, dst_reg */
> +			/* mov dst_reg, %r11 */
> 			EMIT_mov(AUX_REG, dst_reg);
>=20
> 			if (BPF_SRC(insn->code) =3D=3D BPF_X)
> @@ -635,15 +635,15 @@ static int do_jit(struct bpf_prog *bpf_prog, int *a=
ddrs, u8 *image,
> 				EMIT1(add_1mod(0x48, AUX_REG));
> 			else if (is_ereg(AUX_REG))
> 				EMIT1(add_1mod(0x40, AUX_REG));
> -			/* mul(q) r11 */
> +			/* mul(q) %r11 */
> 			EMIT2(0xF7, add_1reg(0xE0, AUX_REG));
>=20
> 			if (dst_reg !=3D BPF_REG_3)
> -				EMIT1(0x5A); /* pop rdx */
> +				EMIT1(0x5A); /* pop %rdx */
> 			if (dst_reg !=3D BPF_REG_0) {
> -				/* mov dst_reg, rax */
> +				/* mov %rax, dst_reg */
> 				EMIT_mov(dst_reg, BPF_REG_0);
> -				EMIT1(0x58); /* pop rax */
> +				EMIT1(0x58); /* pop %rax */
> 			}
> 			break;
> 		}
> @@ -678,21 +678,21 @@ static int do_jit(struct bpf_prog *bpf_prog, int *a=
ddrs, u8 *image,
> 		case BPF_ALU64 | BPF_RSH | BPF_X:
> 		case BPF_ALU64 | BPF_ARSH | BPF_X:
>=20
> -			/* Check for bad case when dst_reg =3D=3D rcx */
> +			/* Check for bad case when dst_reg =3D=3D %rcx */
> 			if (dst_reg =3D=3D BPF_REG_4) {
> -				/* mov r11, dst_reg */
> +				/* mov dst_reg, %r11 */
> 				EMIT_mov(AUX_REG, dst_reg);
> 				dst_reg =3D AUX_REG;
> 			}
>=20
> 			if (src_reg !=3D BPF_REG_4) { /* common case */
> -				EMIT1(0x51); /* push rcx */
> +				EMIT1(0x51); /* push %rcx */
>=20
> -				/* mov rcx, src_reg */
> +				/* mov src_reg, %rcx */
> 				EMIT_mov(BPF_REG_4, src_reg);
> 			}
>=20
> -			/* shl %rax, %cl | shr %rax, %cl | sar %rax, %cl */
> +			/* shl %cl, %rax | shr %cl, %rax | sar %cl, %rax */
> 			if (BPF_CLASS(insn->code) =3D=3D BPF_ALU64)
> 				EMIT1(add_1mod(0x48, dst_reg));
> 			else if (is_ereg(dst_reg))
> @@ -706,23 +706,23 @@ static int do_jit(struct bpf_prog *bpf_prog, int *a=
ddrs, u8 *image,
> 			EMIT2(0xD3, add_1reg(b3, dst_reg));
>=20
> 			if (src_reg !=3D BPF_REG_4)
> -				EMIT1(0x59); /* pop rcx */
> +				EMIT1(0x59); /* pop %rcx */
>=20
> 			if (insn->dst_reg =3D=3D BPF_REG_4)
> -				/* mov dst_reg, r11 */
> +				/* mov %r11, dst_reg */
> 				EMIT_mov(insn->dst_reg, AUX_REG);
> 			break;
>=20
> 		case BPF_ALU | BPF_END | BPF_FROM_BE:
> 			switch (imm32) {
> 			case 16:
> -				/* Emit 'ror %ax, 8' to swap lower 2 bytes */
> +				/* Emit 'ror $0x8, %ax' to swap lower 2 bytes */
> 				EMIT1(0x66);
> 				if (is_ereg(dst_reg))
> 					EMIT1(0x41);
> 				EMIT3(0xC1, add_1reg(0xC8, dst_reg), 8);
>=20
> -				/* Emit 'movzwl eax, ax' */
> +				/* Emit 'movzwl %ax, %eax' */
> 				if (is_ereg(dst_reg))
> 					EMIT3(0x45, 0x0F, 0xB7);
> 				else
> @@ -730,7 +730,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
> 				EMIT1(add_2reg(0xC0, dst_reg, dst_reg));
> 				break;
> 			case 32:
> -				/* Emit 'bswap eax' to swap lower 4 bytes */
> +				/* Emit 'bswap %eax' to swap lower 4 bytes */
> 				if (is_ereg(dst_reg))
> 					EMIT2(0x41, 0x0F);
> 				else
> @@ -738,7 +738,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
> 				EMIT1(add_1reg(0xC8, dst_reg));
> 				break;
> 			case 64:
> -				/* Emit 'bswap rax' to swap 8 bytes */
> +				/* Emit 'bswap %rax' to swap 8 bytes */
> 				EMIT3(add_1mod(0x48, dst_reg), 0x0F,
> 				      add_1reg(0xC8, dst_reg));
> 				break;
> @@ -749,7 +749,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
> 			switch (imm32) {
> 			case 16:
> 				/*
> -				 * Emit 'movzwl eax, ax' to zero extend 16-bit
> +				 * Emit 'movzwl %ax, %eax' to zero extend 16-bit
> 				 * into 64 bit
> 				 */
> 				if (is_ereg(dst_reg))
> @@ -759,7 +759,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
> 				EMIT1(add_2reg(0xC0, dst_reg, dst_reg));
> 				break;
> 			case 32:
> -				/* Emit 'mov eax, eax' to clear upper 32-bits */
> +				/* Emit 'mov %eax, %eax' to clear upper 32-bits */
> 				if (is_ereg(dst_reg))
> 					EMIT1(0x45);
> 				EMIT2(0x89, add_2reg(0xC0, dst_reg, dst_reg));
> @@ -811,7 +811,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
>=20
> 			/* STX: *(u8*)(dst_reg + off) =3D src_reg */
> 		case BPF_STX | BPF_MEM | BPF_B:
> -			/* Emit 'mov byte ptr [rax + off], al' */
> +			/* Emit 'mov %al, off(%rax)' */
> 			if (is_ereg(dst_reg) || is_ereg(src_reg) ||
> 			    /* We have to add extra byte for x86 SIL, DIL regs */
> 			    src_reg =3D=3D BPF_REG_1 || src_reg =3D=3D BPF_REG_2)
> @@ -850,22 +850,22 @@ static int do_jit(struct bpf_prog *bpf_prog, int *a=
ddrs, u8 *image,
>=20
> 			/* LDX: dst_reg =3D *(u8*)(src_reg + off) */
> 		case BPF_LDX | BPF_MEM | BPF_B:
> -			/* Emit 'movzx rax, byte ptr [rax + off]' */
> +			/* Emit 'movzbl off(%rax), %rax' */
> 			EMIT3(add_2mod(0x48, src_reg, dst_reg), 0x0F, 0xB6);
> 			goto ldx;
> 		case BPF_LDX | BPF_MEM | BPF_H:
> -			/* Emit 'movzx rax, word ptr [rax + off]' */
> +			/* Emit 'movzwl off(%rax), %rax' */
> 			EMIT3(add_2mod(0x48, src_reg, dst_reg), 0x0F, 0xB7);
> 			goto ldx;
> 		case BPF_LDX | BPF_MEM | BPF_W:
> -			/* Emit 'mov eax, dword ptr [rax+0x14]' */
> +			/* Emit 'mov 0x14(%rax), %eax' */
> 			if (is_ereg(dst_reg) || is_ereg(src_reg))
> 				EMIT2(add_2mod(0x40, src_reg, dst_reg), 0x8B);
> 			else
> 				EMIT1(0x8B);
> 			goto ldx;
> 		case BPF_LDX | BPF_MEM | BPF_DW:
> -			/* Emit 'mov rax, qword ptr [rax+0x14]' */
> +			/* Emit 'mov 0x14(%rax), %rax' */
> 			EMIT2(add_2mod(0x48, src_reg, dst_reg), 0x8B);
> ldx:
> 			/*
> @@ -889,7 +889,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
>=20
> 			/* STX XADD: lock *(u32*)(dst_reg + off) +=3D src_reg */
> 		case BPF_STX | BPF_XADD | BPF_W:
> -			/* Emit 'lock add dword ptr [rax + off], eax' */
> +			/* Emit 'lock add %eax, off(%rax)' */
> 			if (is_ereg(dst_reg) || is_ereg(src_reg))
> 				EMIT3(0xF0, add_2mod(0x40, dst_reg, src_reg), 0x01);
> 			else
> @@ -949,7 +949,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
> 		case BPF_JMP32 | BPF_JSLT | BPF_X:
> 		case BPF_JMP32 | BPF_JSGE | BPF_X:
> 		case BPF_JMP32 | BPF_JSLE | BPF_X:
> -			/* cmp dst_reg, src_reg */
> +			/* cmp src_reg, dst_reg */
> 			if (BPF_CLASS(insn->code) =3D=3D BPF_JMP)
> 				EMIT1(add_2mod(0x48, dst_reg, src_reg));
> 			else if (is_ereg(dst_reg) || is_ereg(src_reg))
> @@ -959,7 +959,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
>=20
> 		case BPF_JMP | BPF_JSET | BPF_X:
> 		case BPF_JMP32 | BPF_JSET | BPF_X:
> -			/* test dst_reg, src_reg */
> +			/* test src_reg, dst_reg */
> 			if (BPF_CLASS(insn->code) =3D=3D BPF_JMP)
> 				EMIT1(add_2mod(0x48, dst_reg, src_reg));
> 			else if (is_ereg(dst_reg) || is_ereg(src_reg))
> @@ -969,7 +969,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
>=20
> 		case BPF_JMP | BPF_JSET | BPF_K:
> 		case BPF_JMP32 | BPF_JSET | BPF_K:
> -			/* test dst_reg, imm32 */
> +			/* test imm32, dst_reg */
> 			if (BPF_CLASS(insn->code) =3D=3D BPF_JMP)
> 				EMIT1(add_1mod(0x48, dst_reg));
> 			else if (is_ereg(dst_reg))
> @@ -997,7 +997,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
> 		case BPF_JMP32 | BPF_JSLT | BPF_K:
> 		case BPF_JMP32 | BPF_JSGE | BPF_K:
> 		case BPF_JMP32 | BPF_JSLE | BPF_K:
> -			/* cmp dst_reg, imm8/32 */
> +			/* cmp imm8/32, dst_reg */
> 			if (BPF_CLASS(insn->code) =3D=3D BPF_JMP)
> 				EMIT1(add_1mod(0x48, dst_reg));
> 			else if (is_ereg(dst_reg))
> --=20
> 2.20.1
>=20

