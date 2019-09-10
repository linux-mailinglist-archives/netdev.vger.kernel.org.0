Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E5BAE486
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 09:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfIJHRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 03:17:04 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54594 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfIJHRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 03:17:04 -0400
Received: from [88.214.186.143] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1i7aOW-00041e-Rg; Tue, 10 Sep 2019 03:16:59 -0400
Date:   Tue, 10 Sep 2019 03:16:49 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     vyasevich@gmail.com, marcelo.leitner@gmail.com,
        davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net 0/2] fix memory leak for sctp_do_bind
Message-ID: <20190910071649.GB31884@localhost.localdomain>
References: <20190910071343.18808-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910071343.18808-1-maowenan@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 03:13:41PM +0800, Mao Wenan wrote:
> First patch is to do cleanup, remove redundant assignment,
> second patch is to fix memory leak for sctp_do_bind if failed
> to bind address.
> 
> Mao Wenan (2):
>   sctp: remove redundant assignment when call sctp_get_port_local
>   sctp: destroy bucket if failed to bind addr
> 
>  net/sctp/socket.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> -- 
> 2.20.1
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>

