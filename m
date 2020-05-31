Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6487A1E95BE
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgEaE7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaE7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:59:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDDBC05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:59:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36067129033F1;
        Sat, 30 May 2020 21:58:59 -0700 (PDT)
Date:   Sat, 30 May 2020 21:58:58 -0700 (PDT)
Message-Id: <20200530.215858.2059483692603625208.davem@davemloft.net>
To:     roopa@cumulusnetworks.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH net-next v2 0/3] vxlan fdb nexthop misc fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590900521-14647-1-git-send-email-roopa@cumulusnetworks.com>
References: <1590900521-14647-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 21:59:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>
Date: Sat, 30 May 2020 21:48:38 -0700

> Roopa Prabhu (3):
>   vxlan: add check to prevent use of remote ip attributes with NDA_NH_ID
>   vxlan: few locking fixes in nexthop event handler
>   vxlan: fix dereference of nexthop group in nexthop update path

Mid-air collision :-)  I applied v1, could you please send something
relative to that?

Thank you.
