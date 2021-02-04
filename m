Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5687430E9FB
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhBDCKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhBDCKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 21:10:44 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD4CC0613D6;
        Wed,  3 Feb 2021 18:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=qpZXbW6EJfxgDufWrNMMYF+eNpvsq+lvzqFizGqVhaw=; b=LYnWJpaHdQRlqryZJtk5hjlnWM
        zebhtvBAVeIQ/8eqLc7/AgEYRe/OW12kGVqAjqPnaPvYBbY99KKGOAhcrLG4PFgUwFg3R7ZhaHgIB
        CRw00VCXz9AYn3+bZMnlnMcojekI3kT2k+85AWColBGffhddK8cq4GASCSTcD1NcrE3j84+oGgH4+
        ZjxaZO5RYQ8Q0967lwEi2FCUu7DbbN1vygKurEmLt0pVvk9jlEIGZitonB1XhBHdKzIv/EHdflL8I
        K6LMwuEGls8qgsyaY0UWKoo2tKKs12eFlfq1UHURpT1xH+GniYBzH3Qcdh2urbpRxJAp5VFVG1nqg
        FVO2lRrw==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7U5p-0002nc-Ap; Thu, 04 Feb 2021 02:10:01 +0000
Subject: Re: [PATCH V2] drivers: net: ethernet: i825xx: Fix couple of
 spellings and get rid of blank lines too in the file ether1.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210204011821.18356-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <bea4f9c4-b1bb-eab6-3125-bfe69938fa5b@infradead.org>
Date:   Wed, 3 Feb 2021 18:09:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210204011821.18356-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/21 5:18 PM, Bhaskar Chowdhury wrote:
> 
> s/initialsation/initialisation/
> s/specifiing/specifying/
> 
> Plus get rid of few blank lines.
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
> Changes from V1:
>    Fix typo in the subject line
>    Give explanation of all the changes in changelog text
> 
>  drivers/net/ethernet/i825xx/ether1.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
> index a0bfb509e002..850ea32091ed 100644
> --- a/drivers/net/ethernet/i825xx/ether1.c
> +++ b/drivers/net/ethernet/i825xx/ether1.c

a. don't delete the blank lines
b. the change below is not described and does not change any whitespace AFAICT.
   I.e., DDT [don't do that].

> @@ -1047,7 +1044,7 @@ static void ether1_remove(struct expansion_card *ec)
>  {
>  	struct net_device *dev = ecard_get_drvdata(ec);
> 
> -	ecard_set_drvdata(ec, NULL);
> +	ecard_set_drvdata(ec, NULL);
> 
>  	unregister_netdev(dev);
>  	free_netdev(dev);


-- 
~Randy

