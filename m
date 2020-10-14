Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A0228D762
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 02:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgJNAWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 20:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgJNAWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 20:22:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 333B72078A;
        Wed, 14 Oct 2020 00:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602634927;
        bh=LrRHWxAmu53K+XRuzJU2+I0WmRKHk+eGQsEh2cbtxlA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MGUFzumryJ98wz/psgeB/bdqiEMxawJO+hjX5AIG/kdvAPm8ZwqRDj71XYMwXp1va
         fG150i6KwG5Aux1EThQWxLHzLC1F5QbVPbL8Vq3cfZYoKXLtNDPczexm3C68p0aecz
         zptLIyzV7p/auj93cThm9VaZ+BD3hBWaHLlMuSYk=
Date:   Tue, 13 Oct 2020 17:22:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Christian Eggers <ceggers@arri.de>,
        "David S . Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 1/2] socket: fix option SO_TIMESTAMPING_NEW
Message-ID: <20201013172205.4fa0d90d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CABeXuvrgdP9C4jM2VhNn_FAdTvW5EVMoNSOmca2YW-XtM544rw@mail.gmail.com>
References: <20201012093542.15504-1-ceggers@arri.de>
        <CA+FuTSfkBHtKqjppMmqudj9GwZBidSqvOP6WCzoxLGihqiz5Qw@mail.gmail.com>
        <CABeXuvrgdP9C4jM2VhNn_FAdTvW5EVMoNSOmca2YW-XtM544rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 22:10:31 -0700 Deepa Dinamani wrote:
> > On Mon, Oct 12, 2020 at 5:36 AM Christian Eggers <ceggers@arri.de> wrote:  
> > > v2:
> > > -----
> > > - integrated proposal from Willem de Bruijn
> > > - added Reviewed-by: from Willem and Deepa  
> 
> You may add my
> Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>

Applied both, thanks everyone!
