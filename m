Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE48933A56A
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 16:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhCNPXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 11:23:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39568 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhCNPWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 11:22:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12EFGi4a142371;
        Sun, 14 Mar 2021 15:22:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SQxyDHTz06iORMnRPJKqShzj8KUab0Jl2Fqad+kyM0M=;
 b=rNHs5ei/vjDLqAQjml83x/+IgqP3I3WGBoSFa4Jhq7leo1iRGFtRERvmvQzXhNuAlXTV
 nEO55GmiBm+Fle7Ocphe6ins+PnGJ2hypaflUhOndR+MHufoN8QEppY2Lx03Lkl9bUjc
 pMsEa4x1fWyNWZdDqYUcLGXFNjmPhr2XyBwy/BwcmKgHs6vZOauNv45U05Ck4awfOidO
 fJh8Sddk/p/IW9kVSFPQL2urUKfe9OdqmLau5DdPvOHTg7HiXEETrWQJEyM+raYGBTg+
 PA/KSfSHZe/jBlk7fcAbC10zP2mrTQFLCj5uebhdphn8mXhQ76Y8vIhoyyE6BjF5liwl 0A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 378nbm1x7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Mar 2021 15:22:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12EFGJrp145680;
        Sun, 14 Mar 2021 15:22:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3796yr87p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Mar 2021 15:22:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ih4ST1aOIVNEziJSGSMHCDjO+f8HrSTKfZjV8/7I+hR18QIaj84/hLjmt+NQalPgrLdYKf4G9rWQy3PmXbBatLEEeMZoxH/vWpX5K4fFtjaLxJk24qE5qwtIcdsIU+P9jvablMrwyAPdSjeQaOPZqIX4iEYT8I8+6KYizjX2qRFQVBDGt/nFMONmPhgEqJ4rtoxsNj8xl1LAE1/WIsKThmZTyZsq46y16UCM8c7xBLWcPGejQBpgDWfC4WSkQpi+bJSa0U+4lyAaVLPp8fUM2QffHxSsmafUDDjM5phFp21Fi2WM4o0Fohsk3ULHWqJZrxe/IbSN8RZeo1F5HCNldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQxyDHTz06iORMnRPJKqShzj8KUab0Jl2Fqad+kyM0M=;
 b=ddcXyRoKXmGVulmEeVNT3VlrqzkvWcEsGp0WCK5NsTXCcwODB0sq5LVzWrlVUzqwTpaGeiX3xaAkQb8Ad3d/s/4MM8d7JGJ2wWs2XReOGpoIrFZ7o5B5K8lTLu8wUsbCYsLR6NlOUTPtsVlEsnh3y9S7Xqq6YQQJy2vyoiMnPCbJhDuVpwhB9HkDuyUij2nxbhwFga4skpkgTXk6zMZiRafDw8mreehRmalG2ZU99VOWUY1kNAr3rhPzmjtA9eOCHlIm8b3jSnQNh+TeS454ljcUuwn/VwpqcCQSfmDd3aP9O48nk+I7jP51GHowQwPNE2VuqC9hmKbIK8+dTv7wFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQxyDHTz06iORMnRPJKqShzj8KUab0Jl2Fqad+kyM0M=;
 b=r07lDcP9RxfkwifllSrmUCsBCWb5m7+0DCmGhjPDz2Zc2JaWPROxtKl/F3LysA16gGu7mpr6lfmvJyVXwyDChQYRdOvrUkErKowLP77AdeIkeo4RuiF5a9uBuL1etG/xFhUBKMUmByNN6Xh2pAGeXmlXbCUnNiUbdlnN1SPXYyM=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BY5PR10MB3779.namprd10.prod.outlook.com (2603:10b6:a03:1b6::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Sun, 14 Mar
 2021 15:22:02 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.3933.032; Sun, 14 Mar 2021
 15:22:02 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Mel Gorman <mgorman@techsingularity.net>
CC:     Matthew Wilcox <willy@infradead.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Thread-Topic: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Thread-Index: AQHXFZqeiaeerAJORUmxXf3CqEbyg6p95BIAgACVhgCAAcXIgIAANasAgAASVACAAFUXgIABDpMAgAA4uYCAAASqgIAAK+yAgAEiPgCAACnEgA==
Date:   Sun, 14 Mar 2021 15:22:02 +0000
Message-ID: <325875A2-A98A-4ECF-AFDF-0B70BCCB79AD@oracle.com>
References: <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
 <20210311084200.GR3697@techsingularity.net> <20210312124609.33d4d4ba@carbon>
 <20210312145814.GA2577561@casper.infradead.org>
 <20210312160350.GW3697@techsingularity.net>
 <20210312210823.GE2577561@casper.infradead.org>
 <20210313131648.GY3697@techsingularity.net>
 <20210313163949.GI2577561@casper.infradead.org>
 <7D8C62E1-77FD-4B41-90D7-253D13715A6F@oracle.com>
 <20210313193343.GJ2577561@casper.infradead.org>
 <20210314125231.GA3697@techsingularity.net>
In-Reply-To: <20210314125231.GA3697@techsingularity.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: techsingularity.net; dkim=none (message not signed)
 header.d=none;techsingularity.net; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91eb15fd-1e31-4261-4101-08d8e6fceb24
x-ms-traffictypediagnostic: BY5PR10MB3779:
x-microsoft-antispam-prvs: <BY5PR10MB377990F78837570C6AA42048936D9@BY5PR10MB3779.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X8y/0YvRAGojCrrKqKDhe+kw2b8tPh2ah8Aueb41r2O7ybvNJ8otvGEqP7R79kBn0iFIuJrNSTHQs13+agF7+/xqysdjIQ+BP3XnM2KoFTTFqRkJYcTLzzMOwDS0dujBLH3viE4171AUMjmQfF2hPKXf11i+DBtFfTYwU9gfPfDIHDZsvAU9uv9yPTx06fiRRw7+m1mVs5xx/N68EgucGGTLR5mZ8zUDjdXO+Ww5POdpgfdcn58nvEt9PWLOvQD6D5Q3TE7EqcTA5bnD6u7xBx/8Dh2v35qu46nxr2DSDEAMrj195+7teSdluP6q9vMZbIacgalZiWxzfYSEvhEDd8SXymkyJ6rMRHYaP0k2Jrq/itLZz/N6JOK60/mLRtP2L4UzpXwUKlW8wb7XyWz3xl0XBV+iX6I8J6BfOdCdNJDFzkPAt21TqW6iuBnQjTxOt0SBvAnfgpa1qST6BgFcFuOAj2MLmaPb+qnQCV70CI1mfR9s0OjlB61h2eccmz9ZVzbI2AUGyVKvC0dR5pCrW/H0fIy9Be4VAog6uZLS5bgBahnmRbQDN84uxXm3eVebMZjK3PakM573WsEE4tqLYl0coFjYZ/x7m64VWoD4Q08dLm/HbHm9+Jy5IoOsoRF8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(64756008)(5660300002)(91956017)(66446008)(66556008)(316002)(66476007)(36756003)(6916009)(76116006)(66946007)(83380400001)(2906002)(71200400001)(6506007)(478600001)(2616005)(8936002)(4326008)(8676002)(186003)(26005)(6512007)(53546011)(86362001)(54906003)(33656002)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?LXUvQ8CUlntjr4u3+nmXacgmmKXgZHpqZzU/Ibb5uoC7T3nywVh9qyLRJ/LK?=
 =?us-ascii?Q?W2jJ7jzuFonFc7m/WEJwVPIXUZCsuCQFgQMJ0NrvI7DybBkR3AKbeDesLBRJ?=
 =?us-ascii?Q?aHSqzFqKoJFqr6aye9LN78rXxtxyjWjjnq10ihAWybREoXr8Hmnogom0XaYu?=
 =?us-ascii?Q?kiIczxfMBNvfUtfOX0UKjmqQZSACgoqgKp26R8sinJcMoAjNNojWFBH3oc6i?=
 =?us-ascii?Q?9hiUj2D/3vC104Xi2zHSuciMJjmIaF7529rGZi9T1or810pERs2x3fVODELy?=
 =?us-ascii?Q?dMw04HZ/BOwoZYWvqOHex/f7xGzgQVcGLBgaUBwpJIx8CKJHwxu1/CZYjwPK?=
 =?us-ascii?Q?W7ULbXpTWW74GFBBbePH3WIzaoCaKyooH5yiT9ED3JEFQhyEybfQPqsJJSHB?=
 =?us-ascii?Q?AOSwzTsQ0CDe553m1FzFMyeTb+uqvEIXnlMuiNjKNPx7tj0b87yW9mkqhBGa?=
 =?us-ascii?Q?Xtt4tBoKLehbzG6qSm5UsAg7A9hDbjfaYR7VV0j0w+r9rPVL268yy04Rrs9J?=
 =?us-ascii?Q?tVboJTzAyWSH4jr3uWVmCEB4t25rv+6Ex5h9eUwYkHkf4oTE9Q6drnVt9DMO?=
 =?us-ascii?Q?dRktLIhAlq0OCu9D4J99tgorgBHuZrN40M3LXUYvLRSzGJNvKVgg3tGYz9kX?=
 =?us-ascii?Q?Hx2RtLFowUT/Qm2vGgjsFty8ZP1PhZWAtqa3NoQTakoBrFHZPCcG10qvYvWg?=
 =?us-ascii?Q?ErkczFIVOMiqTazBWp4fnC/sEOk6pCZxRM0QDngz90BCGKmW3iRfefatPN2S?=
 =?us-ascii?Q?9a+e+ixselj7v1LiVzwhIjC1ntjZAlkPpAYYLX6bIzcmyyKny6fsenxmsJas?=
 =?us-ascii?Q?Mz8vhX2gjQb7jUBpnuYp7uKZssT0fDgnhAKTIoUEglDWvM7pVUP7+BIGAzaD?=
 =?us-ascii?Q?3j3CEvX56fHFF8kSSjuRgmJ/Z1PAeqK3QtAvRzqrh/8AUjsGJpPzuj97cI/s?=
 =?us-ascii?Q?YLWwAZVFYWlkSA8/Z237Nrai4vT82LL3NJ+OYH0hCjOoXpdyefbwjQfBawRR?=
 =?us-ascii?Q?7ViAeFvC2231takdoXVctEzHe9OYmxm1LQ3pOSuHbDAD6eeurQ5P7XiJkwLB?=
 =?us-ascii?Q?xf9tr2BL5dNkb0DPAHlGFONeIcevyQIlrRcKbGN1hSvjrb1SMOMm4lVIClq0?=
 =?us-ascii?Q?dvo7cUTcfqEvWyvqNHL+ej/p4p8UL4ppSxZz0pMfIjz8wUdxWuwNst11+q+Z?=
 =?us-ascii?Q?B8n3IM5wuqDS2yo++qAd/UFXH8EIeOjx94EL9omZbMhR/Zz5F8OAwaXa2rZu?=
 =?us-ascii?Q?Sv9CI5j3+0q5dCs71BUk47cPOPIDuxgtzJFBNpqIHQxwKOvk6qZWip8kpZ8b?=
 =?us-ascii?Q?Q217xytsQ7EIMxnBv427TW4U?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9C6C42FAF2E5644BBFC076DF5E87E6D6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91eb15fd-1e31-4261-4101-08d8e6fceb24
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2021 15:22:02.3745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZzhkVS1k11l563Kj9uIh61Q1huj7/wKLYiXcNvhOMwEOAmCrFhcaPJ9gaZdoiZ2ErnYozMmpa2WM6K8P6Hl6zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3779
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9923 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103140119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9923 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103140119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 14, 2021, at 8:52 AM, Mel Gorman <mgorman@techsingularity.net> wro=
te:
>=20
> On Sat, Mar 13, 2021 at 07:33:43PM +0000, Matthew Wilcox wrote:
>> On Sat, Mar 13, 2021 at 04:56:31PM +0000, Chuck Lever III wrote:
>>> IME lists are indeed less CPU-efficient, but I wonder if that
>>> expense is insignificant compared to serialization primitives like
>>> disabling and re-enabling IRQs, which we are avoiding by using
>>> bulk page allocation.
>>=20
>> Cache misses are a worse problem than serialisation.  Paul McKenney had
>> a neat demonstration where he took a sheet of toilet paper to represent
>> an instruction, and then unrolled two rolls of toilet paper around the
>> lecture theatre to represent an L3 cache miss.  Obviously a serialising
>> instruction is worse than an add instruction, but i'm thinking maybe
>> 50-100 sheets of paper, not an entire roll?
>>=20
>=20
> I'm well array of the advantages of arrays over lists. The reality is tha=
t
> the penalty is incurred unconditionally as the pages have to be removed
> from the per-cpu or buddy lists and the cache footprint of the allocator
> and the data copies are already large. It's also the case that bulk free
> interfaces already exist that operate on lists (free_unref_page_list)
> so there is existing precedent. The bulk free API in this series was not
> used by the callers so I've deleted it.
>=20
> Obviously the callers would need to be adjusted to use the array
> interface. The sunrpc user has an array but it is coded in a way that
> expects the array could be partially populated or has holes so the API ha=
s
> to skip populated elements. The caller is responsible for making sure tha=
t
> there are enough NULL elements available to store nr_pages or the buffer
> overruns. nr_elements could be passed in to avoid the buffer overrun but
> then further logic is needed to distinguish between a failed allocation
> and a failure to have enough space in the array to store the pointer.
> It also means that prep_new_page() should not be deferred outside of
> the IRQ disabled section as it does not have the storage to track which
> pages were freshly allocated and which ones were already on the array. It
> could be tracked using the lower bit of the pointer but that is not free
> either. Ideally the callers simply would ensure the array does not have
> valid struct page pointers in it already so prepping the new page could
> always be deferred.  Obviously the callers are also responsible for
> ensuring protecting the array from parallel access if necessary while
> calling into the allocator.
>=20
>> Anyway, I'm not arguing against a bulk allocator, nor even saying this
>> is a bad interface.  It just maybe could be better.
>>=20
>=20
> I think it puts more responsibility on the caller to use the API correctl=
y
> but I also see no value in arguing about it further because there is no
> supporting data either way (I don't have routine access to a sufficiently
> fast network to generate the data). I can add the following patch and let
> callers figure out which interface is preferred. If one of the interfaces
> is dead in a year, it can be removed.
>=20
> As there are a couple of ways the arrays could be used, I'm leaving it
> up to Jesper and Chuck which interface they want to use. In particular,
> it would be preferred if the array has no valid struct pages in it but
> it's up to them to judge how practical that is.

I'm interested to hear from Jesper.

My two cents (US):

If svc_alloc_arg() is the /only/ consumer that wants to fill
a partially populated array of page pointers, then there's no
code-duplication benefit to changing the synopsis of
alloc_pages_bulk() at this point.

Also, if the consumers still have to pass in the number of
pages the array needs, rather than having the bulk allocator
figure it out, then there's not much additional benefit, IMO.

Ideally (for SUNRPC) alloc_pages_bulk() would take a pointer
to a sparsely-populated array and the total number of elements
in that array, and fill in the NULL elements. The return value
would be "success -- all elements are populated" or "failure --
some elements remain NULL".

But again, if no other consumer finds that useful, or that API
design obscures the performance benefits of the bulk allocator,
I can be very happy with the list-centric API. My interest in
this part of the exercise is simply to reduce the overall amount
of new complexity across mm/ and consumers of the bulk allocator.


> Patch is only lightly tested with a poor conversion of the sunrpc code
> to use the array interface.
>=20
> ---8<---
> mm/page_alloc: Add an array-based interface to the bulk page allocator
>=20
> The existing callers for the bulk allocator are storing the pages in
> arrays. This patch adds an array-based interface to the API to avoid
> multiple list iterations. The page list interface is preserved to
> avoid requiring all users of the bulk API to allocate and manage
> enough storage to store the pages.
>=20
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
>=20
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 4a304fd39916..fb6234e1fe59 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -520,13 +520,20 @@ struct page *__alloc_pages(gfp_t gfp, unsigned int =
order, int preferred_nid,
>=20
> int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
> 				nodemask_t *nodemask, int nr_pages,
> -				struct list_head *list);
> +				struct list_head *page_list,
> +				struct page **page_array);
>=20
> /* Bulk allocate order-0 pages */
> static inline unsigned long
> -alloc_pages_bulk(gfp_t gfp, unsigned long nr_pages, struct list_head *li=
st)
> +alloc_pages_bulk_list(gfp_t gfp, unsigned long nr_pages, struct list_hea=
d *list)
> {
> -	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list);
> +	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list, NUL=
L);
> +}
> +
> +static inline unsigned long
> +alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **=
page_array)
> +{
> +	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, pag=
e_array);
> }
>=20
> /*
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3e0c87c588d3..96590f0726c7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4965,13 +4965,20 @@ static inline bool prepare_alloc_pages(gfp_t gfp,=
 unsigned int order,
>=20
> /*
>  * This is a batched version of the page allocator that attempts to
> - * allocate nr_pages quickly from the preferred zone and add them to lis=
t.
> + * allocate nr_pages quickly from the preferred zone. Pages are added
> + * to page_list if page_list is not NULL, otherwise it is assumed
> + * that the page_array is valid.
> + *
> + * If using page_array, only NULL elements are populated with pages.
> + * The caller must ensure that the array has enough NULL elements
> + * to store nr_pages or the buffer overruns.
>  *
>  * Returns the number of pages allocated.
>  */
> int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
> 			nodemask_t *nodemask, int nr_pages,
> -			struct list_head *alloc_list)
> +			struct list_head *page_list,
> +			struct page **page_array)
> {
> 	struct page *page;
> 	unsigned long flags;
> @@ -4987,6 +4994,9 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid=
,
> 	if (WARN_ON_ONCE(nr_pages <=3D 0))
> 		return 0;
>=20
> +	if (WARN_ON_ONCE(!page_list && !page_array))
> +		return 0;
> +
> 	if (nr_pages =3D=3D 1)
> 		goto failed;
>=20
> @@ -5035,7 +5045,24 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_ni=
d,
> 			break;
> 		}
>=20
> -		list_add(&page->lru, alloc_list);
> +		if (page_list) {
> +			/* New page prep is deferred */
> +			list_add(&page->lru, page_list);
> +		} else {
> +			/* Skip populated elements */
> +			while (*page_array)
> +				page_array++;
> +
> +			/*
> +			 * Array pages must be prepped immediately to
> +			 * avoid tracking which pages are new and
> +			 * which ones were already on the array.
> +			 */
> +			prep_new_page(page, 0, gfp, 0);
> +			*page_array =3D page;
> +			page_array++;
> +		}
> +
> 		allocated++;
> 	}
>=20
> @@ -5044,9 +5071,12 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_ni=
d,
>=20
> 	local_irq_restore(flags);
>=20
> -	/* Prep page with IRQs enabled to reduce disabled times */
> -	list_for_each_entry(page, alloc_list, lru)
> -		prep_new_page(page, 0, gfp, 0);
> +	/* Prep pages with IRQs enabled if using a list */
> +	if (page_list) {
> +		list_for_each_entry(page, page_list, lru) {
> +			prep_new_page(page, 0, gfp, 0);
> +		}
> +	}
>=20
> 	return allocated;
>=20
> @@ -5056,7 +5086,10 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_ni=
d,
> failed:
> 	page =3D __alloc_pages(gfp, 0, preferred_nid, nodemask);
> 	if (page) {
> -		list_add(&page->lru, alloc_list);
> +		if (page_list)
> +			list_add(&page->lru, page_list);
> +		else
> +			*page_array =3D page;
> 		allocated =3D 1;
> 	}
>=20

--
Chuck Lever



