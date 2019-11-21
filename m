Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6BA10525F
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 13:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfKUMny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 07:43:54 -0500
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:41542
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726358AbfKUMnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 07:43:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Unzr6ggJns79ioW8Ssn9T0BM62/Q0wMnM601k9rSNvfqmZwYhJ9QTS0Cr/0cRnXHJ1OXjrlRes2uv6E2fABO40XQToRxcG3puO+vZjSniNd/3ceIzh+2zaP3dfUvpY6zshPdbfqR7HqzESJo+6bBXnzk1+PlZHQ2Ni+i4LXt2Jdcom68Upe319YnclVau/H2Q78un6BbN2Kho6zUUNqingfDV4kkjmDFDZUEzW2rg8TzZql/dIQ+D1s4Y46x+985aLDmhj8JuAM9lGcQ6maxx7z2zzGQCRKeZgYMFhkBwlrBmufR1z6PERqsP71dfZs38CkHMbSruffEEDQ7FrXnKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSQbtG0Alfc3yiZLZ/XoaxyxraUFXjeVkATBmZiB0Xw=;
 b=VCyQcp1Dxrp/87cToNh1Vv4dM8KHJGTRxDV1ZwaxbbLO4OpKcMeMLyvmW1D3/Eah18dxYd5oKMrp3yXFeXsNLLg7riF6x9H3eP+UUXgfJmNgbenvcWUqOBAq9ZDdK+s8qQhr0fd+MNjQsqd2r/QJMkM0QbF6i58nZ0eX/xOGntjdT+ueKmoRuCHfgl7CmCFDjKrLkl/VDNN0mha+d5I7JqAg6dirEFrON0nCLtJohs9hAeayHhh4sESLsfPG9gzJIGvQ8IDaKsktqV1mJoYD8Jfb/Vb4Di1uHAcZGAnQDfavtQvoylDv8iVU3UPf4I6ZK8vmfVOlBcjGiNUiyN+SXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSQbtG0Alfc3yiZLZ/XoaxyxraUFXjeVkATBmZiB0Xw=;
 b=ir2vu09qK11+MIX/mrJZT56Aa49AKcdzGclq/tS8mE/sCFjLbm2fDMSw8j10ogTGxIja+wrTm0Ub2JOuGZiW8n6xGGJ15dwcWXXIYGN+hhUfv4RQ7aLlKoaLfn2mIY8zG54TrEyLQ1qk5zSolBvSweb/ZWRu72B7J4pc+n6D8EE=
Received: from AM5PR0502MB3043.eurprd05.prod.outlook.com (10.175.46.9) by
 AM5PR0502MB2947.eurprd05.prod.outlook.com (10.175.39.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Thu, 21 Nov 2019 12:43:47 +0000
Received: from AM5PR0502MB3043.eurprd05.prod.outlook.com
 ([fe80::29d4:44d0:62ec:45db]) by AM5PR0502MB3043.eurprd05.prod.outlook.com
 ([fe80::29d4:44d0:62ec:45db%10]) with mapi id 15.20.2474.019; Thu, 21 Nov
 2019 12:43:47 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [RFC PATCH 00/10] Add a new Qdisc, ETS
Thread-Topic: [RFC PATCH 00/10] Add a new Qdisc, ETS
Thread-Index: AQHVn6MipeEL1zH+9Uqkum7uhiStHqeUtFcAgADfAwA=
Date:   Thu, 21 Nov 2019 12:43:47 +0000
Message-ID: <87imndcscd.fsf@mellanox.com>
References: <cover.1574253236.git.petrm@mellanox.com>
 <20191120152534.2041788e@cakuba.netronome.com>
In-Reply-To: <20191120152534.2041788e@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0148.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::16) To AM5PR0502MB3043.eurprd05.prod.outlook.com
 (2603:10a6:203:a2::9)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [78.45.160.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7d610485-ebf0-452d-8be0-08d76e8073e9
x-ms-traffictypediagnostic: AM5PR0502MB2947:|AM5PR0502MB2947:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM5PR0502MB2947DF2E0AA390E4249FC02FDB4E0@AM5PR0502MB2947.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(43544003)(199004)(189003)(71200400001)(71190400001)(6486002)(6512007)(54906003)(229853002)(305945005)(36756003)(6436002)(99286004)(66946007)(6246003)(6916009)(66476007)(446003)(2616005)(66446008)(66556008)(186003)(66066001)(2906002)(25786009)(478600001)(4326008)(5660300002)(6506007)(3846002)(81166006)(11346002)(14454004)(81156014)(64756008)(102836004)(86362001)(6116002)(8936002)(8676002)(26005)(14444005)(5024004)(316002)(7736002)(256004)(76176011)(386003)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0502MB2947;H:AM5PR0502MB3043.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gs35cRN6Ss4rsDXRMykxBHKfMpY3GrhOZqbLkO3uxqav7e+j7jSHQw0QQ054oVVsVIyWjv2MooPKXHMXrPFp9IfgwnylHppWHTOHpNmgu4fcRU65x4iPUjFbMnoG3lsd4DBnHuNkEn8dY4N7cQS8ZuwKpYeQ7AxTp5EsNrumbmPsPsk58NX8no9xT7ub4aYO2I20WjTpBVp9WXiUh3e2p8/6T/Jz/wCCpFYIVr3YXXYBQjaeFHo4AAPVF08dEIkQmpwgoNmUH6CU4fkzH+WGbZ1vIM5OCDl94Ng1F9c3mmNaRb+KmRaBNrnvqTwcC7P8xXKRZy31aoj90bTD0TBodHUfa5IMg57QZWt33p/bvYP+0YnQPhSre161xnqblWte3VYyy5kcd+NMILwLDtbpdI5ipIwLWvcxsOWkmxIVapg4HJBHv6zlynezlTmjd+Oa
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d610485-ebf0-452d-8be0-08d76e8073e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 12:43:47.7228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N31aE3YjW+UrHtqVW1Boz2HrbSbfUOb/VUTM/1duLHiap+gow0qW5g2n1MaapURlbpTmPfNW/61KK6WOejU0uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0502MB2947
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> On Wed, 20 Nov 2019 13:05:08 +0000, Petr Machata wrote:
>> The IEEE standard 802.1Qaz (and 802.1Q-2014) specifies four principal
>> transmission selection algorithms: strict priority, credit-based shaper,
>> ETS (bandwidth sharing), and vendor-specific. All these have their
>> corresponding knobs in DCB. But DCB does not have interfaces to configur=
e
>> RED and ECN, unlike Qdiscs.
>>
>> In the Qdisc land, strict priority is implemented by PRIO. Credit-based
>> transmission selection algorithm can then be modeled by having e.g. TBF =
or
>> CBS Qdisc below some of the PRIO bands. ETS would then be modeled by
>> placing a DRR Qdisc under the last PRIO band.
>>
>> The problem with this approach is that DRR on its own, as well as the
>> combination of PRIO and DRR, are tricky to configure and tricky to offlo=
ad
>> to 802.1Qaz-compliant hardware. This is due to several reasons:
>>
>> - As any classful Qdisc, DRR supports adding classifiers to decide in wh=
ich
>>   class to enqueue packets. Unlike PRIO, there's however no fallback in =
the
>>   form of priomap. A way to achieve classification based on packet prior=
ity
>>   is e.g. like this:
>>
>>     # tc filter add dev swp1 root handle 1: \
>> 		basic match 'meta(priority eq 0)' flowid 1:10
>>
>>   Expressing the priomap in this manner however forces drivers to deep d=
ive
>>   into the classifier block to parse the individual rules.
>>
>>   A possible solution would be to extend the classes with a "defmap" a l=
a
>>   split / defmap mechanism of CBQ, and introduce this as a last resort
>>   classification. However, unlike priomap, this doesn't have the guarant=
ee
>>   of covering all priorities. Traffic whose priority is not covered is
>>   dropped by DRR as unclassified. But ASICs tend to implement dropping i=
n
>>   the ACL block, not in scheduling pipelines. The need to treat these
>>   configurations correctly (if only to decide to not offload at all)
>>   complicates a driver.
>>
>>   It's not clear how to retrofit priomap with all its benefits to DRR
>>   without changing it beyond recognition.
>>
>> - The interplay between PRIO and DRR is also causing problems. 802.1Qaz =
has
>>   all ETS TCs as a last resort. I believe switch ASICs that support ETS =
at
>>   all will handle ETS traffic likewise. However the Linux model is more
>>   generic, allowing the DRR block in any band. Drivers would need to be
>>   careful to handle this case correctly, otherwise the offloaded model
>>   might not match the slow-path one.
>>
>>   In a similar vein, PRIO and DRR need to agree on the list of prioritie=
s
>>   assigned to DRR. This is doubly problematic--the user needs to take ca=
re
>>   to keep the two in sync, and the driver needs to watch for any holes i=
n
>>   DRR coverage and treat the traffic correctly, as discussed above.
>>
>>   Note that at the time that DRR Qdisc is added, it has no classes, and
>>   thus any priorities assigned to that PRIO band are not covered. Thus t=
his
>>   case is surprisingly rather common, and needs to be handled gracefully=
 by
>>   the driver.
>>
>> - Similarly due to DRR flexibility, when a Qdisc (such as RED) is attach=
ed
>>   below it, it is not immediately clear which TC the class represents. T=
his
>>   is unlike PRIO with its straightforward classid scheme. When DRR is
>>   combined with PRIO, the relationship between classes and TCs gets even
>>   more murky.
>>
>>   This is a problem for users as well: the TC mapping is rather importan=
t
>>   for (devlink) shared buffer configuration and (ethtool) counters.
>
> IMHO adding an API to simplify HW config is a double edged sword.
> I think everyone will appreciate the simplicity of the new interface..
> until the HW gets a little more smart and then we'll all have to

For reference, the Spectrum hardware already is more smart. We could
offload PRIO with several DRRs under different bands, the HW is
expressive enough to describe this. But nobody seems to need this: it
seems there are no customers needing anything more than what 802.1Qaz
describes. The DCB interface, which is pretty much married to HW
interfaces, is likewise very close to what 802.1Q specifies, and I don't
believe that's by chance.

> go back to the full interface and offload both that and the simple one,
> or keep growing the new interface (for all practical sense just for HW)
> Qdisc.

If 802.1Q introduces an algorithm that can't be expressed as a single
Qdisc, growing the ETS Qdisc is of course valid. E.g. the shaper
operation is restricted to a single band, so it makes sense to express
it as an independent unit. That's unlike the ETS algorithm, which needs
cooperation between several bands, so you can't easily attach "ETS'ness"
under individual PRIO bands.

> Having written a MQ+GRED offload I sympathize with the complexity
> concerns, also trying to explain how to set up such Qdiscs to users
> results in a lot of blank stares.
>
> Is there any chance at all we could simplify things by adding a better
> user interface and a common translation layer in front of the drivers?

One can imagine a library that handles these sorts of stuff. Drivers
would forward TC events to it, it would figure out what's what, and
somehow signal back to the driver. But packaging this as a Qdisc is such
an interface as well. And because Qdisc interface is well understood not
only by kernel hackers, but also by end users, a Qdisc takes care of
that part of the problem as well.
