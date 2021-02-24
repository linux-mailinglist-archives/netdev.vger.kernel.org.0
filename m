Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E13B323AB5
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 11:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhBXKpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 05:45:24 -0500
Received: from mail-eopbgr110129.outbound.protection.outlook.com ([40.107.11.129]:26944
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234893AbhBXKpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 05:45:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3pO3a1nWZOJ7aSKKkOQISbWMHIwxVd2aYGvpcN+p1uwPOHFen9IqrzFjXg5rsJ22FJK3AiQPcwduPPtuhVZx6x2NVeZ2JUfTzcKc0Ek+FNTVWo5/s9ZYAtz6pKUyTGDQ12yqPYZzaCbqeLZyALma7R/FzakTcBb64/8SkbLtQihMRs/ZNkeBZLahy9SS4Y0lDNQxtqJJoKgZwkU8gfOy3Xqr1tVsoxeYTdNmQs/YOUwwY6w+yryPPVYs4hmsy/p8OKQGzVUzBOzHmgeDlGoKtAkVNy3op2cpHp9vzNk9SsCR/CC3XEnV3plvAliSk3Bch66zAAudd00zI+daK735w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUW+8U5qw9rl8QSA0szVrZbwS2IF7aTAP5PwkWt9QII=;
 b=lKU04dFeFEBoE/BBr8b/xOr1HFSnEiV/XjXGz7mYLj5+vCyboFnVIYIMfD+w4c3RusK/xw9euMWIcQfnAxJ4+XKRPzqkNRQzSPZE75NkR2Ef7f9qtlVN1SxapTNQFBK9vhMvfudJKbfWjq3lFPCk3mCbZXMcuxZgovbQmEMMPKkl7oJ6Y5HxSm1r2tUzGRAQoi6IYoIeubWE9AZuK1LkkVvFjK+NCGSGgmN8WroOqZNEHzBy89mE3715PXSmhPIfug+LokBxanjwpS+0nCwF1i0WDYeq6f6HAT3kp10XtCJq3w/8JWui4isTamTgiS2fIeEt/pKzAH56noa9uBSYRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUW+8U5qw9rl8QSA0szVrZbwS2IF7aTAP5PwkWt9QII=;
 b=Pkl9b7c9IUfC4BTWTCbmWfNwVk0UJ6KcSYGqBgnZDhqhTbwquSJ36c2ElH3yaeh9A6g0dNOYI5KIR7g74KQXwA04Ph5ePKrjescUZWwtCOZAMRVxasnyiPBqSOx6EnNisuTQ6vLTDGhowRZ2A5YlaTv6KlPUVLu1v0jDkErGtoE=
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:3a::14)
 by CWLP265MB3282.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:e2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Wed, 24 Feb
 2021 10:44:20 +0000
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::908e:e6f1:b223:9167]) by CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::908e:e6f1:b223:9167%9]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 10:44:20 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: RE: [PATCH] [v13] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Topic: [PATCH] [v13] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHXATVZ5f5l6UkeM0GGLk69Yeo12qpcKnA9gAsG29A=
Date:   Wed, 24 Feb 2021 10:44:19 +0000
Message-ID: <CWXP265MB1799C770207CA7BDC35D11B8E09F9@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20210212115030.124490-1-srini.raju@purelifi.com>
 <87im6rov2q.fsf@codeaurora.org>
In-Reply-To: <87im6rov2q.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none
 header.from=purelifi.com;
x-originating-ip: [103.213.193.217]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d60254c6-aa69-403e-7d02-08d8d8b12435
x-ms-traffictypediagnostic: CWLP265MB3282:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWLP265MB328202091928DDAF48078150E09F9@CWLP265MB3282.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xy0Nbb8ihdEfJeQe7O9srLB7dGGdAMvJoABi9HTU+VJVLIrMMIERyBMeIlGlewul6nKXq9ezl2AyOZCwMoRRs0VkrmEIQg7O3B6EsCe2MglFis510ZW1RHC2HLT3LBDLKX/L0qhh7MK7XPeZiT8RslCjUg8lkT45WoO4zQo0+tHctzUdiMvx3GAJXVODOi6t9BQhG2kZePKnE7hZiXs4fmo7PbrTdufuYtgQ1mhNwP12QVkPJQUPX5vddWcNIbYkQPknFaEWr/7jS1bahp+CGy6UToCsO65oRGBdsW01Ul6cLZ6QtXL2015FzBzyBfaR9hvsAD306SXKoVWkzFKsijvoMgLmW//IZKlP4DgEbrNNtHHdwEh4ZsEgJbos63H0lxAxzXlV3fRsfoNgFQxDm3LPQwCGJymv/fBo5HoUSynDP2nt09tOrhIDCP0gUi19Iaofyn9Xy8xKji+MtfzVx5koVPGZTIKr+NNr/sD94n84SxVprFF0YAxdICOGI7tljWfnqQu30OoR1l3PI/wwlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(396003)(366004)(346002)(39830400003)(136003)(376002)(2906002)(55016002)(9686003)(86362001)(6506007)(5660300002)(8676002)(26005)(52536014)(478600001)(186003)(66946007)(8936002)(6916009)(76116006)(66446008)(7696005)(66476007)(66556008)(64756008)(4744005)(4326008)(71200400001)(54906003)(316002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?m+P13kvrCILKH0ixTKK+8u0tpbn35KziZGOo3I8lcK9ltsjGd86rs4KCyACI?=
 =?us-ascii?Q?WTD+MNN9iQqLmVMHlS2284/PwZdpul8R4fvJ3N4lFJQaXIHKTQyvSVScGFk4?=
 =?us-ascii?Q?2i75WE4Q8oxMHA5UXRxcwyL21zg1rgQlAnkn8nwBCSbk23uPLJh2TRwH9BCc?=
 =?us-ascii?Q?WIrQ5p/pc7tRPB+E3UnVjOnT3dVtjvmBchVG+BCaWjUdfwCeeqjPt76NiplN?=
 =?us-ascii?Q?OwHYMWo115ldeghJO2ojvt8SPy9rUBVzAB29pLYy7KjRGQTm6r7YQuplQw3t?=
 =?us-ascii?Q?VhihjDy+IMR3hyKNbjA7qZS8xnIJXAc0FMNkUSz32x7i4i+zDhcUpdWGs8bl?=
 =?us-ascii?Q?C490ZhQ5phhALqr2eEegjDtKcGbThJO7+D8suKnBqXgrHkoJUAPz1gLgRX8Z?=
 =?us-ascii?Q?dd3ZU50vZHIkMXcGXiu1B65Wy5tpOlrMhgxgv4iBE6LIOufsFowpsAjTb0qA?=
 =?us-ascii?Q?wI9lbXWkxuA2xW9MPdo/XoOsrke1h3TW09JVQfcMqPUxSphdy4ir2C1CrAiM?=
 =?us-ascii?Q?zzD1/ldnhcZML6Mk9hN2knlRFbceFJe0yM7dv+ebK1zPfDUorEaIHIYrMBV7?=
 =?us-ascii?Q?wBG3Vt5qWrBhAg5l3fFMk2EV7Y+k2OE7jTiq/fbmG9cy+qBy3Z0kXlnK44HB?=
 =?us-ascii?Q?yFLiMErTF4vcfzs+uHwJj8frvOnlhTaDfnjUkYaqUM6TJQ4Hdb6WfToV3gbQ?=
 =?us-ascii?Q?7kC+jdqIH639yzKtTlQ0m3J6oyeY8mRhGdT1Xom3KAUG7Ube1WA8tMx03IJX?=
 =?us-ascii?Q?lbFA9w4wgT/4F6nndO6Qfv+buef9SZEMtM6aYf9Ni55ITIsrak425Q2CYqDq?=
 =?us-ascii?Q?Yiff7PoXJIRrQPaMWZxSnrNIbAX5WV8l/HX7WSrdtQdLfWMZVElo9K2FvWb7?=
 =?us-ascii?Q?YVqa2vCkFuPbEFm+1ZkuEeQ4UVTiaA6xH2Sfj/HHuNJlJgh5MayZeVMcSfMX?=
 =?us-ascii?Q?ggMWjqDSsJsAzHcp+KIGUYiO4WQFn9fjMB4CIVHvUWFA9Y7f9yA7oHe6R7fk?=
 =?us-ascii?Q?WPuVlQnc2qw9as9zA09Z3oZ+aMo13Xjn6ATP3rK/Dt8+DfvTzXIqCmPfbMAy?=
 =?us-ascii?Q?TYQy+6Hoe06UEPFDwFK5FKhyxFYn8M8UENQS6A2BZIhFiVMh2ndWe6lDiW/u?=
 =?us-ascii?Q?34YVE5Wtjtk53AAduF+nPGzBH945Tc1nAeWpbLT985G6qYBxRyKUluFg/3B/?=
 =?us-ascii?Q?67/4juxs4j9Zmv8kW8vaXPJHN4epxhAaT37Dq1gw9to39+XoPFQNoiN41sDF?=
 =?us-ascii?Q?JmPPLs7buHTPL30uf+qcFY/NbJlP6VjEXxBRxX2D48cT/xk/cQMds54udUAS?=
 =?us-ascii?Q?z4tKMhEndMvXKq7QugQMGE37?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d60254c6-aa69-403e-7d02-08d8d8b12435
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 10:44:20.0076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yyAUtkaTJnKuLDHwQ2gFUm2urPoxDlR5HLVzKWlrTTtct3AScC7W0WG+BhJIz/R+ohIxlUpdl2m+uFO+SlLiVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB3282
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Having the firmware files under plfxlc/ directory looks good to me. But I=
'm not really a fan of upper case filenames, is there a reason for that? I =
would prefer have all lowercase filenames.

Thanks for your suggestions. We have renamed the firmware names to lower-ca=
se and will submit v14

Thanks
Srini

