Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D5B24E966
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 21:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgHVTgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 15:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgHVTgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 15:36:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383DEC061574;
        Sat, 22 Aug 2020 12:36:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60D3215CED94F;
        Sat, 22 Aug 2020 12:20:05 -0700 (PDT)
Date:   Sat, 22 Aug 2020 12:36:50 -0700 (PDT)
Message-Id: <20200822.123650.1479943925913245500.davem@davemloft.net>
To:     kalou@tfz.net
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, akpm@linux-foundation.org,
        adobriyan@gmail.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2 2/2] net: socket: implement SO_DESCRIPTION
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200822032827.6386-2-kalou@tfz.net>
References: <20200815182344.7469-1-kalou@tfz.net>
        <20200822032827.6386-1-kalou@tfz.net>
        <20200822032827.6386-2-kalou@tfz.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Aug 2020 12:20:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pascal Bouchareine <kalou@tfz.net>
Date: Fri, 21 Aug 2020 20:28:27 -0700

> This command attaches the zero terminated string in optval to the
> socket for troubleshooting purposes. The free string is displayed in the
> process fdinfo file for that fd (/proc/<pid>/fdinfo/<fd>).
> 
> One intended usage is to allow processes to self-document sockets
> for netstat and friends to report
> 
> We ignore optlen and constrain the string to a static max size
> 
> Signed-off-by: Pascal Bouchareine <kalou@tfz.net>

This change is really a non-starter unless the information gets
published somewhere where people actually look at dumped sockets, and
that's inet_diag and friends.
