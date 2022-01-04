Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A069E484201
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiADNBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:01:07 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:41379 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229910AbiADNBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:01:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V0y0J-x_1641301264;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V0y0J-x_1641301264)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 04 Jan 2022 21:01:05 +0800
Date:   Tue, 4 Jan 2022 21:01:03 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: Reduce overflow of smc clcsock listen
 queue
Message-ID: <YdRFD8bY897LbUxr@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1641293930-110897-1-git-send-email-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641293930-110897-1-git-send-email-alibuda@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 06:58:50PM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> In nginx/wrk multithread and 10K connections benchmark, the
> backend TCP connection established very slowly, and lots of TCP
> connections stay in SYN_SENT state.

<snip>

> +struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work*/
												missing a space here ^
>  struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
>  struct workqueue_struct	*smc_close_wq;	/* wq for close work */

<snip>

>  	return (struct smc_sock *)sk;
>  }
>  
> +extern struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work*/
												        missing a space here ^

There are missing two spaces in comments. Besides that, this patch looks
good to me, thanks.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

Thanks.
Tony Lu
