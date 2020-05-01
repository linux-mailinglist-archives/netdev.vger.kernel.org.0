Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C091C0CA5
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgEADe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEADe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:34:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D96C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:34:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4398412773F42;
        Thu, 30 Apr 2020 20:34:58 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:34:57 -0700 (PDT)
Message-Id: <20200430.203457.763371687516403655.davem@davemloft.net>
To:     kda@linux-powerpc.org
Cc:     netdev@vger.kernel.org, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: Re: [PATCH v5 net-next 2/2] xen networking: add XDP offset
 adjustment to xen-netback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587999632-1206-2-git-send-email-kda@linux-powerpc.org>
References: <1587999632-1206-1-git-send-email-kda@linux-powerpc.org>
        <1587999632-1206-2-git-send-email-kda@linux-powerpc.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:34:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Mon, 27 Apr 2020 18:00:32 +0300

> the patch basically adds the offset adjustment and netfront
> state reading to make XDP work on netfront side.

Missing a Signed-off-by: tag for this patch, and the entire patch series needs
a proper header posting.
