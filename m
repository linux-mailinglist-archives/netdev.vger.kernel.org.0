Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B6D1C9FEA
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEHBFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbgEHBFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:05:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4AEC05BD43;
        Thu,  7 May 2020 18:05:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5601B119376CB;
        Thu,  7 May 2020 18:05:34 -0700 (PDT)
Date:   Thu, 07 May 2020 18:05:33 -0700 (PDT)
Message-Id: <20200507.180533.1047191517962735284.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next] net/smc: remove set but not used variables
 'del_llc, del_llc_resp'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507142406.14638-1-kgraul@linux.ibm.com>
References: <20200507142406.14638-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 18:05:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Thu,  7 May 2020 16:24:06 +0200

> From: YueHaibing <yuehaibing@huawei.com>
> 
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> net/smc/smc_llc.c: In function 'smc_llc_cli_conf_link':
> net/smc/smc_llc.c:753:31: warning:
>  variable 'del_llc' set but not used [-Wunused-but-set-variable]
>   struct smc_llc_msg_del_link *del_llc;
>                                ^
> net/smc/smc_llc.c: In function 'smc_llc_process_srv_delete_link':
> net/smc/smc_llc.c:1311:33: warning:
>  variable 'del_llc_resp' set but not used [-Wunused-but-set-variable]
>     struct smc_llc_msg_del_link *del_llc_resp;
>                                  ^
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

Applied, thanks.
