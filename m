Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6326523B038
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHCWeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHCWeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:34:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66F7C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 15:34:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB20512775CEF;
        Mon,  3 Aug 2020 15:17:36 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:34:21 -0700 (PDT)
Message-Id: <20200803.153421.1214139307689007135.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: fix extracting IP addresses in
 TC-FLOWER rules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596228820-25570-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1596228820-25570-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:17:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Sat,  1 Aug 2020 02:23:40 +0530

> commit c8729cac2a11 ("cxgb4: add ethtool n-tuple filter insertion")
> has removed checking control key for determining IP address types
> for TC-FLOWER rules, which causes all the rules being inserted to
> hardware to become IPv6 rule type always. So, add back the check
> to select the correct IP address type to extract and hence fix the
> correct rule type being inserted to hardware.
> 
> Also, ethtool_rx_flow_key doesn't have any control key and instead
> directly sets the IPv4/IPv6 address keys. So, explicitly set the
> IP address type for ethtool n-tuple filters to reuse the same code.
> 
> Fixes: c8729cac2a11 ("cxgb4: add ethtool n-tuple filter insertion")
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied.
