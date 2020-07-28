Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9628231671
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbgG1Xv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 19:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbgG1Xv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 19:51:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAECC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 16:51:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DD40128C9A5E;
        Tue, 28 Jul 2020 16:35:12 -0700 (PDT)
Date:   Tue, 28 Jul 2020 16:51:54 -0700 (PDT)
Message-Id: <20200728.165154.545392312452463645.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org
Subject: Re: How to make a change in both net and net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3476832.1595978507@warthog.procyon.org.uk>
References: <3476832.1595978507@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 16:35:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Wed, 29 Jul 2020 00:21:47 +0100

> Should I just rebase the net-next patches on top of the one I sent you once
> you've picked it into net, or is there a better way?

Post the patch for 'net', wait for 'net' to merge into 'net-next' (usually
once a week or so), and then submit the 'net-next' things.
