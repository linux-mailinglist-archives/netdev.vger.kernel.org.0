Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42BA5F5D0
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 13:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfD3Lhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 07:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfD3Lhf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 07:37:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA6721670;
        Tue, 30 Apr 2019 11:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624254;
        bh=Ii9PZoRqsByTkF1EgWtX5Dtq4tu0TXAkzlU0xPyCnhg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b5ZWbpbzZ/YRliycGtCGRtZiPW347PPc9dfCHModX2zV93lZIyH7pNJlF5Qd9O9iK
         MmmZZkL6E+3WB1Df3QcgnJxfQvKREj5U6C2KlB+ff93pUnDGfSh2WuTVGk7NCEenKQ
         +QZYAFfoxWlsW/BT3t+v7EWyN1+DeyldIYfwtCV0=
Date:   Tue, 30 Apr 2019 13:37:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Oskolkov <posk@google.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        Peter Oskolkov <posk@posk.io>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Captain Wiggum <captwiggum@gmail.com>,
        Lars Persson <lists@bofh.nu>
Subject: Re: [PATCH 4.9 stable 0/5] net: ip6 defrag: backport fixes
Message-ID: <20190430113732.GA9401@kroah.com>
References: <20190426154108.52277-1-posk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426154108.52277-1-posk@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 26, 2019 at 08:41:03AM -0700, Peter Oskolkov wrote:
> This is a backport of a 5.1rc patchset:
>   https://patchwork.ozlabs.org/cover/1029418/
> 
> Which was backported into 4.19:
>   https://patchwork.ozlabs.org/cover/1081619/
> 
> and into 4.14:
>   https://patchwork.ozlabs.org/cover/1089651/
> 
> 
> This 4.9 patchset is very close to the 4.14 patchset above
> (cherry-picks from 4.14 were almost clean).
> 

All now queued up, thanks!

greg k-h
