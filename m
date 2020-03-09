Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699E817E13C
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 14:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCINb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 09:31:59 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:54528 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726427AbgCINb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 09:31:58 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9D373C008A;
        Mon,  9 Mar 2020 13:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583760717; bh=DLFMSVGyx7VUcvHWsWeLHVUedPsGpxHraDzG+w3Xxek=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=V5gYUizxVePlA1ejY7pl+kDOVZuCb5YDRs4Evb5ZinJm+KOM1HmrLpIM8k9UzESjE
         aVDJs5rIKmPRGz6pAUuGg0PHlZNfiUJaPXXj9083oDWW+P3HxCCegppAVG3NaUt+ge
         B3h9b/5Ng6M7ohwbtPsjuHvkwWW2ktGkB/Wb0WZwQsVYbQJ4P5ZFHQxxC/oF3fRri8
         egF18Fzg8i0bpxhMNpC4ilvQ27r2KkBjd3QNzn5PZBPW7X6vPYTepl+LPj2PEb8nRb
         D07VHg9uztHm0vVjTY67wCCerJTiDO86h8FvTmL6FzkjF/PFwzhW9Lv3BT3+bXqYqO
         F36Yp56sMGECQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 877E7A008A;
        Mon,  9 Mar 2020 13:31:41 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 9 Mar 2020 06:31:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 9 Mar 2020 06:31:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9OlCOrj1i73aUPh1am4MTVma90kLrIZJ64ZIaA+817EJEYzTv71iiVQQP71oNMB5vBXylk3hHWZS947vyDCDOD0Q79CpQVSOFbER5AxOx3F7Zp3+MErOCh3uuibn84KYuzKqd8TEqfvi09WmHk01jeMz4F45btBFk82Yx5E271Uy61PVbpw8U3oiYwE6ExDCgFcLqvHhu3Sq4j7B2Znm6YcJUqfrb5+PpV/8clji/WFIdvV2P1YDLo0RyRZtPNs3mZpmXRMOMGcpt95sstAxKWfZyyRbCAgtyTbWDuwfWBAKQDV/lB4/Yqnri1x7+WcWsidyqPUocFGDw2Jbj4Lwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLFMSVGyx7VUcvHWsWeLHVUedPsGpxHraDzG+w3Xxek=;
 b=dlhuq3HAiV691Xry3MFQXwFIv+vxKiTD2clZSBlMuSbp1xTJq8Hh+QzAK9KVfLpxN4etgGwYtJNE+ew2YZMhyqcEsXXCiyT9F99wWAIZVHecIcoP/DRJTJqAIGpXqySgildcstc8Q6A8PQ9ebxP2mE2FCm9cDfKWMJaYfo9MxmJWcf9eHvaZppkTiCzqj7BSGb/bTZWmLOaKGOYmGMBqd91Md/NzMrpuE+/QagPd6RTQ0XGjP+phh4DqfbKn/fFp9gZUj6+SGjp8PpsV9EWHN1xg1tdGJBQu8JGCf4ATTSlncjnZllbVZcqtMOTzxWb8h3rtGIuhXgziJKrEWcwkyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLFMSVGyx7VUcvHWsWeLHVUedPsGpxHraDzG+w3Xxek=;
 b=TSFlKgMRQXVJoKfLQnKFQuc4cVorlSWUpANa/FxVzNwqgstmQTBlQ57emyNkem8PPf2+6wHIkNQI3ydXK1J8DKq75E0OyPZQgg6V4BjL2I4sUdmluEikrM4u2REVLs1PJLry1X3CDBLYBQk05NIx1epH3WQt+OhacujRRKbB+CU=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3604.namprd12.prod.outlook.com (2603:10b6:408:45::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Mon, 9 Mar
 2020 13:31:40 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa%7]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 13:31:40 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "mlxsw@mellanox.com" <mlxsw@mellanox.com>
Subject: RE: [patch net-next v4 03/10] flow_offload: check for basic action hw
 stats type
Thread-Topic: [patch net-next v4 03/10] flow_offload: check for basic action
 hw stats type
Thread-Index: AQHV9HVFN/JIjqGKAkyi9LUKP+sk+qhAD/MQgAAdBICAABfyEA==
Date:   Mon, 9 Mar 2020 13:31:40 +0000
Message-ID: <BN8PR12MB32667E9CE0F64894A8638BF3D3FE0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-4-jiri@resnulli.us>
 <BN8PR12MB3266F1691CDDA4352EFC2684D3FE0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200309120453.GB13968@nanopsycho.orion>
In-Reply-To: <20200309120453.GB13968@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec345e12-f01c-476e-36ca-08d7c42e334b
x-ms-traffictypediagnostic: BN8PR12MB3604:
x-microsoft-antispam-prvs: <BN8PR12MB360471C28B918085A33AA976D3FE0@BN8PR12MB3604.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0337AFFE9A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(376002)(39860400002)(366004)(189003)(199004)(86362001)(81166006)(81156014)(966005)(478600001)(8936002)(54906003)(9686003)(66476007)(66946007)(66556008)(66446008)(64756008)(7416002)(55016002)(316002)(76116006)(8676002)(5660300002)(6916009)(26005)(186003)(52536014)(2906002)(33656002)(4326008)(558084003)(71200400001)(6506007)(7696005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3604;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /S4sKPP+7clmdnY0Z4DUq1/bpZ09k/ZuIlwhz4lFIkiYO2UEa/8KYK2Bs34TIyqj29S13HK6JwSGUpCSEpRzGiSlwZ1qXR+1aoiZlbbyBiOBEVoUFr9k+XbJl5qrQhe8VtDc6hN7CK0E8g0mcRg4/uOAHrA8ZvCZWr9jKOX+JzgAKfoLdFiQJilS7/jvpwpY/C52DJUS8IqK3at+/wjlDr1ktDgsRHJK40BaLIMoVYSw4PP22G/oz527Y2TcPJ+9bmbDzPES3NHJIACTO9PxmS0tVlWpy6n7w3y6FDHLQcG+W0Xo3NHmFJNInigD2+qofDxTTdNfXRVSJFa0KSOpYXNJLrcJv6Atr4nD1ScVUR8YAgob8z5Yx38e2FSJG59VotIXhVsJNB8pFiNRu7PGWUYxsTQCEcyTalMZanb+yhJuIyrqgsbxbrSGGLLqnId3fs1OAldannMdAYK7uY2Oi+tARE8gQJwUGEfuQ6fp5meDKxsNVEHhAjd6hJfVDcjKvIofXz+Yuk5T8isUG9YpAg==
x-ms-exchange-antispam-messagedata: JzpdizmbXz6+K8VEH+HOUoHVIHkAhQ2a12fvXv0yivM/vHUrhYqFhoWS0mLuAW9Gm8rKPmbn3b++433a10U5xDClrQ0DPAHeYU/h3Xn21Ywkfp0ki5mp6gi4iIpRBPHLUD9iOAnpBKhca1WLdr6OjA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ec345e12-f01c-476e-36ca-08d7c42e334b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 13:31:40.4031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7nlfYd09iXnQ2QQGceGppghZUbB12U1YFH2lHyes0isftMSHASE/uGNy/3W6KBA7DBikL2Vdw7Smb/V9GK5vNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3604
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mar/09/2020, 12:04:53 (UTC+00:00)

> How exactly? This should not have any change for the existing users.

The fix is here: https://patchwork.ozlabs.org/patch/1251573/

---
Thanks,
Jose Miguel Abreu
