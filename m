Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5712427B7DC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgI1XTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgI1XSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:18:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFEEC0610D4;
        Mon, 28 Sep 2020 16:00:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91D5A1274783A;
        Mon, 28 Sep 2020 15:44:11 -0700 (PDT)
Date:   Mon, 28 Sep 2020 16:00:58 -0700 (PDT)
Message-Id: <20200928.160058.501175525907482710.davem@davemloft.net>
To:     petko.manolov@konsulko.com
Cc:     gregKH@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RESEND v3 0/2] Use the new usb control message API.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200927124909.16380-1-petko.manolov@konsulko.com>
References: <20200923134348.23862-9-oneukum@suse.com>
        <20200927124909.16380-1-petko.manolov@konsulko.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 15:44:11 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petko.manolov@konsulko.com>
Date: Sun, 27 Sep 2020 15:49:07 +0300

> Re-sending these, now CC-ing the folks at linux-netdev.

I can't apply these since the helpers do not exist in the
networking tree.
