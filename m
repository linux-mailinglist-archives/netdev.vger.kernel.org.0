Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622ED2BBA3B
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgKTXf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727364AbgKTXf0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 18:35:26 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E6602240B;
        Fri, 20 Nov 2020 23:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605915326;
        bh=TTt3MEq8QRajzP9EXiGwrllhFHFxADyDYhdvJNbhXQg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=05Vlwg+sSzHzs3HYjAUY7lLSm6oPSYIP3wVa2PQsJpWb2SmzmoMPWGjK3hfzgaarj
         IMMZBujGotVROV5LUBsQdRZfJgo+6hSjVgajMdWYSu4RvAmN70fWW/Y5wNrXoYBj+u
         UDl6MQiPYSb449+7yeDfbPBB7/iWT8BwfdgSIDSI=
Date:   Fri, 20 Nov 2020 15:35:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next 00/10] mptcp: More miscellaneous MPTCP fixes
Message-ID: <20201120153525.093a38bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 11:45:53 -0800 Mat Martineau wrote:
> Here's another batch of fixup and enhancement patches that we have
> collected in the MPTCP tree.
> 
> Patch 1 removes an unnecessary flag and related code.
> 
> Patch 2 fixes a bug encountered when closing fallback sockets.
> 
> Patches 3 and 4 choose a better transmit subflow, with a self test.
> 
> Patch 5 adjusts tracking of unaccepted subflows
> 
> Patches 6-8 improve handling of long ADD_ADDR options, with a test.
> 
> Patch 9 more reliably tracks the MPTCP-level window shared with peers.
> 
> Patch 10 sends MPTCP-level acknowledgements more aggressively, so the
> peer can send more data without extra delay.

Applied, thanks!
