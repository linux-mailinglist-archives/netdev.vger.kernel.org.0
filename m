Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE672311F3
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732500AbgG1Ssj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbgG1Ssi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 14:48:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83CAF20786;
        Tue, 28 Jul 2020 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595962118;
        bh=2MMLZ3MJCDsMPfuroLApervDJB3JUibEeJR4+4CGuVo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nW+O6GnXS/KUkZx60/N41FyEAjw/bsy6D51kfHQ7LGm/rnBbcVsfiSLUyhp3U9dVl
         FOhU2DgSXWaNGBHHAQ46OFrph9w29yLeXbadZekeyxfvUozphYINm2uz9gdiuGpO/W
         QYSBKtKPmocIyWQoM7OHdGPBV+viMV38+QBhXBUY=
Date:   Tue, 28 Jul 2020 11:48:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     sameehj@amazon.com, davem@davemloft.net, netdev@vger.kernel.org,
        dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, gtzalik@amazon.com, netanel@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, akiyano@amazon.com,
        ndagan@amazon.com, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, hawk@kernel.org,
        shayagr@amazon.com, lorenzo@kernel.org
Subject: Re: [PATCH RFC net-next 0/2] XDP multi buffer helpers
Message-ID: <20200728114835.3eaa8d49@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728123327.GB25823@ranger.igk.intel.com>
References: <20200727125653.31238-1-sameehj@amazon.com>
        <20200728123327.GB25823@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 14:33:27 +0200 Maciej Fijalkowski wrote:
> On Mon, Jul 27, 2020 at 12:56:51PM +0000, sameehj@amazon.com wrote:
> > From: Sameeh Jubran <sameehj@amazon.com>
> > 
> > This series is based on the series that Lorenzo sent [0].  
> 
> What is your final design for multi buffer support in XDP?
> Why don't you provide a single RFC that is fully functional but instead
> you're sending a bunch of separate RFCs?

+1

are we expecting a new attachment type?
