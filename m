Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6486643B233
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhJZMVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:21:52 -0400
Received: from mail-eopbgr50128.outbound.protection.outlook.com ([40.107.5.128]:4331
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234152AbhJZMVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:21:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7gfzYcFhGqyhhjp7Ia7fDvR8rvLedIrDgzCeWhEw2UIC2RJx6eT58D2qoZ9aRtsanjXMIelaVwcOdZZ74nJAl2qAPZJQhtwEDtaHeAr4A1J19ZCAH6MhrXYgwme9mNngWBd5XfabKuUfXRLVt5QugcL85wwntTGBHZWTWH7rzeFWvl/5q7xAN0dQRsJm/zNcvniKe+U9ao/u9BkIPjJIgIgMowahLnunJr7bBJQ4IAAsjdVbCj96hsOuYXd0gjV2V/VQFlRCwjRfG2AOIU66wdqJ7sntiSgSjAcznz0oq3RCepqSe7gCrIcbwLP111EyWOnB8b7MrUOUvRC+/HvCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mORujAupEtYToVV+/vTsNMfA9C7Uu6RtqvY2xEDKwo=;
 b=CrhIWYq4+UfugFmjxENJdXEtr2JlQD2l2m3geYn/edjbL84oDKIGsLdKw1JOyLHsrwm9Aa8u1vBr+NYt/svspdaWnasJ8j4cdWMY0HDy7K7Lhm3l/XmS0Nvew6ZqTGvc8rZ11wU1o/fR2dN8W2pLa05v/RM9b6Yb4Vyo/eBGH5AwbnNo9WljG2W6SZ0FBfn3Oystofnwat6wT0R0XZYa0PBs66hQ6WjI0HRYqDcm2v0GAQOhKzOuFX531+YcteIx36eDFf6l7fC3eZ+S99M+BMMYakk1cELeaHv0OaHHi4XLK9eJOZ2HII8YfegVsFt/VSus1gsCG92zYmUidKmIlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mORujAupEtYToVV+/vTsNMfA9C7Uu6RtqvY2xEDKwo=;
 b=BAY44JWrN5W0Swrw+DgauYyVhLt+M5Q2qij9hktAnuGH2kmto1uK9etPKiBD6bfDE/WBorUf9ulPhBgw7erbcFZexV8sBFEXIMe3HwVWi0hHpP/isqIrTO5VCa2TR635wIyyvY9bTm89Fu2NKLeg0vqarHIK+CmKwbwFGwdWVQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AM5P190MB0499.EURP190.PROD.OUTLOOK.COM (2603:10a6:206:19::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 12:19:24 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::a861:17ac:d33c:4347]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::a861:17ac:d33c:4347%5]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 12:19:23 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Taras Chornyi <tchornyi@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH] MAINTAINERS: please remove myself from the Prestera driver
Date:   Tue, 26 Oct 2021 15:19:07 +0300
Message-Id: <20211026121907.6066-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0035.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::23) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR08CA0035.eurprd08.prod.outlook.com (2603:10a6:20b:c0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 12:19:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35d76e9b-3c61-4d26-61c8-08d9987ad880
X-MS-TrafficTypeDiagnostic: AM5P190MB0499:
X-Microsoft-Antispam-PRVS: <AM5P190MB04997A3666FB4DE0B88BB5AB95849@AM5P190MB0499.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: feVB2qv5qeIopcPPoJibE5xdVE+EPwihVd0hiEXj0PyuQpcBn19nl8fzYzi4vcZTBxXDN7319Cux6/+ILxtbr1mkNCwL3hilheLpsZwHyhoqvflX2VfSEUvCJzt7vQvWS7HvaUSp16feSIt66ahoBNxq2kRuM081LIxnvlGH1gJycfNBPNTpd1PCiideW3La9JVwr980sA3v4ZIUICT0gbsfwEwmGTv4nyx9RBiZ9NSk+EeLTxk1qWrbiFM659bmTDpa5+9K1KOgUOroAF/kYi4pr/odCMAX0IXCuGh4ccv82v9i3kRQsQrGYNgVnwwebck7+ouVtXCzeIVG3fEOYnMxwXIud0WHmgf76J3+YQysS1F0usePakcI747XIEw5FyEmnyfFPE2drUzsUMwo49szovDjOPJSrOkNcnnWCSTRqKQTNwF6Oh/HymWnSLNntWVrSOw+zBaIBpMDoBBH1WDYsImR8Db0fvPztm22wLk15WkuWSs1wIEYjwDv9P4hJrqb26ZJwNjkBXp9rAbSziTx1a8KKj1bNtZVevmC+5axsOe1XFFfrb/HpO/RKa3r7UKB9IXTrliRXOOU5ZS+YAXfxEcbwjGbkhxVtO4xepPFRyzCodJK04aMZwsgj2rW5wnwUjz1n4kKGchcgSddgMZAzXgw/WMlGlbG/lvhsH6Qyxqwj9tiyrTNDN5yfuGYmpBiqtdXxX172gGlWDJe6MymwWrdXcq7+v7yi/W8hrh7FatMEmZjkzP71nvU0tE868TBRwTv/Om10LJceNcRUZ1MqiqrnrEHRy7GezZF03U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(346002)(39830400003)(6506007)(86362001)(66476007)(26005)(6666004)(36756003)(52116002)(508600001)(4744005)(110136005)(966005)(1076003)(6512007)(83380400001)(186003)(4326008)(5660300002)(8936002)(66556008)(66946007)(316002)(2616005)(8676002)(54906003)(38100700002)(2906002)(6486002)(956004)(38350700002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QhsuFjcPPWv41LxqHsFkc1Sygp/50pVYJtTBZh1cEM1pClbrHpJ4hIViXito?=
 =?us-ascii?Q?W1br6Ow9XVeqS0sBCRaFnALFHJ6r6k2EOExdq5rNiTtp4vsu9r3hqT2wF8mo?=
 =?us-ascii?Q?D9W3JtH+Wh+/2To8ifQXS02Y6XDyFveQ6WWeDOY7ZegJWFIG7UD+IccGNuAk?=
 =?us-ascii?Q?rcm0tTPW44swETyr7pua3AB/Sa2cIasPf3DqXb3Wl3eusq89aBeH/lNhQw6s?=
 =?us-ascii?Q?/fCUooLuxPN1/o9PkOHrhnHGfARbNdB2v6qywYZKeFF/7gq1jTO+mgYtHw60?=
 =?us-ascii?Q?3YM0+s90LXxA6EKY0N6q2L9PTvuo9+yrNPfaSJGntgTftPaV4UAvoXE5mtes?=
 =?us-ascii?Q?YAmN7db8rWN+xEr2O+Pz6mntjf4QyGQ4GVPm9w8HR3cy/HFxfs1qvRCdArf3?=
 =?us-ascii?Q?woB16f/wG4qnck2eLcx8fXYnE6iQmrio5+VZbenM5UAm71SMsQYd3ZzhOPV9?=
 =?us-ascii?Q?27rP5HhHgImEXQ68P8GGPmbfmbOlDZm1F4d39rU4/t91Q8RtK8BnCC9oWFW/?=
 =?us-ascii?Q?mR8gKGviprPTLWQpu8skSOnAQVzStjh0Xh8Ng0rjqamEJwyompAYkcSQY2WR?=
 =?us-ascii?Q?ibaSmi51dXgX+GhkHLQDhW5wJtUerZYzbnhyLrTTkB04Y0RW0mwpWAdeKdHw?=
 =?us-ascii?Q?Qs0ZLptbixLalogMXX7aTdpLvzq2aYQFK8+67xFWqeXIY3EOLRIHXCtjg3uS?=
 =?us-ascii?Q?/s7UXpoWHgBuIqADocREQfIyIcIj9t98zSF6N0ywwhTLxYDxQnzkrUGwTiMK?=
 =?us-ascii?Q?hixmtfYJOdrOeZaH+JeyMb4Ta7Rlgodl1sPnzjxCdJ5WW9zWHNUqP0FGysbc?=
 =?us-ascii?Q?8wUjINzgRf8NNaWHDyh0AXlobSUOwSbg/AVavx9wuT/zJXFQAjbInDYlSEAz?=
 =?us-ascii?Q?Vh6DiY4lgNeDdkuPSwb6aSJ+dAXu7JsDmzOU3yV8+mdwB4WdL5SQ2s1TGouV?=
 =?us-ascii?Q?+TVVs4n1l/42FOT5/ZbpHA3XdUQ6eGl1dFlUtW9Tbh5y86EgimI4dmPlioYH?=
 =?us-ascii?Q?cDvxyNhPvddIpiqJ6dZygctvylH3rF/wQe9v3Eg+EztcoQAnsF2/XNQTjF1A?=
 =?us-ascii?Q?CfypNxyCwRPc4dgZ3O5BigzCgliCDErQFUlFepPdO3E8+huMKu/lOlbhrGbC?=
 =?us-ascii?Q?E55nUpIRAz+WTnAkZvhyWszNgAxwg3SkI0UuUT+IZXrVJ0eDzvA2uqQ0FgdT?=
 =?us-ascii?Q?OIX2BrHRnQh3jECQE1Te+fv49R7TaFMCprCioUi/ahDRpoejuEnlT86cadnH?=
 =?us-ascii?Q?hbs3HO9BZfD3RkFg9WK3mMLTl8hmrPxx8iVdK7SawRgJlbvNUjWU8jj1N27A?=
 =?us-ascii?Q?O22k1NFjIV+C5ECRalodWoc60KeX/lDkXTlOWOtk9cWpfNzYXJGa48G9MkMT?=
 =?us-ascii?Q?Rs7nO40fzZmFoOj+5TSFVNxxwrsTXHRq8A07At273uDN130BKkloeObtygCo?=
 =?us-ascii?Q?sq6Yfy8WollW4Va4brpabQmxoY4PZcpTY4rif+y+KzHB0C+jJyIqRL+C8LNe?=
 =?us-ascii?Q?QjCdJL7RfX1bUb0OdJwJ9InqWOIsJQqhGMw+Jqaly2WFeZtb5S+7HdnZ3XC5?=
 =?us-ascii?Q?TCTx7mpK9c+PYplHBPltqlt4VADXQyhIXfP1wNPagQjIXf0VPgL4c7xleFOV?=
 =?us-ascii?Q?7lntseFRxR8uzWWXo6+jlqZgNsU7RDNk9/z+S/pmBveh+ER+rcRUIz6fwj/0?=
 =?us-ascii?Q?HlCoGg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d76e9b-3c61-4d26-61c8-08d9987ad880
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 12:19:23.7928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MwxmTLRAKVOdAj6llFOWDAb97DV1J+hNYfU/D2gi8zCGzgNNrUTE0aJuNWzlFXur6G9P2tJucqMYFqeTe8N6e4Rcg7mHFvrwprH8qBV15rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P190MB0499
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 975086c5345d..771d02ee038b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11284,7 +11284,6 @@ F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
 F:	drivers/net/ethernet/marvell/octeontx2/af/
 
 MARVELL PRESTERA ETHERNET SWITCH DRIVER
-M:	Vadym Kochan <vkochan@marvell.com>
 M:	Taras Chornyi <tchornyi@marvell.com>
 S:	Supported
 W:	https://github.com/Marvell-switching/switchdev-prestera
-- 
2.17.1

