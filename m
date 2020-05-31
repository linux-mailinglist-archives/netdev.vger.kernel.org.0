Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E721E95AF
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgEaErz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgEaEry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:47:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F3EC05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:47:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D915E128FCC84;
        Sat, 30 May 2020 21:47:53 -0700 (PDT)
Date:   Sat, 30 May 2020 21:47:52 -0700 (PDT)
Message-Id: <20200530.214752.46958625785678808.davem@davemloft.net>
To:     roopa@cumulusnetworks.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH net-next 0/2] vxlan fdb nexthop misc fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590729156-35543-1-git-send-email-roopa@cumulusnetworks.com>
References: <1590729156-35543-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 21:47:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>
Date: Thu, 28 May 2020 22:12:34 -0700

> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> Roopa Prabhu (2):
>   vxlan: add check to prevent use of remote ip attributes with NDA_NH_ID
>   vxlan: few locking fixes in nexthop event handler

Series applied, thanks.
