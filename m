Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1F5230B65
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 15:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgG1NYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 09:24:53 -0400
Received: from mail-vi1eur05on2066.outbound.protection.outlook.com ([40.107.21.66]:18364
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729984AbgG1NYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 09:24:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIOx9Hj5zc2T4Al5Nu/GfmFrxr+TIxqKVsMifGnKuBtkGiwC+N9CvOtLCsYVL3xgp2BqJrcbGlesA2lxP/kizbymwYz5zmwKqX8U3X96I96bmy1njhhv/RcNhOI7cXB3gCO3Z7JhLZdUxjwZsZrXIrSnL1pJdE0WXbtWF4bovO3e634prNwdz7F8h9k/eOowUn6ExehuvXKueJa2lC99DPXSHgWoN+z+MUVzphXI6ctKUrhT+fI0g2/r4L6E0sN+Hajc0hfg5AZyhn0dqI/XqczBtY3gKrJ+VYJVtBQXHQHqDusAvo9sFXX04gHv6XhBqGtBY9n/EB35csTUQsPVoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P84RnxJyHvI//AbzX7k0SoF6Y36451R1wiQbMMUDYQk=;
 b=LymSCAZwGKirKETBj31hGlttr8eFOAeYrq/GBVyEnXJwHLz0l+l9qs+EA0MIoGiGWZoCsA5CgfnKYSRTk+oP+wrWBXS66Uo8PtiU0rt2a26Wcurj9T2L/iS8/Ph9151OxWbWPOqZ9QdQ5/94FvQD98Jbgzbd0E+NZByXOIXRtOq6yxDg4Edm8pAnI3PcMhjYPvpebYZmzM3VWkde0ofkbYA2B+o0ERfDarl9E2csA2VWINbT8Seh/pm+HX2/kP20roh+LHPGAE2P4xXOX5A1Jhfaurn/8VbSMFIzo3VhsNSt7ILWRtAyAYQvYPj/9Oa+sOpOwtO1n+yediKdRDFLTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P84RnxJyHvI//AbzX7k0SoF6Y36451R1wiQbMMUDYQk=;
 b=pFW7OsdIQy4nX7hghByQPAPurly924bTE7D+i7bBvWzVyVhv/aTUE/Qhcf5N6CjHJ6Jkw0+S35IX725pSZENSveMYB3y9mUEVV/b79+27LQGzpdPW4ZMYI6IyB/oCZ/LFgeqTZxxaLhK0jNt3i1DJGzMM98fooWK4h85rocyqpU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0501MB2843.eurprd05.prod.outlook.com (2603:10a6:3:cd::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Tue, 28 Jul 2020 13:24:48 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b%5]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 13:24:48 +0000
References: <20200727164714.6ee94a11@hermes.lan> <20200728052048.7485-1-briana.oursler@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Briana Oursler <briana.oursler@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] tc: Add space after format specifier
In-reply-to: <20200728052048.7485-1-briana.oursler@gmail.com>
Date:   Tue, 28 Jul 2020 15:24:44 +0200
Message-ID: <87r1svhiw3.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0005.eurprd02.prod.outlook.com
 (2603:10a6:200:89::15) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM4PR0202CA0005.eurprd02.prod.outlook.com (2603:10a6:200:89::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 13:24:47 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28a2ee8d-b17b-4600-4f98-08d832f999c4
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2843:
X-Microsoft-Antispam-PRVS: <HE1PR0501MB2843DE8A6E21137254C457EEDB730@HE1PR0501MB2843.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qn2HFk+pa2rjtsyMoAbyIjedM9In7LCooxFeMGb8/sx1ozSP/LGnjs1ilKsJLWCkfTMtf+MaopxYjkjqCkmlDfK82iIsdYTZlB+EHXVqs7NNN4j0M07fQCH1gX8v6r56GafSdKYPWbAkHXc1K28BCdN3q5jxgOScLu9pk7TYZ7oYrWLRbTBVFOVtyr92rwXauDIFEW7caZBkm5MYG4cLpga7/LoIQa33Ej3+krTaomHg1lV8rUjGZizXOdrYGlVcb0P1v3X8VAis40zX6kL23Qbs1/XSyxv+7NGo/IaDU1zkbhZnJ9ZLCkBu/UVPNUtV7Af9+ydaIj5kU9hoqXjHYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(54906003)(956004)(316002)(2616005)(8676002)(16526019)(186003)(86362001)(6916009)(52116002)(6496006)(6486002)(6666004)(26005)(478600001)(2906002)(36756003)(5660300002)(66556008)(66476007)(8936002)(4326008)(4744005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NjphpYLb+g/yv8rctzLPG2z+Yg894JUqjuotV+XL/h6sOQNjzLAZp2cIO9+qQgA2ouC9zp2xeRQOi3VKYO0e0fgETNKtXHBv4HrhfAdPi9CHByrkTnKPdjzHRT0EEJjCIoGNi4dpssNk7GhnIBWD2uIyfCx1DWuQu4u/sZrlVxuAs+cuoFN1+a9HBmh1uTHF7+l0TiVr6FCQSPrBowjWwCI2eaRVcCt4cQsmyoiDJcuuCtBbSl2o/fvdj2EZG7zrOPierEJNQ5cBZshURmye737JraJKFbRRuubja7Ar5Q6Oz5PdZ8611PkOEFJPyOjWfQMuSLgH7rcd/symVgKQIC/jwguRo0u7UY2gV787FcsFTqad6t159enPu0DnYvlF1VgYvuSGYcDqhhPXVui3QmlPCGhBimFhN0EWl8jz0+pJGeIrN5EoEcJ+ZP0MIflUUfRhAuEQ1vtnt6qihgCCJPt7v9L+dx1LHKJE2iGj8R8CxFsFhpeiOmUNhx8fl9Bp
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a2ee8d-b17b-4600-4f98-08d832f999c4
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 13:24:48.2739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRVgs36M9CVT/aQQAv9mCmV2J5xPBIX8p1Sc+aoA0BR+54E2n6dqmXDTDCeEYtFo354t+RxNgLDenGpocBX49g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2843
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Briana Oursler <briana.oursler@gmail.com> writes:

> Add space after format specifier in print_string call. Fixes broken
> qdisc tests within tdc testing suite. Per suggestion from Petr Machata,
> remove a space and change spacing in tc/q_event.c to complete the fix.
>
> Tested fix in tdc using:
> ./tdc.py -c qdisc
>
> All qdisc RED tests return ok.
>
> Fixes: d0e450438571("tc: q_red: Add support for
> qevents "mark" and "early_drop")
>
> Signed-off-by: Briana Oursler <briana.oursler@gmail.com>

Tested-by: Petr Machata <petrm@mellanox.com>

Thanks for taking care of this!
