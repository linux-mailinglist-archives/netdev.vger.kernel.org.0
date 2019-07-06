Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C99C60FE9
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 12:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfGFKvD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 6 Jul 2019 06:51:03 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:49002 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfGFKvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 06:51:03 -0400
Received: from [192.168.0.113] (CMPC-089-239-107-172.CNet.Gawex.PL [89.239.107.172])
        by mail.holtmann.org (Postfix) with ESMTPSA id 526A4CEFAE;
        Sat,  6 Jul 2019 12:59:32 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH][next] 6lowpan: fix off-by-one comparison of index id with
 LOWPAN_IPHC_CTX_TABLE_SIZE
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190624144757.1285-1-colin.king@canonical.com>
Date:   Sat, 6 Jul 2019 12:51:00 +0200
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B6A1CB42-C239-42CA-B14E-483A02B930EB@holtmann.org>
References: <20190624144757.1285-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

> The WARN_ON_ONCE check on id is off-by-one, it should be greater or equal
> to LOWPAN_IPHC_CTX_TABLE_SIZE and not greater than. Fix this.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> net/6lowpan/debugfs.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/6lowpan/debugfs.c b/net/6lowpan/debugfs.c
> index 1c140af06d52..a510bed8165b 100644
> --- a/net/6lowpan/debugfs.c
> +++ b/net/6lowpan/debugfs.c
> @@ -170,7 +170,7 @@ static void lowpan_dev_debugfs_ctx_init(struct net_device *dev,
> 	struct dentry *root;
> 	char buf[32];
> 
> -	WARN_ON_ONCE(id > LOWPAN_IPHC_CTX_TABLE_SIZE);
> +	WARN_ON_ONCE(id >= LOWPAN_IPHC_CTX_TABLE_SIZE);

this patch no longer applied cleanly to bluetooth-next. Can you send me an updated version.

Regards

Marcel

