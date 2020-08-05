Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7D523CF26
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgHETP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgHETMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 15:12:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7555EC0611E2
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 12:11:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94A86152E87D5;
        Wed,  5 Aug 2020 11:54:25 -0700 (PDT)
Date:   Wed, 05 Aug 2020 12:11:10 -0700 (PDT)
Message-Id: <20200805.121110.1918790855908756881.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     gnault@redhat.com, netdev@vger.kernel.org, pmachata@gmail.com,
        roopa@cumulusnetworks.com, dsahern@kernel.org, akaris@redhat.com
Subject: Re: [PATCH net] Revert "vxlan: fix tos value before xmit"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200805101807.GN2531@dhcp-12-153.nay.redhat.com>
References: <20200805024131.2091206-1-liuhangbin@gmail.com>
        <20200805084427.GC11547@pc-2.home>
        <20200805101807.GN2531@dhcp-12-153.nay.redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Aug 2020 11:54:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Wed, 5 Aug 2020 18:18:07 +0800

> Should I re-post the patch with Fixes flag?

No, I took care the Fixes tag and queued this up for -stable.

But you do need to explain what kind of testing you even did on this
change we are reverting.  Did you make this change purely on
theoretical grounds and a code audit?

Because it is clear now that this commit broke things and did not fix
anything at all.

Please explain.
