Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BBE3429F9
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 03:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhCTCUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 22:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCTCUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 22:20:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B763C061760;
        Fri, 19 Mar 2021 19:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
        References:Message-ID:In-Reply-To:Subject:cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8tVUr4Z77XqdpCburPTzUBwUNmrxBPTRD/lmMybR51w=; b=0LNLcMdgj5Cu0nrQ3Fk/ODSTzX
        nu71IUROAoEOnO1otENeUgEgJ4sn+4S1/DYIKPz2onuTOnPgcatUlQycnCZKRQNjEx1t+PeeFZqk7
        5JrvYqn0qaSRrgB6Puz3cDIzodHnfZk+mHfT/uuwTAYuG6jfxSKuAEmxKOrlxrFw4stzjukw0usG1
        hhlQwH9TCw3D2OHWAsIAI2UYgfxqGp24keDFYjP4gxqUX3A09/OEbflxH9sDjsHGLIBrp0iHRjtjg
        sUa7Z7dumpN4ynLjjyH5dSUGiStzXBO10Di1VKkZwBjVPNm9KpAEOtUJW66ybIx0T7Lp4BZx30LOp
        u0T1LBuw==;
Received: from rdunlap (helo=localhost)
        by bombadil.infradead.org with local-esmtp (Exim 4.94 #2 (Red Hat Linux))
        id 1lNRDh-001em1-Jh; Sat, 20 Mar 2021 02:20:06 +0000
Date:   Fri, 19 Mar 2021 19:20:05 -0700 (PDT)
From:   Randy Dunlap <rdunlap@bombadil.infradead.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        yuehaibing@huawei.com, vaibhavgupta40@gmail.com,
        christophe.jaillet@wanadoo.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] ethernet: sun: Fix a typo
In-Reply-To: <20210318203443.21708-1-unixbhaskar@gmail.com>
Message-ID: <7724a2e-178c-d010-b13c-f2d41efc2d0@bombadil.infradead.org>
References: <20210318203443.21708-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: Randy Dunlap <rdunlap@infradead.org>
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20210319_192005_672153_B2FC5BD9 
X-CRM114-Status: GOOD (  13.10  )
X-Spam-Score: -0.0 (/)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On Fri, 19 Mar 2021, Bhaskar Chowdhury wrote: > s/serisouly/seriously/
    > > ...plus the sentence construction for better readability. > > Signed-off-by:
    Bhaskar Chowdhury <unixbhaskar@gmail.com> > --- > Changes from V2: > Missed
    the subject line l [...] 
 Content analysis details:   (-0.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.0 NO_RELAYS              Informational: message was not relayed via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Fri, 19 Mar 2021, Bhaskar Chowdhury wrote:

> s/serisouly/seriously/
>
> ...plus the sentence construction for better readability.
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  Changes from V2:
>  Missed the subject line labeling ..so added
>
> drivers/net/ethernet/sun/sungem.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
> index 58f142ee78a3..9790656cf970 100644
> --- a/drivers/net/ethernet/sun/sungem.c
> +++ b/drivers/net/ethernet/sun/sungem.c
> @@ -1674,8 +1674,8 @@ static void gem_init_phy(struct gem *gp)
> 	if (gp->pdev->vendor == PCI_VENDOR_ID_APPLE) {
> 		int i;
>
> -		/* Those delay sucks, the HW seem to love them though, I'll
> -		 * serisouly consider breaking some locks here to be able
> +		/* Those delays sucks, the HW seems to love them though, I'll

Nope: needs subject/verb agreement, e.g. "delays suck".

> +		 * seriously consider breaking some locks here to be able
> 		 * to schedule instead
> 		 */
> 		for (i = 0; i < 3; i++) {
> --
> 2.26.2
>
>
