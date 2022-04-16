Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819395034AC
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 09:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiDPHmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 03:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiDPHmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 03:42:22 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BB6E38A7;
        Sat, 16 Apr 2022 00:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=lSlZ0oC8eyM75bJ8SCbn8l2oeSxIau3s/L1LVWLjE4U=;
  b=uP8MdD5Q6dpYOhFVjgup8KVg3M8lohqEDCXqglxVNcJIgHqq2DMPOEQl
   jKOgvSQnAMPFJX8bERuNIn7c0fV/wYoAgZ0NGgEM72+NTN5Y4IC4lO9vH
   L4GdNL5Dia0R9p5n3+f7mtBuhyiRA7A4FMjBQkrU1u1cTj+itAFXmYSWH
   0=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,264,1643670000"; 
   d="scan'208";a="11683876"
Received: from 203.107.68.85.rev.sfr.net (HELO hadrien) ([85.68.107.203])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2022 09:39:49 +0200
Date:   Sat, 16 Apr 2022 09:39:48 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Soumya Negi <soumya.negi97@gmail.com>
cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, outreachy@lists.linux.dev
Subject: Re: [PATCH] staging: qlge: add blank line after struct declaration
In-Reply-To: <20220416061936.957-1-soumya.negi97@gmail.com>
Message-ID: <alpine.DEB.2.22.394.2204160939110.3501@hadrien>
References: <20220416061936.957-1-soumya.negi97@gmail.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Fri, 15 Apr 2022, Soumya Negi wrote:

> Adhere to linux coding style. Reported by checkpatch:
> CHECK: Please use a blank line after function/struct/union/enum declarations

The subject line talks about a struct declaration, but there doesn't seem
to be one here.

julia

>
> Signed-off-by: Soumya Negi <soumya.negi97@gmail.com>
> ---
>  drivers/staging/qlge/qlge.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> index 55e0ad759250..d0dd659834ee 100644
> --- a/drivers/staging/qlge/qlge.h
> +++ b/drivers/staging/qlge/qlge.h
> @@ -2072,6 +2072,7 @@ struct qlge_adapter *netdev_to_qdev(struct net_device *ndev)
>
>  	return ndev_priv->qdev;
>  }
> +
>  /*
>   * The main Adapter structure definition.
>   * This structure has all fields relevant to the hardware.
> --
> 2.17.1
>
>
>
