Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E1522F914
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgG0Tbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:31:44 -0400
Received: from mail-am6eur05on2058.outbound.protection.outlook.com ([40.107.22.58]:44929
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726222AbgG0Tbn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 15:31:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqqnrusJhJh7U0pqCrL3hc6PfzY+TTUT2m00J2+856qOxTd1nepAl7UEWGf1uxWJ5yhmcGvSb8ffoL4p1kRzEmKei3sFLpRbYdfn6eUSepSsJd9QRM8RNGHXA5bBBRK0IYflAeJ0EtRwLJNBU/oFJ5nOlJ9oIu+ym7Jju42kas94Ehms9s2RHmpaYeNZQj3sA6qRbO42oQOHMF2RGiea/wTY7c/TRzAjnAGVLA+7+fe6HahJM6XbtQve6itHE7iBhtBDrHtr+m7y01OXYNe4CnfELZN+9zE35IQ9VT0kGNlNcgppH7HQRBHQ4jSQhK+2A/AiPsP+cWOBmVzy2pdwog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FfipY4pASrd5WUFnt/bxnTCPjm4pwXnZumV0DBcio8=;
 b=UDgxHMBmJtSkQ6sCXzT7RX25RrlHgBLl0NElcHpmx1P7aXQvyvjVVKWmLeralBux0hF6oLKW6pvc5ynbLasgmk50K2uCVwRgtKD4grRY8a26V482vHjOI2cQukecec5LqqogeI2Ri8e9buRdyfRFhMP5t3DpVUv40HjQZ/NuFoyqDuFDKch6TmR3BI2DgyKKYQ/SovqmoSbS7nd3jzmDEDQn6YyuJS49eeK9Av8uLa5chb1T5/QdnYnzib7YnjHsnJtGy5eu0zrTlf3lv1EfZwPyO9+/pktUQwvKY8ueI9VYNAKMBXOMhJPCtGAtJWzIn3pznmNEQeW0kU4qn3Ytmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FfipY4pASrd5WUFnt/bxnTCPjm4pwXnZumV0DBcio8=;
 b=BbVbAQ3c+x+jlucbvyE2zpIFzlOIy8f/zDfi6BR7r2B1EYpJcuvWTIWE8mVUaw8CQqQPhAxX0VeGD/0q4kg1B3vN73ta9K17PFcCbRw9bXUe6GS8wwmHrtn6HYgnk7W3luQ+wjqyskaBZZCo+hK5x6Hzrl7Z1rXaRfXd4NAHjWo=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0501MB2843.eurprd05.prod.outlook.com (2603:10a6:3:cd::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Mon, 27 Jul 2020 19:31:39 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b%5]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 19:31:39 +0000
References: <20200727044616.735-1-briana.oursler@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Briana Oursler <briana.oursler@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: Question Print Formatting iproute2
In-reply-to: <20200727044616.735-1-briana.oursler@gmail.com>
Date:   Mon, 27 Jul 2020 21:31:36 +0200
Message-ID: <87wo2ohi07.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0010.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::20) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by FR2P281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.10 via Frontend Transport; Mon, 27 Jul 2020 19:31:38 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 58a1a4a1-44ca-45c7-5ef9-08d83263aebf
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2843:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB284373C684D04083AF3C46A8DB720@HE1PR0501MB2843.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:69;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NJHlPmLZ7cqUMW8rEnd6b6BPpUfArGnb2JaOxpWV9cN6Cw3fmpdW+sjJ6wdcRMb4ICye56Ofce/0VyjBEPhwd20/vnQhGjYVadFzj4Cty4C4qmQYdaHkQPqceehjxDCQ5Rf7VL9IpwBRxuW0FbpU9pJwdfYS+fqRMDBvoOqwNYm4uN9Eniz+VJylDIVw+4G0tK5K5w9TyOCG4vHRfjquOCJNSJvbF+tRBtpP0Bc2f56ZpZtet1zKUu/u3OMu73E/OR/CQmNCCPucYuzdHMK7DXRo5XwwshTFKmGo3mmEwA7DjCtGjhVaR6f7zqVHRHp5m3L12iWg+fEUPpg/ebHNrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(5660300002)(36756003)(26005)(2906002)(478600001)(83380400001)(66946007)(66556008)(66476007)(8936002)(4326008)(6916009)(2616005)(956004)(54906003)(316002)(52116002)(6496006)(6486002)(8676002)(107886003)(16526019)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QLkOEUbIB940RIVuReddKis7yg3WuwrR0kSlXXkR1xGT0szE4jM1/WeJxbQaW2Y1/kY+Nv/cz79aSV21gXNNq0HjON3dtuW8lIAlT4glpBmCHBpOb65AQkhyNmdpYvJP0+qSPEaDdmEhBX9qh1RdDTU5vRJyfVOfPiW7Qxn5R2S/YmOujjDn3fYPen8VbxJx8TY/sk65VOc35C8IWvc62+YPhO/ealKZairq7GQDLX1/euDb0arphdYwDsz4asZI3qddft3H1IWfU+fAag8ZrjchEfrXhdGydtvoSoMVlhP/j/2hfTsd4XdofLjykw6MpRfiqqoAjRmlO/t9RXSYT5EB5bs3oILfSN8KdXMdnKBN8zrsBIzS67rAMFFS4RXGaLnCFhI9SmyQLXqnyF31qvu+889CoswF5aHL4lnJ0mUMYJnyZJjwDiZJMn0ysCxb5Ei1XMJZ1Tc5AzGCRuusF4d+e5U6Phg8iPQtcgcxzBgQmn/tGCx5lLh1M8nkP1il
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58a1a4a1-44ca-45c7-5ef9-08d83263aebf
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 19:31:39.0432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5qggnUwMw4EQNQddGM0EE1+hpL7oygbXJ3aJfRgbCkPyOmYtolc0idFAx6ZReGVJvwHiJ+YLgMewl9IDCaCkFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2843
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Briana Oursler <briana.oursler@gmail.com> writes:

> I git bisected and found d0e450438571("tc: q_red: Add support for
> qevents "mark" and "early_drop"), the commit that introduced the
> formatting change causing the break.
>
> -       print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt->qth_max, b3));
> +       print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt->qth_max, b3));
>
> I made a patch that adds a space after the format specifier in the
> iproute2 tc/q_red.c and tested it using: tdc.py -c qdisc. After the
> change, all the broken tdc qdisc red tests return ok. I'm including the
> patch under the scissors line.
>
> I wanted to ask the ML if adding the space after the specifier is preferred usage.
> The commit also had:
>  -               print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt->Wlog);
>  +               print_uint(PRINT_ANY, "ewma", " ewma %u ", qopt->Wlog);
>
> so I wanted to check with everyone.

Yeah, I outsmarted myself with those space changes. Those two chunks
need reversing, and qevents need to have the space changed. This should
work:

modified	  tc/q_red.c
@@ -222,12 +222,12 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
 	print_string(PRINT_FP, NULL, "min %s ", sprint_size(qopt->qth_min, b2));
 	print_uint(PRINT_JSON, "max", NULL, qopt->qth_max);
-	print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt->qth_max, b3));
+	print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt->qth_max, b3));

 	tc_red_print_flags(qopt->flags);

 	if (show_details) {
-		print_uint(PRINT_ANY, "ewma", " ewma %u ", qopt->Wlog);
+		print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt->Wlog);
 		if (max_P)
 			print_float(PRINT_ANY, "probability",
 				    "probability %lg ", max_P / pow(2, 32));
modified	  tc/tc_qevent.c
@@ -82,8 +82,9 @@ void qevents_print(struct qevent_util *qevents, FILE *f)
 			}

 			open_json_object(NULL);
-			print_string(PRINT_ANY, "kind", " qevent %s", qevents->id);
+			print_string(PRINT_ANY, "kind", "qevent %s", qevents->id);
 			qevents->print_qevent(qevents, f);
+			print_string(PRINT_FP, NULL, "%s", " ");
 			close_json_object();
 		}
 	}

Are you going to take care of this, or should I?
