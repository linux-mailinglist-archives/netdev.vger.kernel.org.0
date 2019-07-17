Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F736B588
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 06:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfGQEXk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jul 2019 00:23:40 -0400
Received: from m9a0002g.houston.softwaregrp.com ([15.124.64.67]:41698 "EHLO
        m9a0002g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725294AbfGQEXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 00:23:40 -0400
Received: FROM m9a0002g.houston.softwaregrp.com (15.121.0.190) BY m9a0002g.houston.softwaregrp.com WITH ESMTP;
 Wed, 17 Jul 2019 04:23:36 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 17 Jul 2019 04:23:31 +0000
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (15.124.72.10) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 17 Jul 2019 04:23:31 +0000
Received: from CH2PR18MB3189.namprd18.prod.outlook.com (52.132.244.203) by
 CH2PR18MB3206.namprd18.prod.outlook.com (52.132.244.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Wed, 17 Jul 2019 04:23:28 +0000
Received: from CH2PR18MB3189.namprd18.prod.outlook.com
 ([fe80::2053:cdc8:d81c:a5d6]) by CH2PR18MB3189.namprd18.prod.outlook.com
 ([fe80::2053:cdc8:d81c:a5d6%7]) with mapi id 15.20.2073.012; Wed, 17 Jul 2019
 04:23:28 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     Benjamin Poirier <BPoirier@suse.com>,
        David Miller <davem@davemloft.net>
CC:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] be2net: Signal that the device cannot transmit during
 reconfiguration
Thread-Topic: [PATCH net] be2net: Signal that the device cannot transmit
 during reconfiguration
Thread-Index: AQHVO67z2A6t0cO8nkSyQhUeM2Az8KbOMBQE
Date:   Wed, 17 Jul 2019 04:23:28 +0000
Message-ID: <CH2PR18MB31898E033896F9760D36BFF288C90@CH2PR18MB3189.namprd18.prod.outlook.com>
References: <20190716081655.7676-1-bpoirier@suse.com>
In-Reply-To: <20190716081655.7676-1-bpoirier@suse.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=firo.yang@suse.com; 
x-originating-ip: [45.122.156.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d75c1769-5775-4dab-b9dd-08d70a6e84ed
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR18MB3206;
x-ms-traffictypediagnostic: CH2PR18MB3206:
x-microsoft-antispam-prvs: <CH2PR18MB32066BFE5300D49125996D1B88C90@CH2PR18MB3206.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(189003)(199004)(7696005)(76176011)(14444005)(256004)(44832011)(476003)(486006)(99286004)(2906002)(76116006)(64756008)(6506007)(66946007)(66066001)(66476007)(66446008)(66556008)(53546011)(81166006)(81156014)(8676002)(52536014)(74316002)(11346002)(446003)(102836004)(5660300002)(71200400001)(7736002)(305945005)(8936002)(71190400001)(86362001)(6436002)(26005)(6116002)(3846002)(186003)(68736007)(33656002)(54906003)(14454004)(110136005)(316002)(25786009)(9686003)(6246003)(53936002)(55016002)(4326008)(229853002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3206;H:CH2PR18MB3189.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QempcL2D+485Ksp5L46DHjbEdam0bjtHjdC+Rw9G3YBkXZQ/Rn7N48i/QL+rM8Kz6MFgMBuUMoXxjVjn+8r779E9QdFnXOeIR2Q7ARBywek7rD03lnq37qPCxynLqmJ4SMGCNSuhISWxFFst0olhA8AEepirBUq4aB5SKgdy72ddWx1oM78751lZNhb8+GehZ7piCIkJDY9TDqF8QUWFN7n0kZmoxplhV2XXt4dvf1kk3YJyLKgmUqoQDg/D2hsPhwqJDUHadcL5SfwrTdoCyq/CD80U8XzzQP6NJMfg21qzUy6xX8kxQmLQWwCZ8/66BGhuswISa73sRQbiuB/wH6rqTGQMICYgxTzkuaFjsgtRnatQ+km6Z0Jo0sUAqmRFHYPyprQbpRISAUEJAKHomOPZiNIpbZP5Za8VhH0s9hs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d75c1769-5775-4dab-b9dd-08d70a6e84ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2019 04:23:28.7787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: firo.yang@suse.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3206
X-OriginatorOrg: suse.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think there is a problem if dev_watchdog() is triggered before netif_carrier_off(). dev_watchdog() might call ->ndo_tx_timeout(), i.e. be_tx_timeout(), if txq timeout  happens. Thus be_tx_timeout() could still be able to access the memory which is being freed by be_update_queues().

Thanks,
Firo

________________________________________
From: Benjamin Poirier
Sent: Tuesday, July 16, 2019 4:16 PM
To: David Miller
Cc: Ajit Khaparde; Sathya Perla; Somnath Kotur; Sriharsha Basavapatna; Saeed Mahameed; Firo Yang; netdev@vger.kernel.org
Subject: [PATCH net] be2net: Signal that the device cannot transmit during reconfiguration

While changing the number of interrupt channels, be2net stops adapter
operation (including netif_tx_disable()) but it doesn't signal that it
cannot transmit. This may lead dev_watchdog() to falsely trigger during
that time.

Add the missing call to netif_carrier_off(), following the pattern used in
many other drivers. netif_carrier_on() is already taken care of in
be_open().

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 82015c8a5ed7..b7a246b33599 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4697,8 +4697,12 @@ int be_update_queues(struct be_adapter *adapter)
        struct net_device *netdev = adapter->netdev;
        int status;

-       if (netif_running(netdev))
+       if (netif_running(netdev)) {
+               /* device cannot transmit now, avoid dev_watchdog timeouts */
+               netif_carrier_off(netdev);
+
                be_close(netdev);
+       }

        be_cancel_worker(adapter);

--
2.22.0

