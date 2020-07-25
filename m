Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0282B22D34B
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgGYAbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgGYAbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:31:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554A0C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:31:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86E0E12763AE5;
        Fri, 24 Jul 2020 17:14:28 -0700 (PDT)
Date:   Fri, 24 Jul 2020 17:31:12 -0700 (PDT)
Message-Id: <20200724.173112.451428196025351292.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     stephen@networkplumber.org, amarao@servers.com,
        netdev@vger.kernel.org, jiri@resnulli.us
Subject: Re: [RFT iproute2] iplink_bridge: scale all time values by USER_HZ
From:   David Miller <davem@davemloft.net>
In-Reply-To: <F074B3B5-1B07-490F-87B8-887E2EFB32F3@cumulusnetworks.com>
References: <869fed82-bb31-589f-bd26-591ccfa976ed@servers.com>
        <20200724091517.7f5c2c9c@hermes.lan>
        <F074B3B5-1B07-490F-87B8-887E2EFB32F3@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 17:14:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: nikolay@cumulusnetworks.com
Date: Fri, 24 Jul 2020 19:24:35 +0300

> While I agree this should have been done from the start, it's too late to change. 

Agreed.
