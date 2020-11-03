Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270C72A552E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388723AbgKCVRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:17:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388388AbgKCVKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 16:10:24 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F0A205ED;
        Tue,  3 Nov 2020 21:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437824;
        bh=qfM6Ado5dVym6b3oNJPoh5/P1bNLzw5EzwIlfFeVBoE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HO4dwPzRTRu/sxyoRrZ3O5DJWrFsagfpiZHO0cq6Qzm1qdVWXu4ulioBJUoSl0QsV
         SB1LXVaMS0giyG+DcJLYkkQxVsQ79UZtwXoY1wLhqEfR/fGMmqWvCpCXAlR2LlpXMW
         wPzG0VRW0i/STaecmuNNDD9hGinhTfy0d6I5rVws=
Date:   Tue, 3 Nov 2020 13:10:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Davide Caratti <dcaratti@redhat.com>, mptcp@lists.01.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] mptcp: token: fix unititialized variable
Message-ID: <20201103131023.7deabb3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <97343b07772ae794ca2aad683734901c055aa0ab.camel@redhat.com>
References: <49e20da5d467a73414d4294a8bd35e2cb1befd49.1604308087.git.dcaratti@redhat.com>
        <97343b07772ae794ca2aad683734901c055aa0ab.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 02 Nov 2020 11:48:25 +0100 Paolo Abeni wrote:
> On Mon, 2020-11-02 at 10:09 +0100, Davide Caratti wrote:
> > gcc complains about use of uninitialized 'num'. Fix it by doing the first
> > assignment of 'num' when the variable is declared.
> > 
> > Fixes: 96d890daad05 ("mptcp: add msk interations helper")
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> Acked-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks!
