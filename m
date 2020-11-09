Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A782AC3FF
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgKISjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:39:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729454AbgKISjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 13:39:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9BC0206B2;
        Mon,  9 Nov 2020 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604947188;
        bh=76O1J6CJQGUjIBmB3pFb2sYnANHXnIGCinhzrVMiOsk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fabP3SDbuqbD5NZZNRjjMP0RjeJsyRlobXVVIlK7S48H2zopUaIMH8YD11yWFJpu2
         QksHwZGPokwPzJ9V7SNtgD1BVVyRkM+tKQzdP5K0Ws6a2ZcbiKD+puD/IiAsaOrjW8
         0ykpcy9D5FnZlnUr52r7Q4QxQGNJosspybktv+xQ=
Date:   Mon, 9 Nov 2020 10:39:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        cjhuang@codeaurora.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] net: qrtr: Add distant node support
Message-ID: <20201109103946.4598e667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMZdPi-5Qp7jOHDZLZoWKJ4zwU6Sa9ULAts0eY6ObCu91Awx+w@mail.gmail.com>
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
        <20201107162640.357a2b6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMZdPi-5Qp7jOHDZLZoWKJ4zwU6Sa9ULAts0eY6ObCu91Awx+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 09:49:24 +0100 Loic Poulain wrote:
> > Looks like patch 1 is a bug fix and patches 2-5 add a new feature.
> > Is that correct?  
> 
> That's correct, though strictly speaking 2-5 are also bug fix since remote node
> communication is supposed to be supported in QRTR to be compatible with
> other implementations (downstream or private implementations).

Is there a spec we can quote to support that, or is QRTR purely 
a vendor interface?

What's the end user issue that we're solving? After firmware upgrade
things stop working? Things don't work on HW platforms on which this
was not tested? Don't work on new HW platforms?
