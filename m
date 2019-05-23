Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE53B273A0
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbfEWA7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:59:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfEWA7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:59:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 659771504392A;
        Wed, 22 May 2019 17:59:04 -0700 (PDT)
Date:   Wed, 22 May 2019 17:59:04 -0700 (PDT)
Message-Id: <20190522.175904.1465319150809891757.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv6: Fix redirect with VRF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522221218.9839-1-dsahern@kernel.org>
References: <20190522221218.9839-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:59:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 22 May 2019 15:12:18 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> IPv6 redirect is broken for VRF. __ip6_route_redirect walks the FIB
> entries looking for an exact match on ifindex. With VRF the flowi6_oif
> is updated by l3mdev_update_flow to the l3mdev index and the
> FLOWI_FLAG_SKIP_NH_OIF set in the flags to tell the lookup to skip the
> device match. For redirects the device match is requires so use that
> flag to know when the oif needs to be reset to the skb device index.
> 
> Fixes: ca254490c8df ("net: Add VRF support to IPv6 stack")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable.
