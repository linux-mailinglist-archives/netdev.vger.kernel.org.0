Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59F6334C38
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhCJXHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbhCJXHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 18:07:23 -0500
X-Greylist: delayed 155488 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 Mar 2021 15:07:23 PST
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F85C061574;
        Wed, 10 Mar 2021 15:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=GThwOt7we7afhufajq/5ARwrxio8Hss54rg43Et+q4Y=; b=aFTqMZq1+d0BQWUk9reg54Kvtz
        ZExbPx7xFUu6/kFimMmWqNKRGOhqJu2ziQFfzdrVysEpREMiMbe5T+BU+KedvqUcsTIjwIJd5SUWt
        +xLpDVXlDN6BIwujX5grjC4cPBGbzLk+bKuLNBD4KJMlHn8185g+kQuVhfD9oGAbnRoVlL8QV/bWT
        G7jTh3HnY6BhN/HGNW5VkVQL/QhWLcXocewWPiWuTj2b2OEltWbUwS7vizPWXguUfUhjg6U/ZMhnS
        59deUbJ2lgjilZgCQH7HVzcdlNLv53WN5YjvP3VjWOthmP4IDPGZjeRQeWzdqOkS26sS5sL/XMb1m
        D974DBZQ==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lK7vE-000rfW-8W; Wed, 10 Mar 2021 23:07:20 +0000
Subject: Re: [PATCH] net: fddi: skfp: Mundane typo fixes throughout the file
 smt.h
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210310225123.4676-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <bfae0e27-6bc1-b3fe-3ca8-f96b8d3c81ad@infradead.org>
Date:   Wed, 10 Mar 2021 15:07:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310225123.4676-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 2:51 PM, Bhaskar Chowdhury wrote:
> 
> Few spelling fixes throughout the file.
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

thanks.

> ---
>  drivers/net/fddi/skfp/h/smt.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/fddi/skfp/h/smt.h b/drivers/net/fddi/skfp/h/smt.h
> index a0dbc0f57a55..8d104f13e2c3 100644
> --- a/drivers/net/fddi/skfp/h/smt.h
> +++ b/drivers/net/fddi/skfp/h/smt.h
> @@ -411,7 +411,7 @@ struct smt_p_reason {
>  #define SMT_RDF_ILLEGAL 0x00000005	/* read only (PMF) */
>  #define SMT_RDF_NOPARAM	0x6		/* parameter not supported (PMF) */
>  #define SMT_RDF_RANGE	0x8		/* out of range */
> -#define SMT_RDF_AUTHOR	0x9		/* not autohorized */
> +#define SMT_RDF_AUTHOR	0x9		/* not authorized */
>  #define SMT_RDF_LENGTH	0x0a		/* length error */
>  #define SMT_RDF_TOOLONG	0x0b		/* length error */
>  #define SMT_RDF_SBA	0x0d		/* SBA denied */
> @@ -450,7 +450,7 @@ struct smt_p_version {
> 
>  struct smt_p_0015 {
>  	struct smt_para	para ;		/* generic parameter header */
> -	u_int		res_type ;	/* recsource type */
> +	u_int		res_type ;	/* resource type */
>  } ;
> 
>  #define	SYNC_BW		0x00000001L	/* Synchronous Bandwidth */
> @@ -489,7 +489,7 @@ struct smt_p_0017 {
>  struct smt_p_0018 {
>  	struct smt_para	para ;		/* generic parameter header */
>  	int		sba_ov_req ;	/* total sync bandwidth req for overhead*/
> -} ;					/* measuered in bytes per T_Neg */
> +} ;					/* measured in bytes per T_Neg */
> 
>  /*
>   * P19 : SBA Allocation Address
> @@ -562,7 +562,7 @@ struct smt_p_fsc {
>  #define FSC_TYPE2	2		/* Special A/C indicator forwarding */
> 
>  /*
> - * P00 21 : user defined authoriziation (see pmf.c)
> + * P00 21 : user defined authorization (see pmf.c)
>   */
>  #define SMT_P_AUTHOR	0x0021
> 
> --


-- 
~Randy

