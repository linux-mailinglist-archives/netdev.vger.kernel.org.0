Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C94F3F60E6
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbhHXOrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237755AbhHXOrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 10:47:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5383061214;
        Tue, 24 Aug 2021 14:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629816418;
        bh=Y2VvGS4ewH0QFV6jn39fYPmqIbAtnr1Y+vm2V40pcbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Df8kuWrSWWNcLUXAcC0rexKKK2wVu7j9FZnPDxVf3Fhhti5KIsPTGoxxVc9OrpnKn
         PoYnGctC6V0MyPhVbQ3RA9a2u5tLdAwuBLRtqABOUbjbSZtGpEscGAwba+1yJ/faAc
         CBDEyRLWnnYl+o6+pmKXZMdcRXq43s36S14dMjdPS9zhUBWHpzLZ4QtN3hVhpUFNGh
         cf/KnVaz0pXNqjls71nDDHmVXdnRzqQIFOwSjYuSgr/WJRIIryCSNllTe2mqM+Df7Y
         JXuTU1gLB4mCpWB1cLt56xmLT/sf19tXQkDw3nRaCAse4S0wa2c/bUEvy9stYII5b/
         u2vq0kcFE/pfw==
Date:   Tue, 24 Aug 2021 07:46:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     CGEL <cgel.zte@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] tools:test_xdp_noinline: fix
 boolreturn.cocci warnings
Message-ID: <20210824074657.363455a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2d701f13-8996-ed7d-3d41-794aa8a6e96c@linuxfoundation.org>
References: <20210824065526.60416-1-deng.changcheng@zte.com.cn>
        <2d701f13-8996-ed7d-3d41-794aa8a6e96c@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 08:42:15 -0600 Shuah Khan wrote:
> On 8/24/21 12:55 AM, CGEL wrote:
> > From: Jing Yangyang <jing.yangyang@zte.com.cn>
> > 
> > Return statements in functions returning bool should use true/false
> > instead of 1/0.
> > 
> > Reported-by: Zeal Robot <zealci@zte.com.cn>
> > Signed-off-by: Jing Yangyang <jing.yangyang@zte.com.cn>
> 
> We can't accept this patch. The from and Signed-off-by don't match.

That's what I thought but there is a From in the email body which git
will pick up. The submission is correct.

Please trim your responses.
