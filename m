Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C73A1DF0E0
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbgEVVBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731000AbgEVVBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:01:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF87C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 14:01:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB19D12354FC4;
        Fri, 22 May 2020 14:01:02 -0700 (PDT)
Date:   Fri, 22 May 2020 14:01:02 -0700 (PDT)
Message-Id: <20200522.140102.1671996845235363045.davem@davemloft.net>
To:     roopa@cumulusnetworks.com
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH net-next v4 0/5] Support for fdb ECMP nexthop groups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590125177-39176-1-git-send-email-roopa@cumulusnetworks.com>
References: <1590125177-39176-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 14:01:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>
Date: Thu, 21 May 2020 22:26:12 -0700

> This series introduces ecmp nexthops and nexthop groups
> for mac fdb entries.
 ...

Series applied, thanks Roopa.
