Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA5F1C210E
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 01:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgEAW76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726045AbgEAW75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:59:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2054C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:59:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 41A9D1500CC2D;
        Fri,  1 May 2020 15:59:57 -0700 (PDT)
Date:   Fri, 01 May 2020 15:59:56 -0700 (PDT)
Message-Id: <20200501.155956.993581768857393476.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] ethtool: Add support for 100Gbps per lane
 link modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430234106.52732-1-saeedm@mellanox.com>
References: <20200430234106.52732-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:59:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 30 Apr 2020 16:41:04 -0700

> This small series adds new ethtool link modes bits to 
> Define 100G, 200G and 400G link modes using 100Gbps per lane.

Andrew, could you please give this series a quick review?

Thank you.
