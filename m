Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12E14AC577
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 17:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345995AbiBGQZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 11:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238296AbiBGQNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:13:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB8DC0401CC;
        Mon,  7 Feb 2022 08:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=QcrPZVnpOsUdir5hCyEdJWhJ7fNz0EgpSbs0nJV/69M=; b=sZ6xlv0oWX5uQyN2qe5dxEqoA+
        sBKZK+18TRJkLd5JGh17gdQku0bee0OWY/Ui/3e5o7qTt9Ucjtz85S03Xl2ywRM9BjkhM5SLydjXI
        97ymstDHBk9OMgToMrIr7m6wXrMmS81HLgCGoRm1IjChSxpVzmkrEq2ChCieDwTYFfkXYAIviIYp5
        49UmoV3ga0nOm/kzRUyy26ZigReZe+0opEfyxGXd09xTbkx0UlfbixnQ0Q7c10tiJgwwJ2olauqrr
        xhUuUHmwPhFAh9qro25vXNfJehdIHw++i6zCLF//fuRqDJp5eWzGs2dPKVsJHy3Vm7ytK4Ek2I1kM
        uaffy2Cw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nH6dS-001Ri8-2z; Mon, 07 Feb 2022 16:13:02 +0000
Message-ID: <46818f0c-e05b-c984-967b-12d723f04550@infradead.org>
Date:   Mon, 7 Feb 2022 08:12:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] staging: qlge: Fix checkpatch errors in the module
Content-Language: en-US
To:     Ayan Choudhary <ayanchoudhary1025@gmail.com>, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20220207071500.2679-1-ayanchoudhary1025@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220207071500.2679-1-ayanchoudhary1025@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 2/6/22 23:15, Ayan Choudhary wrote:
> The qlge module had many checkpatch errors, this patch fixes most of them.
> The errors which presently remain are either false positives or
> introduce unncessary comments in the code.

I guess that most of these are warnings and not errors, but since none of
them are quoted here, I cannot tell that for sure.

> Signed-off-by: Ayan Choudhary <ayanchoudhary1025@gmail.com>
> ---
>  drivers/staging/qlge/Kconfig     |  8 +++++---
>  drivers/staging/qlge/TODO        |  1 -
>  drivers/staging/qlge/qlge.h      | 24 ++++++++++++------------
>  drivers/staging/qlge/qlge_main.c | 12 +++++++++---
>  drivers/staging/qlge/qlge_mpi.c  | 11 +++++------
>  5 files changed, 31 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
> index 6d831ed67965..21fd3f6e33d6 100644
> --- a/drivers/staging/qlge/Kconfig
> +++ b/drivers/staging/qlge/Kconfig
> @@ -5,7 +5,9 @@ config QLGE
>  	depends on ETHERNET && PCI
>  	select NET_DEVLINK
>  	help
> -	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
> +		This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
>  
> -	To compile this driver as a module, choose M here. The module will be
> -	called qlge.
> +		Say Y here to enable support for QLogic ISP8XXX 10Gb Ethernet cards.
> +
> +		To compile this driver as a module, choose M here. The module will be
> +		called qlge.

Anyway, please follow coding-style for Kconfig files:

(from Documentation/process/coding-style.rst, section 10):

For all of the Kconfig* configuration files throughout the source tree,
the indentation is somewhat different.  Lines under a ``config`` definition
are indented with one tab, while help text is indented an additional two
spaces.


thanks.
-- 
~Randy
