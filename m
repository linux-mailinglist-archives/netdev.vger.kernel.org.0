Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D18B7D18C
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbfGaWw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:52:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45030 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfGaWw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:52:56 -0400
Received: from localhost (c-24-20-22-31.hsd1.or.comcast.net [24.20.22.31])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0BD7A1264D9B9;
        Wed, 31 Jul 2019 15:52:55 -0700 (PDT)
Date:   Wed, 31 Jul 2019 18:52:54 -0400 (EDT)
Message-Id: <20190731.185254.1694468178531691780.davem@davemloft.net>
To:     takondra@cisco.com
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, xe-linux-external@cisco.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] tipc: compat: allow tipc commands without arguments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729221507.48893-1-takondra@cisco.com>
References: <20190729221507.48893-1-takondra@cisco.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 15:52:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jon et al., please review.

Thank you.
