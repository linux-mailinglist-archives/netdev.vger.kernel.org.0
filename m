Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173CD3497D5
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhCYRXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhCYRWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 13:22:54 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0915AC06174A;
        Thu, 25 Mar 2021 10:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=fd+YSWCmuNgmoKSLYqtfvKsiI6YnkssysiIkHOs21QQ=; b=DsB5oT+FJPywUs1Z4knMdOjmtC
        4oytI+VCd/Q65mM1pHDdCuXdOjEw7BjNAcUf75cQK/VGRklbXK5hD2iY/Bv8ygam47uDrMl8PrTx3
        fmMNvHVj/tDN2YShNsq1VmX/L3/NW4jue8xtYiclJ1lo5A2ymRBnAksM+GmB750DORIw+mvDYJtnw
        KlsTMlr5LUEksSSVc/oyfh/ELqyQIBIjcS2payygeF7fd0WBJ7syKuauD3q9BeBO2pTehY+SneHj/
        GNqKKq0VKV0VhTyT8gZTUnuFhWnYL4Y9wThmcykOkAv020pPipw9ohqk+vytyKqe2d6dsdVnFsKAx
        jqLhJKPQ==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lPTh6-001u0o-6n; Thu, 25 Mar 2021 17:22:52 +0000
Subject: Re: [PATCH] fddi: skfp: Rudimentary spello fixes
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210325070835.32041-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c75e92a7-077c-44ee-4fef-1d5efdb89ff4@infradead.org>
Date:   Thu, 25 Mar 2021 10:22:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325070835.32041-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/21 12:08 AM, Bhaskar Chowdhury wrote:
> 
> s/autohorized/authorized/
> s/recsource/resource/
> s/measuered/measured/
> sauthoriziation/authorization/

  s/

> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

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

