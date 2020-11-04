Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E9C2A72D5
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 00:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbgKDXtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 18:49:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733093AbgKDXpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 18:45:10 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A85C22228;
        Wed,  4 Nov 2020 23:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604533509;
        bh=JRldIlDVs8fymV35Y0M6EzeYpvpac/0xyZgCdJrQBcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UsVlcULfF26de5VAgTL9BUEsHHCvZFOVFERmyjcemD/IqknBOIGhRkDCTe4RLAEUk
         S9tfyQIoUVYFxNlDEuQ/wE0CwtsHyjBMIDbVxQD3l2CjlhG9mNknVh2MgkViFIOfJj
         9dQBvVF/Pph0DbbulHVL5SdIx1eElTFT40ngNQ3w=
Date:   Wed, 4 Nov 2020 15:45:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 1/3] ptp: idt82p33: add adjphase support
Message-ID: <20201104154508.557cc29b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604531626-17644-1-git-send-email-min.li.xe@renesas.com>
References: <1604531626-17644-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 18:13:44 -0500 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Add idt82p33_adjphase() to support PHC write phase mode.
> 
> Changes since v1:
> -Fix broken build

One more trivial thing detected by checkpatch:

ERROR: trailing whitespace
#41: FILE: drivers/ptp/ptp_idt82p33.c:138:
+^Ioffset = _OFFSET(regaddr);^I$

Please add Richard's Acked-by tags to the commit messages.

Also are you sure the last patch is okay? Richard suggested it's not
worth the risk AFAIU.
