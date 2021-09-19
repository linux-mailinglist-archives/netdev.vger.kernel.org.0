Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71B7410AE0
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 11:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237435AbhISJY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 05:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237226AbhISJYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 05:24:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F29861212;
        Sun, 19 Sep 2021 09:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632043380;
        bh=DTCVzhxy45g1bLfr51LF2BFS1ilTxS3Wra1hNpxEFAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ncechFSzFh++pC4C8gu0lEkSfzwO5ILTZmyFt76aI4W28vFKcjmQZNPUo8NbfTf7M
         Q6ctNGwBW5DeabZ1my2rCaapZQp3+/vDeIlxPKKBzbYMenPkbapeoxn2oyBaTruLUl
         lZb1TuqcdZiWu3TGYN9dsKPD11hIpK3rOxnc6Q58=
Date:   Sun, 19 Sep 2021 11:22:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        linux-staging@lists.linux.dev, Daniel Drake <drake@endlessos.org>
Subject: Re: [PATCH v2] MAINTAINERS: Move Daniel Drake to credits
Message-ID: <YUcBcaa2M6Ar86Jl@kroah.com>
References: <20210917102834.25649-1-krzysztof.kozlowski@canonical.com>
 <YUSZy0fH0oKuFsLV@kroah.com>
 <875yuxx7eg.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yuxx7eg.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 12:05:11PM +0300, Kalle Valo wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > On Fri, Sep 17, 2021 at 12:28:34PM +0200, Krzysztof Kozlowski wrote:
> >> Daniel Drake's @gentoo.org email bounces (is listed as retired Gentoo
> >> developer) and there was no activity from him regarding zd1211rw driver.
> >> Also his second address @laptop.org bounces.
> >> 
> >> Cc: Daniel Drake <drake@endlessos.org>
> >> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> >
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Thanks. I assume it's ok for everyone that I take this to
> wireless-drivers.

No objection from me, thanks.

greg k-h
