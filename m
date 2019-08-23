Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048439A4EC
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 03:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732065AbfHWBdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 21:33:32 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:41522 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731600AbfHWBdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 21:33:32 -0400
Received: by mail-qt1-f170.google.com with SMTP id i4so9785779qtj.8
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 18:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0Q9zM+n+ewbX7TbrLlf1WG/tf6ulqFs08Kxmsy3fmcE=;
        b=sQBnHxmuw+4macmp6tWByThbN10Tm7Vy0gZ+KoQ9QxsMAMdEpO7PFVeFFQdQ3B0946
         7XO7rEgCv3EAtnE6qRNHXbxqqHoU0xM43mCdBJJDvvwr/HmVmUNQeSL5AZdTQMHmpwM6
         WorsLHR558P7XhOOzn+2KGTIcfeoh5MzY3DDBJOSZ4ffjxCx/1BKoBfi2K2J5Le3IfRA
         gXkXpabhnTEpBP4qZsm0rxNsoZI1V+1i+S1+t0m2e/r46ilbvK24YGVKreqz/Vc9BhBH
         83+xAUe7TwVyr1rceJcSK0lfW84T/QGvKmJ7LwPzAnpestCuJ0i25oalB0Of7E7lV8bK
         dqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0Q9zM+n+ewbX7TbrLlf1WG/tf6ulqFs08Kxmsy3fmcE=;
        b=AibhVwxnWQ1WnbWgKlZt9ByhKPTKeEHgekB+E7ANOBzIoTVB/BrH1kaH55H8SVd3f/
         y0klWX4Rij/wYtxKmFwhCgcBxusdXqFmGfBHoSusuWS9d68QLBayLSSDPfys+hRPrikF
         jsnQhFjoH4pFukVwhfudfZKLVwJVyJmuETqUfCtJ7JPDfgQkQQGDnYASFBDkzfU/8G8v
         /u2pGWvp4MrU2d/0vcSwsu+YSN8XeCNEmCSswMhEcRmuDFVmJBglN7OSuW+3GrE0+pDk
         dabNROxv7yX4sCWYTp1iVHl+ardF8RNa3tsHcjOaTSRhoqgZasxWxso+6PIN+K8EbcKe
         UxFg==
X-Gm-Message-State: APjAAAV8ODrxesO79v/wBxArgxibBefa8LXFXT6/zw5hHO4z4C+tFlUl
        2fSAWdED4vKFDvR5kCVjbHKiyjhOyzo=
X-Google-Smtp-Source: APXvYqwLRktQLzo0soBLWZszKVydZjyzTzha212vzqAmRyyRE8K4sYbwmVeOjogoxf9DvQpTYPVI+A==
X-Received: by 2002:ac8:7b99:: with SMTP id p25mr2629803qtu.243.1566524011303;
        Thu, 22 Aug 2019 18:33:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p38sm830900qtc.76.2019.08.22.18.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 18:33:31 -0700 (PDT)
Date:   Thu, 22 Aug 2019 18:33:24 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [net-next 4/8] net/mlx5e: Add device out of buffer counter
Message-ID: <20190822183324.79b74f7b@cakuba.netronome.com>
In-Reply-To: <20190822233514.31252-5-saeedm@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
        <20190822233514.31252-5-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 23:35:52 +0000, Saeed Mahameed wrote:
> From: Moshe Shemesh <moshe@mellanox.com>
> 
> Added the following packets drop counter:
> Device out of buffer - counts packets which were dropped due to full
> device internal receive queue.
> This counter will be shown on ethtool as a new counter called
> dev_out_of_buffer.
> The counter is read from FW by command QUERY_VNIC_ENV.
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Sounds like rx_fifo_errors, no? Doesn't rx_fifo_errors count RX
overruns?
