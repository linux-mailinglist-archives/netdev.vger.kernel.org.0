Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8007D1AD
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 01:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbfGaXIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 19:08:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45270 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaXIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 19:08:49 -0400
Received: from localhost (c-24-20-22-31.hsd1.or.comcast.net [24.20.22.31])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF76312659654;
        Wed, 31 Jul 2019 16:08:48 -0700 (PDT)
Date:   Wed, 31 Jul 2019 19:08:48 -0400 (EDT)
Message-Id: <20190731.190848.748082229948688274.davem@davemloft.net>
To:     kda@linux-powerpc.org
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, netdev@vger.kernel.org,
        kdav@linux-powerpc.org
Subject: Re: [PATCH net-next] be2net: disable bh with spin_lock in
 be_process_mcc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730113226.39845-1-dkirjanov@suse.com>
References: <20190730113226.39845-1-dkirjanov@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 16:08:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Tue, 30 Jul 2019 13:32:26 +0200

> Signed-off-by: Denis Kirjanov <kdav@linux-powerpc.org>

Empty commit message, no way.

You must explain what this patch is doing, and why.
