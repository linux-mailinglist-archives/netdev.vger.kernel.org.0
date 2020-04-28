Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEFE1BCCB4
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 21:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgD1Ttj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 15:49:39 -0400
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:41219
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728559AbgD1Ttj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 15:49:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JB8ILTRcyr+2LcGXPP4ILc2TdUUCvo39HJgeT/ZfBZdjIzXDETH5T/WogjekqRmA7Sd3HmQa851gkzh65clrl8VZKOz8PuKM0l3V4GbmVhbvu/b+LE+S8DIkUoQsYKGGCFZelNJxqJ454A7GMW4uqEYEFr7fs13dMgOh0t3kkMly4lwPi8RrIh56gjKc06Re+xr3pLVNFs4Tv0fVLMdmC8D+cHfPWyA0mWuFe2RdtEx2jprpLpAAtuxnWf15OgRIunOsE+HAXnzy/X5tSTyttp1b3aH/cHakNjYTVU8Si1O/YouIqe6oubez7MevOJEpQ0MLlQ0VMVSjYtHmIt5kJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9u+fLOZ4yJuS9BOGR/I0XYG6jyU3Fbeh8NUyZ6pC10=;
 b=hIviLSBHkqbmtlawRRyekGLKPq0GBi/N0/90j86HJppAZq/JgQEuFyvi1a70Pzr8FopFNXsoOoQ0jpGs4X+84d0rbzb9rYgbYG+cdRCrCsEBisHP5CfRdkBhJ6c4Tnicx8F349Zzn+jgU1LLYaIzJdlF4pmrbiBbqPiaa1q3llMMxw50qnjWEzVeVbxekX1gJTKrCICXGVh3lOl0ZQplSt1VIluvnaYeG+WBBL4zPHsr5OF5fnNO1fPDKobfMcHMLFX7n5r7mPpVj+dMlynrlfcwy9obMIks9sq8nSBEeOAHJ9gK/zKG6TUf08+li7OqXZzZJHIM1tvhDuVQucMLlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9u+fLOZ4yJuS9BOGR/I0XYG6jyU3Fbeh8NUyZ6pC10=;
 b=pAfqgVDlwSyZwrbr7v0yQXT4QarUzxOoFXz8e/zfWsQ3My5H28XUyXQD8tTECayFOpk9hIMXUU0cNL5j+Iz5Ue4+UdAxv0ENW2QvxaXw41ik99v3CaEfP18ibIhFMldxR25+8xSr4RTgMasIF/YRn64iDUuu9zgtcU3S36o+W70=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5487.eurprd05.prod.outlook.com (2603:10a6:803:91::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 19:49:34 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 19:49:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "zhengbin13@huawei.com" <zhengbin13@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH] net/mlx5e: Remove unneeded semicolon
Thread-Topic: [PATCH] net/mlx5e: Remove unneeded semicolon
Thread-Index: AQHWGhOK1iItA7OFSE2pYtjUtrylqqiO+B4A
Date:   Tue, 28 Apr 2020 19:49:34 +0000
Message-ID: <486b0d0b3b2607ece7324c98ccf9caa9a0af570d.camel@mellanox.com>
References: <20200424084357.80679-1-zhengbin13@huawei.com>
In-Reply-To: <20200424084357.80679-1-zhengbin13@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 142654b0-75b4-4d37-68b2-08d7ebad4698
x-ms-traffictypediagnostic: VI1PR05MB5487:
x-microsoft-antispam-prvs: <VI1PR05MB548741AE9DF957C335893FF8BEAC0@VI1PR05MB5487.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(8936002)(6512007)(66446008)(5660300002)(4744005)(6506007)(2616005)(66476007)(76116006)(498600001)(26005)(86362001)(2906002)(91956017)(8676002)(64756008)(66556008)(66946007)(36756003)(71200400001)(110136005)(186003)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WgCQCi8J4xke7Zj/zcImo6GMy1Z8amUsEn0sZjXN6E3jW4nG9DF7+tFNw5ZlOhUTuDvhflVqrcvSNeRVQyOZDH+KuSN3H5B/nsqKJ8zv8dFFGQCLFM5LTngu9BV4O5DlSblVJBFYAe18e0eVAdRfaYd6rGXqIupa1G7k8b+TBgi1ZPO1u58SrDfsYdcFjGq62UHGwWk5/cfnKyHF3Uk3t2ZsjeTuvb9BH4eu45bAanl+j2LJQqJ06c03wLSzKSgzj7dfEFazjlNdMp0142AkO4Rq5cJC8VoeXTuKBZ1ze6v5hQ9Phx7gLVLWBk8v/LVgvWTTeWLZbwJ8eV4aVqu2PSeoqSWXTuLPy0dngmu26mo/ELvh8Z2B5pxfDMgqR1KcztA8cbNZjgP7r/kNAgGeTko5p5OBlIGO8XR9iIqXLvVn6463zCCvixCdAz29Yc45
x-ms-exchange-antispam-messagedata: uubdabK7jaWXEbr1Ma5POxyYcYfWsqrKpXqRZ6KosncHlPTpzey5GUk0hMu8ZkkpzqYlPrYSmiwPs+olpp01vjw6FFrHF71elZkfHxnYoBp0jsOz0nGT6blKgitG+QL8n+jMaNGpCcmP4MDV6x1hYj47M74hANsUndvJcejMMP1fu2zLXnpuir8j+KJF2IcJjJIfZrTwD4NPxLHihUEph/VsYgXk6KqOyVyM/mjLwtXDOMrqRrqeMEHk8LDcg163lH17ouwSUpD1Y2vL/CuJoTMo9ee1DsPITIm1jHtMkCUQBtbyhGpwlzTDosHebWcfwF/qDyse57z172jpKxsWPFpuHSNp3oJ1jIcvBoyasJfjUrqHz3O+i2JjZ1YEeZo8DMdT2RZ948+hQTmS0MO3Rk/L8r0iWxhMgk//5tjGkF4JeTW7MJGNKaV1pnX7LOu1svnHB99wqQ0eqpDl7nTTb+zNAlNk/wHkMZLuCdZfFfDX4xp3dTwFPkJs7sSudnEnbqg7cubnYLjsCIeQjDpe+xrrxYsREWhBCLfrRoZqKtFeEWeXVNuwwwhhJPWTUPs1jDn/SScFDuhhQTc7diFslTezB+6n3qQWzZv/wBrpsIQPUA4ovjidqwGUvcPEF5beHNBhvY853+btL0gDlo2W2j9jpUZ8A8I3Xig8J91Q2ImeCE3lcMIcaY+OoVQUSg93DLIV1lBUHX6Egz5JW8FBVa6bD4Yk7+ARtUF+1OmJiZGTCHU1TNLdBBu8Jb5HTlZUjdBk3DRGkcPCJzq04ifleHnmAMycZyjHzG45k50e3Ww=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0AADAD52BFCA14EB03205CF39FE8201@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142654b0-75b4-4d37-68b2-08d7ebad4698
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2020 19:49:34.1088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wkhZ5uR9P8lhNVA0WH7vR9fUirxzMVwWhv5sfJ4grDqeXEWZuRkWmlyl+cQ3uUnbJSNP2UMuNadZG2AAbRbxRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5487
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA0LTI0IGF0IDE2OjQzICswODAwLCBaaGVuZyBCaW4gd3JvdGU6DQo+IEZp
eGVzIGNvY2NpY2hlY2sgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbi90Y19jdC5jOjY5MDoyLTM6IFVubmVlZGVkDQo+IHNlbWljb2xvbg0K
PiANCj4gUmVwb3J0ZWQtYnk6IEh1bGsgUm9ib3QgPGh1bGtjaUBodWF3ZWkuY29tPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBaaGVuZyBCaW4gPHpoZW5nYmluMTNAaHVhd2VpLmNvbT4NCj4gLS0tDQo+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdGNfY3QuYyB8IDIgKy0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi90
Y19jdC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3Rj
X2N0LmMNCj4gaW5kZXggYTE3MmM1ZTM5NzEwLi5hNjczYWRiNTQzMDcgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi90Y19jdC5jDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi90Y19jdC5jDQo+
IEBAIC02ODcsNyArNjg3LDcgQEAgbWx4NV90Y19jdF9ibG9ja19mbG93X29mZmxvYWQoZW51bSB0
Y19zZXR1cF90eXBlDQo+IHR5cGUsIHZvaWQgKnR5cGVfZGF0YSwNCj4gIAkJcmV0dXJuIG1seDVf
dGNfY3RfYmxvY2tfZmxvd19vZmZsb2FkX3N0YXRzKGZ0LCBmKTsNCj4gIAlkZWZhdWx0Og0KPiAg
CQlicmVhazsNCj4gLQl9Ow0KPiArCX0NCj4gDQo+ICAJcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiAg
fQ0KPiAtLQ0KPiAyLjI2LjAuMTA2Lmc5ZmFkZWRkDQo+IA0KDQoNCkFwcGxpZWQgdG8gbmV0LW5l
eHQtbWx4NSwgd2lsbCBiZSBzZW50IHRvIG5ldC1uZXh0IGluIG9uZSBvZiBteSBuZXh0DQpwdWxs
IHJlcXVlc3RzLi4NCg0KVGhhbmtzIQ0KDQoNCg==
