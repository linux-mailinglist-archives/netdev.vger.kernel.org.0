Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BE23EBB72
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhHMR2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhHMR2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 13:28:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C71CB60F57;
        Fri, 13 Aug 2021 17:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628875675;
        bh=bviahBNGn3oBGdRG7DC5ARf7GPjuUa1idJKISna3K/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WDNRuWl7/dwJDr9as5mUo9DCdCrX4kvJvnyI+p6CwRCQSSihR/f/USKvjMPqFGsWK
         RSI1hJE4Y07wIriF9wMWp16wRrWeMt9OXd1KXQ1ba9F2TLMGHr45LHRJta/gipx4Wp
         8TMClsuzBMNQdea+mqqXeIcxO6B1DITexBvWwT6PtkTDKlTlpNq8EUqq0JmJn+mBFO
         JdiUtVsR0Fgnk2dmb84KIa79XRrw59UIcG7BS3jrNLxndN8EWTDXSfaIH2AXKCllxZ
         TpT2OLO7anWMuZ9OcyY/SVXp37YAnwgNzipsqhWWDer/xyEFxr3DLJ2lHEOGLaVcw/
         YC2RgZoBpM58A==
Date:   Fri, 13 Aug 2021 10:27:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Jeffrey Huang <huangjw@broadcom.com>,
        Andrew Gospodarek <gospo@broadcom.com>
Subject: Re: [PATCH net v3 0/4] bnxt: Tx NAPI disabling resiliency
 improvements
Message-ID: <20210813102754.44350186@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLin05_S6chzC6ubPDbcNEuRVt_wbvqf0xajpZC6y8Hum7w@mail.gmail.com>
References: <20210812214242.578039-1-kuba@kernel.org>
        <CACKFLin05_S6chzC6ubPDbcNEuRVt_wbvqf0xajpZC6y8Hum7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 15:07:53 -0700 Michael Chan wrote:
> On Thu, Aug 12, 2021 at 2:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > A lockdep warning was triggered by netpoll because napi poll
> > was taking the xmit lock. Fix that and a couple more issues
> > noticed while reading the code.  
> 
> Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Applied, thanks!
