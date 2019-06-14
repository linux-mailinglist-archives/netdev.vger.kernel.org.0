Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3BA24624B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfFNPOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:14:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52440 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbfFNPOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:14:37 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5EF49Zk022999;
        Fri, 14 Jun 2019 08:13:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yryuILdBwZnK1CyKNgOJsebOGk8n7E1Kyf0D5bEn2Mw=;
 b=d5LN2vyrypTLi75HEw6JkGoef7T87KdMGcTlHwxT513JsnymgUnrRg2JI4UyjfISLFa+
 2pgxKD3ZQTP2xyF+5rpgnkzD04z/q+bMS6WyHgzUIsglkQx/gmjEbHy6mjtrTRJEb+Tk
 V0oguA5UebTojN3zxMuL1eQlejX5JB+Nu9Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t4ds0r2aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 Jun 2019 08:13:25 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 14 Jun 2019 08:13:24 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 14 Jun 2019 08:13:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yryuILdBwZnK1CyKNgOJsebOGk8n7E1Kyf0D5bEn2Mw=;
 b=dbBmwI8obqTc+QVopdmIMII1d1jfkYO/6+GXwmioxqMGuXrE8gHW+fWFvHmwWb3JcczdIo92Shn+L6n/gK7h1F7JXAsVziPbLX5ZqwIJHfOQCSoy9x1miyMws6/n9+2LlDuEpHdpUHtgA95ls8oknYAAZJ0wyW0bB2Yvv/djyX0=
Received: from DM5PR15MB1163.namprd15.prod.outlook.com (10.173.215.141) by
 DM5PR15MB1706.namprd15.prod.outlook.com (10.174.108.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Fri, 14 Jun 2019 15:13:23 +0000
Received: from DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::38aa:95ca:d50f:9745]) by DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::38aa:95ca:d50f:9745%3]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 15:13:23 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Josh Poimboeuf <jpoimboe@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 8/9] x86/bpf: Convert asm comments to AT&T syntax
Thread-Topic: [PATCH 8/9] x86/bpf: Convert asm comments to AT&T syntax
Thread-Index: AQHVIetLPIU2acwXW0W72I9U+7dGQaaZ7m6AgADXPYCAAH3nAA==
Date:   Fri, 14 Jun 2019 15:13:23 +0000
Message-ID: <38F47DBB-F98F-4C12-B7D0-A363085065F3@fb.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <77fe02f7d575091b06f68f8eed256da94aee653f.1560431531.git.jpoimboe@redhat.com>
 <E8372F56-269A-48A4-B80B-14FA664F8D41@fb.com>
 <20190614074245.GS3436@hirez.programming.kicks-ass.net>
In-Reply-To: <20190614074245.GS3436@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2:e3f9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f9e4c4c-e9a3-4751-f78e-08d6f0dad7e8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1706;
x-ms-traffictypediagnostic: DM5PR15MB1706:
x-microsoft-antispam-prvs: <DM5PR15MB17065AAF7DB3C386288FD2CEB3EE0@DM5PR15MB1706.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(366004)(346002)(396003)(136003)(199004)(189003)(6916009)(2616005)(305945005)(476003)(11346002)(46003)(71200400001)(71190400001)(486006)(54906003)(14454004)(446003)(316002)(81156014)(36756003)(68736007)(25786009)(2906002)(81166006)(8676002)(33656002)(6246003)(6436002)(256004)(229853002)(5660300002)(53936002)(57306001)(99286004)(50226002)(4326008)(6116002)(6486002)(6512007)(4744005)(91956017)(186003)(86362001)(7736002)(8936002)(76176011)(66446008)(66476007)(64756008)(53546011)(102836004)(478600001)(66946007)(73956011)(66556008)(6506007)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1706;H:DM5PR15MB1163.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UOGSl6SMQCB63dXemZtpAuYVDTrfircjD8Qe550uKjvR77DeuFnM2qdxMLM9ZS53wf4wfQ1e7+K91gx4Ph1G4KsXXUOx20aNrlHyqTAiwhkPJ9I7MTawHzYuC2CotYFU627B5DpVYbYo+R2c63nacj0CrU3zskiZqcCL84PPE5Fnra2CK5EpRo1w/P4v3vZiyvjQKJ2sQeS0vjue9CZKTu5KEllsY+XN6myd0d8ElbYJHuXhO3COKqSdKAxX24lxBgFLLKfeLzrEcMSB+15ndtWQC9q6oycVZnndfAqp2X9SOoBIqiAB+bAOm/tLBGyLD3tuJehq3DKCFG1lCh8W/6GiemwKGrKgnXzLzEwQel+PSKakzUAz2748Zzh7Tsi/FR9Alrt45wd84xcrY0YrPI7TQ7JnIb5+KSeMfXd0PRc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2A1DC0A2427F574BB2C824E37D7C26A4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f9e4c4c-e9a3-4751-f78e-08d6f0dad7e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 15:13:23.4008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1706
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=785 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140125
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 14, 2019, at 12:42 AM, Peter Zijlstra <peterz@infradead.org> wrote=
:
>=20
> On Thu, Jun 13, 2019 at 06:52:24PM +0000, Song Liu wrote:
>>> On Jun 13, 2019, at 6:21 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote=
:
>=20
>>> @@ -403,11 +403,11 @@ static void emit_mov_imm64(u8 **pprog, u32 dst_re=
g,
>>> 		 * For emitting plain u32, where sign bit must not be
>>> 		 * propagated LLVM tends to load imm64 over mov32
>>> 		 * directly, so save couple of bytes by just doing
>>> -		 * 'mov %eax, imm32' instead.
>>> +		 * 'mov imm32, %eax' instead.
>>> 		 */
>>> 		emit_mov_imm32(&prog, false, dst_reg, imm32_lo);
>>> 	} else {
>>> -		/* movabsq %rax, imm64 */
>>> +		/* movabs imm64, %rax */
>>=20
>> 		^^^^^ Should this be moveabsq?=20
>>=20
>>> 		EMIT2(add_1mod(0x48, dst_reg), add_1reg(0xB8, dst_reg));
>>> 		EMIT(imm32_lo, 4);
>>> 		EMIT(imm32_hi, 4);
>=20
> Song, can you please trim replies; I only found what you said because of
> Josh's reply.

Sorry for the problem. I will trim in the future.=20

Song
