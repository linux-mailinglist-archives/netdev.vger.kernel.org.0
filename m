Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20FD1F5CFF
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 22:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgFJUUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 16:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgFJUUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 16:20:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47920C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 13:20:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02655119289C8;
        Wed, 10 Jun 2020 13:20:38 -0700 (PDT)
Date:   Wed, 10 Jun 2020 13:20:38 -0700 (PDT)
Message-Id: <20200610.132038.2265113079002934200.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, roopa@cumulusnetworks.com
Subject: Re: [PATCH net] vxlan: Remove access to nexthop group struct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200609232728.26621-1-dsahern@kernel.org>
References: <20200609232728.26621-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jun 2020 13:20:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue,  9 Jun 2020 17:27:28 -0600

> vxlan driver should be using helpers to access nexthop struct
> internals. Remove open check if whether nexthop is multipath in
> favor of the existing nexthop_is_multipath helper. Add a new
> helper, nexthop_has_v4, to cover the need to check has_v4 in
> a group.
> 
> Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>

Also applied, thanks David.
