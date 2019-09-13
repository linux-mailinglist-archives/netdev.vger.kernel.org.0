Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A264B28DC
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 01:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404349AbfIMXXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 19:23:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390498AbfIMXXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 19:23:44 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DNNXQE006187;
        Fri, 13 Sep 2019 16:23:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=A3emQzkQz9tX7HeijsNR/4h9zmX4tY3hynXxC83zFbk=;
 b=aHVFGtvUo2gHOqBQsswSPwlStANUE1BIr6DxTjeuj33ykR2cWJDot9sc758SbZ1haUxu
 wNRMlX+RtqcuAGOfq7h6mpC007lyinCftgiiohZQEGSesu2Aq/N9Q3FnAf0kqaL4JsIH
 lflYTb8sP6j85k+3DEyfw9espUVFFUAsZvc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uytcsxmwg-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 16:23:39 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 16:23:37 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 16:23:37 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 16:23:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpXVdT0K8VY/13/B3toVEO50cmOzFonqhatLEH3BMXalJDvwg99m2BlpJyeUkxi/P8ckteEAkFl9zTdS1XnSEi2x4DHIbLtdnm47nfl+kcjJGTbN5Jf5XwQG87P0J1eJPdS17ow8HwDni7bQWv/o6nmKE8OxtkH7vzCNlma+9t8d/FoxIU4quQt0QvfpMvyDBwrLJKfLe0VAEGT/mtER/m2aixwRVEqnA5voHA/mIQCcYjqsCFWTF1dqOBodr32/CwGqeYIcpmxMe7uCtNmt2CgH+ztZTqKxnbjgHxzKye+hbISDSBmUCh/IVLcnvpDFYtZu4kA0wNYwV89D9+AXLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3emQzkQz9tX7HeijsNR/4h9zmX4tY3hynXxC83zFbk=;
 b=Sdg6RnDRKcSw1vRS4OWpd5NLE5HWUO35e0t0UO8/AO573qAAFC/pNAaaSEqYVdB1MYjzXkXyUbgvMQpYFEsUye4jdCbzoF7K8FQAlUcDw4kEsmiAOpFNm39Y+be7tjsrpkCpug5tKdMpGMdxlj19yIdzfQRG3awvR2xEZ15h8IJdDC2M0XmW3ItuUeS1YCGUmO7kyuS5M9DY1yVN0WTd7xEOQ1bZ4NOe1n2AK527tQediK/TxCeiHZk4oyHB2MumN/Ru2kDbrk15E9ED7yh0mFDfIEaAIOSym4w8lj0Yf6b3Atdvzu3uIlctGcwp7sJdOQhwov5E0ItLhvvfqNqQBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3emQzkQz9tX7HeijsNR/4h9zmX4tY3hynXxC83zFbk=;
 b=IOmI7o0Ui7p4EI/BYZWFY5x0uKLrWjIDLhdf/71KvmXpBEUWbb75MDfC9IReAUzUcBNIQ7qn7yWTeZ30bef4ci2gWonpY8mXrNBZwG/DAvKQGzKvWoXLp2tyVWWA+3JZ3XTciHjnrfRc+MzlN1ocoNTFcZYP6xzLP81HI2piIi4=
Received: from CY4PR15MB1207.namprd15.prod.outlook.com (10.172.180.17) by
 CY4PR15MB1685.namprd15.prod.outlook.com (10.175.120.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Fri, 13 Sep 2019 23:23:36 +0000
Received: from CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3]) by CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3%6]) with mapi id 15.20.2241.025; Fri, 13 Sep 2019
 23:23:36 +0000
From:   Thomas Higdon <tph@fb.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jonathan Lemon <jonathan.lemon@gmail.com>, Dave Jones <dsj@fb.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "Dave Taht" <dave.taht@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        "Soheil Hassas Yeganeh" <soheil@google.com>
Subject: [PATCH v5 2/2] tcp: Add snd_wnd to TCP_INFO
Thread-Topic: [PATCH v5 2/2] tcp: Add snd_wnd to TCP_INFO
Thread-Index: AQHVaopEWP9GmIb+u0OtCWskRBBIDQ==
Date:   Fri, 13 Sep 2019 23:23:35 +0000
Message-ID: <20190913232332.44036-2-tph@fb.com>
References: <20190913232332.44036-1-tph@fb.com>
In-Reply-To: <20190913232332.44036-1-tph@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:208:120::42) To CY4PR15MB1207.namprd15.prod.outlook.com
 (2603:10b6:903:110::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.16.2
x-originating-ip: [163.114.130.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5baf63e6-6c1d-4c01-7b47-08d738a16687
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1685;
x-ms-traffictypediagnostic: CY4PR15MB1685:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1685050227870D99C33C1741DDB30@CY4PR15MB1685.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(66446008)(66556008)(64756008)(66946007)(66476007)(2501003)(486006)(3846002)(14454004)(4326008)(6116002)(2351001)(478600001)(7736002)(25786009)(305945005)(6436002)(5640700003)(6486002)(1076003)(53936002)(6512007)(6916009)(54906003)(71200400001)(71190400001)(66066001)(2906002)(5660300002)(86362001)(14444005)(8936002)(36756003)(186003)(52116002)(8676002)(2616005)(6506007)(476003)(1730700003)(81156014)(386003)(81166006)(50226002)(11346002)(256004)(102836004)(99286004)(26005)(76176011)(316002)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1685;H:CY4PR15MB1207.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4oaZm0YF4uqesQQZGTQH6nLGLbfZ8axRIq20+6BBpV9he8Vt4bSKrRbeynPX/mGomJpCz2DcHkEwfMIQlVTO6YuFZS1wwObc6dXLNRwcdsGT9pA6jzEgsYzWSQYX/YUt0CSAusgCahZbXv3PiS3p9SBHAP1/Ju88031M/CoaBbxx4QiLlWJTm/BrCLJvRWv+xwsXBkZWq4UOYTv7eonWdKsuBzVeAL5FBCduCjCGLB4oJkUT+h0x+etFcDtavcYlhU3SH3ziWh9RkaEnU6Oa4Akrp/JF7zgvTsTOkFz2a/GJE/Bn5LjTFhGHcywQjBqD6R220HbsH0r5rEtWHwAR02XfjcAXcT2fb8bvySuudZLDdq909N4havmMRr0bjfKmTCh6WZQPqto3hrAnjYNLF0B1FwARNccc05VeigXdou8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5baf63e6-6c1d-4c01-7b47-08d738a16687
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 23:23:35.9228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N/kruPnfbN1fs9inEsB2FsXDgjoWjsivVtRbLHzU1JbQLuiX6msV4jhP+lLstLs9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1685
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_11:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015
 adultscore=0 malwarescore=0 mlxlogscore=839 suspectscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909130227
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neal Cardwell mentioned that snd_wnd would be useful for diagnosing TCP
performance problems --
> (1) Usually when we're diagnosing TCP performance problems, we do so
> from the sender, since the sender makes most of the
> performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
> From the sender-side the thing that would be most useful is to see
> tp->snd_wnd, the receive window that the receiver has advertised to
> the sender.

This serves the purpose of adding an additional __u32 to avoid the
would-be hole caused by the addition of the tcpi_rcvi_ooopack field.

Signed-off-by: Thomas Higdon <tph@fb.com>
---
changes since v4:
 - clarify comment
 include/uapi/linux/tcp.h | 4 ++++
 net/ipv4/tcp.c           | 1 +
 2 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 20237987ccc8..81e697978e8b 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -272,6 +272,10 @@ struct tcp_info {
 	__u32	tcpi_reord_seen;     /* reordering events seen */
=20
 	__u32	tcpi_rcv_ooopack;    /* Out-of-order packets received */
+
+	__u32	tcpi_snd_wnd;	     /* peer's advertised receive window after
+				      * scaling (bytes)
+				      */
 };
=20
 /* netlink attributes types for SCM_TIMESTAMPING_OPT_STATS */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4cf58208270e..79c325a07ba5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3297,6 +3297,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *i=
nfo)
 	info->tcpi_dsack_dups =3D tp->dsack_dups;
 	info->tcpi_reord_seen =3D tp->reord_seen;
 	info->tcpi_rcv_ooopack =3D tp->rcv_ooopack;
+	info->tcpi_snd_wnd =3D tp->snd_wnd;
 	unlock_sock_fast(sk, slow);
 }
 EXPORT_SYMBOL_GPL(tcp_get_info);
--=20
2.17.1

