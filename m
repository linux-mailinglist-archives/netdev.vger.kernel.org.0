Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E21228C9C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgGUXR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUXR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:17:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62349C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 16:17:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DE8AF11E45904;
        Tue, 21 Jul 2020 16:00:43 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:17:28 -0700 (PDT)
Message-Id: <20200721.161728.1020067920131361017.davem@davemloft.net>
To:     sundeep.lkml@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, sgoutham@marvell.com,
        sbhatta@marvell.com
Subject: Re: [PATCH net 0/3] Fix bugs in Octeontx2 netdev driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595351648-10794-1-git-send-email-sundeep.lkml@gmail.com>
References: <1595351648-10794-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 16:00:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sundeep.lkml@gmail.com
Date: Tue, 21 Jul 2020 22:44:05 +0530

> Subbaraya Sundeep (3):
>   octeontx2-pf: Fix reset_task bugs
>   octeontx2-pf: cancel reset_task work
>   octeontx2-pf: Unregister netdev at driver remove

I think you should shut down all the interrupts and other state
before unregistering the vf network device.
