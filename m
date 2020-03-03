Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA92178669
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 00:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgCCXfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 18:35:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728317AbgCCXfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 18:35:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4AE3215A9FC20;
        Tue,  3 Mar 2020 15:35:47 -0800 (PST)
Date:   Tue, 03 Mar 2020 15:35:46 -0800 (PST)
Message-Id: <20200303.153546.1011655145785464830.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     kuba@kernel.org, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] doc: sfp-phylink: correct code indentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1j97cE-0004aW-Ur@rmk-PC.armlinux.org.uk>
References: <E1j97cE-0004aW-Ur@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 15:35:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 03 Mar 2020 13:29:42 +0000

> Using vim to edit the phylink documentation reveals some mistakes due
> to the "invisible" pythonesque white space indentation that can't be
> seen with other editors. Fix it.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

I applied this, but you do know that GIT is going to warn about the
trailing whitespace to me:

.git/rebase-apply/patch:29: trailing whitespace.
	
.git/rebase-apply/patch:39: trailing whitespace.
	
warning: 2 lines add whitespace errors.

Do the empty lines really need that leading TAB?
