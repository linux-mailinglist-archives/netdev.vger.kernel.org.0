Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D077B2DB8A0
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgLPBrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:47:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPBrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 20:47:46 -0500
Date:   Tue, 15 Dec 2020 17:47:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608083225;
        bh=KW5lmrsW+VblLlkc4MpIDELQ4yt7sjs4+wR6kNkujKs=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=koOtxnMqU9oSc/NFRwHCbvs6ZpxsudFEp/cUN0Wm7V3W4a28x58/6AuIh3E4r4Zcq
         dq4dgiJxPhFOdUpb6pTOkVGUfv1QRrPpt70Qg/HAXxwokeIKYBbwdrzFLm38/IaMwb
         tkXWrMBq05wxqX1MA+76buhRlPzziGrBB87jLRNbMYPFtQzj8l9diWwwC6DYTQdwc2
         1qUAcmnJOTTj7GX99cKD5Nxaxj4SvafeCRQh1c4uDoYULCD+QKuInJbC3O8V8KjvoO
         8/PLrCEAGqlSuCadIqek9M6v2slJxCw7iJEQJKhzADp2OphdydFUuxnoRhxGV98/X2
         GITkVTfjwXppA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <david.lebrun@uclouvain.be>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [PATCH net-next] seg6: fix the max number of supported SRv6
 behavior attributes
Message-ID: <20201215174704.545462ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216020834.c460011bccede55d0049c3c2@uniroma2.it>
References: <20201212010005.7338-1-andrea.mayer@uniroma2.it>
        <20201214205740.7e7a3945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201216020834.c460011bccede55d0049c3c2@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 02:08:34 +0100 Andrea Mayer wrote:
> I agree with this approach. Only for the sake of clarity I would prefer to
> define the macro SEG6_LOCAL_MAX_SUPP as follows:
> 
> in seg6_local.c:
>  [...]
> 
>  /* max total number of supported SRv6 behavior attributes */
>  #define SEG6_LOCAL_MAX_SUPP 32
> 
>  int __init seg6_local_init(void)
>  {
>     BUILD_BUG_ON(SEG6_LOCAL_MAX + 1 > SEG6_LOCAL_MAX_SUPP);
>     [...]
>  }
> 
> 
> Due to the changes, I will submit a new patch (v1) with a more appropriate
> subject. The title of the new patch will most likely be:
> 
>  seg6: fool-proof the processing of SRv6 behavior attributes

SGTM, thanks!
