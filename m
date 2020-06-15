Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB941FA1A6
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731630AbgFOUcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgFOUcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:32:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3594EC061A0E;
        Mon, 15 Jun 2020 13:32:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5FA7120ED49A;
        Mon, 15 Jun 2020 13:32:23 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:32:23 -0700 (PDT)
Message-Id: <20200615.133223.729356034153957124.davem@davemloft.net>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, wu000273@umn.edu, jiri@mellanox.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] test_objagg: Fix potential memory leak in error
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200612200154.55243-1-pakki001@umn.edu>
References: <20200612200154.55243-1-pakki001@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:32:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>
Date: Fri, 12 Jun 2020 15:01:54 -0500

> In case of failure of check_expect_hints_stats(), the resources
> allocated by objagg_hints_get should be freed. The patch fixes
> this issue.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Applied.
