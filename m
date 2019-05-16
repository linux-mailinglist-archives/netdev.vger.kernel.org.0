Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7849620B47
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 17:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfEPPa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 11:30:56 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:2534
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726692AbfEPPa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 11:30:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjFRyEF+r0iSm1zpGNwtiNGlavM9lqkbECsXY5mbnGU=;
 b=FrUYVidze5zm2O89CUtq2ZsNDAsxldldwYTNn0VJ5AmFyAIzvQBZPvF7My9S8UglrpXZygdqJDpaY9T4K4cmreMocJt0IkT6qmEgnt6oHhbPRPaTiDNinEZMeYs/BjMn9eRwU0aQ0j/sdwfINuSMNYcvNKVkJ4DGbUpJuUc1uTY=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB3165.eurprd04.prod.outlook.com (10.170.229.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Thu, 16 May 2019 15:30:51 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::d9de:1be3:e7e6:757f]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::d9de:1be3:e7e6:757f%3]) with mapi id 15.20.1900.010; Thu, 16 May 2019
 15:30:51 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] enetc: add hardware timestamping support
Thread-Topic: [PATCH 1/3] enetc: add hardware timestamping support
Thread-Index: AQHVC84BpTq18Sng3k254t8Y+2yCUKZt0N+AgAAFuTA=
Date:   Thu, 16 May 2019 15:30:51 +0000
Message-ID: <VI1PR04MB4880B9B346D29E0EFC715D28960A0@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <20190516100028.48256-1-yangbo.lu@nxp.com>
 <20190516100028.48256-2-yangbo.lu@nxp.com>
 <20190516143251.akbt3ns6ue2jrhl5@localhost>
In-Reply-To: <20190516143251.akbt3ns6ue2jrhl5@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fa7ec64-6c2e-45da-664a-08d6da137ac7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB3165;
x-ms-traffictypediagnostic: VI1PR04MB3165:
x-microsoft-antispam-prvs: <VI1PR04MB3165156301F587BBBD657544960A0@VI1PR04MB3165.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(376002)(346002)(39860400002)(189003)(199004)(52314003)(13464003)(71190400001)(305945005)(71200400001)(99286004)(66476007)(66066001)(66556008)(66946007)(6246003)(64756008)(6436002)(66446008)(54906003)(229853002)(14444005)(256004)(33656002)(5660300002)(52536014)(68736007)(73956011)(76116006)(53936002)(110136005)(6636002)(3846002)(6116002)(44832011)(14454004)(25786009)(102836004)(6506007)(186003)(478600001)(446003)(8936002)(26005)(11346002)(81156014)(8676002)(81166006)(2906002)(7736002)(7696005)(486006)(76176011)(4326008)(476003)(74316002)(316002)(9686003)(55016002)(86362001)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB3165;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F9kOkM3tBf8cdsXeggI+RmydGsnaTZrqfv+IYg13HxmUYCvD5KwThJ21Kd6El58ZM/TwgNQXwzX2XpDjWzQ7bhjpjAh3ptlEuNfE5j6pJSls1McnBHjVFbQk1a/VuzmYIdT6ooOP3/EgSSXh+XU6VhaWQnjTNilsOrhXvTXow02cEwokCJwj4X6SnamL154kb23/eNlnkQMsALD7SiQyQo6PdHMmCS2PwzLdZJVABUrm5u6pWR/zH6Jlt6utIidtFAhHi9BgdtYyCGEH3KVcCpDM6TGDpSFlT5xzj24hY4kwberlXCrDmRydgFEb3cSCU7FjDDmPxIch/+7ArwskPHEE/+b1l78OAVEPTS/ZIbNXDl4Tp5sbFbU0Y30IbsuG8LWCtYSEfui20uDbv1/s58viIvLBb+XwrI00q8jn7kQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa7ec64-6c2e-45da-664a-08d6da137ac7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 15:30:51.6417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3165
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>-----Original Message-----
>From: Richard Cochran <richardcochran@gmail.com>
>Sent: Thursday, May 16, 2019 5:33 PM
>To: Y.b. Lu <yangbo.lu@nxp.com>
>Cc: netdev@vger.kernel.org; David Miller <davem@davemloft.net>; Claudiu
>Manoil <claudiu.manoil@nxp.com>; Shawn Guo <shawnguo@kernel.org>; Rob
>Herring <robh+dt@kernel.org>; devicetree@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 1/3] enetc: add hardware timestamping support
>
>On Thu, May 16, 2019 at 09:59:08AM +0000, Y.b. Lu wrote:
>
[...]
>
>>  static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_bud=
get)
>>  {
>>  	struct net_device *ndev =3D tx_ring->ndev;
>> +	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
>>  	int tx_frm_cnt =3D 0, tx_byte_cnt =3D 0;
>>  	struct enetc_tx_swbd *tx_swbd;
>> +	union enetc_tx_bd *txbd;
>> +	bool do_tstamp;
>>  	int i, bds_to_clean;
>> +	u64 tstamp =3D 0;
>
>Please keep in reverse Christmas tree order as much as possible:

For the xmass tree part, Yangbo, better move the priv and txbd declarations
inside the scope of the if() {} block where they are actually used, i.e.:

		if (unlikely(tx_swbd->check_wb)) {
			struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
			union enetc_tx_bd *txbd;
			[...]
		}

>
>	union enetc_tx_bd *txbd;
>	int i, bds_to_clean;
>	bool do_tstamp;
>	u64 tstamp =3D 0;
>
>>  	i =3D tx_ring->next_to_clean;
>>  	tx_swbd =3D &tx_ring->tx_swbd[i];
>>  	bds_to_clean =3D enetc_bd_ready_count(tx_ring, i);
>>
>> +	do_tstamp =3D false;
>> +
>>  	while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
>>  		bool is_eof =3D !!tx_swbd->skb;
>>
>> +		if (unlikely(tx_swbd->check_wb)) {
>> +			txbd =3D ENETC_TXBD(*tx_ring, i);
>> +
>> +			if (!(txbd->flags & ENETC_TXBD_FLAGS_W))
>> +				goto no_wb;
>> +
>> +			if (tx_swbd->do_tstamp) {
>> +				enetc_get_tx_tstamp(&priv->si->hw, txbd,
>> +						    &tstamp);
>> +				do_tstamp =3D true;
>> +			}
>> +		}
>> +no_wb:
>
>This goto seems strange and unnecessary.  How about this instead?
>
>			if (txbd->flags & ENETC_TXBD_FLAGS_W &&
>			    tx_swbd->do_tstamp) {
>				enetc_get_tx_tstamp(&priv->si->hw, txbd, &tstamp);
>				do_tstamp =3D true;
>			}
>

Absolutely, somehow I missed this.  I guess the intention was to be able to=
 support multiple
if() blocks for the writeback case (W flag set) but the code is much better=
 off without the goto.

>>  		enetc_unmap_tx_buff(tx_ring, tx_swbd);
>>  		if (is_eof) {
>> +			if (unlikely(do_tstamp)) {
>> +				enetc_tstamp_tx(tx_swbd->skb, tstamp);
>> +				do_tstamp =3D false;
>> +			}
>>  			napi_consume_skb(tx_swbd->skb, napi_budget);
>>  			tx_swbd->skb =3D NULL;
>>  		}
>> @@ -167,6 +169,11 @@ struct enetc_cls_rule {
>>
>>  #define ENETC_MAX_BDR_INT	2 /* fixed to max # of available cpus */
>>
>> +enum enetc_hw_features {
>
>This is a poor choice of name.  It sounds like it describes HW
>capabilities, but you use it to track whether a feature is requested
>at run time.
>
>> +	ENETC_F_RX_TSTAMP	=3D BIT(0),
>> +	ENETC_F_TX_TSTAMP	=3D BIT(1),
>> +};
>> +
>>  struct enetc_ndev_priv {
>>  	struct net_device *ndev;
>>  	struct device *dev; /* dma-mapping device */
>> @@ -178,6 +185,7 @@ struct enetc_ndev_priv {
>>  	u16 rx_bd_count, tx_bd_count;
>>
>>  	u16 msg_enable;
>> +	int hw_features;
>
>This is also poorly named.  How about "tstamp_request" instead?
>

This ndev_priv variable was intended to gather flags for all the active h/w=
 related
features, i.e. keeping count of what h/w offloads are enabled for the curre=
nt device
(at least for those that don't have already a netdev_features_t flag).
I wouldn't waste an int for 2 timestamp flags, I'd rather have a more gener=
ic name.
Maybe active_offloads then?

Anyway, the name can be changed later too, when other offloads will be adde=
d.

Thanks,
Claudiu
