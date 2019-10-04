Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F352CBFE2
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390058AbfJDP6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:58:41 -0400
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:63559
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389794AbfJDP6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 11:58:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nc9RoAubZ1TaeOrjliLwd6BePTCTL12TXWlxi5+RT4ujMM+W1Uv3qUGdOjQoDZhbHBpzYs8tFYHRIAKKFsYNWdHc5icwLoV9s6cWA0Ef7ScznZlpHmPccvGGrejI4DpC7HmCHUBN0ivwpyJEN7y3blzMXExbQmDRWGmnWBQvzs7KJNXFNId5l+xo5Q4wQWm8v67wDZ0wxREOJjOrmW6Mdra1rYmZ70yJV3IP3ldT/jWP/k37U1hxOn0XilYRTjueAXnwhNYS8V8TWn4kBRJ8dwvTRLQ/krzse1lWfFa3qMRA3W1p97Hn+Ac0lh8bW0vm3MpXjct3nKw7MvUsrDyB6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xo8MmoAzTXKxglXzQ1waQvVTJujcm0ARq+8iO1p++nI=;
 b=XxazRX35Qyypg+kOtseMw5y5/nDP3NWLagvRHXpT7ymasDN4k1351dXBY7RsDmtG82QO+glNo8nEsBtkI3tgqJ1RoIPg/dyeurrzRJ2p8/hJsJGakQTIdsfdFm+pCIt9wWddEGEf+8nRG0Og820bxYQoJdjz/5/pgtDClkPAUvAp9fnYoo3ld8ORhSyCB9W+14LCadPZ8mvDTZaTUq2gq9lNjbjous39QPabgxmbMZlW/9+W+P5IK49X9kvdD2GEMaDMf+dINfL/eiId4QrT20+BwBtbVvJYMrPY/NwulMeyqbA/5oftpkqJ9vmOPX8141Z2cGKhYULyDntML2o+tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xo8MmoAzTXKxglXzQ1waQvVTJujcm0ARq+8iO1p++nI=;
 b=ZDOL7irZ0UGvE2zNFo7xI78D5uf87jIZ6j49dHfXD7hyYem+KwtN4hJKPUQn8gpF7lSo6HFHItDnrz4IRMcNJty+lk6L8iU0cyO8G9ekGQ7brAoGysUzyNnXkbt8ySPmbYimv+3azp+toZvZrSu52hBE5nCc8j0nUicni7LVGbk=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4269.eurprd05.prod.outlook.com (52.133.13.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Fri, 4 Oct 2019 15:58:33 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2305.023; Fri, 4 Oct 2019
 15:58:33 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     John Hurley <john.hurley@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: Re: [RFC net-next 0/2] prevent sync issues with hw offload of flower
Thread-Topic: [RFC net-next 0/2] prevent sync issues with hw offload of flower
Thread-Index: AQHVeXc5O/tBF1cs/0KKA2t1J+rpTKdJG6uAgAAJVgCAAAVwAIABdnmAgAAFNgA=
Date:   Fri, 4 Oct 2019 15:58:32 +0000
Message-ID: <vbf36g8jyeh.fsf@mellanox.com>
References: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
 <vbfk19lokwe.fsf@mellanox.com>
 <CAK+XE=mjARd+DodNg9Sn4C+gg6dMTmvdNrKtEYhsLGVqtGrysw@mail.gmail.com>
 <vbfimp5oig9.fsf@mellanox.com>
 <CAK+XE=nrzH8B=2GRcvmgOus67HSh_QXfBsawO_qicp8nSyZ_FA@mail.gmail.com>
In-Reply-To: <CAK+XE=nrzH8B=2GRcvmgOus67HSh_QXfBsawO_qicp8nSyZ_FA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LNXP265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::30) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dabef5ae-4f40-4236-c962-08d748e3b4e8
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB4269:|VI1PR05MB4269:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4269A6F08147C6F2021B0912AD9E0@VI1PR05MB4269.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(376002)(396003)(136003)(52314003)(51914003)(189003)(199004)(8936002)(4326008)(2906002)(52116002)(486006)(446003)(6916009)(99286004)(102836004)(11346002)(71190400001)(71200400001)(476003)(14454004)(305945005)(5660300002)(6246003)(14444005)(256004)(81156014)(8676002)(2616005)(81166006)(186003)(86362001)(36756003)(66556008)(64756008)(66476007)(66946007)(6116002)(3846002)(6512007)(7736002)(6436002)(229853002)(76176011)(54906003)(66446008)(26005)(66066001)(6506007)(386003)(6486002)(53546011)(25786009)(316002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4269;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GKd+S2kqLC0naLlvXk8psPZc9oZ+5rLBFjgtWtpdjSvzQRrEle8rLcdcbJnEMET5FHlI1Lc2khOzQR5bHwfF70ZmBJVJhOUmGMw1/6Zmmv5mvuTnevwHzTCjgwTYR3WHrg7KH9jVAV6zGv3CjQdwTc6atAURdZHkyh0jvwC4NKyFShcHb+SdpsJJOGX+zsRQSBb42qLYJmJhekB+SsVRR2FKkzciU3+LIoKCrmBmvPwGbDZPE3aUIwlVKTzhIxF5rGy+NMfMcUu5+wLIWNCC1Pt1Qht+PkvQk+llhVihlQIoHc4vwADtZNMe9FqmNdpj8Nx9FCsVhuUd72/Ex4HjPby6iLDvIEXkkSFBi/l7ozwFcX2UndhM+trxlAsGkPPzoZOzlxPVmVZYWCf5SymwjMlR5Pjqv8F7HyzKRfg4dy8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dabef5ae-4f40-4236-c962-08d748e3b4e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 15:58:32.9733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 984KYWKavL0F8e+7/nU9/wHgpq6EbntNEmYHvdSeRewMUKawj0ZAgtpDShyyaDOx6i20zEuXwjXi8ezGD5rZNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4269
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 04 Oct 2019 at 18:39, John Hurley <john.hurley@netronome.com> wrote:
> On Thu, Oct 3, 2019 at 6:19 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>>
>>
>> On Thu 03 Oct 2019 at 19:59, John Hurley <john.hurley@netronome.com> wro=
te:
>> > On Thu, Oct 3, 2019 at 5:26 PM Vlad Buslov <vladbu@mellanox.com> wrote=
:
>> >>
>> >>
>> >> On Thu 03 Oct 2019 at 02:14, John Hurley <john.hurley@netronome.com> =
wrote:
>> >> > Hi,
>> >> >
>> >> > Putting this out an RFC built on net-next. It fixes some issues
>> >> > discovered in testing when using the TC API of OvS to generate flow=
er
>> >> > rules and subsequently offloading them to HW. Rules seen contain th=
e same
>> >> > match fields or may be rule modifications run as a delete plus an a=
dd.
>> >> > We're seeing race conditions whereby the rules present in kernel fl=
ower
>> >> > are out of sync with those offloaded. Note that there are some issu=
es
>> >> > that will need fixed in the RFC before it becomes a patch such as
>> >> > potential races between releasing locks and re-taking them. However=
, I'm
>> >> > putting this out for comments or potential alternative solutions.
>> >> >
>> >> > The main cause of the races seem to be in the chain table of cls_ap=
i. If
>> >> > a tcf_proto is destroyed then it is removed from its chain. If a ne=
w
>> >> > filter is then added to the same chain with the same priority and p=
rotocol
>> >> > a new tcf_proto will be created - this may happen before the first =
is
>> >> > fully removed and the hw offload message sent to the driver. In cls=
_flower
>> >> > this means that the fl_ht_insert_unique() function can pass as its
>> >> > hashtable is associated with the tcf_proto. We are then in a positi=
on
>> >> > where the 'delete' and the 'add' are in a race to get offloaded. We=
 also
>> >> > noticed that doing an offload add, then checking if a tcf_proto is
>> >> > concurrently deleting, then remove the offload if it is, can extend=
 the
>> >> > out of order messages. Drivers do not expect to get duplicate rules=
.
>> >> > However, the kernel TC datapath they are not duplicates so we can g=
et out
>> >> > of sync here.
>> >> >
>> >> > The RFC fixes this by adding a pre_destroy hook to cls_api that is =
called
>> >> > when a tcf_proto is signaled to be destroyed but before it is remov=
ed from
>> >> > its chain (which is essentially the lock for allowing duplicates in
>> >> > flower). Flower then uses this new hook to send the hw delete messa=
ges
>> >> > from tcf_proto destroys, preventing them racing with duplicate adds=
. It
>> >> > also moves the check for 'deleting' to before the sending the hw ad=
d
>> >> > message.
>> >> >
>> >> > John Hurley (2):
>> >> >   net: sched: add tp_op for pre_destroy
>> >> >   net: sched: fix tp destroy race conditions in flower
>> >> >
>> >> >  include/net/sch_generic.h |  3 +++
>> >> >  net/sched/cls_api.c       | 29 ++++++++++++++++++++++++-
>> >> >  net/sched/cls_flower.c    | 55 ++++++++++++++++++++++++++---------=
------------
>> >> >  3 files changed, 61 insertions(+), 26 deletions(-)
>> >>
>> >> Hi John,
>> >>
>> >> Thanks for working on this!
>> >>
>> >> Are there any other sources for race conditions described in this
>> >> letter? When you describe tcf_proto deletion you say "main cause" but
>> >> don't provide any others. If tcf_proto is the only problematic part,
>> >
>> > Hi Vlad,
>> > Thanks for the input.
>> > The tcf_proto deletion was the cause from the tests we ran. That's not
>> > to say there are not more I wasn't seeing in my analysis.
>> >
>> >> then it might be worth to look into alternative ways to force concurr=
ent
>> >> users to wait for proto deletion/destruction to be properly finished.
>> >> Maybe having some table that maps chain id + prio to completion would=
 be
>> >> simpler approach? With such infra tcf_proto_create() can wait for
>> >> previous proto with same prio and chain to be fully destroyed (includ=
ing
>> >> offloads) before creating a new one.
>> >
>> > I think a problem with this is that the chain removal functions call
>> > tcf_proto_put() (which calls destroy when ref is 0) so, if other
>> > concurrent processes (like a dump) have references to the tcf_proto
>> > then we may not get the hw offload even by the time the chain deletion
>> > function has finished. We would need to make sure this was tracked -
>> > say after the tcf_proto_destroy function has completed.
>> > How would you suggest doing the wait? With a replay flag as happens in
>> > some other places?
>> >
>> > To me it seems the main problem is that the tcf_proto being in a chain
>> > almost acts like the lock to prevent duplicates filters getting to the
>> > driver. We need some mechanism to ensure a delete has made it to HW
>> > before we release this 'lock'.
>>
>> Maybe something like:
>
> Ok, I'll need to give this more thought.
> Initially it does sound like overkill.
>
>>
>> 1. Extend block with hash table with key being chain id and prio
>> combined and value is some structure that contains struct completion
>> (completed in tcf_proto_destroy() where we sure that all rules were
>> removed from hw) and a reference counter.
>>
>
> Maybe it could live in each chain rather than block to be more fine grain=
ed?
> Or would this potentially cause a similar issue on deletion of chains?

IMO just having one per block is straightforward enough, unless there is
a reason to make it per chain.

>
>> 2. When cls API wants to delete proto instance
>> (tcf_chain_tp_delete_empty(), chain flush, etc.), new member is added to
>> table from 1. with chain+prio of proto that is being deleted (atomically
>> with detaching of proto from chain).
>>
>> 3. When inserting new proto, verify that there are no corresponding
>> entry in hash table with same chain+prio. If there is, increment
>> reference counter and wait for completion. Release reference counter
>> when completed.
>
> How would the 'wait' work? Loop back via replay flag?

What is "loop back via replay flag"?
Anyway, I was suggesting to use struct completion from completion.h,
which has following functions in its API:

/**
 * wait_for_completion: - waits for completion of a task
 * @x:  holds the state of this particular completion
 *
 * This waits to be signaled for completion of a specific task. It is NOT
 * interruptible and there is no timeout.
 *
 * See also similar routines (i.e. wait_for_completion_timeout()) with time=
out
 * and interrupt capability. Also see complete().
 */
void __sched wait_for_completion(struct completion *x)

/**
 * complete_all: - signals all threads waiting on this completion
 * @x:  holds the state of this particular completion
 *
 * This will wake up all threads waiting on this particular completion even=
t.
 *
 * If this function wakes up a task, it executes a full memory barrier befo=
re
 * accessing the task state.
 *
 * Since complete_all() sets the completion of @x permanently to done
 * to allow multiple waiters to finish, a call to reinit_completion()
 * must be used on @x if @x is to be used again. The code must make
 * sure that all waiters have woken and finished before reinitializing
 * @x. Also note that the function completion_done() can not be used
 * to know if there are still waiters after complete_all() has been called.
 */
void complete_all(struct completion *x)


> It feels a bit like we are adding a lot more complexity to this and
> almost hacking something in to work around a (relatively) newly
> introduced problem.

I'm not insisting on any particular approach, just suggesting something
which in my opinion is easier to implement than reshuffling locking in
flower and directly targets the problem you described in cover letter -
new filters can be inserted while concurrent destruction of tp with same
chain id and prio is in progress.

>
>>
>> >
>> >>
>> >> Regards,
>> >> Vlad
