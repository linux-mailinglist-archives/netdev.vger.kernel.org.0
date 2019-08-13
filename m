Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A3A8C4CA
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 01:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfHMX2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 19:28:06 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:45156 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfHMX2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 19:28:06 -0400
Received: from localhost.localdomain (unknown [5.148.42.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 77AC9CB70F;
        Wed, 14 Aug 2019 01:28:03 +0200 (CEST)
Subject: Re: [PATCH] net: ieee802154: remove redundant assignment to rc
To:     Colin King <colin.king@canonical.com>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190813142818.15022-1-colin.king@canonical.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <a3262e25-209d-209d-59fc-a09511fb9280@datenfreihafen.org>
Date:   Wed, 14 Aug 2019 01:28:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190813142818.15022-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 13.08.19 16:28, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable rc is initialized to a value that is never read and it is
> re-assigned later. The initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/ieee802154/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> index dacbd58e1799..badc5cfe4dc6 100644
> --- a/net/ieee802154/socket.c
> +++ b/net/ieee802154/socket.c
> @@ -1092,7 +1092,7 @@ static struct packet_type ieee802154_packet_type = {
>  
>  static int __init af_ieee802154_init(void)
>  {
> -	int rc = -EINVAL;
> +	int rc;
>  
>  	rc = proto_register(&ieee802154_raw_prot, 1);
>  	if (rc)
> 


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
