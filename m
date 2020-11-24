Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D0C2C2B24
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389647AbgKXPWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:37182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728426AbgKXPWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:22:34 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6C97206D8;
        Tue, 24 Nov 2020 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606231353;
        bh=2hbCCL7O02WI45ZdHMPX8DD3dn6U9eXNVBGwpDSoMjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pMaSbZ09M4pk5nFkB8zya1HHv4yBAjOA4PKOvGnXE89HldAlIqazbiGeyib2LJYww
         npa+yzLi2XxikSMYXQETBxz7bP24c3uXAzV8uv6ejMRoNda6E1Juy6w+lgTGGe/t3U
         0YaIXXb/dy0IdToL5scjhcMpO6QZIryZ4ed4v8f8=
Date:   Tue, 24 Nov 2020 09:22:48 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] mwifiex: Fix fall-through warnings for Clang
Message-ID: <20201124152248.GA17735@embeddedor>
References: <20201117160958.GA18807@embeddedor>
 <20201124150614.68C3EC43461@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124150614.68C3EC43461@smtp.codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 03:06:14PM +0000, Kalle Valo wrote:
> "Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:
> 
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> > warnings by explicitly adding multiple break statements instead of
> > letting the code fall through to the next case.
> > 
> > Link: https://github.com/KSPP/linux/issues/115
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Patch applied to wireless-drivers-next.git, thanks.
> 
> 003317581372 mwifiex: Fix fall-through warnings for Clang

Thank you, Kalle.
--
Gustavo
