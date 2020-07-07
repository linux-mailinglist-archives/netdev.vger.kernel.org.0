Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E99C217898
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgGGUKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 16:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgGGUKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 16:10:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B67BC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 13:10:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F0C2120F93E0;
        Tue,  7 Jul 2020 13:10:01 -0700 (PDT)
Date:   Tue, 07 Jul 2020 13:10:00 -0700 (PDT)
Message-Id: <20200707.131000.1298441361306017391.davem@davemloft.net>
To:     ssundark@amd.com
Cc:     andrew@lunn.ch, Shyam-sundar.S-k@amd.com, thomas.lendacky@amd.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] amd-xgbe: add module param for auto negotiation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a9e5c55f-55cf-439e-30aa-6cf70e44dffd@amd.com>
References: <20200707173254.1564625-1-Shyam-sundar.S-k@amd.com>
        <20200707175541.GB938746@lunn.ch>
        <a9e5c55f-55cf-439e-30aa-6cf70e44dffd@amd.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 13:10:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shyam Sundar S K <ssundark@amd.com>
Date: Wed, 8 Jul 2020 00:31:25 +0530

> Agree to your feedback. Most of the information required to control
> the connection is already present in the
> 
> driver and this piece of information is missing. Customers who run a
> minimal Linux do not have the flexibility

This is not a valid argument.  We have specific APIs for configuring
the link, do not add new ways of doing so.

Thank you.
