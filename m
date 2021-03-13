Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC4D339F46
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 17:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbhCMQ4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 11:56:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44420 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbhCMQ4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 11:56:47 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12DGt7wl068259;
        Sat, 13 Mar 2021 16:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=yGONOmLf1RkdhqS25Vuw0voITPDvbf0+TNuB6Je1usE=;
 b=wjLG9X/9Np/5ga6/NfTtxCzIW3ent01dkxQlzG9z/VxolSb20n24ztjWhHWM2NYPHQ7F
 V82oamTIH+Fj/plk4xUkGcd3FhB9h7gL92DUUr2vYF+mz56DVMlBtBKzZOMX0kOSp2Jo
 W3O/ZM5uuvqw3y9RngT9B9VuI8WQexeP9pMOxO753i9btvM8Ws9DK6Em1yFwXKRtYAUD
 74gI5Hj/O6ttt+X+ceZeNzDw19dZyUcIt6riiAnYHgH7ru9xdkxHpK9UYX0oLJXltDug
 T1J9bOcJbEXcKexzhLPP8HHbbF2oCSiyk2rmsGd+xEOiJhLQkn6IfN14wdaMtmsZ2nSv vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 378jwb8w8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Mar 2021 16:56:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12DGtHoH128393;
        Sat, 13 Mar 2021 16:56:34 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2059.outbound.protection.outlook.com [104.47.38.59])
        by aserp3020.oracle.com with ESMTP id 378n71r7mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Mar 2021 16:56:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDzEOnGiDKSl6CLLAj74gTgxl8ZIfT5OA/Ofdg+q1OwF8WO3TfZ0g02YIGMXEP7yEePkKHNshRDnsTKLrb6NCux0r2/OmPbKxBPP1jwqKOWA4wRDbQQyttNxpRfIv7jsU0vGfoHkadp+XCLkoCGqQXrFawjeypmivthpUQqbHSh9eANwgZJdht0lcaiO/eG2ta7g2os3VNchfYpwrVbzuvq7h12bmPWG0FnfJTXSR0pPf1JBSo4hwbiz0RzWkk8ZkSomR4Fhd6KGgSD2Gosn33tN3uhTnOCXnhb7EzaFHnwbz2y4gQvojTdIloW8M+Hhysc1NWNF/mnyp2f1Fkqw0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGONOmLf1RkdhqS25Vuw0voITPDvbf0+TNuB6Je1usE=;
 b=Ak7aEI3vIZlIeiBnSrHPnUVuLUdr9iMrNRNJerzU/gJ8hvDXwaH1tVn9HOD9+usr8iDYRKb+5Mh5wsnikE8SFHE81FO1PzkrlTbmfj4wSP90VYYU/jxdd0aDHf7s+v8hgX2qu3ErHICKcmBDaViTrS2+XDRQPuKX+0GMloTqN2O4ILJmFS/xq9W8z3mOXYChAKkLA6EWGpGywn7nwXsPLObNIqf4mu6hwxXrwHApYPIjT4vp41Dyoy7RY4KRAB68T/FoUsVm4GlC15+HKvWB/CkLeI+MTeNnDJUfrhQMIzpEHubNg3rslC5Pia7hgRp78chZdBE9uBglm3Kf8Ou3Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGONOmLf1RkdhqS25Vuw0voITPDvbf0+TNuB6Je1usE=;
 b=sKqXD14OgHgYe/Eyvp18veJCGi/x9A5vsYZWsSMtI5tr+vt31UnIKefLzD171oi80AsnK/rqfMhT9NsDlkynlIcXH9TffZgjRBazCFXEybcpengUrBIvSfH7ytq+5HUCwkdd7I1mKO/BEUUtwGqX0kaduhakbWrDO8e3tB/WfWE=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by SJ0PR10MB4800.namprd10.prod.outlook.com (2603:10b6:a03:2da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Sat, 13 Mar
 2021 16:56:32 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 16:56:32 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Thread-Topic: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Thread-Index: AQHXFZqeiaeerAJORUmxXf3CqEbyg6p95BIAgACVhgCAAcXIgIAANasAgAASVACAAFUXgIABDpMAgAA4uYCAAASqgA==
Date:   Sat, 13 Mar 2021 16:56:31 +0000
Message-ID: <7D8C62E1-77FD-4B41-90D7-253D13715A6F@oracle.com>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310104618.22750-3-mgorman@techsingularity.net>
 <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
 <20210311084200.GR3697@techsingularity.net> <20210312124609.33d4d4ba@carbon>
 <20210312145814.GA2577561@casper.infradead.org>
 <20210312160350.GW3697@techsingularity.net>
 <20210312210823.GE2577561@casper.infradead.org>
 <20210313131648.GY3697@techsingularity.net>
 <20210313163949.GI2577561@casper.infradead.org>
In-Reply-To: <20210313163949.GI2577561@casper.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38a340bf-ecf6-4c29-75e1-08d8e640f426
x-ms-traffictypediagnostic: SJ0PR10MB4800:
x-microsoft-antispam-prvs: <SJ0PR10MB480068CD7D3CB7135A8C2399936E9@SJ0PR10MB4800.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5IJb1k/2tyRPyH0KCAVhwSwWd8xKzpfm495Q0RKupRT6PLw8HMhQl1IwgeMlKwX3nsaeNnNpnyi443zwRrxIvfrgq7zrrz77poYwlI+CtK0HQhZx8c7HJIb6U7gMW6xLbgWhLGv0jjVBpqsgLCN0gBU+jO3AzgCaJnA5lJJUpVIh+v1Kcgjlz7VMZcwm1RxUYuY0X/wKe3upIB6linqeJuTPEL5f2EDvn0K2Jp6phdWfGKvWIag3eaFCT6x/ViI9fyFQ1W8IB4hoh7IRgr1C8WgKwKW6xlWJG/sa14tjyBlY0UElMEg47dktUSxNhVyj7dO5dIBcGlRs3mcpwK/hImGpLoQpuphR2Q+AvpHFU8JMg/hnsgDyl7gfVyoPouGk8mEeuoCQstxutyj/6QIPFSJ+WaXLUskBl1oOhOGLsteUp+3+tN2c2im9FEMf/yUV+e9POtkb0YpwFBg5J7B6y0s/o/EnQbt8+XzYTLMSKjRQJ8WR5veUOfTjVjTMxxnrGhNlnM1LQmhUvZ4Ou5/IoMu4lpSsDJtEINXNYDl4FRmLrfz4qasHTlgnYGYBJXZiETnzm5qNNEqgBExSJFjmNJAcuwilNV7lLLYi4eCaozSjIYcmGe5DsgwAa3G75tln
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39860400002)(346002)(396003)(2906002)(5660300002)(8936002)(83380400001)(316002)(71200400001)(6506007)(8676002)(110136005)(86362001)(53546011)(26005)(186003)(2616005)(4326008)(66446008)(64756008)(66946007)(76116006)(66476007)(66556008)(54906003)(91956017)(478600001)(6486002)(6512007)(36756003)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?I6RaTJ67Hqf0cORG/SGIxQBNy3qsI53GP3LnHG/RARVJJV95yOLoDOt6QDlg?=
 =?us-ascii?Q?tyZ6AkI7Fxv2+OARyMaNBcju4+CyfrVMyKRzzJvf7fgIXmPfimsYeSVC8AIW?=
 =?us-ascii?Q?Hb7E11vV5W3WQV0xM5mqqAOH6egtFUiSwp410igABbPGo1S9TbZgl19dLD8y?=
 =?us-ascii?Q?OV81gRQejCBDKpcUmBDm7VORihE8Jy7f/oAZKVLxuStdVp3LTw+AbbY1UbeY?=
 =?us-ascii?Q?rJvBYFoqCEp8d2LBk08NoYt+Qvn7b4fMwjAIxsfiu/9BlESyMb0VUY/6oYcS?=
 =?us-ascii?Q?UlXzoqWrEgyajbVRAxAnCfelFbLcfRuUchYJTIEit3nQIiXIwaEW9L5fSeuy?=
 =?us-ascii?Q?1ZzTTixgUD8nOWOQbKCMd63SVzzWYskhwbsGy0/jYHWFB6VLICUwjc/5jVKf?=
 =?us-ascii?Q?AI6bkzMxUJzdWi5JpruQvWhoLlGbd77aAClDIrHPuTNEfKlIsGv3zycdRig2?=
 =?us-ascii?Q?pio4v0GFwrOVr95y4Sj5AqiQY9ZOCEDzBxT30UwJwvMVu/cZXHgYafscDDOM?=
 =?us-ascii?Q?yKFNWkzKD/mUVPo033N8p7mdng/Pp16k0/VnTORzvphlfRiKIW9yej/iGL5E?=
 =?us-ascii?Q?HxtsfnRkYZhoAy7UJx1zgzKLAicI6JdBf2SP+GIYJodbOzNSrfJ188y1lkmd?=
 =?us-ascii?Q?jddUxS/x4Rs67gtTEQZt+DUSNacL4Q+2bnu4ISXJHqso8EcpQQSkmJFGV1O9?=
 =?us-ascii?Q?9p7nkE3ZrJP+uV+Mq48u7zL5lDI2k4B6fFLyeXPeF5O9YyWMGczdEckopmlG?=
 =?us-ascii?Q?LueiGxgKO2i4msln881X7UZKyCtd7xTfUBd6eSKewxFVKtt98iVQSskp51YV?=
 =?us-ascii?Q?wtVyjnsp1urWioRokUyj5oEdto28hHRDBtD2cCCRvomYjbSitugePC9ppa/F?=
 =?us-ascii?Q?Hll1FtyGkf9r4AQAMQIilqo0rdraN5K+qS7pnTlNZD/kq+i5DtVxqD21lZiw?=
 =?us-ascii?Q?330dDtI8VFJ/STFxovp+WS44y62dlTkl4zWxKHRHkSVjc3No9U3YbBImxArN?=
 =?us-ascii?Q?Bwpnp7eSJrXZwx1EwW+HrJpbuB16HIc7OowYrFQs/EklKErMasxl//Tp6HNr?=
 =?us-ascii?Q?HLjjD5OA9DVThiA+99B7WFflof7i6Oh58VCHA7fBAKXYh9kNiEVhdlJhh5fD?=
 =?us-ascii?Q?p9efFjnW3trA+dIh2KteaEIVFh1lZZ4dxodvoVmIVfz0qeEBR24hHB1STIQ1?=
 =?us-ascii?Q?2ZsSsRheTrKrmAKxxQ2dbfw62Tadw/giie5b6ERoJ8/Jeognnrmw/dA0ZGwS?=
 =?us-ascii?Q?0QeK2P8LGlRD4sZ2Nf+J9TDLbBaz8q/8D2hxItBylPYzEwwUI3Fk1ZeMLTaV?=
 =?us-ascii?Q?20aGCTTuOPHvSBUoJP/Bc3aG?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CC03E11F12527045863F298E790F1AAE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a340bf-ecf6-4c29-75e1-08d8e640f426
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2021 16:56:31.9958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wd3QFllEtsUbUGdSu2UfmLDfvqNdamT5dG9aJTS1qjf6XCpSGPehkAv+cnHmtk+7CJvclkR7QBfh/UA/1g4XcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4800
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9922 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103130132
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9922 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103130132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 13, 2021, at 11:39 AM, Matthew Wilcox <willy@infradead.org> wrote:
>=20
> On Sat, Mar 13, 2021 at 01:16:48PM +0000, Mel Gorman wrote:
>>> I'm not claiming the pagevec is definitely a win, but it's very
>>> unclear which tradeoff is actually going to lead to better performance.
>>> Hopefully Jesper or Chuck can do some tests and figure out what actuall=
y
>>> works better with their hardware & usage patterns.
>>=20
>> The NFS user is often going to need to make round trips to get the pages=
 it
>> needs. The pagevec would have to be copied into the target array meaning
>> it's not much better than a list manipulation.
>=20
> I don't think you fully realise how bad CPUs are at list manipulation.
> See the attached program (and run it on your own hardware).  On my
> less-than-a-year-old core-i7:
>=20
> $ gcc -W -Wall -O2 -g array-vs-list.c -o array-vs-list
> $ ./array-vs-list=20
> walked sequential array in 0.001765s
> walked sequential list in 0.002920s
> walked sequential array in 0.001777s
> walked shuffled list in 0.081955s
> walked shuffled array in 0.007367s
>=20
> If you happen to get the objects in-order, it's only 64% worse to walk
> a list as an array.  If they're out of order, it's *11.1* times as bad.
> <array-vs-list.c>

IME lists are indeed less CPU-efficient, but I wonder if that
expense is insignificant compared to serialization primitives like
disabling and re-enabling IRQs, which we are avoiding by using
bulk page allocation.

My initial experience with the current interface left me feeling
uneasy about re-using the lru list field. That seems to expose an
internal API feature to consumers of the page allocator. If we
continue with a list-centric bulk allocator API I hope there can
be some conveniently-placed documentation that explains when it is
safe to use that field. Or perhaps the field should be renamed.

I have a mild preference for an array-style interface because that's
more natural for the NFSD consumer, but I'm happy to have a bulk
allocator either way. Purely from a code-reuse point of view, I
wonder how many consumers of alloc_pages_bulk() will be like
svc_alloc_arg(), where they need to fill in pages in an array. Each
such consumer would need to repeat the logic to convert the returned
list into an array. We have, for instance, release_pages(), which is
an array-centric page allocator API. Maybe a helper function or two
might prevent duplication of the list conversion logic.

And I agree with Mel that passing a single large array seems more
useful then having to build code at each consumer call-site to
iterate over smaller page_vecs until that array is filled.


--
Chuck Lever



