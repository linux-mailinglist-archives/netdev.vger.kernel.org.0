Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A4BE428D
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 06:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388787AbfJYEhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 00:37:36 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:48255 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388369AbfJYEhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 00:37:36 -0400
Received: from PC192.168.2.106 (p4FE7198A.dip0.t-ipconnect.de [79.231.25.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id CE58CC1BBA;
        Fri, 25 Oct 2019 06:37:33 +0200 (CEST)
Subject: Re: [PATCH net-next] ieee802154: remove set but not used variable
 'status'
To:     YueHaibing <yuehaibing@huawei.com>, varkabhadram@gmail.com,
        alex.aring@gmail.com, davem@davemloft.net
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191023070618.30044-1-yuehaibing@huawei.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <aadfdcc0-06df-5c17-dc14-11d54ac8b65f@datenfreihafen.org>
Date:   Fri, 25 Oct 2019 06:37:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191023070618.30044-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 23.10.19 09:06, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ieee802154/cc2520.c:221:5: warning:
>   variable status set but not used [-Wunused-but-set-variable]
> 
> It is never used, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/net/ieee802154/cc2520.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
> index 4350694..89c046b 100644
> --- a/drivers/net/ieee802154/cc2520.c
> +++ b/drivers/net/ieee802154/cc2520.c
> @@ -218,7 +218,6 @@ static int
>   cc2520_cmd_strobe(struct cc2520_private *priv, u8 cmd)
>   {
>   	int ret;
> -	u8 status = 0xff;
>   	struct spi_message msg;
>   	struct spi_transfer xfer = {
>   		.len = 0,
> @@ -236,8 +235,6 @@ cc2520_cmd_strobe(struct cc2520_private *priv, u8 cmd)
>   		 priv->buf[0]);
>   
>   	ret = spi_sync(priv->spi, &msg);
> -	if (!ret)
> -		status = priv->buf[0];
>   	dev_vdbg(&priv->spi->dev,
>   		 "buf[0] = %02x\n", priv->buf[0]);
>   	mutex_unlock(&priv->buffer_mutex);
> 

Applied to wpan-next. Thanks!

regards
Stefan Schmidt
