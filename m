Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676C23843B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 08:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfFGGSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 02:18:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47298 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726336AbfFGGSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 02:18:48 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x576HrHr006629;
        Thu, 6 Jun 2019 23:17:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LxHb9BTP0C9f9yNrsgwi7N+RnLG3KAR7cGr2BBM532g=;
 b=HxYNxfFki9qv9bG9l8BJ1VlPmxCBbOWQ4H+HknSJyD3twbyul8yUkCum67O/oEmSH9Gv
 Xok/DgO8ZnToJhLomcUFPxaEXiWVTKSZwrZvMJ61ek1hYuLguA06pZlrMwz22aEoBo3R
 JTqP0wMh0Sb8dVG74dOlR9sGmWvgEmoLhj0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy7pua0ua-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 23:17:56 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 23:17:54 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 23:17:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxHb9BTP0C9f9yNrsgwi7N+RnLG3KAR7cGr2BBM532g=;
 b=UHFmQkxGZD3QjgzkFYca/2pgkXp3U88i2akVDuIlch0VoWmGLBhyiElKGDwnMTMlkDSMax4ft8uA7JcGCjp2AJPxDLfEtA/J9OkkzN1r0RY84mYUAkZtKXqxOtCJQq1zzbtPJSWNnxY4gSZnhCpMri0v8GIUnZ/9NW+5oy25LdQ=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1278.namprd15.prod.outlook.com (10.175.3.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Fri, 7 Jun 2019 06:17:52 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Fri, 7 Jun 2019
 06:17:52 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 2/4] bpf/tools: sync bpf.h
Thread-Topic: [PATCH v5 bpf-next 2/4] bpf/tools: sync bpf.h
Thread-Index: AQHVHKrRI3F36XKmG0+uyFvy1jv1qKaPuCCA
Date:   Fri, 7 Jun 2019 06:17:52 +0000
Message-ID: <20190607061749.cazmeqxq5u53xfye@kafai-mbp.dhcp.thefacebook.com>
References: <20190606205943.818795-1-jonathan.lemon@gmail.com>
 <20190606205943.818795-3-jonathan.lemon@gmail.com>
In-Reply-To: <20190606205943.818795-3-jonathan.lemon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0077.namprd05.prod.outlook.com
 (2603:10b6:102:2::45) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:8283]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ec33eb2-fb4c-45ee-c40b-08d6eb0fdf27
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1278;
x-ms-traffictypediagnostic: MWHPR15MB1278:
x-microsoft-antispam-prvs: <MWHPR15MB1278D2BE4AFAE1295177167AD5100@MWHPR15MB1278.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:626;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(376002)(39860400002)(396003)(136003)(199004)(189003)(102836004)(4326008)(229853002)(68736007)(6116002)(446003)(6486002)(8676002)(25786009)(81156014)(11346002)(14454004)(54906003)(46003)(6246003)(8936002)(53936002)(99286004)(558084003)(52116002)(76176011)(6916009)(186003)(81166006)(2906002)(256004)(316002)(71200400001)(71190400001)(66476007)(66556008)(64756008)(66946007)(73956011)(476003)(66446008)(478600001)(486006)(86362001)(6436002)(305945005)(6512007)(9686003)(1076003)(7736002)(5660300002)(6506007)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1278;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yS+Wb9ArZ/vY0Ze0zptvO3k2o5V3JjCUsDX6ydHvSRocP+KxG7XjLn56grsX+6nTu15T8KRI+SyfjrZ11l9wrxbMRBWSB+jAzCyTPlN+kz0gZ5Dq+Qq24fiJvBsJbB0ZWDtxZ4E99NcGQOPbjFmwqoJ48D4Yh0D54yYWohz985m24YaTfG8wectfS09brIHuxpOrJtAx4FTPag48iJON1fU3cj7R0dpRUsd4rvztIgcjjBZtFSXo5gqAyz17zn7+gdzwuxTuEr/RxYS1FFUez5z5uuk8Kzga9Amm52ZMfwUCH6UR3jbrhQRraNDEf/dnTGfGJPaod9AjBgaguZU3zwMgkb+7UPZo0zqJp5+9h93Uk4Y0nUB2psHn3ugpMIcj0kKY3QbO9Ux2VTUGe9cIl1psuzTcP77fIEyoar5MoRU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F51C9E21688F284886431A61B41D0D48@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec33eb2-fb4c-45ee-c40b-08d6eb0fdf27
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 06:17:52.5840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1278
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-07_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=388 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906070044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 01:59:41PM -0700, Jonathan Lemon wrote:
> Sync uapi/linux/bpf.h=20
>=20
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
