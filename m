Return-Path: <netdev+bounces-2362-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59F10701796
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 16:12:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE31C281AD0
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 14:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE95A63C5;
	Sat, 13 May 2023 14:12:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4781EDB
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 14:12:16 +0000 (UTC)
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9392D74;
	Sat, 13 May 2023 07:12:13 -0700 (PDT)
Received: from 104.47.7.176_.trendmicro.com (unknown [172.21.199.100])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 98F81100004F0;
	Sat, 13 May 2023 14:12:11 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1683987130.702000
X-TM-MAIL-UUID: 7469bb08-9b3b-4a1d-be76-64ba1001dc9f
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.176])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id ABB0E10000831;
	Sat, 13 May 2023 14:12:10 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGqlwcD3fMeG2OmWd5oMfnnXEVLjiLME1yR/Pew6iTC+aVW8V4pkLcFcrpXAAm6EnrvTOkBkNoyMzZJwkx3s9cHUybbjzSJFahHJn5f18Bjk3hBjKGvP4AQUh2S9l1waoYqz50D2Yh1g9LGaLQci0ZEbzy3f+hLRIz74jXbojr7gQi4ie6HV8FBA4NZxXLymla3JrSd0enIc2CVwHS5VRv9+j/SvQA5gcG6M9m6Lp2KsAog19MIpkF+CBJ1AuDGc2agh3U7hS3Uq8WAtmNL2FKuDiV1rj6X6+fBdSEoc6c/f+vHQuzJBj9uijTom9U8v6gBBSX6yVb1eJb32FijTrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yw5tLhTrGEqaK6F8eXT6E88/sQpHdiFHqsC7JVD5MR0=;
 b=kPjhTvnITLH89CMGucQBznaF5g6JsIduB0MrYjo145VOPdpn51jiH9nnOXbkJOYDv3yWbS9V5GtAhm+FvSrKMWeRHSmOBf6CQZ9PSA1buGQJ7M0PS+eIDx+SQ4cobGBgX0O5Yw2xNuAbb4zhrns6kQFhcZ9DQZWX8yAYL81DoqHo309In3fCJH3sZENDd3GLRp4uqJUYCSgkdLsqfooPORgQhslz5JXjWA8sBE9r0vmfNgE1CKOn24Jc3waYV1seAze/V2wuXBhDnQaoif+qR4BtuM500vKQT17uwIIww8Bwi0L7GUvmfykFXX2SUzRYqd+iWq9eAmqtUW46VklFMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <3950ac4f-3292-e6ca-7484-77f3a5639305@opensynergy.com>
Date: Sat, 13 May 2023 16:12:06 +0200
Subject: Re: [RFC PATCH v3] can: virtio: Initial virtio CAN driver.
Content-Language: en-US
To: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
 Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
Cc: virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Wolfgang Grandegger <wg@grandegger.com>,
 Marc Kleine-Budde <mkl@pengutronix.de>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
References: <20230511151444.162882-1-Mikhail.Golubev-Ciuchea@opensynergy.com>
 <CAMZ6RqJbjoApwZbiivbvJRYQyBWfWXG4azmwuXGaicrMq0Lozg@mail.gmail.com>
From: Harald Mommer <harald.mommer@opensynergy.com>
In-Reply-To: <CAMZ6RqJbjoApwZbiivbvJRYQyBWfWXG4azmwuXGaicrMq0Lozg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0114.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::20) To BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:4a::9)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BE1P281MB3400:EE_|BE1P281MB2227:EE_
X-MS-Office365-Filtering-Correlation-Id: 064ff691-f74e-4771-f15d-08db53bc09d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E5u9FkspeQcT0VERxDIcJoqs7sznXRAnxf875kU1n7Nv9yrlelcFY+lt3I4yPZhtLWh65gHeJ1VVu0HxXcwaofo74Chbq8ATX/lBpBbZOUcZtEEDYSgsDGYdrWs/Bme6xdBjFAGRG0QiL390Q8YGvIIqjLP5HPRENOcyVjp139cPb4oCM3+qlGch29STMlMwBm7BUhqO5W/qCbDkXSMW6WSudSCHCcPOca/0p+hYcJH8fSM4vKll6CNPm/0RX1tFbU5VRyRePWrj7tV64ZA7lFIpIFosWmwRmR1qK2EuWp+4Cm1pXi05KjxfLHCYy+d90E9h76BKN0wB0aTT9kkWGGNm/VHueYElLOmOlHzvaJsaYYVMaxOKSlwxoDCgeh1Q2rnLaGbsstEglh/ClO68w838emik9DHxlnNNb8scj51C5LipzBU0z+PP2ELY4FkZ1etqqNbBqLbU386uhBSdXJjz1uHBKNjiEkMBhV7tr3BEvAXrdU1RR0zes9ASrisNw60BVLHgsV5gpMLtwiY7CQdaB6tWQT7DoXSnz97paFMX9jcPXcqfiPQ/ehbZw6Oe
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(396003)(346002)(39830400003)(451199021)(186003)(2906002)(26005)(53546011)(36756003)(38100700002)(86362001)(31696002)(2616005)(83380400001)(8936002)(8676002)(66556008)(66476007)(66946007)(41300700001)(4326008)(6636002)(316002)(42186006)(54906003)(110136005)(7416002)(107886003)(44832011)(478600001)(31686004)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTg3OU55MjM2bFUrbzQ1SGJiVWhmZEg5NFpUYVBoY0E3NHg5RlRLRWpTTzFN?=
 =?utf-8?B?RGRibHlNaGdMMUQ4VzVtbm0xczBsOVZLdHltMDFWNlk0QlEvRDd5WVhFb2F1?=
 =?utf-8?B?cGt3ZW1BM2tMaUs2ZE9PbURKSjlCMS9CT0Q5S0QxaDIwUWNySzN0K1ZGU0FR?=
 =?utf-8?B?d1NraDVmM3EvSnk1dTJPZVp5UG5MN21aZkcycVpZOGoyZ3lRdDZHaGs1WThK?=
 =?utf-8?B?UEV2THArUWwwWXpoeHlqV3pnUkRRT2xvVEFjNkZFbzk0NXFjK0xFclVQbzFG?=
 =?utf-8?B?NG40dEo4Nkk2a0dYbU9Mcm52ekFMNHoyV01QWE5tY04yU2VUbGpJVWg5UEZG?=
 =?utf-8?B?SHBCMnhmTkE2aFcxcUlJV3lETThCeHE3K0xWcDVYNm5mRHhHNHRNT3A1QVdh?=
 =?utf-8?B?K1VYWjhHcHJFZVNUM0hiVmJVdFdqZ2VGWkZQRzNveEttMVZweG5TZkUrSUdo?=
 =?utf-8?B?azcycGFPM1B6c1VMRG8xMDY4ekR1Q1BMMjVZVW9oZXhQR1lKNjJ6MjI3bnJE?=
 =?utf-8?B?blZYUnVaSVdlSHZ4UkM1aVRVOG9xMHNRSjBYNytHRlhuUHRJeHJ5QUJ4ZDVC?=
 =?utf-8?B?RDV0RGpybEhPbXhKbk5aL0l3Ry9RSUpHMndVMUZyRWZEOWQ1V3IxTU0yUy9Z?=
 =?utf-8?B?UTdUTy9LVTk2ZFFYTkQ0T2RLTWJFMnllUGNEZGdZYmh1RXkrbFdNL2dWSUVp?=
 =?utf-8?B?UWluVFcwemlaZlZEWmVnQUVJOS9MNWNCcDEvbis4ZnpJQlpLOEY1RXBOaURw?=
 =?utf-8?B?eVlXTU1ZYy9CUm9OcitMT01aWTBWQkhNRWxLWFdnUlFtdWNudUhsM1EzSnZi?=
 =?utf-8?B?NE1rZzBlZTVHL0FPNVhLQU1LU2hQTTIyRVk1aG45YnN0Z1hXQkpzTkVOYWxv?=
 =?utf-8?B?dlgzVGN6WEt5bmhTMkJ3WmNiNEZYTUpCczErUUdiTUd0K1JDcjVCZjRpcmdE?=
 =?utf-8?B?UmhaNTUxczZDTExWM240L1hiZTBieFk5bXpjUlJ3UE4zU3RvZmdBZS9VbjQ1?=
 =?utf-8?B?QzVENFA2aTlZSEdrNnlxcVBlL2twRmpkdncwd20rdDVxT0pGM3Z3T3VTVngz?=
 =?utf-8?B?V1MrSk9URHRicUtoTklhcWFpd3M4UWVTQnRLTzVVNGJNM1B4bEhJaGcyY2ww?=
 =?utf-8?B?TnZWY1NVRzFMK1JSQ3hwRHFLWmVsN24wS0R4UEl6cjRkZVVhd3lQN1oyTGhK?=
 =?utf-8?B?cjl2alNDOTVjSzRWTmhZZC9EcVFGTnpaNzF5eGZrdjQ5a2xTOG5uZDNxYTBj?=
 =?utf-8?B?R3ZVL0NwOEc2MXhockZBckd3cExIZUVBYVE5M3hkYmFSd3dNWHVaNkZPUU5z?=
 =?utf-8?B?T2V6NmU3N3hpK3M4TjMrd0RCTlFrM2tlM0xuZnlZMThYUVhqaVFoZ3pPeDUr?=
 =?utf-8?B?T3QyQmZHUUxDMmNsN09Pclp0bVFTcGsycWdhcWRsN2pDM25HZ1J4dnZ4UHFP?=
 =?utf-8?B?bFFpUE5Wd1JGcXMrZHF5bW54eFA1MkZ5bktaRWJKekIwbEJSa2k5R21YU2NF?=
 =?utf-8?B?b2VXY0lNRk9SZTBGcFZ3WCs5ZExsampldWNweWU4OVNaSkV1eEJoRGZNL3Vs?=
 =?utf-8?B?T0dZYjAyT0U0UHhCYW1tQWVlOWFBNFI2WkVublRWMGpJMjhYbksxWlJCUzBi?=
 =?utf-8?B?ZUR5ZGFyalcxL1dOSEtrdGxWWkhKZHZraG5HdVVXN01QTkNlK05SM0Jick1W?=
 =?utf-8?B?V2ZXdXQrUklPK0w0VU5SekZWdUxQYnE2VmtJbmdGVXIrSysveTRzN015bmZl?=
 =?utf-8?B?STdvWU9GaXNzdDlpOHZ1ZitYcm9xOTBLaEhQenl4emtqWUwyYm1xVVVIOWFF?=
 =?utf-8?B?YnBJbWR0U0E5L3NMWHBvcVc4ckROUTFhWEpEd3c1U2gxNXRianpINDZqbHQy?=
 =?utf-8?B?S0tCQndVcVo0M3Zuemk0MnM4ZWtvUG41Nm1zNGxWUkZiSnhUQk13RGlMWUFr?=
 =?utf-8?B?UHJoZlhKd1NBNGVOR0FOeUc1M2tzTE9xRzFPQ01sK3ByR3o4ZU1idWlxZklM?=
 =?utf-8?B?QnRwMEJyT2NsRlBxOVhwMG90UVJQRVhjUzlyYXJJS1llYzJ5N3g5eldHUXdU?=
 =?utf-8?B?Mm91SkZ0L1RtVU8rWS9RWmFYMTRaMG5KcURHLy9peS9CMFp4WTZESHNuRW92?=
 =?utf-8?Q?jfhdtUvAlPkfFJQ2mCdQMCC8M?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 064ff691-f74e-4771-f15d-08db53bc09d2
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2023 14:12:09.0005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kg0sYJ0GTHtAEbBLcDHutb5RfWpimkG0FUlwwZkLc6pysoNck5xM/w/BVX4HeLjNZwxJW4H8BGvX7DZFC7IYFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE1P281MB2227
X-TM-AS-ERS: 104.47.7.176-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1007-27622.007
X-TMASE-Result: 10--13.869700-4.000000
X-TMASE-MatchedRID: hls5oAVArl8RqNE+xcwLcIGD9MrmzQNz9mojSc/N3QdlEv6AItKWF9Wv
	RsOl9XyIasOJoXx/wo+NKX6Ls5D/U0erW12mrTm5HWRJEfGP5nlYyqUhAqJUSfmrkkH6JvZBAIp
	fGMv6NnXM+Hh7VbHQ6kSaTKs/NgcvwhEzFq5pLdSDpW5ZeDjLZP7CDyGkV4qABm9f7S94IJwjty
	fNKljEg0iJ9d0G5Wsd9Cg8TV2EmpDL1IusN7305NKDcT1f9CjEdmWMDQajOiLpRYEGd8yzt5kQ0
	od6QhJDbGYMn6V2Kka5cURAloITPk1+zyfzlN7ygxsfzkNRlfKx5amWK2anSPoLR4+zsDTtFAQv
	QYa7pIPAHJqjqaf/UYENOHnkwjuuqBTQg3zVADpd/c81SFI10A==
X-TMASE-XGENCLOUD: bc8459aa-9737-456b-8809-a96b33a97b4a-0-0-200-0
X-TM-Deliver-Signature: 302FD573BD55D6D6EEAFB9F8A0ECAB9F
X-TM-Addin-Auth: i9OSjGYSqL264KZI6nKFI6QkG3T21UDlLUbx/t72v/LGXx7rRDhUBjkOXoF
	08qp8+SusbqQ94S1O7j+ziR6ny48LxA8rwJbirBthECwOM7PITt/TRh+xUMtq0sWYzGbmAElMuH
	8fc/M0EMm0Oz1shrH0xLLstLjW3SyFQ51OvVa6G6iFL6/apBJp7bS5V/Qycp23EofFeGu1GjTWi
	dJFFD23Etf5w/0xriqBP3+gImqh4iSdE+tbtKbTuqUj7VaBTJVCH7RudCU6X6TxLr88rW2fe6rW
	DGXDlT8xrCId4X0=.n9qs3OwoUq/uZlBCUL7CDlFznhD8OSROqbY+1DBc3gad/ym4GI91JC+9kG
	wt4fCk7+XHO6DaqOTT00H4U3NbALpJ6R73QO64vBiKeQNCpn/2aKgLzP28pYEcJTVF9DdMXRGqg
	W3hUAT9qqJlABCUDv+Kmg1PrcJo6F3ny14yqErAwaDvSwMx75uH0rY227Hi0yTHWTM2ZwPfkJmR
	l8RqlMAHzfqkhDcAG4dwdNdzj7bhZiqzVU5suWUboYBtUmj93Du7j0kabZQexCUS3E7FEjf79BN
	zdzE+KQV9c6RxAPRRSaFiT9bE6qS+ZOz4DsAtL2ASWIaxskbAyVOYXSAjgQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1683987131;
	bh=f4y+d2dGCmDC/C5euopYmIFPFTrQ/rkOXc3Otvv9Qv4=; l=2083;
	h=Date:To:From;
	b=NyFlTagKJgCi+eqZKcvcEq0U0jDpF9/zXcfIyTUoKGR3EUTK7P0GUGDyCYwh/MJ75
	 gXQvcBXyAHpSUFUBUh6yL3yJz3Eg7Bdzqwn/9IA2TtZF5vEGI9s3a0sqRZNBn/hpsY
	 VvXeOLNG0cCnhJA0a08w7UYja/XCNTno5kmTHIq40bmjj+J54egTwUn7z21fPlKF5u
	 Ab7q3T32pvb9fY69+ITCwPqHr6HdD/hCWgignA58dC6DUvocP/AtV4fux7VnXnrtou
	 o8/5NW67dsoKRNZjm/TTEVmTTz7upQ2/0x5NXnodS/JBQtar5379ZB7xErkQ22JxOa
	 VrNbVCI0p2nDw==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Vincent,

sometimes it's close to weekend and already late. I've to correct myself.

On 12.05.23 11:53, Vincent MAILHOL wrote:
>
>> +static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
>> +                                        struct net_device *dev)
>> +{
>> +       struct virtio_can_priv *priv = netdev_priv(dev);
>> +       struct canfd_frame *cf = (struct canfd_frame *)skb->data;
>> +       struct virtio_can_tx *can_tx_msg;
>> +       struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
>> +       struct scatterlist sg_out[1];
>> +       struct scatterlist sg_in[1];
>> +       struct scatterlist *sgs[2];
This 2 here.
>
>> +       /* Normal queue stop when no transmission slots are left */
>> +       if (atomic_read(&priv->tx_inflight) >= priv->can.echo_skb_max ||
>> +           vq->num_free == 0 || (vq->num_free < 2 &&
> Replace the Magic number 2 with a #define.

Is this 2 here.

Obviously with my previous answer I switched into panic mode thinking 
already about explaining indirect descriptors and all kind of virtio 
details and the expression in depth not realizing any more that 
something different was requested.

Appropriate answer:

/* CAN TX needs 2 descriptors: 1 device readable and 1 device writable */
#define CAN_TX_DESC (1 + 1)

Or something with ARRAY_SIZE(sgs) to get the number of elements in sgs 
keeping the first 2 above.

And then I'll have to think again whether I really want to keep 
sgs_in[1] and sgs_out[1] as arrays. Not now, now is weekend.

>> +           !virtio_has_feature(vq->vdev, VIRTIO_RING_F_INDIRECT_DESC))) {
>> +               netif_stop_queue(dev);
>> +               netdev_dbg(dev, "TX: Normal stop queue\n");
>> +       }
>> +
>> +       spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +
>> +kick:
>> +       if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
>> +               if (!virtqueue_kick(vq))
>> +                       netdev_err(dev, "%s(): Kick failed\n", __func__);
>> +       }
>> +
>> +       return xmit_ret;
>> +}
>>

