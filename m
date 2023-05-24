Return-Path: <netdev+bounces-5035-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A256A70F7A3
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA789281301
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B9818019;
	Wed, 24 May 2023 13:30:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C334960868
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:30:51 +0000 (UTC)
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361B2119
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:30:47 -0700 (PDT)
Received: from 104.47.11.177_.trendmicro.com (unknown [172.21.178.36])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id F09E910000848;
	Wed, 24 May 2023 13:30:44 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1684935044.227000
X-TM-MAIL-UUID: 09b181cc-7619-444e-bd6f-e28ae6dde259
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.177])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 378DC10000311;
	Wed, 24 May 2023 13:30:44 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxyTJHY3NbA7nT3stvFFhPzFb5JiBGcB+ITpteyx7x+OrQcjPugJvDJapxUwWqaEM3anTtMzuZTVofg4myzHanWI8yu1Ga7ovdMUx4ZyPKD4DhThlnvnMPO2BG2tz71q4y4+TS3tsuJX+B9/Dnjpvnys+aW+aIGlNjldENOVC5WVQ5cN2M6pk194VatUeDQ/pd7XaSgxyt29n7SeDgJLBh8LIr6RtBfJlS75grGiljEEPJDhRjex4k55aR6OH72091Q+pn8X5tiVhy3SFlgAsMoWCPnE9Lqnt7k3M2ukoa70+QTpvmPwOnZYiRHLqYWXG/Gi0biL8uB1r3WYVOkp3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/RQBMnyjxANslbE23BzQnVTe3Pfw3dGJaluVIX4Oac=;
 b=JgsLKIeyeoGy2Xvf28ln6whQv89yr4CurZwxn6owGChO8sVdee2b3m/G/CRP7q+FJVH+Pb3IU+zTEU7e1EiURD3m6glTgJkqUk5W10SuOU/yo5XEJYtxx8dOSFSulXxsquRwpajMkjhz+QWyrSYRyy+QzDHIuJZ6FuD6kqKucsF8he2ITxcUukf67ePTMWiHcFVQSca+5+y1qdFz5CKyO02rlPtlH61kqu4qjNG/GlfJa68nZpKsiN953gHPv9RU/OYAzDG35WQXeGrv1uypDDbIfmFGXeosrG8jafrMPf9YWpyq38z+ZLAFXTTbaDKb19BczGDYqMkeUrZcTcdUMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <fa51745b-efc2-f513-adf9-35253405ec1c@opensynergy.com>
Date: Wed, 24 May 2023 15:30:40 +0200
From: Harald Mommer <harald.mommer@opensynergy.com>
Subject: Re: [RFC PATCH v3] can: virtio: Initial virtio CAN driver.
To: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc: Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>,
 Marc Kleine-Budde <mkl@pengutronix.de>, virtio-dev@lists.oasis-open.org,
 linux-can@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 Wolfgang Grandegger <wg@grandegger.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
References: <20230511151444.162882-1-Mikhail.Golubev-Ciuchea@opensynergy.com>
 <CAMZ6RqJbjoApwZbiivbvJRYQyBWfWXG4azmwuXGaicrMq0Lozg@mail.gmail.com>
 <a83e29fd-09d0-64b4-ce56-c7f7a5e44f66@opensynergy.com>
 <CAMZ6RqJxOh1zY0UauK6bK0d2ToU7M2q_TWyUEb4Bvai3r+AEYA@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAMZ6RqJxOh1zY0UauK6bK0d2ToU7M2q_TWyUEb4Bvai3r+AEYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0444.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:81::29) To BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:4a::9)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BE1P281MB3400:EE_|FRYP281MB2523:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ff00bc8-cce9-426f-ce1c-08db5c5b1235
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZHZtvrvql033zeVyHUlxL+33L1ZEbWDh9jf0AJv+wgo/MOXHLDdg3iqgiMTkepIjSteq5b0Pk/nrrz9/T1eCTyLLJ25TYyre/v5Ef2/KbWURvbt4UsAH6VKqTp5z4RoU+xNREVyjpzGsN/MIwahcLAg86SGb3QQoIDV9WQp5fcPCTYsqAkNWVoDN9MqbGuSiPWvYVVebu7Dr7QCiBn8TCk6CQqY4ujBcGVDHxnarDbNSnvhKtlrOqXo2gJECDHvWQ7wA+3to/0KZ42VKPem7swN22yv3CR8w5dcbyCMvd1Iwaa0Ok802XYVWVFpkRyVlmG3B1QOIEuJnsytiTA5J23GX+8jiWdUDX8+QKnCBLj3DYebZHkeGxP8VGDfWt4OHUwOQ6Mm9aRI4yQYapZ+5M8kulsCyWwlJ1PPO3UVpudx33ShqQlKtzw7yXL59ayRydw+E14kjnRcvdJ0jfhsBQg6o93RO3k9BOdL8wojB02W01DUTgwTUFi0B4/vfzVpx7IVd88i5/i6nRwhfBEoELnzY7qv2eJMhG9tDSwO8SyXkdbYNYXdBaY/9d8gYbtphHSdFPr+kC9s+Oy/ha0bYMA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(396003)(39840400004)(451199021)(31686004)(66899021)(31696002)(316002)(5660300002)(44832011)(7416002)(36756003)(38100700002)(41300700001)(66476007)(66556008)(66946007)(107886003)(6916009)(83380400001)(4326008)(53546011)(478600001)(186003)(2906002)(8676002)(8936002)(30864003)(86362001)(966005)(54906003)(26005)(2616005)(42186006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFBERVVRb1NudDM1cEJMTDhOUTZHYnhHUFJjNU5xTTZwYTRnVXFqd1ZSamxJ?=
 =?utf-8?B?ZHNOSmxiZGRXRm5jS3RSU0Q0QkVpc3FGcnhaNnl3ckpXS2VmVjQrYlpZaTN6?=
 =?utf-8?B?UlZtbHNOYzNXZ3NmRkhVU2N4ZTlLak5ZODVwb2MyWnZYa2dWb2dBUTFmT2l4?=
 =?utf-8?B?UlNpby9QSVpJM09la0V0dkhjZUxSZkkvc1NBTHZWbExYVHVWS2JXVzJvWlpS?=
 =?utf-8?B?SVRGcDlQMWZaVjVPb1pkS1hIdHlvbnhCbDgxU211SGdOYVBJVEVNUnN2L2RJ?=
 =?utf-8?B?dnhPNThLS1dybDRNYlFNSEcyU1RqYkVaeXJlaG1oNGM2V1lQKzN4ODhJR0lh?=
 =?utf-8?B?eXRwN0l1bHVFOHZtVC9DQzh2cEdQZHRzT1VydVVWWkV5WTQxeHlIcDBTY0ZY?=
 =?utf-8?B?SjMvSW0rdjNNckZ6WTdPZXZGMlN0SVBOSldFVTZsNmdSMGVXTlRvN0RDK0Qr?=
 =?utf-8?B?WGdLZXA0RVV6MklpWjlmdnBGZzRMcTFBUzJhcWFLbUw4V201cHVNNkpMQWJS?=
 =?utf-8?B?QU16UTRLcmdpS2FjN1VUSGpuVnRYR0hjWW9xRldITmhyQzRVclVsbW5lUG5K?=
 =?utf-8?B?U0FTS1ozdGorVkUvcW1NL3o5cnFJTmZMZmRsOHpMRVNVMURuYTlJbzRKVE9r?=
 =?utf-8?B?bUZ6TzlWM2FxVGUxQi9qRXlRODQzUm9PYXhmRzRUMmV3aG5nR29zZ3pyNjBr?=
 =?utf-8?B?anEzOER2bWpxVzUzMndackVLdEFnaG9sRzNyM1kwZ0pvclJQTk9pYnZDdmdO?=
 =?utf-8?B?TnYzdHE4bENzalA0YzQwVTlJcmczWFJOUVY4R0NtNXlMeFdab2F6YkR6RnN1?=
 =?utf-8?B?bGlnNnlFOGUrdTJLYzZTQWtQQUI5dDIxWEdOOVJ3OVJPUUcwVTkydmZMQmVT?=
 =?utf-8?B?aDRHZDdQSzhkMno3UDR4SksxbGI0c3RoZVJpMXRBdk5HZUVNVElrUS9Ua2F0?=
 =?utf-8?B?MENkRzNFZmtuTi9KN1lqQnVYaW9hOFRsM1BqMkkrTkkyZjZSVXVtZWJpSDdD?=
 =?utf-8?B?Z0toZUFuLzhPaU9aOC9zVXYvMEU2b0ZBZCtpMW9UYVR6aFB5SWRDcUYvak1F?=
 =?utf-8?B?Sy8xMjNQYnlKNzcxQ0xUZG9Ua0drVjRpUk5odUgvTEJsRENqaUlLZFpqNDc0?=
 =?utf-8?B?UUVZNjRjTXVsOVhjK3duMWtGckplUjg3UlVMbTFQOENMbk8yUGdJcDh2QmFG?=
 =?utf-8?B?eW9udFdPZ3dQNmdGQ1BCd3RXZ2h5eFh6UitCZjRtbkZQMHZ5UGNlM0FjSGRn?=
 =?utf-8?B?MkI5TzFjMDk4TVhudWIvSG1LaFhSSGdiSVd3U2hzTXBTSjlZMktVUmlpVVZ3?=
 =?utf-8?B?OExnWkxXNUNKY20yQ21SY3p2N0tJQndaaWFkNXg5cUlFNlRwUysxT2wyeHd2?=
 =?utf-8?B?ZE51OGZXRnFxR3hsc202UkNzM3g2SGhMcFVUNjVqTnVZYklubkVnczluYkR5?=
 =?utf-8?B?b216alFVcVFDdmN3RG5yMUtoclNZYTZoTkVCdk5yYWlrTjRoV2dFUVM3MXd1?=
 =?utf-8?B?WDdoS29Md1luZU5hbHNZVlRaR0NqZWF1OVNFRG1uTXBScXlhUVFvYzBxcVJC?=
 =?utf-8?B?YUpwWWpqMVVCb3IyTXNxQUtJQjFDU3BONHZUM0pFQ0xvbkhJNk9jcFlOTzFU?=
 =?utf-8?B?Sk1rVmNUMDlxVEtVTFdkTjNtWU1oczFDdEc5U0owSFEwM0JJdjc5N3JZZXZG?=
 =?utf-8?B?TUpEZ2lBS0V6UThHM3d0eW5DNlpjaG9GenRndmhUMU9kRE9obFVRMDBjZVlM?=
 =?utf-8?B?b0s2TDNRVGZBWmZ1cVlGcTZiU1JBSDZsdi9VOFlJdTN1blJicU1XeUFidE8x?=
 =?utf-8?B?L1Y0N2pIVDBiMGtkM3RPUFFTWmJHenppR0VZK1Jhbm1iRVpidzRSeXpxQ0U0?=
 =?utf-8?B?K3NtN1ZyNGFnSU5GRkd0bm5qUUNFTGhyZ2M1eWFNY3MvTjZnNEV6TW5pb3R3?=
 =?utf-8?B?WWhkbkxjTVJpRlFETVRwTE1sT2Q4K1BCQWhjQXE0dnRFMFAyTUxITFErR1dT?=
 =?utf-8?B?N2Q4YWUvZ3BhdWJKRkdKN2dpOTBTNTV0b25FYmE5RHBzQU0vNzN1L3FJSGJL?=
 =?utf-8?B?ZEVsbWZPVHBNcVRvSFpXMXJ3bzRQYnpJVDEzMTRqdGtHWnRTd3BqSHNYRS9T?=
 =?utf-8?Q?xowYdcu1bc01qo3fCdPjOvSx9?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff00bc8-cce9-426f-ce1c-08db5c5b1235
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 13:30:42.2123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ctkv6ubvDf2NlMXZ+bb5FVxNMpt9XUg3/zyP5eaqPXak2uI4jW8vrVu5X5hZNG99OsMUeBZX81d5YV9amoqhRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRYP281MB2523
X-TM-AS-ERS: 104.47.11.177-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1007-27646.007
X-TMASE-Result: 10--35.179100-4.000000
X-TMASE-MatchedRID: 8HTFlOrbAtEMek0ClnpVp/HkpkyUphL9mSLeIgEDej9gPgeggVwCFor8
	9wC5UuPW31bMjj/I3ClYEymJXJOxRYxxTMlLewfd9Ib/6w+1lWTZ8CGYax+2xmnbLXx5NP9tn/U
	W8oaf6U/Tdt4rUYJZj2YKUF1Nf4jolBuUGhpXEr2qFx2c/3V5cTRgv1Ik+59f1MLjrA2jzIWD3F
	7iC1Qm2sd4hTvlyI3bk5uy84qax214WMUW7ukAphqkhv3OdF4D1jpJ5RePtfhQKAQSutQYXIRQJ
	083LK5lZ7X12VjMO9JKCGvlk9ppmz9ETA4D04a1HlDQRrnQLaXzZKDA1/pIrrsi/Y4xNrJBLhd6
	ma7WE8vvPBXLPdbeHJw+mD95Xw7s3H7LcTAG9qtIcJTn2HkqsbJyu9jGj0qnhYzaaC+0+5CYpmB
	4zAaUDoI2saheyR9d7oMhxEU/K+bFudcw92cu15bvOXb2nXF11KDIlODIu+X+Aw16GgqpOyToWH
	TPugn4kJ/08lUVnXSgAqbdN++1MMqkj+iRKUEjeJasioSJSCC3ClSK/bUMDU5oN2XumCC9bnLs1
	nKCcJoZ++8Drb44OsFtP0cHDTjahhVqo3gxO+EDEV/zpFyKvQWhMWXqiWWy4Ju5UjuFVst7RBRp
	wgaepYzumR141MFnd0lf3A+f2SMBWYjuD7O4SUH0jmDpcSmLaZATGA5/BXgsTMNBTJAZWaxewQi
	l71AILLfwQGDSv+iRtLk5L8LNDEIYiAJlkvRNovaPAM40SOGjy03X2hNeV2taNN5IoqQRTxSugU
	04antsOYddpI4t4+fNg8THqc7Tm1njeX/9TvR+yskgwrfsC30tCKdnhB581B0Hk1Q1KyLUZxEAl
	FPo846HM5rqDwqtlExlQIQeRG0=
X-TMASE-XGENCLOUD: ae36abcf-d031-430e-9487-86099473ec21-0-0-200-0
X-TM-Deliver-Signature: B9BBFA906875E5587A5D6E705D93CAA0
X-TM-Addin-Auth: Odv/6Omt9NXCazckIq8Ig0gHKI+pffTMrH/RqrIVS1MqY/NE8W+qpojIsYv
	ltmi0NRe6PtZBL75H483l0GCP0SfdNRZsMLrf8rFHOHgvfrc2dP8gmxu8v/Kh/SXwgqdxsAwsHK
	HR6gV/ytx397xC/s3RbF++sCLhvS/ZPxLFfCedm5vXWHOsn84oofOLC9iH4CvDxJkpH+fJmaypg
	mpEdyEnLoIoeqjTwxS48Q3DShyXxzN/aXVigfiHc7CQ0je6ZVZfYvpEWs5KSwjhi7LGp1okCFL6
	RIlH0JdkumZPpdg=.f3+PfHA+0owyxHZnSaQoa8YSkqGI/KNpJOrTULn9CT1t9ObHRx86lahl+g
	3903AcxD9v4+SAy4k3msZFxyxhA52WrYumPkSjRvEYadEwQsvGgQxIhTEU2XpATIPkk+km8dMMO
	vQ4EgvDPtJBSkvEmhLEHCmMrq+nz8XsDO0idtsbwAZVE3d5FZLmClbtIbzf6+WZIKfp14DG0HQ1
	YT+mLHNI1jgWTi06xuh1PokSxsxYVrPWMimPQ8Wr4YBGEoIBY69nriQxOJDDLmN7QFaO12nBQRD
	lMNRXgD/DXTOhAgXtGdbLGUePOB4WG/2NXQ+km3toxaFjAjUajR2HNMJV8w==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1684935044;
	bh=iUXi6TEWWzlEdPXSSnul2SmQpXodAj8a3o0E5yxqp6Q=; l=21213;
	h=Date:From:To;
	b=Vgzh7ACMBjblJAA7qpEEZ+eU8wDXiYq5jGxVxPd1mLt1Omhp9hVtTBLrjQWviWs8R
	 EiXtp5pZ5xoyAc+2KEY1j37EkEHcgR2NtwtllIQxZA1Eiu+hqGbFxZJ6NhqBPAeoEa
	 cZN0twJBSdarDp81djSU/tgs9jthpHM87kWejsdAIWTtVocoioFASxT94W0bBrG0OV
	 6uhHlii5aPFLHyZcdl8klLeKy2UhRR6tldAVXukPQayRtPgchv3ULPXKL1mgU9IRvp
	 pGl+Uoz0FpTdiG8JbiyQ4L5xPdlgHMtAj13z7Td8Za163TDL0mgOj0WQJcp4/Idsu+
	 Ito1JPMRXCc7g==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Vincent,

On 15.05.23 08:31, Vincent MAILHOL wrote:
>>>             if (err) {
>> Opened Eclipse, searched for "if (err != 0)" in the kernel code. 290
>> matches. For "if (ret != 0)" I found now 1970 matches.
> Read my comment again. I never mentioned err vs. ret.
>
>   I am asking to replace "if (err != 0)" by "if (err)". We are not
> using MISRA and there is no concept of essential boolean type here.
> You can pass an integer to an if ().
>
> I do not use eclipse, but git can give a few relevant statistics:
>
>    $ git grep "if (err != 0)" | wc -l
>    277
>    $ git grep "if (err)" | wc -l
>    34307
>
> And while this is not the topic, "ret" is more popular than "err":
>
>    $ git grep "if (ret != 0)" | wc -l
>    1956
>    $ git grep "if (ret)" | wc -l
>    67927
>
> but both are well established usage so I do not really care which one
> of "ret" or "err" you use.

Looks like major practice is indeed to omit the != 0 for error 
indicating return codes so I will adapt to the majority but adding an 
unlikely. The block is not expected to be entered at all as the comment 
says however it needs to be  there due to defensive programming practice.

=> if (unlikely(ret))

>>>> +               /* Not expected to happen */
>>>> +               dev_err(dev, "%s(): virtqueue_add_sgs() failed\n", __func__);
>>>> +       }
>>>> +
>>>> +       if (!virtqueue_kick(vq)) {
>>>> +               /* Not expected to happen */
>>>> +               dev_err(dev, "%s(): Kick failed\n", __func__);
>>>> +       }
>>>> +
>>>> +       while (!virtqueue_get_buf(vq, &len) && !virtqueue_is_broken(vq))
>>>> +               wait_for_completion(&priv->ctrl_done);
>>>> +
>>>> +       mutex_unlock(&priv->ctrl_lock);
>>>> +
>>>> +       return priv->cpkt_in.result;
>>>> +}
...
>>>> +static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
>>>> +                                        struct net_device *dev)
>>>> +{
>>>> +       struct virtio_can_priv *priv = netdev_priv(dev);
>>>> +       struct canfd_frame *cf = (struct canfd_frame *)skb->data;
>>>> +       struct virtio_can_tx *can_tx_msg;
>>>> +       struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
>>>> +       struct scatterlist sg_out[1];
>>>> +       struct scatterlist sg_in[1];
>>>> +       struct scatterlist *sgs[2];
>>> Instead declaring two times an array of 1, can we do:
>>>
>>>           struct scatterlist sgs[2];
> Ooopsy on my side. sgs is an array of pointers so the above is not equivalent.
>
> And doing this:
>
>            struct scatterlist *sgs[2];
>
> Would be problematic as the memory of the two elements would not be allocated.
>
>>> and then use sgs[0] for out and sgs[1] for in?
>>>
>>> Or, if you really want to keep sg_out and sg_in, at least do:
>>>
>>>             struct scatterlist sg_out, sg_in;
>>>             struct scatterlist *sgs[] = {&sg_out, &sg_in};
>>>
>>> N.B. The same comment also applies to the other places where you are
>>> doing some sg[1] declarations.
>> Makes thing worse. I'm not even sure whether this is a null change only
>> or introduces a problem.
>>
>> virtio strictly separates devices readable and device writeable data.
>> Therefore I want really to have here 2 separate definitions. The one is
>> data to the device, the other is data from the device.
> ACK. My second example does that:
>
>              struct scatterlist sg_out, sg_in;
>              struct scatterlist *sgs[] = {&sg_out, &sg_in};

First I remove the [1] from sg_out and sg_in to make those scalars 
instead of arrays of [1].

Your 2nd example above violates the reverse xmas tree rule so I cannot 
take this one as is.

But got the thing through the compiler with the following construct:

     struct scatterlist sg_out, sg_in, *sgs[2] = { &sg_out, &sg_in };

>> If this had any advantage, I could separate the data further. For
>> example I could separate the payload from the preceding data. In this
>> case I had  struct scatterlist sg_out[2]. As long as the payload is
>> small the memcpy for the payload can be justified and [1] is good. In
>> fact, those are still arrays even if by coincident now the number of
>> elements is 1.
> sg_out and sg_in are only passed to one function: sg_init_one(). And
> as the name suggests, sg_init_one expects a single scatterlist, not an
> array.
>
> A look at:
>
>    $ git grep sg_init_one
>
> show me that doing as "sg_init_one(&foo[0], ...)" is not a popular
> solution. The majority does sg_init_one(&foo, ...).
ACK. Checked this also now, saw &foo[0] once or so.
> I do get that sgs is an array of arrays. I am just not comfortable
> with sg_out and sg_in being declared as arrays because these never get
> used as such.
>
>>>> +       unsigned long flags;
>>>> +       u32 can_flags;
>>>> +       int err;
>>>> +       int putidx;
>>>> +       netdev_tx_t xmit_ret = NETDEV_TX_OK;
>>>> +       const unsigned int hdr_size = offsetof(struct virtio_can_tx_out, sdu);
>>>> +
>>>> +       if (can_dev_dropped_skb(dev, skb))
>>>> +               goto kick; /* No way to return NET_XMIT_DROP here */
>>>> +
>>>> +       /* No local check for CAN_RTR_FLAG or FD frame against negotiated
>>>> +        * features. The device will reject those anyway if not supported.
>>>> +        */
>>>> +
>>>> +       can_tx_msg = kzalloc(sizeof(*can_tx_msg), GFP_ATOMIC);
>>>> +       if (!can_tx_msg)
>>>> +               goto kick; /* No way to return NET_XMIT_DROP here */
I missed here to update the number of dropped messages.
>>>> +
>>>> +       can_tx_msg->tx_out.msg_type = cpu_to_le16(VIRTIO_CAN_TX);
>>>> +       can_flags = 0;
>>>> +
>>>> +       if (cf->can_id & CAN_EFF_FLAG) {
>>>> +               can_flags |= VIRTIO_CAN_FLAGS_EXTENDED;
>>>> +               can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
>>>> +       } else {
>>>> +               can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_SFF_MASK);
>>>> +       }
>>>> +       if (cf->can_id & CAN_RTR_FLAG)
>>>> +               can_flags |= VIRTIO_CAN_FLAGS_RTR;
>>>> +       else
>>>> +               memcpy(can_tx_msg->tx_out.sdu, cf->data, cf->len);
>>>> +       if (can_is_canfd_skb(skb))
>>>> +               can_flags |= VIRTIO_CAN_FLAGS_FD;
>>>> +
>>>> +       can_tx_msg->tx_out.flags = cpu_to_le32(can_flags);
>>>> +       can_tx_msg->tx_out.length = cpu_to_le16(cf->len);
>>>> +
>>>> +       /* Prepare sending of virtio message */
>>>> +       sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + cf->len);
>>>> +       sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg->tx_in));
>>>> +       sgs[0] = sg_out;
>>>> +       sgs[1] = sg_in;
>>>> +
>>>> +       putidx = virtio_can_alloc_tx_idx(priv);
>>>> +
>>>> +       if (unlikely(putidx < 0)) {
>>>> +               netif_stop_queue(dev);
>>>> +               kfree(can_tx_msg);
>>>> +               netdev_warn(dev, "TX: Stop queue, no putidx available\n");
>>> ida_alloc_range() can also return -ENOMEM. So the error is not
>>> necessarily because of no putidx available. Maybe better to print the
>>> error message (with %pe to show the mnemotechnic).
>> %pe does not do that. It works for an error coded in a pointer. I have
>> here an int.
> Yes, and you can use the ERR_PTR() to turn your int into an error pointer.
>
> Do:
>
>    $ git grep -A1 "%pe"
>
> if you need examples.

Thanks for this trick with ERR_PTR(). Does not show me a clear text 
error but dumps the pointer in hex so that an additional hex to decimal 
conversion becomes necessary to lookup for the error code. May be due to 
my small embedded setup.

But I realized thinking about all those comments that there is major 
problem in this block:

- The queue is stopped in this block
- The only place where the queue is re-enabled is when a pending TX 
message is processed
- If there is a -ENOMEM and no TX message is pending the driver blocks 
until doomsday

Received also a review comment being to noisy here

- ENOMEM is a rare but valid condition so not tracing this anymore
- ENOSPC should be impossible if flow control works so WARN_ON(putidx == 
-ENOSPC)

=> Remove queue stop, trace only impossible condition not to be noisy, 
drop message always and don't forget to increase drop count.

With current code -ENOSPC was seen. There was a bug in 
virtio_can_read_tx_queue() where the netif_wake_queue() is not done when 
the tx_lock is still held but immediately afterwards and that was a problem.

>>>
>>> Why do we need both VIRTIO_CAN_F_RTR_FRAMES VIRTIO_CAN_FLAGS_RTR?
>>>
>>> Is it to manage devices not able to sent remote frames? If so, we may
>>> also need to add a CAN_CTRLMODE_RTR in linux/can/netlink.h?
>> VIRTIO_CAN_F_RTR_FRAMES is a feature flag. RTR frames may or may not be
>> supported. AUTOSAR CAN drivers do not know anything about RTR frames.
> Now that you say it, it rings a bell.
>
> So indeed, we will probably need a new flag in can/netlink.h to report
> to the userland whether a device is capable or not to manage remote
> frames.

Currently our virtio devices run in the Linux environment but this may 
not to be the case for all our virtio devices in the future. It is 
likely that at some point in time some devices will be migrated to a 
smaller RTOS environment and then it is well imaginable that someone 
wants to use an existing AUTOSAR CAN driver as backend for a virtio CAN 
device. With such a setup no VIRTIO_CAN_F_RTR_FRAMES.

Yes, probably, if we make such a setup possible and want to be clean.

>> if someone wants to build a virtio CAN device on top of an AUTOSAR CAN
>> driver with the additional requirement not to change the existing
>> AUTOSAR CAN driver RTR frames cannot be supported and the feature flag
>> won't be offered by the virtio device.
>>
>> VIRTIO_CAN_FLAGS_RTR is a bit to indicate a frame type in a CAN message.
>> Used internally in an Linux SocketCAN interface.
> ACK.
>
> On a side note, did you have a look at:
>
>    https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2felixir.bootlin.com%2flinux%2flatest%2fsource%2finclude%2fuapi%2flinux%2fcan%2fnetlink.h%23L95&umid=0b3549ac-d010-4d96-a348-2702485d82af&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-75dedb6bf65ef4342bf7c18b89f4f30ed7dc9dc6
>
> ?
>
> It lists the different hardware capabilities which may or may not be
> present at the hardware level. This list can be used as an input to
> decide how to extend the feature bit list.

Looked at this and got some more headache especially with FD. There is 
CAN_CTRLMODE_FD and CAN_CTRLMODE_FD_NON_ISO. Elsewhere is CANFD_BRS. 
Virtio CAN with (too much?) AUTOSAR in mind has only an idea of FD and 
does not distinguish any of this. In AUTOSAR Can_Write() and friends 
there is only bit 30 which says "this is a CAN FD frame".

Virtio CAN was intended to get CAN for automotive usage into the virtual 
machine. However it should be open to be extended later if there were 
requirements.

The hard requirements I got for now are

 1. Bring CAN for automotive usage into the virtual machine
 2. Do not overload the very first version with features

2.) ensures 1.) will happen.

>>>> +
>>>> +/* CAN Result Types */
>>>> +#define VIRTIO_CAN_RESULT_OK            0
>>>> +#define VIRTIO_CAN_RESULT_NOT_OK        1
>>> Silly question, but what is the rationale of not using the error code
>>> from errno.h?
>> Looked into the AUTOSAR_SWS_StandardTypes.pdf  Std_ReturnType:
>>
>> E_OK = 0
>>
>> E_NOT_OK = 1
>>
>> other are "Available for user specific errors" like CAN_BUSY.
>>
>> Linux is only one operating system. An important one but there are
>> others. AUTOSAR people may ask you "What is errno.h?" (and also "What is
>> malloc?").
> Sorry, but I do not buy this argument. Do you really now AUTOSAR
> developpers who do not know about malloc()?

They know. But neither it's provided by their classic AUTOSAR 
environment nor are they allowed to use it if MISRA is enforced which is 
likely the case.

MISRA C 2012 Dir 4.12: "Dynamic memory allocation shall not be used".

MISRA C 2012 Rule 21.3 "The memory allocation and deallocation functions 
of <stdlib.h> shall not be used".

"What's malloc()" at least in the last company meant "I'm doing MISRA so 
I'm not supposed to use malloc()".

>> Our internal client is interested in a Virtio AUTOSAR CAN
>> driver. So there were reasons to look first into AUTOSAR.
> Is it AUTOSAR Classic or AUTOSAR Adaptive?

Looking currently into the specification(s) for the "Classic Platform". 
There exists no "errno.h".

> AUTOSAR Adaptive is POSIX (to some extends):
>
>    [SWS_OSI_01001] POSIX PSE51 Interface: [The OSI shall provide OS
>    functionality with POSIX PSE51 interface, according to the
>    1003.13-2003 specification.]
>
> Ref: AUTOSAR AP R22-11 - Specification of Operating System Interface
> https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2fwww.autosar.org%2ffileadmin%2fstandards%2fR22%2d11%2fAP%2fAUTOSAR%5fSWS%5fOperatingSystemInterface.pdf&umid=0b3549ac-d010-4d96-a348-2702485d82af&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-1b9dde25c1a8497018be33058ca535bcfe2c272a
>
>> There is also a CAN_BUSY for the AUTOSAR Can_Write() to be returned but
>> this is not needed at this interface as a virtio AUTOSAR CAN driver was
>> busy when there are no sufficient messages available in the virtqueue,
>> so for this condition we need no defined error code to be used in a
>> virtio message.
>>
>> Virtio block defines VIRTIO_BLK_S_OK 0, VIRTIO_BLK_S_IOERR 1,
>> VIRTIO_BLK_S_UNSUPP 2.
>>
>>> I do see that some other virtio devices do the same:
>>>
>>>     https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2felixir.bootlin.com%2flinux%2fv4.6%2fsource%2finclude%2fuapi%2flinux%2fvirtio%5fnet.h%23L140&umid=0b3549ac-d010-4d96-a348-2702485d82af&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-698619745d87a25323604ab5a614cc946b24e642
>>>
>>> But I am genuinely curious to understand why virtio do not use more
>>> standard error codes.
>> I cannot speak for virtio. errno.h is ANSI C and POSIX but virtio does
>> not only address those environments. It is a more general specification.
> That's my point. ISO C is so predominant that those error codes are
> available nearly everywhere. And this being just some #define, it can
> easily be integrated to the few system which do not have this header.
>
> If there is a requirement to make virtio header self contained, then I
> would understand why POSIX error code can not be used. But as I said,
> I am genously curious to understand the reason behind this choice.
>
>> For the virtio RPMB device the result codes in the virtio specification
>> come for example directly from an JEDEC specification for eMMC. Which
>> has some connection to a JEDEC UFS specification, same result codes
>> there. Makes a lot of sense to use those result codes in this context.
>>
>> As virtio is more general, I have for this also my doubts whether it
>> really was a good idea to take over the CAN RX and CAN TX message
>> definitions 1:1 from Linux (if this is possible). Someone proposed but
>> I've my doubts.
> Yes, I did ask here:
>
>    https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2flore.kernel.org%2flinux%2dcan%2fCAMZ6RqLALOYFWQJ4C4HTaRw7y%2dwaUbqOX0WzrWVNiQG51QexHw%40mail.gmail.com%2f&umid=0b3549ac-d010-4d96-a348-2702485d82af&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-6453b89fa56fa0a97905d808b20a7df3eb16f85a
>
> I am still waiting for your answer.
>
> I do understand that Linux is not the only OS. However, it is the only
> one with a complehensive set of open source CAN dirvers. Reusing the
> Linux structures would allow to reuse bigger chunks of code,
> decreasing the amount of effort needed implement drivers in the virtio
> host.
>
> That said, the POSIX error code and reusing the Linux CAN structures
> are two different topics.
>
>>>> +/* CAN flags to determine type of CAN Id */
>>>> +#define VIRTIO_CAN_FLAGS_EXTENDED       0x8000
>>>> +#define VIRTIO_CAN_FLAGS_FD             0x4000
>>>> +#define VIRTIO_CAN_FLAGS_RTR            0x2000
>>>> +
>>>> +struct virtio_can_config {
>>>> +#define VIRTIO_CAN_S_CTRL_BUSOFF (1u << 0) /* Controller BusOff */
>>>> +       /* CAN controller status */
>>>> +       __le16 status;
>>>> +};
>>>> +
>>>> +/* TX queue message types */
>>>> +struct virtio_can_tx_out {
>>>> +#define VIRTIO_CAN_TX                   0x0001
>>>> +       __le16 msg_type;
>>>> +       __le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bits */
>>>> +       __le32 reserved; /* May be needed in part for CAN XL priority */
>>>> +       __le32 flags;
>>>> +       __le32 can_id;
>>>> +       __u8 sdu[64];
>>>> +};
>>>> +
>>>> +struct virtio_can_tx_in {
>>>> +       __u8 result;
>>>> +};
>>>> +
>>>> +/* RX queue message types */
>>>> +struct virtio_can_rx {
>>>> +#define VIRTIO_CAN_RX                   0x0101
>>>> +       __le16 msg_type;
>>>> +       __le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bits */
>>>> +       __le32 reserved; /* May be needed in part for CAN XL priority */
>>> Can we use this field to report the classical CAN DLC greater than 8?
>>> If also needed by CAN XL, the field can be turned into a union.
>> Classical CAN cannot have a DLC > 8. CAN FD has a length up to 64 bytes.
> No, The DLC is coded on four bits and ranges from 0 to 15 for both
> Classical CAN and CAN-FD.
>
> Please refer to:
>
>    commit ea7800565a12 ("can: add optional DLC element to Classical CAN
> frame structure")
>    Link:https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2fgit.kernel.org%2ftorvalds%2fc%2fea7800565a12&umid=0b3549ac-d010-4d96-a348-2702485d82af&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-83a945dba88675fd8f98628601040c6860123b6d
>
> For more details, please refor to section 8.4.2.4 "DLC field" of ISO
> 11898-1:2015.
>
> I do believe that AUTOSAR do not allow Classical CAN frames with a DLC
> greater than 8, but the virtio implementation should support the ISO
> definitions.

I see now. The "length" in the more familiar (to me) AUTOSAR CAN_PduType 
is a "length" and not a "dlc". This detail with the DLC is ISO only and 
so I missed this. Not only therefore.

The CAN XL priority is 11 bits only and so fits in a __le16. Nobody else 
used an union so maybe:

__le32 reserved; =>

     __u8 reserved_classic_dlc; /* if CAN classic length = 8 then DLC 
can be 8..15 */
     __u8 padding;
     __le16 reserved_xl_priority; /* May be needed for CAN XL priority */

The member length is already __le16 to be able to put the 12 bits of 
2048 for CAN XL.

What made it more easy to miss is that also the cantools from Ubuntu 
20.04 do not support DLC > 8. The change in the cantools came in 
20-Nov-2020 by some commits from Oliver Hartkopp. Using newer cantools I 
can send and receive CAN frames with a DLC > 8 over vcan on my machine 
without having to hack the cantools. So the prerequisites to develop 
this feature seem to be available without having to hack cantools or vcan.

Now also not only a new CAN frame structure was introduced with 5.11.0 
but also CAN_CTRLMODE_CC_LEN8_DLC. CAN_CTRLMODE_CC_LEN8_DLC seems to be 
a feature if I understand this correctly. If we want to allow to use an 
AUTOSAR CAN driver as virtio device back end then also a new feature 
flag (e.g. VIRTIO_CAN_F_CLASSIC_DLC) would be needed.

If possible I would like to have this as a future feature only changing 
now the "reserved" field to make clear the planned purposes.

>> CAN XL into it.
>>
>> But for CAN XL we need anyway a more critical look from CAN XL experts
>> on the list. Here in the house there is already only fewer experience
>> with CAN FD in comparison with classic CAN but none at all with CAN XL.
>> Too new. If something is done in a stupid way we can define in the
>> future completely new messages as we have the msg_type. But if no
>> mistake is made now we can avoid this and enhancing things will be more
>> simple later. The RX and TX messages are really critical. Some bugs in
>> the software can be fixed easily. But if we define here something not
>> future proof this can only be addressed later in the spec with some more
>> effort.
> ACK.
>
>>>> +       __le32 flags;
>>>> +       __le32 can_id;
>>>> +       __u8 sdu[64];
>>>> +};
>>>> +
>>>> +/* Control queue message types */
>>>> +struct virtio_can_control_out {
>>>> +#define VIRTIO_CAN_SET_CTRL_MODE_START  0x0201
>>>> +#define VIRTIO_CAN_SET_CTRL_MODE_STOP   0x0202
>>>> +       __le16 msg_type;
>>>> +};
>>>> +
>>>> +struct virtio_can_control_in {
>>>> +       __u8 result;
>>>> +};
>>>> +
>>>> +#endif /* #ifndef _LINUX_VIRTIO_VIRTIO_CAN_H */
> Yours sincerely,
> Vincent Mailhol
>
Regards

Harald Mommer



