Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E91B3AD5C
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbfFJCzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:55:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48918 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfFJCzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:55:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 11CE214EAD05A;
        Sun,  9 Jun 2019 19:55:01 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:55:00 -0700 (PDT)
Message-Id: <20190609.195500.2162257859838379859.davem@davemloft.net>
To:     hariprasad.kelam@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: nci: fix warning comparison to bool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190608084154.GA7520@hari-Inspiron-1545>
References: <20190608084154.GA7520@hari-Inspiron-1545>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:55:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Date: Sat, 8 Jun 2019 14:11:54 +0530

> Fix below warning reported by coccicheck
> 
> net/nfc/nci/ntf.c:367:5-15: WARNING: Comparison to bool
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> ---
>  net/nfc/nci/ntf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
> index 1e8c1a1..81e8570 100644
> --- a/net/nfc/nci/ntf.c
> +++ b/net/nfc/nci/ntf.c
> @@ -364,7 +364,7 @@ static void nci_rf_discover_ntf_packet(struct nci_dev *ndev,
>  	ntf.ntf_type = *data++;
>  	pr_debug("ntf_type %d\n", ntf.ntf_type);
>  
> -	if (add_target == true)
> +	if (add_target)

add_target is a bool, these kinds of changes are not good.
