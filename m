Return-Path: <netdev+bounces-191-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F1F6F5D0C
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 19:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E40DB1C20F59
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 17:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E8C27711;
	Wed,  3 May 2023 17:30:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83F62770E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 17:30:26 +0000 (UTC)
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586E1AC
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 10:30:19 -0700 (PDT)
Received: from 104.47.7.175_.trendmicro.com (unknown [172.21.174.129])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id DD93D10000D06;
	Wed,  3 May 2023 17:30:17 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1683135016.825000
X-TM-MAIL-UUID: b4869cbe-9fec-42e3-b547-6135dce0a99d
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.175])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id C9B7B1000030B;
	Wed,  3 May 2023 17:30:16 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k04Li3bDwDJ4mpK94xWGaWfYGaYMibJ8qjAtGeVZCjLaYXXRw1yufT/agNqbCsBwxdvN7vM5kAh11kIPe1Rv0eDFAhyBAr8C2sYS9XpRHKyLuLoNJQj07fHdtfAlkuJXip5AJ+w+WlH9NhSidCxoTM6hi4ADNstfem6H16mfZtSARguHrnduILeOn639JZfSwD4ZqrVay9x/af9+vrV//ZSa7leFt1IVxy1knbyuS6feAnBPhF5CkdsnGmNZi+gvKyej+a2r0A5QZ8I8wN3gXO06JMo6TUw00FhpcJCsHGnSEXdrxs8Mejva158uFur7rYn+rYhLiS+n3VGnZMybHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mttyDaM3Ex6RoOPdcxAPJrp0de6lm5H7rnT63dy4K8Q=;
 b=QcN1WHVaOjRGokAFmJ/60bMvlJAFJPoEaczxsm/He85ul5/ncTICMOcXnbV6wvwvx/VqbUh/a+IP5sY5ue7XRAAu/HwdyxXKarC+D6sVmTm/HLWwRGxljv8NxF8U35MDA2K0fWtZUuJzrHxMc+rh2LWFc8L2iErEqA0L2kXCu5rtKQH6QOiXFERC1dhxcHoPnk13FsRnLUJMpia7xSqwDkdS/8hURyicR25y734n1zmAKTUzYTXhtY8xlyfjSSUGwm62igpTaFqD3Ws75wZZPTLWhkItWpi9FuKfcAD4DULLqkR+MUhgRy6j6Yoovqg6X5haVxq4GFrYyXIYba8CQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <5e2fce6c-764a-0146-c7e8-004cefec461d@opensynergy.com>
Date: Wed, 3 May 2023 19:30:12 +0200
From: Harald Mommer <harald.mommer@opensynergy.com>
Subject: Re: [RFC PATCH v2] can: virtio: Initial virtio CAN driver.
References: <20230421145653.12811-1-Mikhail.Golubev-Ciuchea@opensynergy.com>
 <20230424-footwear-daily-9339bd0ec428-mkl@pengutronix.de>
Content-Language: en-US
To: Marc Kleine-Budde <mkl@pengutronix.de>,
 Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
Cc: virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Wolfgang Grandegger <wg@grandegger.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230424-footwear-daily-9339bd0ec428-mkl@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P251CA0021.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::26) To FR0P281MB3403.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:53::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR0P281MB3403:EE_|FR2P281MB1637:EE_
X-MS-Office365-Filtering-Correlation-Id: cc7d756d-28bf-4707-bc3f-08db4bfc0e48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HCuHiVF0Y4qlqGsjDtMO6QR5LrhiigjzahIm2qEwm04evFvIj2+q9V0L76H140U00WpgHCP4hO2gFaYszbJEA+6fBp/VJzujhpfDlgSVNBpLiFmk+AQ4VOUuWbZVaJlzYEJcj3sokeC4BJ+P3Pq+EiRr8WKzSy7ulODpIettnFnj4f++/VwokF+WWmA5NVagwXTnNBKbwzA7AGBl8RpmkxIHQ8yCBntIx0chVJX2tYfj532DRtOV+JtC73j1et9sqS55EbqghpUN4VawfmH8LUpf9lLQqUDCuK1ONGCPwx4ib6qEDsiBg3wmwfknZ563LaEt1tmtnaAknQsLSQb4RZcSDyqiZIcf8bCsQ0zKt2XFIidYIaLg2QCJ5wg+/6JX/50TOCPIZDez+Qj7PfUkmRazjJxtNM3nM4tqdVIJG8tH9bG8v0+RsDfY/DDOqLJqWepO1UlOD1R/z0gPXMJGFX2kLeA0UG07nx9YpLa/omxquDyrB1NzdywljYKRVvYMME/Ig18rpH7Abgb+W7+LICU+0aSnW8S85uxVN5TA2ec=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR0P281MB3403.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(39830400003)(346002)(136003)(451199021)(36756003)(38100700002)(83380400001)(31686004)(26005)(186003)(53546011)(2616005)(966005)(30864003)(110136005)(54906003)(42186006)(478600001)(8936002)(41300700001)(66946007)(4326008)(66556008)(66476007)(6636002)(86362001)(31696002)(8676002)(44832011)(2906002)(5660300002)(316002)(7416002)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDl3RUE2SzlsM2g0eEQ3VXJWTmE4KzZqNGdmNnRpYklnQjBrY0V4UUJ2Q2to?=
 =?utf-8?B?cE0zT0hjQjYwNVhkbjBkaEhtK3NYM2MvTHZXNXpNN1ZCckNuYWtsdHR2bU9J?=
 =?utf-8?B?RVIwWHlZUDEvdlNpQXF1RXBjczF2c2xsQ3dFTjBySFRpc1pSSkJWQXBhQjJY?=
 =?utf-8?B?dEwwKzgwR25tUnRhS1F5Q090SXFzeVdUb1ByR0laWksvZUV4VG5zMS8xYUNy?=
 =?utf-8?B?OE5QVThMOWNTOEl2ZVNZQXVtR1poenoyQzFKNzFMUFNkbHVXRkNEdURFYWtQ?=
 =?utf-8?B?ZkZDSG1mZ1RReXlhbmFoWEFZZENGWER0V2hEKzhMdUh1M0txUkRuNzBSS3dv?=
 =?utf-8?B?NDkrR1g5WTV3YlFzME12dklHbkNpZjlkVHhJbVhpbmpuRGwwcUx0VjBwTFJa?=
 =?utf-8?B?dklWSXZ5UFNDdER5S0FJL1pGSlZIWmVZRFovMGlXalczSWExYXdsYUhBbDhM?=
 =?utf-8?B?bHVMSFRybS9hNXdOWTJXV242MFZzVHMvU0FEcTN3OTgzSEFmemxFMTk2Q2xx?=
 =?utf-8?B?clR3T1VWa3ZXemlTZXBhM2xCa1NkVE9oM3J5WmFaQW9jT0JqNkE3clBQK2ZN?=
 =?utf-8?B?TitkNERLMUNRQ1BkclFqUitZYTdGYlF5cWx0STZHRmxtSFhWQ2lSVU4xZVVx?=
 =?utf-8?B?Mys1QytsbUlibUI3Rmo0bnFSQUJzZ2dvajczNUtUUjFEdSt1VXFKMGo3WGQ1?=
 =?utf-8?B?STFxM00xd21MVzhOcStPUXNYNUVYQ3FQMlJXM05ycUdFd0t0YVRrT2tmZkxK?=
 =?utf-8?B?c1VOOFV2UFk5QVhOeFNScDZmRVFuR2pJZWxzNHViTHFDM3BPREY0L0ZKM3k2?=
 =?utf-8?B?WEdaUDFBeWJ3VkpySUpJdGdsazRXaUU4SHRIQitUSEppSXdsYjdWcEJFdGhr?=
 =?utf-8?B?OGduVi8yeEFQM21SczBSbWJtWHI0NFEwK3dKNjAzbTIyZ1I0ajVjc1VvbFlj?=
 =?utf-8?B?WUViRmkrMUhOdDRRVDd3Qlc4Y21xcmVFMkI4K3VjZEZlcTlLdlJISWpBNlA5?=
 =?utf-8?B?VURLZnlreGJLb2U5SmMza3FmdHBvdTVhL1ZGNjNoZldoZndMeG9ScG51cmlT?=
 =?utf-8?B?ampCRFJZN1hLRm9NeUk0VU1ZVUh3OGZiWUtIL3JCS05jOEVYUUdwKzRIZ1FK?=
 =?utf-8?B?Ym1EY0Q5Z0pJeC9sSGExMS9QVVJkUmJQWFdzMDBCQ25heUNVL2xsWFAzcTNl?=
 =?utf-8?B?THdGcWNnYi8wL1NPRjRhc3A2SE45OUFkbno1eTljUytPeHpMc0NHeWZEN3E1?=
 =?utf-8?B?djgzRVRLWlp5VFhUNW5zRE5iSHM0TWd6dVhaY3hRTzFONnpBZVJUSjMrSVFD?=
 =?utf-8?B?YjRJV1FzcGNObVdxZ25nZ25OeDRTZ1JOd1lXMjFFcWxxYXk5NDhWbktxSWFF?=
 =?utf-8?B?ajJ4UnNhVktmUC91eTc1N2dMRktZT3pxdTlUTURWK3Zjc0Q0QytObTJlU1g0?=
 =?utf-8?B?ZUhGNHZKTXlqUGFBT04zeGdGOU50K1pWZ1VlWDNNY2gwMU1QR1lFQmZDanhD?=
 =?utf-8?B?elVrendGT2tUMHgzUkJKZUNLNll2WU9wZm53Nm9HNENBUEVUenNkSEJpb1c5?=
 =?utf-8?B?MGlPNFowTkpCeHhjSmtXaHkzdDNqSGpMc0I3VkNFTTFXYlA2Qlk1SjYzV0da?=
 =?utf-8?B?TXJBTE9tSGowMmVaVnZtcXEvVzd5dUVzWS8wcXE3eG5nQ1B2T0IxaXJ5cTVO?=
 =?utf-8?B?Nm5qM2lXMmh0R1dWTkp2ZnlUR0ZvdkpudkFqMHlCZjA2SHRuMGQ4elAxS1lr?=
 =?utf-8?B?RFlnSnQzb2wrQysyenc5Tk5oY3lKYVVNWEpGWWtZWUQwOUNLbjJiU2ZKQ3RX?=
 =?utf-8?B?VFVPZk82ZjBzVm9uWGtlMzNiczEraHVwTzFwdmJBL0RvaE9PSVVjc2VycUhQ?=
 =?utf-8?B?MU5CbmcrNzdIMjQvUm13TEpaaVpwOGVCNVNTTmo3YjV5b2oyVnVqU3FYUHRH?=
 =?utf-8?B?clB4Y2lOdXEvV2w5MGNEUGJJRWh6V1RFeHMzVm1ockV2U0JzLy8xazFxMlpX?=
 =?utf-8?B?TlZQQWpyczE2L29RNzhhaDNoSENaeEtuTldSRFQ0ZEpST1pBbjVNd1Jsd3ZY?=
 =?utf-8?B?bEJhRGxWSUpBWGZyZUxRekl5Sms5QmYySDNVYnVhTytNZTR3R1JUbXN3amdK?=
 =?utf-8?Q?OdZYAT5gAP5MwyxUb+cyqjLDZ?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7d756d-28bf-4707-bc3f-08db4bfc0e48
X-MS-Exchange-CrossTenant-AuthSource: FR0P281MB3403.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 17:30:14.8569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xY/kD1D9ycQE3m6+z4hdTjq/g7NPPpSQOPWkpklc96cUQ/2lew3EfDwXMXagfUN94N109RSywEzPSArF5kBxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB1637
X-TM-AS-ERS: 104.47.7.175-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1007-27604.000
X-TMASE-Result: 10--26.298800-4.000000
X-TMASE-MatchedRID: jFqw+1pFnMywzFuyya2WsK5i3jK3KDOot3aeg7g/usDLN5nQQXYmEnQi
	GZe0jWAMwl2cYXxQkIHCnfj2t9y5LBLmJd2F/yFu2Sa33ZGXWdZN8rmPQRlvK44YPFy+no7QfMZ
	9Z21cFRybtw2XfFPBnJk0QsjIISGAsNZy551oc7fFVAV8vDjN/0qAhuLHn5fEHOUhijZNQhuvek
	lZ9sa6cW4zM+bnKiiVCdLNFi5rjkB0c2Jq7zcO7U7nLUqYrlslFIuBIWrdOeMkKSeU/Y3qfAl+H
	yAcPie7c8G/amkXuJM0WUhIBZM4pUwYXRRr2ymntw+xHnsmQjP0swHSFcVJ6J4Q+L3BXIWuSUy3
	4bcFHJuFUd/pWRRSnibpppeK26UcLT4SwCkKtFGuW2+UBGEpHR6OXxdRGLx8QcU8dj0/qVE4zub
	ZisoWTH4n+j7L37FSKgH3zFtFSVDJXrzb/C9WHK+/qoWUv5IZxmJ6Bfwk3mVTy6c1YDoDBOzHNV
	saiyNEvs75gcY5ey6SoRHgQxWMzlq/w+Qp55pkKwi7MItzaY3T2VrdfuNrJiXOD7ucKRbIdhhLQ
	h0EWTvaU73B0kiPBU/A96FQATYhIQJt3nwJw/DwlvzzUUaf2bcKVIr9tQwN6Mw4RnkAvRKtSdBR
	2Mbq9dVlqJcPf47wSK3kZjikmpbMREV2LIMX6N9JA2lmQRNUkos2tunL8DSwuKAMD8Wm9SISqXF
	fARUwGH1KCmCC3rjI8wvS+OLuVxcxrn+mxO3T8MPuu+RzTf4hauGyjTkf9bwYtb0g7YwtPe8xAl
	mWtaO/CU9ohIHhuD5ulPX+hurIDwsoidZSmzx+yskgwrfsCyH5xd1Wn9PCmyiLZetSf8my5/tFZ
	u9S3Ku6xVHLhqfx33fj+sMArfMaMUyeC0staEkVAPr0TXS8
X-TMASE-XGENCLOUD: a9beded2-15d2-4068-b0a2-6faef6f579ad-0-0-200-0
X-TM-Deliver-Signature: 8BFFB09C4174A7742A913BC39FECDEED
X-TM-Addin-Auth: QV6oa4XSBgSvsu62x/zdtg7ukHpVetAtYhvZMkSgyelCkMV4+Cp5PFCthWc
	NLwIq+JOs8Uex6WIWPfLWXfswXwVOceAQW2+W+bXW1UtoP4o1fiRnAgeEz7XcjXmDcZPA6er1nW
	nY2eeMnqBssCtIYH+2nJ4NNOh4NUw7qn6PR0s//tBzmsqIZywZDlQk3MiSNlC/6V0hXU+tg9KFL
	s0CGk97Q8pWVNLGMOAPfI0RY4KNMGSLXMqz5tu1+vT3St17QqQvyRUNbnwUK9AhyXV3mcZRy0Ns
	psH1Lr22xLSXo+E=.c8CeiMwOGPC7wQt1Kim6nt7rIDYe9DPs4Dsk8qABdXNNfa8xlGXd6gJtrD
	ktUEuVB9/gkLbRa0AnN2Yli3wprrVIpBi7BtcntGDhVrDXc/ZiDyL4q6p0ps54gp4kL/6VuIT+y
	4g5a/W79Os4TfONlTtKPz2lzWJMQOLdrkruy9ipRRydEaH9otFx6JWUjGBTdlpcxoLKdQ9+D8H6
	RoeYs/4HD0YunbZDKGexb2APsythB5fKbzxXqLuDdGcH7fDJT7B4tpREHqfkZX1O9AnY2thJj74
	oZUctagjGl1B45SURpZdXT3G9TUZsbsWvhikiSca2EkH1DRqAmoYy63DFPQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1683135017;
	bh=fPVvdm+WbO8OwB+h6lD67mfFazi30owUdkREwa8CNMQ=; l=43593;
	h=Date:From:To;
	b=hDOHoJBYfxrFGyODK4i+2w6kSWLh0dpcuTAkj0tuPaghG0zeWpZDHJwURIUSUGeix
	 KejKtBVRWv/8XkjEjGtPg829qqwTXpYJI8v30By98biO4ZC7nGu7QAjBEiPffEk83C
	 5gOLGRJJCEtfvuS7WE9rL9IC65yZEes46r61iTGoNpmmNa4eSJzmmeCbuQprirrz5X
	 P4uK09N1vEnVh6ep4QxFCiJV9SREvJLfg08jgL/TuEBTOt7itoSGCdsusKb91mqHwq
	 NkVHGxPN5y3/86BXpe2Zs6vU0hGa6GsWkDZaHp19WcmtLLVYVk+v5XRawAdOHDq3NX
	 5uN4B+SCF6Gsw==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 24.04.23 21:02, Marc Kleine-Budde wrote:
> Please don't use unicode chars:
>
> | WARNING: Message contains suspicious unicode control characters!
> |          Subject: [RFC PATCH v2] can: virtio: Initial virtio CAN driver.
> |             Line: +     __le16 length; /* 0..8 CC, 0..64 CANFD, 0..2048 CANXL, 12 bits */
> |             --------------------------------------------^
> |             Char: SOFT HYPHEN (0xad)
>
Patch already provided by you.
> Please fix this warning:
>
> | drivers/net/can/virtio_can.c:350:35: warning: incorrect type in assignment (different base types)
> | drivers/net/can/virtio_can.c:350:35:    expected restricted __le16 [usertype] length
> | drivers/net/can/virtio_can.c:350:35:
> | got unsigned int [assigned] [usertype] len

Patch already provided by you.

> For now I've only looked at the xmit function.
>
>> ---
>>
>> V2:
>> * Remove the event indication queue and use the config space instead, to
>>    indicate a bus off condition
>> * Rework RX and TX messages having a length field and some more fields for CAN
>>    EXT
>> * Fix CAN_EFF_MASK comparison
>> * Remove MISRA style code (e.g. '! = 0u')
>> * Remove priorities leftovers
>> * Remove BUGONs
>> * Based on virtio can spec RFCv3
> Can you post a link to the RFC?
When we have it ready for sending we will do and this should happen ASAP.
> Please sort by CONFIG symbols in the Makefile, see below.
Patch already provided by you.
>>   source "drivers/net/can/c_can/Kconfig"
>>   source "drivers/net/can/cc770/Kconfig"
>>   source "drivers/net/can/ctucanfd/Kconfig"
>> diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
>> index 52b0f6e10668..d31949052acf 100644
>> --- a/drivers/net/can/Makefile
>> +++ b/drivers/net/can/Makefile
>> @@ -30,5 +30,6 @@ obj-$(CONFIG_CAN_SJA1000)	+= sja1000/
>>   obj-$(CONFIG_CAN_SUN4I)		+= sun4i_can.o
>>   obj-$(CONFIG_CAN_TI_HECC)	+= ti_hecc.o
>>   obj-$(CONFIG_CAN_XILINXCAN)	+= xilinx_can.o
>> +obj-$(CONFIG_CAN_VIRTIO_CAN)	+= virtio_can.o
> Please keep this files sorted alphabetically.
Patch already provided by you.
>>   subdir-ccflags-$(CONFIG_CAN_DEBUG_DEVICES) += -DDEBUG
>> diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c
>> new file mode 100644
>> index 000000000000..23f9c1b6446d
>> --- /dev/null
>> +++ b/drivers/net/can/virtio_can.c
>> @@ -0,0 +1,1060 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * CAN bus driver for the Virtio CAN controller
>> + * Copyright (C) 2021-2023 OpenSynergy GmbH
>> + */
>> +
>> +#include <linux/atomic.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/stddef.h>
>> +#include <linux/can/dev.h>
>> +#include <linux/virtio.h>
>> +#include <linux/virtio_ring.h>
>> +#include <linux/virtio_can.h>
>> +
>> +/* CAN device queues */
>> +#define VIRTIO_CAN_QUEUE_TX 0 /* Driver side view! The device receives here */
>> +#define VIRTIO_CAN_QUEUE_RX 1 /* Driver side view! The device transmits here */
>> +#define VIRTIO_CAN_QUEUE_CONTROL 2
>> +#define VIRTIO_CAN_QUEUE_COUNT 3
>> +
>> +#define CAN_KNOWN_FLAGS \
>> +	(VIRTIO_CAN_FLAGS_EXTENDED |\
>> +	 VIRTIO_CAN_FLAGS_FD |\
>> +	 VIRTIO_CAN_FLAGS_RTR)
>> +
>> +/* Max. number of in flight TX messages */
>> +#define VIRTIO_CAN_ECHO_SKB_MAX 128
>> +
>> +struct virtio_can_tx {
>> +	struct list_head list;
>> +	int putidx;
>> +	struct virtio_can_tx_out tx_out;
>> +	struct virtio_can_tx_in tx_in;
>> +};
>> +
>> +/* virtio_can private data structure */
>> +struct virtio_can_priv {
>> +	struct can_priv can;	/* must be the first member */
>> +	/* NAPI for RX messages */
>> +	struct napi_struct napi;
>> +	/* NAPI for TX messages */
>> +	struct napi_struct napi_tx;
>> +	/* The network device we're associated with */
>> +	struct net_device *dev;
>> +	/* The virtio device we're associated with */
>> +	struct virtio_device *vdev;
>> +	/* The virtqueues */
>> +	struct virtqueue *vqs[VIRTIO_CAN_QUEUE_COUNT];
>> +	/* I/O callback function pointers for the virtqueues */
>> +	vq_callback_t *io_callbacks[VIRTIO_CAN_QUEUE_COUNT];
>> +	/* Lock for TX operations */
>> +	spinlock_t tx_lock;
>> +	/* Control queue lock. Defensive programming, may be not needed */
>> +	struct mutex ctrl_lock;
>> +	/* Wait for control queue processing without polling */
>> +	struct completion ctrl_done;
>> +	/* List of virtio CAN TX message */
>> +	struct list_head tx_list;
>> +	/* Array of receive queue messages */
>> +	struct virtio_can_rx rpkt[128];
>> +	/* Those control queue messages cannot live on the stack! */
>> +	struct virtio_can_control_out cpkt_out;
>> +	struct virtio_can_control_in cpkt_in;
>> +	/* Data to get and maintain the putidx for local TX echo */
>> +	struct list_head tx_putidx_free;
>> +	struct list_head *tx_putidx_list;
> Can you please explain the big picture on tx_putidx_list. The "struct
> list_head" is supposed to be embedded in some kind of struct, it makes
> little sense to use them on their own.

This is used to generate efficiently a tx index between 0 and 
VIRTIO_CAN_ECHO_SKB_MAX - 1 in function virtio_can_alloc_tx_idx(). Get 
next element and determine the position in the array to get an index. 
The index is put back in put back the tx_idx in virtio_can_free_tx_idx().

Learned now that there are kernel functions already to do exactly what I 
need.

https://www.kernel.org/doc/html/v5.0/core-api/idr.html#c.idr_init

Going to use ida_init(), ida_alloc_range(), ida_free() and ida_destroy() 
to replace those strange looking linked lists. As I now learned that 
there is already kernel provided functionality I would otherwise get a 
valid new review comment "use kernel provided functionality".
>> +	/* In flight TX messages */
>> +	atomic_t tx_inflight;
>> +	/* Max. In flight TX messages */
>> +	u16 tx_limit;
>> +	/* BusOff pending. Reset after successful indication to upper layer */
>> +	bool busoff_pending;
>> +};
>> +
>> +/* Function copied from virtio_net.c */
>> +static void virtqueue_napi_schedule(struct napi_struct *napi,
>> +				    struct virtqueue *vq)
>> +{
>> +	if (napi_schedule_prep(napi)) {
>> +		virtqueue_disable_cb(vq);
>> +		__napi_schedule(napi);
>> +	}
>> +}
>> +
>> +/* Function copied from virtio_net.c */
>> +static void virtqueue_napi_complete(struct napi_struct *napi,
>> +				    struct virtqueue *vq, int processed)
>> +{
>> +	int opaque;
>> +
>> +	opaque = virtqueue_enable_cb_prepare(vq);
>> +	if (napi_complete_done(napi, processed)) {
>> +		if (unlikely(virtqueue_poll(vq, opaque)))
>> +			virtqueue_napi_schedule(napi, vq);
>> +	} else {
>> +		virtqueue_disable_cb(vq);
>> +	}
>> +}
>> +
>> +static void virtio_can_free_candev(struct net_device *ndev)
>> +{
>> +	struct virtio_can_priv *priv = netdev_priv(ndev);
>> +
>> +	kfree(priv->tx_putidx_list);
>> +	free_candev(ndev);
>> +}
>> +
>> +static int virtio_can_alloc_tx_idx(struct virtio_can_priv *priv)
>> +{
>> +	struct list_head *entry;
>> +
>> +	if (atomic_read(&priv->tx_inflight) >= priv->can.echo_skb_max)
>> +		return -1; /* Not expected to happen */
> Please use proper return values.
You probably want to see here -ENOSPC which is what ida_alloc_range() 
would return.
>> +
>> +	atomic_add(1, &priv->tx_inflight);
>> +
>> +	if (list_empty(&priv->tx_putidx_free))
>> +		return -1; /* Not expected to happen */
> Please use proper return values.
>
>> +
>> +	entry = priv->tx_putidx_free.next;
> This looks wrong, you want to use list_first_entry.

Checked and found the code to be correct. Anyway, with kernel provided 
IDA this line will disappear.

>> +	list_del(entry);
>> +
>> +	return entry - priv->tx_putidx_list;
>> +}
>> +
>> +static void virtio_can_free_tx_idx(struct virtio_can_priv *priv, int idx)
>> +{
>> +	if (idx >= priv->can.echo_skb_max) {
>> +		WARN_ON(true); /* Not expected to happen */
>> +		return;
>> +	}
>> +	if (atomic_read(&priv->tx_inflight) == 0) {
>> +		WARN_ON(true); /* Not expected to happen */
>> +		return;
>> +	}
>> +
>> +	list_add(&priv->tx_putidx_list[idx], &priv->tx_putidx_free);
>> +	atomic_sub(1, &priv->tx_inflight);
>> +}
Will use ida_free() withing virtio_can_free_tx_idx().
>> +
>> +/* Create a scatter-gather list representing our input buffer and put
>> + * it in the queue.
>> + *
>> + * Callers should take appropriate locks.
>> + */
>> +static int virtio_can_add_inbuf(struct virtqueue *vq, void *buf,
>> +				unsigned int size)
>> +{
>> +	struct scatterlist sg[1];
>> +	int ret;
>> +
>> +	sg_init_one(sg, buf, size);
>> +
>> +	ret = virtqueue_add_inbuf(vq, sg, 1, buf, GFP_ATOMIC);
>> +	virtqueue_kick(vq);
>> +	if (ret == 0)
>> +		ret = vq->num_free;
>> +	return ret;
>> +}
>> +
>> +/* Send a control message with message type either
>> + *
>> + * - VIRTIO_CAN_SET_CTRL_MODE_START or
>> + * - VIRTIO_CAN_SET_CTRL_MODE_STOP.
>> + *
>> + * Unlike AUTOSAR CAN Driver Can_SetControllerMode() there is no requirement
>> + * for this Linux driver to have an asynchronous implementation of the mode
>> + * setting function so in order to keep things simple the function is
>> + * implemented as synchronous function. Design pattern is
>> + * virtio_console.c/__send_control_msg() & virtio_net.c/virtnet_send_command().
>> + */
>> +static u8 virtio_can_send_ctrl_msg(struct net_device *ndev, u16 msg_type)
>> +{
>> +	struct virtio_can_priv *priv = netdev_priv(ndev);
>> +	struct device *dev = &priv->vdev->dev;
>> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
>> +	struct scatterlist sg_out[1];
>> +	struct scatterlist sg_in[1];
>> +	struct scatterlist *sgs[2];
>> +	int err;
>> +	unsigned int len;
>> +
>> +	/* The function may be serialized by rtnl lock. Not sure.
>> +	 * Better safe than sorry.
>> +	 */
>> +	mutex_lock(&priv->ctrl_lock);
>> +
>> +	priv->cpkt_out.msg_type = cpu_to_le16(msg_type);
>> +	sg_init_one(&sg_out[0], &priv->cpkt_out, sizeof(priv->cpkt_out));
>> +	sg_init_one(&sg_in[0], &priv->cpkt_in, sizeof(priv->cpkt_in));
>> +	sgs[0] = sg_out;
>> +	sgs[1] = sg_in;
>> +
>> +	err = virtqueue_add_sgs(vq, sgs, 1u, 1u, priv, GFP_ATOMIC);
>> +	if (err != 0) {
>> +		/* Not expected to happen */
>> +		dev_err(dev, "%s(): virtqueue_add_sgs() failed\n", __func__);
>> +	}
>> +
>> +	if (!virtqueue_kick(vq)) {
>> +		/* Not expected to happen */
>> +		dev_err(dev, "%s(): Kick failed\n", __func__);
>> +	}
>> +
>> +	while (!virtqueue_get_buf(vq, &len) && !virtqueue_is_broken(vq))
>> +		wait_for_completion(&priv->ctrl_done);
>> +
>> +	mutex_unlock(&priv->ctrl_lock);
>> +
>> +	return priv->cpkt_in.result;
>> +}
>> +
>> +static void virtio_can_start(struct net_device *ndev)
>> +{
>> +	struct virtio_can_priv *priv = netdev_priv(ndev);
>> +	u8 result;
>> +
>> +	result = virtio_can_send_ctrl_msg(ndev, VIRTIO_CAN_SET_CTRL_MODE_START);
>> +	if (result != VIRTIO_CAN_RESULT_OK) {
>> +		/* Not expected to happen */
>> +		netdev_err(ndev, "CAN controller start failed\n");
>> +	}
>> +
>> +	priv->busoff_pending = false;
>> +	priv->can.state = CAN_STATE_ERROR_ACTIVE;
>> +
>> +	/* Switch carrier on if device was not connected to the bus */
>> +	if (!netif_carrier_ok(ndev))
>> +		netif_carrier_on(ndev);
>> +}
>> +
>> +/* See also m_can.c/m_can_set_mode()
>> + *
>> + * It is interesting that not only the M-CAN implementation but also all other
>> + * implementations I looked into only support CAN_MODE_START.
>> + * That CAN_MODE_SLEEP is frequently not found to be supported anywhere did not
>> + * come not as surprise but that CAN_MODE_STOP is also never supported was one.
>> + * The function is accessible via the method pointer do_set_mode in
>> + * struct can_priv. As usual no documentation there.
>> + * May not play any role as grepping through the code did not reveal any place
>> + * from where the method is actually called.
>> + */
>> +static int virtio_can_set_mode(struct net_device *dev, enum can_mode mode)
>> +{
>> +	switch (mode) {
>> +	case CAN_MODE_START:
>> +		virtio_can_start(dev);
>> +		netif_wake_queue(dev);
>> +		break;
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* Called by issuing "ip link set up can0" */
>> +static int virtio_can_open(struct net_device *dev)
>> +{
>> +	/* start the virtio_can controller */
>> +	virtio_can_start(dev);
>> +
>> +	/* RX and TX napi were already enabled in virtio_can_probe() */
>> +	netif_start_queue(dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static void virtio_can_stop(struct net_device *ndev)
>> +{
>> +	struct virtio_can_priv *priv = netdev_priv(ndev);
>> +	struct device *dev = &priv->vdev->dev;
>> +	u8 result;
>> +
>> +	result = virtio_can_send_ctrl_msg(ndev, VIRTIO_CAN_SET_CTRL_MODE_STOP);
>> +	if (result != VIRTIO_CAN_RESULT_OK)
>> +		dev_err(dev, "CAN controller stop failed\n");
>> +
>> +	priv->busoff_pending = false;
>> +	priv->can.state = CAN_STATE_STOPPED;
>> +
>> +	/* Switch carrier off if device was connected to the bus */
>> +	if (netif_carrier_ok(ndev))
>> +		netif_carrier_off(ndev);
>> +}
>> +
>> +static int virtio_can_close(struct net_device *dev)
>> +{
>> +	netif_stop_queue(dev);
>> +	/* Keep RX napi active to allow dropping of pending RX CAN messages,
>> +	 * keep TX napi active to allow processing of cancelled CAN messages
>> +	 */
>> +	virtio_can_stop(dev);
>> +	close_candev(dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
>> +					 struct net_device *dev)
>> +{
>> +	struct virtio_can_priv *priv = netdev_priv(dev);
>> +	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
>> +	struct virtio_can_tx *can_tx_msg;
>> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
>> +	struct scatterlist sg_out[1];
>> +	struct scatterlist sg_in[1];
>> +	struct scatterlist *sgs[2];
>> +	unsigned long flags;
>> +	size_t len;
>> +	u32 can_flags;
>> +	int err;
>> +	netdev_tx_t xmit_ret = NETDEV_TX_OK;
>> +	const unsigned int hdr_size = offsetof(struct virtio_can_tx_out, sdu);
>> +
>> +	if (can_dropped_invalid_skb(dev, skb))
> Use can_dev_dropped_skb() instead, see ae64438be192 "(can: dev: fix skb
> drop check, 2022-11-02)".
Patch already provided by you.
>> +		goto kick; /* No way to return NET_XMIT_DROP here */
>> +
>> +	/* Virtio CAN does not support error message frames */
>> +	if (cf->can_id & CAN_ERR_FLAG) {
>> +		kfree_skb(skb);
>> +		dev->stats.tx_dropped++;
>> +		goto kick; /* No way to return NET_XMIT_DROP here */
>> +	}
> It is not checked in any other CAN driver, please remove. We might want
> to move this into a can_dropped_invalid_skb().

Then I'll remove already for the upstream version (this here) keeping 
internally as today can_dev_dropped_skb() does not yet check for this 
even in latest.

>> +
>> +	/* No local check for CAN_RTR_FLAG or FD frame against negotiated
>> +	 * features. The device will reject those anyway if not supported.
>> +	 */
>> +
>> +	can_tx_msg = kzalloc(sizeof(*can_tx_msg), GFP_ATOMIC);
>> +	if (!can_tx_msg)
>> +		goto kick; /* No way to return NET_XMIT_DROP here */
>> +
>> +	can_tx_msg->tx_out.msg_type = cpu_to_le16(VIRTIO_CAN_TX);
>> +	can_flags = 0;
>> +	if (cf->can_id & CAN_EFF_FLAG)
>> +		can_flags |= VIRTIO_CAN_FLAGS_EXTENDED;
>> +	if (cf->can_id & CAN_RTR_FLAG)
>> +		can_flags |= VIRTIO_CAN_FLAGS_RTR;
>> +	if (can_is_canfd_skb(skb))
>> +		can_flags |= VIRTIO_CAN_FLAGS_FD;
>> +	can_tx_msg->tx_out.flags = cpu_to_le32(can_flags);
>> +	can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
> if CAN_EFF_FLAG is set use CAN_EFF_MASK, otherwise use CAN_SFF_MASK.
Patch already provided by you.
>> +	len = cf->len;
>> +	can_tx_msg->tx_out.length = len;
> = cpu_to_le16(len);
Patch already provided by you.
>> +	if (len > sizeof(cf->data))
>> +		len = sizeof(cf->data);
>> +	if (len > sizeof(can_tx_msg->tx_out.sdu))
>> +		len = sizeof(can_tx_msg->tx_out.sdu);
> These checks have already been done by can_dropped_invalid_skb().
Patch already provided by you.
>> +	if (!(can_flags & VIRTIO_CAN_FLAGS_RTR)) {
>> +		/* Copy if not a RTR frame. RTR frames have a DLC but no payload */
>> +		memcpy(can_tx_msg->tx_out.sdu, cf->data, len);
>> +	}
> can you move this into the RTR check above?
Patch already provided by you.
>> +
>> +	/* Prepare sending of virtio message */
>> +	sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + len);
>> +	sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg->tx_in));
>> +	sgs[0] = sg_out;
>> +	sgs[1] = sg_in;
>> +
>> +	if (atomic_read(&priv->tx_inflight) >= priv->tx_limit) {
> What is....
>
>> +		netif_stop_queue(dev);
>> +		kfree(can_tx_msg);
>> +		netdev_dbg(dev, "TX: Stop queue, tx_inflight >= tx_limit\n");
>> +		xmit_ret = NETDEV_TX_BUSY;
>> +		goto kick;
>> +	}
>> +
>> +	/* Normal queue stop when no transmission slots are left */
>> +	if (atomic_read(&priv->tx_inflight) >= priv->tx_limit) {
> ...the difference between these 2 checks?

There is a + 1 missing. Code above should never be executed due to this 
requirement (but is):

  * netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb,
  *                               struct net_device *dev);
  *    Called when a packet needs to be transmitted.
  *    Returns NETDEV_TX_OK.  Can return NETDEV_TX_BUSY, but you should stop
  *    the queue before that can happen; it's for obsolete devices and weird
  *    corner cases, but the stack really does a non-trivial amount
  *    of useless work if you return NETDEV_TX_BUSY.

>> +		netif_stop_queue(dev);
>> +		netdev_dbg(dev, "TX: Normal stop queue\n");
>> +	}
>> +
>> +	/* Protect list operations */
>> +	spin_lock_irqsave(&priv->tx_lock, flags);
>> +	can_tx_msg->putidx = virtio_can_alloc_tx_idx(priv);
>> +	list_add_tail(&can_tx_msg->list, &priv->tx_list);
>> +	spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +
>> +	if (unlikely(can_tx_msg->putidx < 0)) {
>> +		WARN_ON(true); /* Not expected to happen */
>> +		list_del(&can_tx_msg->list);
>> +		kfree(can_tx_msg);
>> +		xmit_ret = NETDEV_TX_OK;
>> +		goto kick;
>> +	}
>> +
>> +	/* Push loopback echo. Will be looped back on TX interrupt/TX NAPI */
>> +	can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
>> +
>> +	/* Protect queue and list operations */
>> +	spin_lock_irqsave(&priv->tx_lock, flags);
>> +	err = virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_ATOMIC);
>> +	if (err != 0) {

This block should not be executed when the tx_limit was calculated 
considering vq->num_free. But a can_free_echo_skb() is missing somewhere 
here in this block.

>> +		list_del(&can_tx_msg->list);
>> +		virtio_can_free_tx_idx(priv, can_tx_msg->putidx);
>> +		spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +		netif_stop_queue(dev);
>> +		kfree(can_tx_msg);
>> +		if (err == -ENOSPC)
>> +			netdev_dbg(dev, "TX: Stop queue, no space left\n");
>> +		else
>> +			netdev_warn(dev, "TX: Stop queue, reason = %d\n", err);
>> +		xmit_ret = NETDEV_TX_BUSY;
>> +		goto kick;
>> +	}
>> +	spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +
>> +kick:
>> +	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
>> +		if (!virtqueue_kick(vq))
>> +			netdev_err(dev, "%s(): Kick failed\n", __func__);
>> +	}
>> +
>> +	return xmit_ret;
>> +}
>> +
>> +static const struct net_device_ops virtio_can_netdev_ops = {
>> +	.ndo_open = virtio_can_open,
>> +	.ndo_stop = virtio_can_close,
>> +	.ndo_start_xmit = virtio_can_start_xmit,
>> +	.ndo_change_mtu = can_change_mtu,
>> +};
>> +
>> +static int register_virtio_can_dev(struct net_device *dev)
>> +{
>> +	dev->flags |= IFF_ECHO;	/* we support local echo */
>> +	dev->netdev_ops = &virtio_can_netdev_ops;
>> +
>> +	return register_candev(dev);
>> +}
>> +
>> +/* Compare with m_can.c/m_can_echo_tx_event() */
>> +static int virtio_can_read_tx_queue(struct virtqueue *vq)
>> +{
>> +	struct virtio_can_priv *can_priv = vq->vdev->priv;
>> +	struct net_device *dev = can_priv->dev;
>> +	struct net_device_stats *stats = &dev->stats;
>> +	struct virtio_can_tx *can_tx_msg;
>> +	unsigned long flags;
>> +	unsigned int len;
>> +	u8 result;
>> +
>> +	/* Protect list and virtio queue operations */
>> +	spin_lock_irqsave(&can_priv->tx_lock, flags);
>> +
>> +	can_tx_msg = virtqueue_get_buf(vq, &len);
>> +	if (!can_tx_msg) {
>> +		spin_unlock_irqrestore(&can_priv->tx_lock, flags);
>> +		return 0; /* No more data */
>> +	}
>> +
>> +	if (unlikely(len < sizeof(struct virtio_can_tx_in))) {
>> +		netdev_err(dev, "TX ACK: Device sent no result code\n");
>> +		result = VIRTIO_CAN_RESULT_NOT_OK; /* Keep things going */
>> +	} else {
>> +		result = can_tx_msg->tx_in.result;
>> +	}
>> +
>> +	if (can_priv->can.state < CAN_STATE_BUS_OFF) {
>> +		/* Here also frames with result != VIRTIO_CAN_RESULT_OK are
>> +		 * echoed. Intentional to bring a waiting process in an upper
>> +		 * layer to an end.
>> +		 * TODO: Any better means to indicate a problem here?
>> +		 */
>> +		if (result != VIRTIO_CAN_RESULT_OK)
>> +			netdev_warn(dev, "TX ACK: Result = %u\n", result);
>> +
>> +		stats->tx_bytes += can_get_echo_skb(dev, can_tx_msg->putidx,
>> +						    NULL);
>> +		stats->tx_packets++;
>> +	} else {
>> +		netdev_dbg(dev, "TX ACK: Controller inactive, drop echo\n");
>> +		can_free_echo_skb(dev, can_tx_msg->putidx, NULL);
>> +	}
>> +
>> +	list_del(&can_tx_msg->list);
>> +	virtio_can_free_tx_idx(can_priv, can_tx_msg->putidx);
>> +
>> +	spin_unlock_irqrestore(&can_priv->tx_lock, flags);
>> +
>> +	kfree(can_tx_msg);
>> +
>> +	/* Flow control */
>> +	if (netif_queue_stopped(dev)) {
>> +		netdev_dbg(dev, "TX ACK: Wake up stopped queue\n");
>> +		netif_wake_queue(dev);
>> +	}
>> +
>> +	return 1; /* Queue was not empty so there may be more data */
>> +}
>> +
>> +/* Poll TX used queue for sent CAN messages
>> + * Seehttps://wiki.linuxfoundation.org/networking/napi  function
>> + * int (*poll)(struct napi_struct *napi, int budget);
>> + */
>> +static int virtio_can_tx_poll(struct napi_struct *napi, int quota)
>> +{
>> +	struct net_device *dev = napi->dev;
>> +	struct virtio_can_priv *priv = netdev_priv(dev);
>> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
>> +	int work_done = 0;
>> +
>> +	while (work_done < quota && virtio_can_read_tx_queue(vq) != 0)
>> +		work_done++;
>> +
>> +	if (work_done < quota)
>> +		virtqueue_napi_complete(napi, vq, work_done);
>> +
>> +	return work_done;
>> +}
>> +
>> +static void virtio_can_tx_intr(struct virtqueue *vq)
>> +{
>> +	struct virtio_can_priv *can_priv = vq->vdev->priv;
>> +
>> +	virtqueue_disable_cb(vq);
>> +	napi_schedule(&can_priv->napi_tx);
>> +}
>> +
>> +/* This function is the NAPI RX poll function and NAPI guarantees that this
>> + * function is not invoked simultaneously on multiple processors.
>> + * Read a RX message from the used queue and sends it to the upper layer.
>> + * (See also m_can.c / m_can_read_fifo()).
>> + */
>> +static int virtio_can_read_rx_queue(struct virtqueue *vq)
>> +{
>> +	struct virtio_can_priv *priv = vq->vdev->priv;
>> +	struct net_device *dev = priv->dev;
>> +	struct net_device_stats *stats = &dev->stats;
>> +	struct virtio_can_rx *can_rx;
>> +	struct canfd_frame *cf;
>> +	struct sk_buff *skb;
>> +	unsigned int transport_len;
>> +	unsigned int len;
>> +	const unsigned int header_size = offsetof(struct virtio_can_rx, sdu);
>> +	u16 msg_type;
>> +	u32 can_flags;
>> +	u32 can_id;
>> +
>> +	can_rx = virtqueue_get_buf(vq, &transport_len);
>> +	if (!can_rx)
>> +		return 0; /* No more data */
>> +
>> +	if (transport_len < header_size) {
>> +		netdev_warn(dev, "RX: Message too small\n");
>> +		goto putback;
>> +	}
>> +
>> +	if (priv->can.state >= CAN_STATE_ERROR_PASSIVE) {
>> +		netdev_dbg(dev, "%s(): Controller not active\n", __func__);
>> +		goto putback;
>> +	}
>> +
>> +	msg_type = le16_to_cpu(can_rx->msg_type);
>> +	if (msg_type != VIRTIO_CAN_RX) {
>> +		netdev_warn(dev, "RX: Got unknown msg_type %04x\n", msg_type);
>> +		goto putback;
>> +	}
>> +
>> +	len = le16_to_cpu(can_rx->length);
>> +	can_flags = le32_to_cpu(can_rx->flags);
>> +	can_id = le32_to_cpu(can_rx->can_id);
>> +
>> +	if (can_flags & ~CAN_KNOWN_FLAGS) {
>> +		stats->rx_dropped++;
>> +		netdev_warn(dev, "RX: CAN Id 0x%08x: Invalid flags 0x%x\n",
>> +			    can_id, can_flags);
>> +		goto putback;
>> +	}
>> +
>> +	if (can_flags & VIRTIO_CAN_FLAGS_EXTENDED) {
>> +		can_id &= CAN_EFF_MASK;
>> +		can_id |= CAN_EFF_FLAG;
>> +	} else {
>> +		can_id &= CAN_SFF_MASK;
>> +	}
>> +
>> +	if (can_flags & VIRTIO_CAN_FLAGS_RTR) {
>> +		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_RTR_FRAMES)) {
>> +			stats->rx_dropped++;
>> +			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR not negotiated\n",
>> +				    can_id);
>> +			goto putback;
>> +		}
>> +		if (can_flags & VIRTIO_CAN_FLAGS_FD) {
>> +			stats->rx_dropped++;
>> +			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with FD not possible\n",
>> +				    can_id);
>> +			goto putback;
>> +		}
>> +
>> +		if (len > 0xF) {
>> +			stats->rx_dropped++;
>> +			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with DLC > 0xF\n",
>> +				    can_id);
>> +			goto putback;
>> +		}
>> +
>> +		if (len > 0x8)
>> +			len = 0x8;
>> +
>> +		can_id |= CAN_RTR_FLAG;
>> +	}
>> +
>> +	if (transport_len < header_size + len) {
>> +		netdev_warn(dev, "RX: Message too small for payload\n");
>> +		goto putback;
>> +	}
>> +
>> +	if (can_flags & VIRTIO_CAN_FLAGS_FD) {
>> +		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_FD)) {
>> +			stats->rx_dropped++;
>> +			netdev_warn(dev, "RX: CAN Id 0x%08x: FD not negotiated\n",
>> +				    can_id);
>> +			goto putback;
>> +		}
>> +
>> +		if (len > CANFD_MAX_DLEN)
>> +			len = CANFD_MAX_DLEN;
>> +
>> +		skb = alloc_canfd_skb(priv->dev, &cf);
>> +	} else {
>> +		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_CLASSIC)) {
>> +			stats->rx_dropped++;
>> +			netdev_warn(dev, "RX: CAN Id 0x%08x: classic not negotiated\n",
>> +				    can_id);
>> +			goto putback;
>> +		}
>> +
>> +		if (len > CAN_MAX_DLEN)
>> +			len = CAN_MAX_DLEN;
>> +
>> +		skb = alloc_can_skb(priv->dev, (struct can_frame **)&cf);
>> +	}
>> +	if (!skb) {
>> +		stats->rx_dropped++;
>> +		netdev_warn(dev, "RX: No skb available\n");
>> +		goto putback;
>> +	}
>> +
>> +	cf->can_id = can_id;
>> +	cf->len = len;
>> +	if (!(can_flags & VIRTIO_CAN_FLAGS_RTR)) {
>> +		/* RTR frames have a DLC but no payload */
>> +		memcpy(cf->data, can_rx->sdu, len);
>> +	}
>> +
>> +	if (netif_receive_skb(skb) == NET_RX_SUCCESS) {
>> +		stats->rx_packets++;
>> +		if (!(can_flags & VIRTIO_CAN_FLAGS_RTR))
>> +			stats->rx_bytes += cf->len;
>> +	}
>> +
>> +putback:
>> +	/* Put processed RX buffer back into avail queue */
>> +	virtio_can_add_inbuf(vq, can_rx, sizeof(struct virtio_can_rx));
>> +
>> +	return 1; /* Queue was not empty so there may be more data */
>> +}
>> +
>> +/* See m_can_poll() / m_can_handle_state_errors() m_can_handle_state_change() */
>> +static int virtio_can_handle_busoff(struct net_device *dev)
>> +{
>> +	struct virtio_can_priv *priv = netdev_priv(dev);
>> +	struct can_frame *cf;
>> +	struct sk_buff *skb;
>> +
>> +	if (!priv->busoff_pending)
>> +		return 0;
>> +
>> +	if (priv->can.state < CAN_STATE_BUS_OFF) {
>> +		netdev_dbg(dev, "entered error bus off state\n");
>> +
>> +		/* bus-off state */
>> +		priv->can.state = CAN_STATE_BUS_OFF;
>> +		priv->can.can_stats.bus_off++;
>> +		can_bus_off(dev);
>> +	}
>> +
>> +	/* propagate the error condition to the CAN stack */
>> +	skb = alloc_can_err_skb(dev, &cf);
>> +	if (unlikely(!skb))
>> +		return 0;
>> +
>> +	/* bus-off state */
>> +	cf->can_id |= CAN_ERR_BUSOFF;
>> +
>> +	/* Ensure that the BusOff indication does not get lost */
>> +	if (netif_receive_skb(skb) == NET_RX_SUCCESS)
>> +		priv->busoff_pending = false;
>> +
>> +	return 1;
>> +}
>> +
>> +/* Poll RX used queue for received CAN messages
>> + * Seehttps://wiki.linuxfoundation.org/networking/napi  function
>> + * int (*poll)(struct napi_struct *napi, int budget);
>> + * Important: "The networking subsystem promises that poll() will not be
>> + * invoked simultaneously (for the same napi_struct) on multiple processors"
>> + */
>> +static int virtio_can_rx_poll(struct napi_struct *napi, int quota)
>> +{
>> +	struct net_device *dev = napi->dev;
>> +	struct virtio_can_priv *priv = netdev_priv(dev);
>> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
>> +	int work_done = 0;
>> +
>> +	work_done += virtio_can_handle_busoff(dev);
>> +
>> +	while (work_done < quota && virtio_can_read_rx_queue(vq) != 0)
>> +		work_done++;
>> +
>> +	if (work_done < quota)
>> +		virtqueue_napi_complete(napi, vq, work_done);
>> +
>> +	return work_done;
>> +}
>> +
>> +static void virtio_can_rx_intr(struct virtqueue *vq)
>> +{
>> +	struct virtio_can_priv *can_priv = vq->vdev->priv;
>> +
>> +	virtqueue_disable_cb(vq);
>> +	napi_schedule(&can_priv->napi);
>> +}
>> +
>> +static void virtio_can_control_intr(struct virtqueue *vq)
>> +{
>> +	struct virtio_can_priv *can_priv = vq->vdev->priv;
>> +
>> +	complete(&can_priv->ctrl_done);
>> +}
>> +
>> +static void virtio_can_config_changed(struct virtio_device *vdev)
>> +{
>> +	struct virtio_can_priv *can_priv = vdev->priv;
>> +	u16 status;
>> +
>> +	status = virtio_cread16(vdev, offsetof(struct virtio_can_config,
>> +					       status));
>> +
>> +	if (!(status & VIRTIO_CAN_S_CTRL_BUSOFF))
>> +		return;
>> +
>> +	if (!can_priv->busoff_pending &&
>> +	    can_priv->can.state < CAN_STATE_BUS_OFF) {
>> +		can_priv->busoff_pending = true;
>> +		napi_schedule(&can_priv->napi);
>> +	}
>> +}
>> +
>> +static void virtio_can_populate_vqs(struct virtio_device *vdev)
>> +
>> +{
>> +	struct virtio_can_priv *priv = vdev->priv;
>> +	struct virtqueue *vq;
>> +	unsigned int idx;
>> +	int ret;
>> +
>> +	/* Fill RX queue */
>> +	vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
>> +	for (idx = 0; idx < ARRAY_SIZE(priv->rpkt); idx++) {
>> +		ret = virtio_can_add_inbuf(vq, &priv->rpkt[idx],
>> +					   sizeof(struct virtio_can_rx));
>> +		if (ret < 0) {
>> +			dev_dbg(&vdev->dev, "rpkt fill: ret=%d, idx=%u\n",
>> +				ret, idx);
>> +			break;
>> +		}
>> +	}
>> +	dev_dbg(&vdev->dev, "%u rpkt added\n", idx);
>> +}
>> +
>> +static int virtio_can_find_vqs(struct virtio_can_priv *priv)
>> +{
>> +	/* The order of RX and TX is exactly the opposite as in console and
>> +	 * network. Does not play any role but is a bad trap.
>> +	 */
>> +	static const char * const io_names[VIRTIO_CAN_QUEUE_COUNT] = {
>> +		"can-tx",
>> +		"can-rx",
>> +		"can-state-ctrl"
>> +	};
>> +
>> +	priv->io_callbacks[VIRTIO_CAN_QUEUE_TX] = virtio_can_tx_intr;
>> +	priv->io_callbacks[VIRTIO_CAN_QUEUE_RX] = virtio_can_rx_intr;
>> +	priv->io_callbacks[VIRTIO_CAN_QUEUE_CONTROL] = virtio_can_control_intr;
>> +
>> +	/* Find the queues. */
>> +	return virtio_find_vqs(priv->vdev, VIRTIO_CAN_QUEUE_COUNT, priv->vqs,
>> +			       priv->io_callbacks, io_names, NULL);
>> +}
>> +
>> +/* Function must not be called before virtio_can_find_vqs() has been run */
>> +static void virtio_can_del_vq(struct virtio_device *vdev)
>> +{
>> +	struct virtio_can_priv *priv = vdev->priv;
>> +	struct list_head *cursor, *next;
>> +	struct virtqueue *vq;
>> +
>> +	/* Reset the device */
>> +	if (vdev->config->reset)
>> +		vdev->config->reset(vdev);
>> +
>> +	/* From here we have dead silence from the device side so no locks
>> +	 * are needed to protect against device side events.
>> +	 */
>> +
>> +	vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
>> +	while (virtqueue_detach_unused_buf(vq))
>> +		; /* Do nothing, content allocated statically */
>> +
>> +	vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
>> +	while (virtqueue_detach_unused_buf(vq))
>> +		; /* Do nothing, content allocated statically */
>> +
>> +	vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
>> +	while (virtqueue_detach_unused_buf(vq))
>> +		; /* Do nothing, content to be de-allocated separately */
>> +
>> +	/* Is keeping track of allocated elements by an own linked list
>> +	 * really necessary or may this be optimized using only
>> +	 * virtqueue_detach_unused_buf()?
>> +	 */
>> +	list_for_each_safe(cursor, next, &priv->tx_list) {
>> +		struct virtio_can_tx *can_tx;
>> +
>> +		can_tx = list_entry(cursor, struct virtio_can_tx, list);
>> +		list_del(cursor);
>> +		kfree(can_tx);
>> +	}
>> +
>> +	if (vdev->config->del_vqs)
>> +		vdev->config->del_vqs(vdev);
>> +}
>> +
>> +/* See virtio_net.c/virtnet_remove() and also m_can.c/m_can_plat_remove() */
>> +static void virtio_can_remove(struct virtio_device *vdev)
>> +{
>> +	struct virtio_can_priv *priv = vdev->priv;
>> +	struct net_device *dev = priv->dev;
>> +
>> +	unregister_candev(dev);
>> +
>> +	/* No calls of netif_napi_del() needed as free_candev() will do this */
>> +
>> +	virtio_can_del_vq(vdev);
>> +
>> +	virtio_can_free_candev(dev);
>> +}
>> +
>> +static int virtio_can_validate(struct virtio_device *vdev)
>> +{
>> +	/* CAN needs always access to the config space.
>> +	 * Check that the driver can access the config space
>> +	 */
>> +	if (!vdev->config->get) {
>> +		dev_err(&vdev->dev, "%s failure: config access disabled\n",
>> +			__func__);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
>> +		dev_err(&vdev->dev,
>> +			"device does not comply with spec version 1.x\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int virtio_can_probe(struct virtio_device *vdev)
>> +{
>> +	struct net_device *dev;
>> +	struct virtio_can_priv *priv;
>> +	int err;
>> +	unsigned int echo_skb_max;
>> +	unsigned int idx;
>> +	u16 lo_tx = VIRTIO_CAN_ECHO_SKB_MAX;
>> +
>> +	echo_skb_max = lo_tx;
>> +	dev = alloc_candev(sizeof(struct virtio_can_priv), echo_skb_max);
>> +	if (!dev)
>> +		return -ENOMEM;
>> +
>> +	priv = netdev_priv(dev);
>> +
>> +	priv->tx_putidx_list =
>> +		kcalloc(echo_skb_max, sizeof(struct list_head), GFP_KERNEL);
>> +	if (!priv->tx_putidx_list) {
>> +		free_candev(dev);
>> +		return -ENOMEM;
> Please use the common goto on_failure here, too.
Patch already provided by you.
>> +	}
>> +
>> +	INIT_LIST_HEAD(&priv->tx_putidx_free);
>> +	for (idx = 0; idx < echo_skb_max; idx++)
>> +		list_add_tail(&priv->tx_putidx_list[idx],
>> +			      &priv->tx_putidx_free);
>> +
>> +	netif_napi_add(dev, &priv->napi, virtio_can_rx_poll);
>> +	netif_napi_add(dev, &priv->napi_tx, virtio_can_tx_poll);
>> +
>> +	SET_NETDEV_DEV(dev, &vdev->dev);
>> +
>> +	priv->dev = dev;
>> +	priv->vdev = vdev;
>> +	vdev->priv = priv;
>> +
>> +	priv->can.do_set_mode = virtio_can_set_mode;
>> +	priv->can.state = CAN_STATE_STOPPED;
> No need to assign.
Patch already provided by you.
>> +	/* Set Virtio CAN supported operations */
>> +	priv->can.ctrlmode_supported = CAN_CTRLMODE_BERR_REPORTING;
>> +	if (virtio_has_feature(vdev, VIRTIO_CAN_F_CAN_FD)) {
> What does VIRTIO_CAN_F_CAN_FD mean exactly?

We need to send the matching specification, it's on the top of our list. 
"The device supports CAN FD frames with a maximum payload of 64 bytes". 
Means without this feature negotiated the device does not support CAN FD 
and so the driver also cannot do.

There is also a VIRTIO_F_CAN_CLASSIC feature flag which means that the 
device supports classic CAN 2.0. At least one of the feature flags 
should be set otherwise you had a CAN device supporting nothing at all.

>> +		err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD);
>> +		if (err != 0)
>> +			goto on_failure;
>> +	}
>> +
>> +	/* Initialize virtqueues */
>> +	err = virtio_can_find_vqs(priv);
>> +	if (err != 0)
>> +		goto on_failure;
>> +
>> +	/* It is possible to consider the number of TX queue places to
>> +	 * introduce a stricter TX flow control. Question is if this should
>> +	 * be done permanently this way in the Linux virtio CAN driver.
>> +	 */
> What is configured here?

Number of TX slots until we may get busy.

Assuming physical CAN controllers have normally not more than 128 TX 
places (mailboxes + FIFO places) so defined VIRTIO_CAN_ECHO_SKB_MAX to 
128 which is the assumed max. number of TX slots.

Now I consider also the number of queue entries. With indirect 
descriptors I can put vq->num_free entries into the TX queue without 
having to expect that the virtqueue gets full. Without indirect 
descriptors it's only the half as a TX message has a device readable and 
a device writable part and we need 2 queue entries.

If the number of queue entries available is the limit to get busy this 
one is taken.

The "if (true)" was there as a reminder. I was unsure whether the TX 
flow control was ok or clumsy. Looked now for too long into the flow 
control code to provide an answer here. It's clumsy code to be simplified.

>> +	if (true) {
>> +		struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
>> +		unsigned int tx_slots = vq->num_free;
>> +
>> +		if (!virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
>> +			tx_slots >>= 1;
>> +		if (lo_tx > tx_slots)
>> +			lo_tx = tx_slots;
>> +	}
>> +
>> +	priv->tx_limit = lo_tx;
>> +
>> +	INIT_LIST_HEAD(&priv->tx_list);
>> +
>> +	spin_lock_init(&priv->tx_lock);
>> +	mutex_init(&priv->ctrl_lock);
>> +
>> +	init_completion(&priv->ctrl_done);
>> +
>> +	virtio_can_populate_vqs(vdev);
>> +
>> +	register_virtio_can_dev(dev);
>> +
>> +	napi_enable(&priv->napi);
>> +	napi_enable(&priv->napi_tx);
>> +
>> +	/* Request device going live */
>> +	virtio_device_ready(vdev); /* Optionally done by virtio_dev_probe() */
>> +
>> +	return 0;
>> +
>> +on_failure:
>> +	virtio_can_free_candev(dev);
>> +	return err;
>> +}
>> +
>> +#ifdef CONFIG_PM_SLEEP
> please remove the ifdef and add __maybe_unused instead.
Patch already provided by you.
>> +/* Compare with m_can.c/m_can_suspend(), virtio_net.c/virtnet_freeze() and
>> + * virtio_card.c/virtsnd_freeze()
>> + */
>> +static int virtio_can_freeze(struct virtio_device *vdev)
>> +{
>> +	struct virtio_can_priv *priv = vdev->priv;
>> +	struct net_device *ndev = priv->dev;
>> +
>> +	napi_disable(&priv->napi);
>> +	napi_disable(&priv->napi_tx);
>> +
>> +	if (netif_running(ndev)) {
>> +		netif_stop_queue(ndev);
>> +		netif_device_detach(ndev);
>> +		virtio_can_stop(ndev);
>> +	}
>> +
>> +	priv->can.state = CAN_STATE_SLEEPING;
>> +
>> +	virtio_can_del_vq(vdev);
>> +
>> +	return 0;
>> +}
>> +
>> +/* Compare with m_can.c/m_can_resume(), virtio_net.c/virtnet_restore() and
>> + * virtio_card.c/virtsnd_restore()
>> + */
>> +static int virtio_can_restore(struct virtio_device *vdev)
>> +{
>> +	struct virtio_can_priv *priv = vdev->priv;
>> +	struct net_device *ndev = priv->dev;
>> +	int err;
>> +
>> +	err = virtio_can_find_vqs(priv);
>> +	if (err != 0)
>> +		return err;
>> +	virtio_can_populate_vqs(vdev);
>> +
>> +	priv->can.state = CAN_STATE_ERROR_ACTIVE;
>> +
>> +	if (netif_running(ndev)) {
>> +		virtio_can_start(ndev);
>> +		netif_device_attach(ndev);
>> +		netif_start_queue(ndev);
>> +	}
>> +
>> +	napi_enable(&priv->napi);
>> +	napi_enable(&priv->napi_tx);
>> +
>> +	return 0;
>> +}
>> +#endif /* #ifdef CONFIG_PM_SLEEP */
>> +
>> +static struct virtio_device_id virtio_can_id_table[] = {
>> +	{ VIRTIO_ID_CAN, VIRTIO_DEV_ANY_ID },
>> +	{ 0 },
>> +};
>> +
>> +static unsigned int features[] = {
>> +	VIRTIO_CAN_F_CAN_CLASSIC,
>> +	VIRTIO_CAN_F_CAN_FD,
>> +	VIRTIO_CAN_F_LATE_TX_ACK,
>> +	VIRTIO_CAN_F_RTR_FRAMES,
>> +};
>> +
>> +static struct virtio_driver virtio_can_driver = {
>> +	.feature_table = features,
>> +	.feature_table_size = ARRAY_SIZE(features),
>> +	.feature_table_legacy = NULL,
>> +	.feature_table_size_legacy = 0,
> Nitpick:
> Please indent uniformly with a single space after the =.
Patch already provided by you.
>> +	.driver.name =	KBUILD_MODNAME,
>> +	.driver.owner =	THIS_MODULE,
>> +	.id_table =	virtio_can_id_table,
>> +	.validate =	virtio_can_validate,
>> +	.probe =	virtio_can_probe,
>> +	.remove =	virtio_can_remove,
>> +	.config_changed = virtio_can_config_changed,
>> +#ifdef CONFIG_PM_SLEEP
>> +	.freeze =	virtio_can_freeze,
>> +	.restore =	virtio_can_restore,
>> +#endif
>> +};
>> +
>> +module_virtio_driver(virtio_can_driver);
>> +MODULE_DEVICE_TABLE(virtio, virtio_can_id_table);
>> +
>> +MODULE_AUTHOR("OpenSynergy GmbH");
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("CAN bus driver for Virtio CAN controller");
>> diff --git a/include/uapi/linux/virtio_can.h b/include/uapi/linux/virtio_can.h
>> new file mode 100644
>> index 000000000000..de85918aa7dc
>> --- /dev/null
>> +++ b/include/uapi/linux/virtio_can.h
>> @@ -0,0 +1,71 @@
>> +/* SPDX-License-Identifier: BSD-3-Clause */
>> +/*
>> + * Copyright (C) 2021-2023 OpenSynergy GmbH
>> + */
>> +#ifndef _LINUX_VIRTIO_VIRTIO_CAN_H
>> +#define _LINUX_VIRTIO_VIRTIO_CAN_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/virtio_types.h>
>> +#include <linux/virtio_ids.h>
>> +#include <linux/virtio_config.h>
>> +
>> +/* Feature bit numbers */
>> +#define VIRTIO_CAN_F_CAN_CLASSIC        0
>> +#define VIRTIO_CAN_F_CAN_FD             1
>> +#define VIRTIO_CAN_F_LATE_TX_ACK        2
>> +#define VIRTIO_CAN_F_RTR_FRAMES         3
>> +
>> +/* CAN Result Types */
>> +#define VIRTIO_CAN_RESULT_OK            0
>> +#define VIRTIO_CAN_RESULT_NOT_OK        1
>> +
>> +/* CAN flags to determine type of CAN Id */
>> +#define VIRTIO_CAN_FLAGS_EXTENDED       0x8000
>> +#define VIRTIO_CAN_FLAGS_FD             0x4000
>> +#define VIRTIO_CAN_FLAGS_RTR            0x2000
>> +
>> +struct virtio_can_config {
>> +#define VIRTIO_CAN_S_CTRL_BUSOFF (1u << 0) /* Controller BusOff */
>> +	/* CAN controller status */
>> +	__le16 status;
>> +};
>> +
>> +/* TX queue message types */
>> +struct virtio_can_tx_out {
>> +#define VIRTIO_CAN_TX                   0x0001
>> +	__le16 msg_type;
>> +	__le16 length; /* 0..8 CC, 0..64 CAN­FD, 0..2048 CAN­XL, 12 bits */
>> +	__le32 reserved; /* May be needed in part for CAN XL priority */
>> +	__le32 flags;
>> +	__le32 can_id;
>> +	__u8 sdu[64];
>> +};
>> +
>> +struct virtio_can_tx_in {
>> +	__u8 result;
>> +};
>> +
>> +/* RX queue message types */
>> +struct virtio_can_rx {
>> +#define VIRTIO_CAN_RX                   0x0101
>> +	__le16 msg_type;
>> +	__le16 length; /* 0..8 CC, 0..64 CAN­FD, 0..2048 CAN­XL, 12 bits */
>> +	__le32 reserved; /* May be needed in part for CAN XL priority */
>> +	__le32 flags;
>> +	__le32 can_id;
>> +	__u8 sdu[64];
>> +};
>> +
>> +/* Control queue message types */
>> +struct virtio_can_control_out {
>> +#define VIRTIO_CAN_SET_CTRL_MODE_START  0x0201
>> +#define VIRTIO_CAN_SET_CTRL_MODE_STOP   0x0202
>> +	__le16 msg_type;
>> +};
>> +
>> +struct virtio_can_control_in {
>> +	__u8 result;
>> +};
>> +
>> +#endif /* #ifndef _LINUX_VIRTIO_VIRTIO_CAN_H */
>> --
>> 2.34.1
>>
>>
> Marc

We're reworking.

Harald



