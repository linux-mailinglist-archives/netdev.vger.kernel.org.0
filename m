Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EBD2B6A52
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgKQQcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:32:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727147AbgKQQci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 11:32:38 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29999216C4;
        Tue, 17 Nov 2020 16:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605630758;
        bh=Kd5lKkKZnjFFB6cI6IhBjr0eoAAp1v+O7BK2W7Ibq34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GeEphgA3TR0UF5thw9zB2t4V4mT1X/j6kexkFWEekaUy0wgtxSlRc+WjysBtk7d5T
         vjLx0K/Xci72HM9cYAquXXaI6uAn+l6TdGulIrY7h92myfL7iuWyhULewnD4cuzV0C
         6Cx9OETFg7xGmlYe9W2PdgHdHCQldlBg0onz1N6o=
Date:   Tue, 17 Nov 2020 10:32:35 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] mwifiex: Fix fall-through warnings for Clang
Message-ID: <20201117163235.GA23802@embeddedor>
References: <20201117160958.GA18807@embeddedor>
 <b9989e7d048765111826d1df549a364485ea546f.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9989e7d048765111826d1df549a364485ea546f.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 08:15:59AM -0800, Joe Perches wrote:
> On Tue, 2020-11-17 at 10:09 -0600, Gustavo A. R. Silva wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> > warnings by explicitly adding multiple break statements instead of
> > letting the code fall through to the next case.
> 
> Thanks Gustavo.
> 
> I think this is better style than the gcc allowed
> undescribed fallthrough to break;
> 
> gcc developers disagree though:
> 
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91432

Yeah; I mention that in this[1] changelog text, together with the
reasons why we think the Clang approach is safer. which is exactly
the same information contained in the link[2] included in the changelog
text for this commit.

--
Gustavo

[1] https://git.kernel.org/linus/4169e889e5889405d54cec27d6e9f7f0ce3c7096
[2] https://github.com/KSPP/linux/issues/115
