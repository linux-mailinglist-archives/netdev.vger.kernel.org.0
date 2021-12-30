Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2723D48208C
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 23:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhL3WRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 17:17:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46402 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhL3WRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 17:17:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB34BB81D0C
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 22:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A7CC36AEA;
        Thu, 30 Dec 2021 22:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640902639;
        bh=dy2Wcb7tKf5XjQXZ/dmM8yzluqxsO/4tCH2M3VY0i3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EEfD/DsKimmUitahKL6cOmQ5TdnTDq0fKgo8dbV91kzXJ7Iw0hsLNpx5tPNERUA5H
         vj0B5GpCionE/FjB9ARwVYAP9ZltHAEcWQofWTMGsAstL84s4hKK44/B81orIajs8e
         JMySPkhBYLgrFPC35zLGLZV8+hI3PI2f0iBV8IHHzZw/1cHwHjA32IEX4uxzEeZsyU
         /Kr9xF96VlY99BQxh4OfX8c3en8IYh2Bu/IEujKa1xC0S6fNScr3+Gqv07MdTM32Ii
         9LAF7g9imgXTaJt0o+BFtrPnqX1PJ2z6qZRLvlxLAcol3LfHODU65zii0D9xZlHwwY
         aEbdTXo8eO9eg==
Date:   Thu, 30 Dec 2021 14:17:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net/fungible: Kconfig, Makefiles, and
 MAINTAINERS
Message-ID: <20211230141717.01235f9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAOkoqZny2=S-+sApOn7pKroYoB8HVS3XCCFRmB5DB7k3B0THjA@mail.gmail.com>
References: <20211230163909.160269-1-dmichail@fungible.com>
        <20211230163909.160269-9-dmichail@fungible.com>
        <20211230094327.69429188@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAOkoqZ=18H6CAE8scCV7DWzu9sQDLJHUiVgZi3tmutUNPPE2=A@mail.gmail.com>
        <CAOkoqZny2=S-+sApOn7pKroYoB8HVS3XCCFRmB5DB7k3B0THjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Dec 2021 13:16:16 -0800 Dimitris Michailidis wrote:
> > and it goes through. Tried it also on net-next as of a few minutes ago.
> > Any ideas what may be different?  
> 
> Never mind, I see what happened. One of the patches is bad and is not
> adding the paths correctly.
> 
> Do let me know if I should address the header 'static const' warnings
> from -Wunused-const-variable.

Yes, please - enum seems most appropriate for the values.
