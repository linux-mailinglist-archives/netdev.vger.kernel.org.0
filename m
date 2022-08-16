Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17058595DB8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbiHPNuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbiHPNuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C26297513
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B63A260B86
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 13:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB14C433D6;
        Tue, 16 Aug 2022 13:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660657800;
        bh=B16uI6+M++p+boMOCdlQaFjT8CnGvQ+QoWxovMBxivU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ALSebul+2s5Yp0B4gengxyhZSxPZR9Wjja53RYJp7rXQK19VccexRef3O4ZwEQPid
         rtnDRN2cm8bZBuz50wM9HbiRcuHiOaPpdJbhBO0BTBdeWclxa0TZbrjZYQL2B5YV1x
         vcDhjW8+nMlCLhcqmXziTN2F/VRqMs+ynpCLdjurTLgQQGWHA5HB6wH1ZFRFdpc8H/
         RD1F3sdf6+TuoKlm39+8f5O0SI5e/PoRMmPMGYLziX0wjP7FN8Kn3DfLGmAuOhMU1a
         AhnssxGlEoayNY0CmUm/exEvIQ4SAoH2JwikQTyk/0rOv4tTx4vPXx69XtUuqfjAfo
         RqrN6SZC6NqzA==
Date:   Tue, 16 Aug 2022 16:49:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     jiangheng <15720603159@163.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2]rdma: modify the command output message of rdma
 statistic help based on man manual
Message-ID: <Yvugg0M22X1Vua7M@unreal>
References: <25ce8a4f.6db0.182910b625a.Coremail.15720603159@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25ce8a4f.6db0.182910b625a.Coremail.15720603159@163.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 03:53:38PM +0800, jiangheng wrote:
> 
> From 4ce8d60f34c5cdcff8b25e3c3891fc053736225b Mon Sep 17 00:00:00 2001
> From: jinag <jinag12138@gmail.com>
> Date: Fri, 12 Aug 2022 15:48:07 +0800
> Subject: [PATCH] rdma: modify the command output message of rdma statistic help
>  based on man manual
> 
> 
> ---
>  rdma/stat.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

iproute2 follows kernel coding style, both in the code
and in the patches. Please follow it.

Thanks

> 
> 
> diff --git a/rdma/stat.c b/rdma/stat.c
> index aad8815c..1e869c25 100644
> --- a/rdma/stat.c
> +++ b/rdma/stat.c
> @@ -24,10 +24,10 @@ static int stat_help(struct rd *rd)
>     pr_out("       %s statistic mode [ supported ] link [ DEV/PORT_INDEX ]\n", rd->filename);
>     pr_out("       %s statistic set link [ DEV/PORT_INDEX ] optional-counters [ OPTIONAL-COUNTERS ]\n", rd->filename);
>     pr_out("       %s statistic unset link [ DEV/PORT_INDEX ] optional-counters\n", rd->filename);
> -   pr_out("where  OBJECT: = { qp }\n");
> -   pr_out("       CRITERIA : = { type }\n");
> +   pr_out("where  OBJECT: = { qp | mr }\n");
> +   pr_out("       CRITERIA : = { type | pid }\n");
>     pr_out("       COUNTER_SCOPE: = { link | dev }\n");
> -   pr_out("       FILTER_NAME: = { cntn | lqpn | pid }\n");
> +   pr_out("       FILTER_NAME: = { cntn | lqpn | pid | qp_type }\n");
>     pr_out("Examples:\n");
>     pr_out("       %s statistic qp show\n", rd->filename);
>     pr_out("       %s statistic qp show link mlx5_2/1\n", rd->filename);
> --
> 2.23.0
