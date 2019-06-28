Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31FC25A601
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfF1Uop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbfF1Uop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 16:44:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 380072086D;
        Fri, 28 Jun 2019 20:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561754684;
        bh=WqWPRLbm+w+FmvcvBoBr9T6wM7WHOY2yBQNJ2QF3IlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DZXbS8QQkDm2VylZ/qksl+W6pv1UlX6aRcD3gdVHekEreBY8WGzw5+2CLUUTPOdpq
         D9MJt3+7ABjDa4PGXsw/NUhXUswBrsjDhaY017h+SFEo3Pya4fJHaPFgHSOFDWPKIw
         Jy4OCkHx6HWhhkpEZgERuIEmePbQccuV60TKzr0A=
Date:   Fri, 28 Jun 2019 16:44:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-efi@vger.kernel.org,
        Rob Bradford <robert.bradford@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com, netdev@vger.kernel.org
Subject: Re: [4.19.y PATCH 0/3] Backported fixes for 4.19 stable tree
Message-ID: <20190628204442.GI11506@sasha-vm>
References: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 11:41:54AM -0700, Srivatsa S. Bhat wrote:
>Hi Greg,
>
>This patchset includes a few backported fixes for the 4.19 stable tree.
>I would appreciate if you could kindly consider including them in the
>next release.

+ netdev@

David Miller deals with the 4.19 net/ patches, so this will need to go
through (or acked by) him.

--
Thanks,
Sasha
