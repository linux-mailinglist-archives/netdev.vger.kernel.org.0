Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4150118676C
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgCPJHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:07:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41322 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730314AbgCPJHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 05:07:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 260F9145CAE86;
        Mon, 16 Mar 2020 02:07:10 -0700 (PDT)
Date:   Mon, 16 Mar 2020 02:07:09 -0700 (PDT)
Message-Id: <20200316.020709.946201122435780659.davem@davemloft.net>
To:     xiaofeis@codeaurora.org
Cc:     vkoul@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org
Subject: Re: [PATCH] net: dsa: input correct header length for
 skb_cow_head()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584320645-25041-1-git-send-email-xiaofeis@codeaurora.org>
References: <1584320645-25041-1-git-send-email-xiaofeis@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 02:07:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiaofeis <xiaofeis@codeaurora.org>
Date: Mon, 16 Mar 2020 09:04:05 +0800

> We need to ensure there is enough headroom to push QCA header,
> so input the QCA header length instead of 0.
> 
> Signed-off-by: xiaofeis <xiaofeis@codeaurora.org>

This was already fixed by:

commit 04fb91243a853dbde216d829c79d9632e52aa8d9
Author: Per Forlin <per.forlin@axis.com>
Date:   Thu Feb 13 15:37:09 2020 +0100

    net: dsa: tag_qca: Make sure there is headroom for tag
