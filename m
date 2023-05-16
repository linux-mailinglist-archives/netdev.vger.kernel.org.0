Return-Path: <netdev+bounces-3094-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E76CC7056F2
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:18:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04CEF2812A5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB95829108;
	Tue, 16 May 2023 19:18:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF79187E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:18:24 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB1B7DA7;
	Tue, 16 May 2023 12:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684264702; x=1715800702;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VShqtt81y/fSkdvP5+WL+SSIcWy6fi1ngjofyValK6Y=;
  b=liFE3Y5woB+c+2j2zSmKiCaEOuMc7HJIxl2ueEtW6G0PVJv1yq7yp7Cw
   i5/asBA5NYzj1a1UjuTutnCFoTH5VwCM6PlD98NvpvGzIj21Gl3Kzrqyy
   uar+T5MsXvBW8XJsS6Q6Njy8+hCZktZhvg0vDWJuX9Qpbho5S/f7vAVBp
   5Mt7vd4JDkNgpfJoRW3Si69w4YjlcA9VPDIh0O6UpIMdNnAwHXSnASnIs
   OxGzpxjvl8ZUHxmuBcnVF7vkSdTJYhjSUi7adhGsBgEoEW7JiqD6QVXic
   KLhwxv2lb0cR4+V7OvdyibyX5D6JPkqDPfWU5KwcyZYx7GehATmdlhaPq
   w==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677567600"; 
   d="scan'208";a="152389125"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 May 2023 12:18:21 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 16 May 2023 12:18:18 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 16 May 2023 12:18:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+tUTHVloDIDz2eGgCoSHF+8lL2r9wMRvDk2xfKYD+Q20eirVPU6Lzc5P1lohwGhL+CWveK2ZCYqXuj2R8N+ztOFCdcMeijmlWBfC8utS6DkmYsqmF7jJoVLgIIsfEl7/E9gefTJ9B3ZR4yyhxLypZ4xPAJvz5u+V1ZngJ+nsYn+4kbOhr+Hx1F47+BQgBSM6wBFbxkvleR2qjSLnuVaVrP+rMmPga3qfKLD89sKpeYZu7hMngv91rD9boK4d/Z/yzCmBH10KE8lL6NN2wvdau7SxS1iLl2jdltlQEKTBEzLG5cbu1AkQgs1Xfehi7wMXWtZrjxTt1I37T5Wbd2hEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTTncoPY/5xVqX2SOmHYPu0f90w/LLKhV5I1Hv2qwjM=;
 b=Fwz2Xyf6JzZNUTHVqE85VxOuVsnsbTYNiocmoPl2n/cuCqtG4bhEopkhaD1q7XMEpT+Iy/hWdTRVkxTqz9oHRCYMSXyf7pVdDAofm3MvBNAs4iOVBhAkE8+XA+kgK5EYM9VVX2cUk5u7pd0gWTWTMXvqSWUoqpYcZzasojn5ZMu5PFM4KYuMNTplezPJgulbMaEpzdvyvbNYBidIMM4o6GCmxYuBU/ZSCkFRIg2VxcNRI3AygQ7PjopquZakJrUejbSjkuS5Gn2dMtERs0bmoSnw/kj8QS1veqZhyIzJlXktvh9aWXh8M1l3piDm5Q7el6+Ibs3MYce9CXzjZpOQUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTTncoPY/5xVqX2SOmHYPu0f90w/LLKhV5I1Hv2qwjM=;
 b=jnOg6tHtlK3akSFNeSPwcHDb0y/OHjB20L6OJn7wON7FyQuItOnxY6nnY1f8Atth5DjaG4Oc+VlFUEG0XO4vJ34e+2qaMHTB0dEime9HRPS6rX3WlZeMjq5NNZS/Ke3ZPtz9N1/AdJ7XOxrfuZxZ4/9Edsgz6nApREmhWfclbYY=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by PH7PR11MB7076.namprd11.prod.outlook.com (2603:10b6:510:20f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 19:18:13 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1%6]) with mapi id 15.20.6387.032; Tue, 16 May 2023
 19:18:13 +0000
From: <Daniel.Machon@microchip.com>
To: <bagasdotme@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<corbet@lwn.net>, <gal@nvidia.com>, <rrameshbabu@nvidia.com>,
	<msanalla@nvidia.com>, <moshe@nvidia.com>, <tariqt@nvidia.com>,
	<leonro@nvidia.com>
Subject: Re: [PATCH net v2 2/4] Documentation: net/mlx5: Use bullet and
 definition lists for vnic counters description
Thread-Topic: [PATCH net v2 2/4] Documentation: net/mlx5: Use bullet and
 definition lists for vnic counters description
Thread-Index: AQHZgvNeBM0B5kBy/0uDqnMIiNpOuK9dUGkA
Date: Tue, 16 May 2023 19:18:13 +0000
Message-ID: <ZGPW9BZajS3q33ki@DEN-LT-70577>
References: <20230510035415.16956-1-bagasdotme@gmail.com>
 <20230510035415.16956-3-bagasdotme@gmail.com>
In-Reply-To: <20230510035415.16956-3-bagasdotme@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|PH7PR11MB7076:EE_
x-ms-office365-filtering-correlation-id: 15ef7bc5-d5f9-4097-6e9f-08db56424b2f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xOIRRsq369SZ6cPOpmDUNKFocKKan+VYI27skh1x0Z0lKf0r/HNbUz+foNnKL2nsDPPcIcDWXP8jBj7+5YbEvPoGYMRmGQZO4JybpJfE9LFNuzUpDKaf4b2mqw1NK7e8oThf+LbUNVKfHNQSc/B9N6rmrUQN3o9wajEcxmgyyKXPg66mFk3Eb6vbOXliWWZUL1L8Nwmu6BdGDS2hhtIv06C5cQ0l7197IxwvtSUkPwewdYAyKyNPgvd90LR3lWuG9KvlcR5fCcMBYIvtln3yYDKT7o0BJVsAfHcZDgXZnMPT1NOj34dKvAFDpDdjoVDfbr1+R3TQMdQl16IvFCAZARZpZu3B59v5QAnqJQ8VQ1BW3dLRMKscFvjKkS+0YfPf1cu7poJBTyjORTUFCTg1HqGdtrN7Gpf6buTQb/bFEoiZWNLml4LwNscUrJGCVYDerBfp+bxz8m/CDNtUTI2/o+LnB6TxWnTay4lhbDxyBtSoM8RurEji/6yDM27NofEGCueo6rbAd6nfIoGFZKwfimpahHsn8+zSFmxRFUfe+W/nBsEf1EyZwyssa0aooTtcGbCcjOrLVYyDHO4UZHzl2NiPnZIQPrfRWePJ+aZoAPm0t8ZGqCN2FROFbtDluKsK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199021)(6512007)(6506007)(26005)(9686003)(83380400001)(38100700002)(41300700001)(71200400001)(6486002)(186003)(478600001)(54906003)(66476007)(64756008)(6916009)(91956017)(4326008)(66556008)(66446008)(66946007)(316002)(76116006)(122000001)(7416002)(5660300002)(8676002)(8936002)(33716001)(38070700005)(86362001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gIioL5H6Q6aaEZ44O4Q7L4D2SXFSM3TWUqvfIlm1umB8TBqMCGKaWAAcW9TJ?=
 =?us-ascii?Q?BxLE4Zo6sCnMQTJzFjcAPJV4SQRs9GrJ/p+R+YOoLMCSRBSQDnTrqA2De/GO?=
 =?us-ascii?Q?dlUkJOLvIMlgewVmPL/jlr1eAZ9ZsVnIjodzKpjF9FtzeTtRS9T/AaPeVH2W?=
 =?us-ascii?Q?rSqwcTD7iuLzJUrpPe2mL4MIvQby1NYPOb7K1DwohWHccJjhslFmHxJQju5C?=
 =?us-ascii?Q?4a68pmtUUoRa1YwOhs1yANngobY29oHDoZiuhbYddyuNazRAKtT2mLDNyDgF?=
 =?us-ascii?Q?xXGox++vAg2J/Pt68dVvapp9ZFbf4Du1HPMKXcortLZUPEq2SgqO/933g9ZS?=
 =?us-ascii?Q?nKoj4ajnhTZxHBuGIuEaDrOTcVmBPFKZqpS1glO4FkDP4T9sY4/hG7XTo10Z?=
 =?us-ascii?Q?0wGKTphd5s+fXc8FnvcbndHDXZU7n1IG6Fx8Pr+7p93BhBdIGasecssDL5PK?=
 =?us-ascii?Q?xCoeQTNrQnHFf5hjruT1x41ouh2IDxphXmfI5DbqtW4vf3NHTWINk/uCz7tC?=
 =?us-ascii?Q?L9rQaQrz76EdkNQRk2AmeR0G8SX8WSm6EUqnigkUgFcIW0agpqV1j5YDMaIA?=
 =?us-ascii?Q?unbNEysIso84Qh/oKJ4Vq3Rsd9n5z1wcPm644fYERLDhkSImDl0TMmZ9jxOK?=
 =?us-ascii?Q?Xf2O8/5yz2d8gnxX9mVOCOOnwl58sHJM9rb4KLJAqvw0MY1Le9+trff1VZSY?=
 =?us-ascii?Q?PjuXCVckZiMRxDL1RaMRyCbZsEldhQGzCsYwLs29ohOUwvTio6t0Nw8A6KHz?=
 =?us-ascii?Q?3fH+513nODT9tMwQ4lEFR4AUORhSgbQOAWx44f7+Bzd8N7+oFcKxrIX3atNd?=
 =?us-ascii?Q?7bzgfzCE7c0GoQyfIn07euGhlVYhsCxZxg5h4oo8n8HSitqNfy029uPhyu61?=
 =?us-ascii?Q?+AYMsO0zmnkvqySiZPSd2XPlZoaEl3v+eX9tL9bZKMVIR8GudyvQA/niIXGg?=
 =?us-ascii?Q?FWFn9Z3Ud3/8LpfWBL3AvYtZ8VMV6ULmdsFkDbSKhYTJAH3Khy+NrsUuJydn?=
 =?us-ascii?Q?ICI1PXo6+re18Puu9/XKCdX1AtSQ4HJwLVSA0+Ifq4TBu+C8gmkvFlQfgiai?=
 =?us-ascii?Q?ql/6Z8Sy30HuZKds0mSRZOOwLElIl5d7doWSeQ/l5ANco2oYfemdCI0U5/Gu?=
 =?us-ascii?Q?S+CWUeIZ+Ke+WNVY50oN3jk4iM3BptNVUC6ESe+P9+RWateLNLSoc5tQpkJZ?=
 =?us-ascii?Q?cPiq0WxbRS/cNJbI1lB18yzSf8e3Vkmbu64pwap++e1HPI0UoVkcVW9tpEoC?=
 =?us-ascii?Q?6vlK3wf+uNo0ac43bIVm4k6K4c5N0diF7yJDuzDzAeqv3p/FgVveDvkS0mOW?=
 =?us-ascii?Q?XyAKBO0Qdah9D38fWrWBKaCzY2nglUBmKWpwgW+kf6ZdENxK1qGXgskpvttB?=
 =?us-ascii?Q?788nsHYHz3CwA4AxLMMxGfbXRJiOlS1+Uos7iLp/lE3bKRQfdY67Sdq9FHNI?=
 =?us-ascii?Q?YCEle/PbBA/SRNwZ+IEslvvuhf9I/jMeyZyKnwP5dcJFbtOaS4U6Bne4UcRb?=
 =?us-ascii?Q?XBfpEeqSyr2qIBpXftDSd+IyEVcXlYRFN8MpAxb3Ak9bupJ08TjG+lON4aQ0?=
 =?us-ascii?Q?I8RzITHFy6ryI5d2Xq+qSWogWOyPmEcLfeueZxA1QClKfkFHeEf+G+rQwqfz?=
 =?us-ascii?Q?dA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C62D4BF8A6C33B49BDAF921CAD345993@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ef7bc5-d5f9-4097-6e9f-08db56424b2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 19:18:13.1854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ExZX85QLg6OG/jJHPHUOui/a/3pIP1NyIP+CPjMD4u0RaurRWOiYDE/aPEMjEY/CwXXdMe+KaGPnPTiWOdM4r2c1vz2bisb6eh21WZleuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7076
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>  Description of the vnic counters:
> -total_q_under_processor_handle: number of queues in an error state due t=
o
> -an async error or errored command.
> -send_queue_priority_update_flow: number of QP/SQ priority/SL update
> -events.
> -cq_overrun: number of times CQ entered an error state due to an
> -overflow.
> -async_eq_overrun: number of times an EQ mapped to async events was
> -overrun.
> -comp_eq_overrun: number of times an EQ mapped to completion events was
> -overrun.
> -quota_exceeded_command: number of commands issued and failed due to quot=
a
> -exceeded.
> -invalid_command: number of commands issued and failed dues to any reason
> -other than quota exceeded.
> -nic_receive_steering_discard: number of packets that completed RX flow
> -steering but were discarded due to a mismatch in flow table.
> +
> +- total_q_under_processor_handle
> +        number of queues in an error state due to
> +        an async error or errored command.
> +- send_queue_priority_update_flow
> +        number of QP/SQ priority/SL update events.
> +- cq_overrun
> +        number of times CQ entered an error state due to an overflow.
> +- async_eq_overrun
> +        number of times an EQ mapped to async events was overrun.
> +        comp_eq_overrun number of times an EQ mapped to completion event=
s was
> +        overrun.
> +- quota_exceeded_command
> +        number of commands issued and failed due to quota exceeded.
> +- invalid_command
> +        number of commands issued and failed dues to any reason other th=
an quota
> +        exceeded.

Hi Bagas,

nit: I think 'dues' should be 'due' here. Might as well get that in
when touching the code anyway.

Other than that:

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>

> +- nic_receive_steering_discard
> +        number of packets that completed RX flow
> +        steering but were discarded due to a mismatch in flow table.
 =

