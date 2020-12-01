Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B09B2CAA91
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404205AbgLASOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388650AbgLASOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 13:14:07 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6FCC0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 10:13:27 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 852E84CBC9037;
        Tue,  1 Dec 2020 10:12:45 -0800 (PST)
Date:   Tue, 01 Dec 2020 10:12:40 -0800 (PST)
Message-Id: <20201201.101240.2064813650347834623.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     kuba@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, cforno12@linux.ibm.com,
        ljp@linux.vnet.ibm.com, ricklind@linux.ibm.com,
        dnbanerg@us.ibm.com, drt@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com
Subject: Re: [PATCH net v3 0/2] ibmvnic: Bug fixes for queue descriptor
 processing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1606837931-22676-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1606837931-22676-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 01 Dec 2020 10:12:46 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Tue,  1 Dec 2020 09:52:09 -0600

> This series resolves a few issues in the ibmvnic driver's
> RX buffer and TX completion processing. The first patch
> includes memory barriers to synchronize queue descriptor
> reads. The second patch fixes a memory leak that could
> occur if the device returns a TX completion with an error
> code in the descriptor, in which case the respective socket
> buffer and other relevant data structures may not be freed
> or updated properly.
> 
> v3: Correct length of Fixes tags, requested by Jakub Kicinski
> 
> v2: Provide more detailed comments explaining specifically what
>     reads are being ordered, suggested by Michael Ellerman

Series applied, thanks!
