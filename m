Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD055ACAD
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 19:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfF2RTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 13:19:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfF2RTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 13:19:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12EA414A8CC66;
        Sat, 29 Jun 2019 10:19:37 -0700 (PDT)
Date:   Sat, 29 Jun 2019 10:19:34 -0700 (PDT)
Message-Id: <20190629.101934.129593453807760399.davem@davemloft.net>
To:     csully@google.com
Cc:     netdev@vger.kernel.org, sagis@google.com, jonolson@google.com,
        willemb@google.com, lrizzo@google.com
Subject: Re: [PATCH net-next v3 4/4] gve: Add ethtool support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628230733.54169-5-csully@google.com>
References: <20190628230733.54169-1-csully@google.com>
        <20190628230733.54169-5-csully@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 10:19:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>
Date: Fri, 28 Jun 2019 16:07:33 -0700

> +void gve_get_channels(struct net_device *netdev, struct ethtool_channels *cmd)
 ...
> +int gve_set_channels(struct net_device *netdev, struct ethtool_channels *cmd)
 ...
> +void gve_get_ringparam(struct net_device *netdev,
> +		       struct ethtool_ringparam *cmd)
 ...
> +int gve_user_reset(struct net_device *netdev, u32 *flags)
 ...

Please mark these static as per the kbuild robot feedback.

Thank you.
