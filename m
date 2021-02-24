Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A587323E37
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbhBXN1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 08:27:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51288 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbhBXNVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 08:21:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODJQXp031362;
        Wed, 24 Feb 2021 13:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rqWXpW1cf+ZaJxVFBkLTI1+aOtM1Dlq12P1lwhSuT/Y=;
 b=BjGMbYlg0FZ7/X6CJtvcGdBgIXCRECuo5CP7inuLzngNetrLKslkZyWw9OCwVGM4gCDi
 J4fSiFdlJ61oCdXKlMr9YlGlogQcppDMsPnRtB2gIqzzfzCODHWmJn7kvzaijRZQ19eq
 BPpADfRTTIrbIosxwX32xc4rW3bSzx8YASJ44/V02UjXwmkG/Lo28TR7lJ9Q9Q641wO+
 9joGiFDqt9hC9lKn4jc+7SGraiNzDwqXKWi8ycNHgGWnbGzf+VHyJdpAQuXhYlw3+Zi8
 K67wf72j7XOgXbEIXMoGPPxd42whhrWwxly5yqD4WJLN/MhHVKBHZRZqhp5CLnByWw0u Yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36tsur2whj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:20:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODKa6v068650;
        Wed, 24 Feb 2021 13:20:38 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3020.oracle.com with ESMTP id 36ucb0qvtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMG1g5qWAZR+a+bnodnCvhc9X4wS/Q+1Vu10rw2sLlkSH266XkfYDuNTe130qbwqGB5K0w9w0DbbT06hTr45zZc+M1u20g+3ZJ3ny9I+a8UOe7V60PxsQgOh769WzUZysGTBlj5YYikSLveaCcRC5DSAaUWTR+ARhMOXDFKuAcg0hkTERydyD/vW7OIOvTh0AOGScw1YQ7p7BFAybYWrmvp8Ipkw5WFpSs2mT44oKh+XQxx7WfS4u5XEobabB2f3HY/Ll74Bqedw7UysmriXhHum/yqUXWyRWkY3W3a83WxTNeEZkSf8z2xS3BJgNfpSbZ1L21S/fNGNDrHNb9ZDBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqWXpW1cf+ZaJxVFBkLTI1+aOtM1Dlq12P1lwhSuT/Y=;
 b=EPosdDGBGkCjyBZ9pvsCdu2thUjUbOLnhsa4SeJodgs8Uy52oGTfg5Zo6oaPegpS/+w1Yz+B2pzFxdekxmtGXKdPqglNWzH4aVfKD+Uv5AxVspTim2HIKibbPFvD8qgO5lQGKqwgA0zaQ1giydSDggncAUt5XYXoVAixWmAHjd2/1Pv2QwMS9m4cy/PvTHXmFH7HE8xeSzGjy740if3Dv8F+LiDT5AbkPseZA5BuviS+VJ0mMXsIXvmE0Hf+B5kQujmisZ1e9KP7kDMV7WpVDNn5loj9sic4avJW/y+q2V6NDqM8n7oyxDBpcJfekTAOuO6bnDOCEsaUplQVEdY87w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqWXpW1cf+ZaJxVFBkLTI1+aOtM1Dlq12P1lwhSuT/Y=;
 b=yPV8fMwVH4eDuXpR/4/nRlTPMPznIusSaEnDjOFWe6U2pzs3IdoFW8DdJuvUQm753LvaQoxMOSPojgu5LIGGFlnY1CpNIzA7/MQQKPEMUOOs+nFqqyAobP0Y0BPotxU+CRTwgQ5Iilzx4ugi237gJfif2cwcr0FGkBq3wzpmtgo=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by SJ0PR10MB4464.namprd10.prod.outlook.com (2603:10b6:a03:2d0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Wed, 24 Feb
 2021 13:20:26 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::6da8:6d28:b83:702b]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::6da8:6d28:b83:702b%4]) with mapi id 15.20.3890.019; Wed, 24 Feb 2021
 13:20:26 +0000
From:   Chuck Lever <chuck.lever@oracle.com>
To:     Mel Gorman <mgorman@techsingularity.net>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] Introduce a bulk order-0 page allocator for
 sunrpc
Thread-Topic: [RFC PATCH 0/3] Introduce a bulk order-0 page allocator for
 sunrpc
Thread-Index: AQHXCpd54L9TIoicSkq7mRX6ncMJiapnSnCA
Date:   Wed, 24 Feb 2021 13:20:25 +0000
Message-ID: <498EFB43-76C0-44A9-9AEC-89F7CD8F931A@oracle.com>
References: <20210224102603.19524-1-mgorman@techsingularity.net>
In-Reply-To: <20210224102603.19524-1-mgorman@techsingularity.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: techsingularity.net; dkim=none (message not signed)
 header.d=none;techsingularity.net; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3cb9f26f-16d8-4a80-d113-08d8d8c6f2cb
x-ms-traffictypediagnostic: SJ0PR10MB4464:
x-microsoft-antispam-prvs: <SJ0PR10MB44642A79F3B976445E7760EA939F9@SJ0PR10MB4464.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3tdOtj7eD4dreqG3Orlnxq1Tj5iDywiC3vxLaIVLKSz1eDiQd0Zefa8YOGt7q2Uku5nx5/AYCzqg0/61zJm7d4Bhd+0FhmrFqFaTi0tefJUTHS5/MWtwYRG8qglSpPi2Rvcu2Om179AY2D1UEIeIARuqpENvh8py92wlDni1ip6VpX9rBRWTPbydSPP+gbp+9OchVd5OmpEwpL+/XsylSu6X8KrGCO9BCI0WJyZDmaGAse8B/OLMgdoF58lg0jR/V6s4ZFJ+1ajMkKEWEAvLrTTQ8t80PGAyqwrZqBzBnb5pNBxmnPMnU3eUQVzZNKRTdRwLYxbFg0HqgEBSwGe5yxydgoOmDBQfa8hMB8KgimUEb2JprZRhwJWAInftZSWHBTowy0rTWucMorIP9j9DC2+E81264teHJkDgqgrAZbSk88fGXJmt/m9SM4MojFXMdAmMFPMtpJvRtvPRvzEp4p1YpXYJYtaI95kJm7cJXC456xYOWgUe+pDNRjKjuJm66y+VacwZNFWsvV4IFd5/QgGiFQw8AUCGBxd3cQcng7nwqSlmFYpjVaCvhl/5Bxs9wJmxWgRQ7s87PCMSLOWy1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(26005)(6486002)(33656002)(4326008)(186003)(54906003)(2906002)(36756003)(5660300002)(66476007)(66556008)(316002)(53546011)(44832011)(76116006)(91956017)(66446008)(64756008)(8936002)(2616005)(66946007)(478600001)(71200400001)(86362001)(83380400001)(6512007)(6506007)(8676002)(6916009)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qazz0SahhAR2To3Ph0j37PdnjhW4Rkm1WLdBARbqpSSo5G7BCSZKGMVXCwBF?=
 =?us-ascii?Q?e6xgbQ2rQsS9dCKT69/Yw4j0/NTzAzshL5mGhXgC0t5PnliqDm9qZDkW/xjI?=
 =?us-ascii?Q?YdvgqEmpYqZjvP5ZyP75r/OLnLaa8KmGkyOl2X2UOcpAP3QMN7ZZ5IA1W4So?=
 =?us-ascii?Q?sytWhQdzfl36KgBxhZTXiQ7z/Vk4XS20Ji2sKLVYQt4OzkI2Nvjn9FKkQOOW?=
 =?us-ascii?Q?NCdKfhyXc66oP+y25XhTEGn2Vb4NIaQnoeTrYJTHunQUQQTvkhUvh4W2qbQ4?=
 =?us-ascii?Q?M/pe6Jj/DWpbe0/yKr/vfGkPMNbQUYm5OCANQphCXtAdeAg/q5oZ0BRDGrAQ?=
 =?us-ascii?Q?tj66ibb+KQoZRsfSNxo3tihCaOyrksSt1qopy5cfU9HPeGqxYX3lhD6sxVq6?=
 =?us-ascii?Q?Zn3lkHOrzRF+HqOUjqsHm5By2IdGir61ucurImas3N8gjzorFGH4PtdAzgXv?=
 =?us-ascii?Q?IORiySf9Jhao23bvdnMCmbkH6O5FQs5fx2dQ+Lc3t/eU8wYhKf2wh1GmlNjB?=
 =?us-ascii?Q?1e6RJaLsokBGuSWcSKXrN4c3z38qS7fN/Iplgr6uea8TE7/TNoU8U+BNYDVA?=
 =?us-ascii?Q?2kztXwtb1H/05bn4y2wC5DSLIY10najSuTbkxGq89rLwwPhhitO0M5ZcSm7L?=
 =?us-ascii?Q?axsO7YTWz3Loobl/bsWkYj69axIvtKqJH3nUcaw4k7ixqcZleiNKBPgYOFHW?=
 =?us-ascii?Q?QUFp9LA1+QCd42xnAQxlfaE4WZo+HgDpns+zrBe33jxSkOoT/6daiek9bQvm?=
 =?us-ascii?Q?z0QgNBwkmGRdyiJbzDPVJABamwIBQlgS6QGC8PCdQNiS646tODBgZZRkAk/C?=
 =?us-ascii?Q?OE0cOBjfKg04yI2U4vdnsLsxhWnvD0BOJsFtXgxq2MCHOZhmC6VG7IivUZHa?=
 =?us-ascii?Q?CsqVf7AQNho/e4xixq2uFvqQLZ+wW7QehyfTp51rDa8cTxxX7qPPVldtf1AA?=
 =?us-ascii?Q?km6ebArAWM1FKufh4/osKtrk/aPkcJzrhMbNklI3r47HawWKxn+HzcqUj2gM?=
 =?us-ascii?Q?3y36q6+8leLyHFrPeb6oUalFhUR1rHMrl8iMsR0LEzEcNtWvodenfwCHDetW?=
 =?us-ascii?Q?NwZavArFlEOFNm9VOChe3+GzCABFddSbr4yB4ZwY6Bkx7WZzAwhHuQ2leHUX?=
 =?us-ascii?Q?FOE6N7NmpVZJD40A1YADKpcPm4CdFIY3tvQbAGN0FlCwdecvp47eSq0M1sJj?=
 =?us-ascii?Q?NPjMugI0pbzmQRVAytuCHBLP1MH25ZoLgFqz2ThNZh1Cttyg95TcVW4OEKF+?=
 =?us-ascii?Q?NBlsHQX1SuJ+IcxWU7kQurkRDOARzSEOW8tle9Ny2RB42i83/yCweI+YpNfZ?=
 =?us-ascii?Q?eNaGJy4g9gq/dKs5lOkqTqFp?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EFE0D085496BBC498B5F79E45779EEEA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb9f26f-16d8-4a80-d113-08d8d8c6f2cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 13:20:25.9591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LC4LY1/gk9iB3MAgTz0vEBJFk92n1Fs1ePna/yXZ3t3/LZywSmhOfglsGCSzPfENx6MkPqR7/f8d0t353uEhSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4464
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=782 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240103
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 24, 2021, at 5:26 AM, Mel Gorman <mgorman@techsingularity.net> wro=
te:
>=20
> This is a prototype series that introduces a bulk order-0 page allocator
> with sunrpc being the first user. The implementation is not particularly
> efficient and the intention is to iron out what the semantics of the API
> should be. That said, sunrpc was reported to have reduced allocation
> latency when refilling a pool.
>=20
> As a side-note, while the implementation could be more efficient, it
> would require fairly deep surgery in numerous places. The lock scope woul=
d
> need to be significantly reduced, particularly as vmstat, per-cpu and the
> buddy allocator have different locking protocol that overal -- e.g. all
> partially depend on irqs being disabled at various points. Secondly,
> the core of the allocator deals with single pages where as both the bulk
> allocator and per-cpu allocator operate in batches. All of that has to
> be reconciled with all the existing users and their constraints (memory
> offline, CMA and cpusets being the trickiest).
>=20
> In terms of semantics required by new users, my preference is that a pair
> of patches be applied -- the first which adds the required semantic to
> the bulk allocator and the second which adds the new user.
>=20
> Patch 1 of this series is a cleanup to sunrpc, it could be merged
> 	separately but is included here for convenience.
>=20
> Patch 2 is the prototype bulk allocator
>=20
> Patch 3 is the sunrpc user. Chuck also has a patch which further caches
> 	pages but is not included in this series. It's not directly
> 	related to the bulk allocator and as it caches pages, it might
> 	have other concerns (e.g. does it need a shrinker?)
>=20
> This has only been lightly tested on a low-end NFS server. It did not bre=
ak
> but would benefit from an evaluation to see how much, if any, the headlin=
e
> performance changes. The biggest concern is that a light test case showed
> that there are a *lot* of bulk requests for 1 page which gets delegated t=
o
> the normal allocator.  The same criteria should apply to any other users.
>=20
> include/linux/gfp.h   |  13 +++++
> mm/page_alloc.c       | 113 +++++++++++++++++++++++++++++++++++++++++-
> net/sunrpc/svc_xprt.c |  47 ++++++++++++------
> 3 files changed, 157 insertions(+), 16 deletions(-)

Hi Mel-

Thank you for carrying the torch!


--
Chuck Lever



