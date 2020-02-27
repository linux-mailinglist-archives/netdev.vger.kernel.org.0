Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE4A170FA7
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgB0E2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:28:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36992 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728359AbgB0E2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:28:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0996F15B47880;
        Wed, 26 Feb 2020 20:28:20 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:28:20 -0800 (PST)
Message-Id: <20200226.202820.545246435708068018.davem@davemloft.net>
To:     dianders@chromium.org
Cc:     stable@vger.kernel.org, wgong@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH v2] net: qrtr: fix len of skb_put_padto in
 qrtr_node_enqueue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAD=FV=WiceRwLUS1sdL_W=ELKYZ9zKE13e8vx9SO0+tRvX74QQ@mail.gmail.com>
References: <20200103045016.12459-1-wgong@codeaurora.org>
        <20200105.144704.221506192255563950.davem@davemloft.net>
        <CAD=FV=WiceRwLUS1sdL_W=ELKYZ9zKE13e8vx9SO0+tRvX74QQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:28:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>
Date: Tue, 25 Feb 2020 14:52:24 -0800

> I noticed this patch is in mainline now as:
> 
> ce57785bf91b net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
> 
> Though I'm not an expert on the code, it feels like a stable candidate
> unless someone objects.

Ok, queued up, thanks.
