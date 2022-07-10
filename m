Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD7256CC63
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 04:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiGJCXf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 9 Jul 2022 22:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGJCXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 22:23:33 -0400
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE92E5F56
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 19:23:32 -0700 (PDT)
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay09.hostedemail.com (Postfix) with ESMTP id 429B0349A9;
        Sun, 10 Jul 2022 02:23:31 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf17.hostedemail.com (Postfix) with ESMTPA id DA4D11D;
        Sun, 10 Jul 2022 02:23:21 +0000 (UTC)
Message-ID: <1827050fdadb6173118fb396ad1fead23cda809f.camel@perches.com>
Subject: Re: [PATCH] staging: qlge: Fix indentation issue under long for loop
From:   Joe Perches <joe@perches.com>
To:     Binyi Han <dantengknight@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Sat, 09 Jul 2022 19:23:20 -0700
In-Reply-To: <20220710021629.GA11852@cloud-MacBookPro>
References: <20220710021629.GA11852@cloud-MacBookPro>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Stat-Signature: j5whdcny5gq31cufr8s8931z1g8b14hp
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: DA4D11D
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/1/dpiimQNhY7LZ/+ZAispFO3ewJM53Ds=
X-HE-Tag: 1657419801-289789
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-07-09 at 19:16 -0700, Binyi Han wrote:
> Fix indentation issue to adhere to Linux kernel coding style.
> Issue found by checkpatch.
> 
> Signed-off-by: Binyi Han <dantengknight@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
[]
> @@ -3009,8 +3009,8 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
>  
>  		for (page_entries = 0; page_entries <
>  			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)

Probably better to change the for loop to 3 lines as well.

		for (page_entries = 0;
		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
		     page_entries++)

> @@ -3024,8 +3024,8 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
>  
>  		for (page_entries = 0; page_entries <
>  			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> -				base_indirect_ptr[page_entries] =
> -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> +			base_indirect_ptr[page_entries] =
> +				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));

etc...

