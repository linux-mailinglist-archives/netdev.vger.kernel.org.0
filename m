Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E29FA741
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKMD1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:27:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54184 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbfKMD1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:27:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDA19154FA010;
        Tue, 12 Nov 2019 19:27:37 -0800 (PST)
Date:   Tue, 12 Nov 2019 19:27:35 -0800 (PST)
Message-Id: <20191112.192735.432206863470625660.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, lcherian@marvell.com, sgoutham@marvell.com
Subject: Re: [PATCH 06/18] octeontx2-af: Add per CGX port level NIX Rx/Tx
 counters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573497494-11468-7-git-send-email-sunil.kovvuri@gmail.com>
References: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
        <1573497494-11468-7-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 19:27:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunil.kovvuri@gmail.com
Date: Tue, 12 Nov 2019 00:08:02 +0530

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> index 7d7133c..10cd5da 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
 ...
> +static inline int cgxlmac_to_pf(struct rvu *rvu, int cgx_id, int lmac_id)

I know it's already happening in this file, but do not use the inline keyword
in foo.c files please let the compiler decide.
