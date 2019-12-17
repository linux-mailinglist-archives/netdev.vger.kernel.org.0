Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDFB122DD5
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 15:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfLQN7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:59:51 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15008 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728539AbfLQN7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:59:50 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df8df4b0000>; Tue, 17 Dec 2019 05:59:40 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 17 Dec 2019 05:59:49 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 17 Dec 2019 05:59:49 -0800
Received: from [10.2.165.11] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Dec
 2019 13:59:48 +0000
Subject: Re: [RFC PATCH] mm/gup: try_pin_compound_head() can be static
To:     kbuild test robot <lkp@intel.com>
CC:     <kbuild-all@lists.01.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20191211025318.457113-24-jhubbard@nvidia.com>
 <20191217080358.q3k57ta62txvip5h@4978f4969bb8>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <7828a101-e422-8e2a-ef9b-9c0285065ed5@nvidia.com>
Date:   Tue, 17 Dec 2019 05:56:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191217080358.q3k57ta62txvip5h@4978f4969bb8>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576591180; bh=+kY6WrbKA7lSfaR6JiJsMhpW0kY3DW4edAlAk5Ve1Ws=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=GbGZzaEh7giluV7bpN/IIAOj3Mc18AXcjLeuEGsTgM8/schRNFGUqCq00YAc4ARRK
         0PVe1s7+qdvFmh1Ttru614AJtLodM6wJzZ2UNnA1jIm2+JCvQssDVh7rwrwji91hSp
         Dmomrx8a2mkRdKDi+zuehTjS+cK+ceZUGuV2qS+Q00TgS6unnj2J/spZ+jPwNEGl3X
         xJTAKof+O0alRzDH3cC7VTlXjNJwIWhcBZya8mbb62MvfcrAHYE78VekfobHefcZXx
         ueLyg5p/jxUNWHBbbcLlFxuQBAi3TiHxhM/GsO23RipjSLUTZwruxA+61/WfeUhUby
         xcvllM2I0K27A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/19 12:03 AM, kbuild test robot wrote:
> 
> Fixes: 8086d1c61970 ("mm/gup: track FOLL_PIN pages")
> Signed-off-by: kbuild test robot <lkp@intel.com>
> ---
>   gup.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 038b71165a761..849a6f55938e6 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -75,7 +75,7 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
>    * @Return:	the compound head page, with ref appropriately incremented,
>    * or NULL upon failure.
>    */
> -__must_check struct page *try_pin_compound_head(struct page *page, int refs)
> +static __must_check struct page *try_pin_compound_head(struct page *page, int refs)
>   {
>   	struct page *head = try_get_compound_head(page,
>   						  GUP_PIN_COUNTING_BIAS * refs);
> 

Yes, it should have been declared static. And this also applies to the latest version
(v11). The preferred fix would stay within 80 columns, like this:

diff --git a/mm/gup.c b/mm/gup.c
index c2793a86450e..39b2f683bd2e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -75,7 +75,8 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
   * @Return:    the compound head page, with ref appropriately incremented,
   * or NULL upon failure.
   */
-__must_check struct page *try_pin_compound_head(struct page *page, int refs)
+static __must_check struct page *try_pin_compound_head(struct page *page,
+                                                      int refs)
  {
         struct page *head = try_get_compound_head(page,
                                                   GUP_PIN_COUNTING_BIAS * refs);


thanks,
-- 
John Hubbard
NVIDIA
