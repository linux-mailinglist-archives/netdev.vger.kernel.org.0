Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85062E9E50
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 20:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbhADTtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 14:49:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhADTtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 14:49:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E2820780;
        Mon,  4 Jan 2021 19:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609789723;
        bh=CltlxWNEK/C+c6lCweLqAl+rBPr8Ap+pY2+oZ3aum7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tu3FOadwcmvfUJKILnnxHOhuh34tzF/6hK4lA9c90JLYLOSaQym6ICCD9o/0UKB75
         7HVqJmPoI2uWcv+dZeYkPaTft1W+V8/1yeZEDfS7uX7+NDsAsjPGb3oyUidj1kFqpK
         yL305eGwbvo0c3s/+VEf+fsQ+wOiNsAmLVxmBFzTrkojmhBDvjdwztE71oJ7T3tSVf
         StFb7jztUEW+t+AESmNAmQXWN3EI9MLS+rm6zdn9KOsTiOGXRuMBSajdgL+ywn6HrQ
         YTiffniLDHF1kcmNoXCrfGWYZ4ks1VyyMvMfVCmizNUZoFP9YLsSXNpo/ebysY41Dx
         9oIxobsCcU+AA==
Date:   Mon, 4 Jan 2021 11:48:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next] nfc: Add a virtual nci device driver
Message-ID: <20210104114842.2eccef83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACwDmQCVkxa6u0ZuS4Zn=9JvOXoOE8-v1ZSESO-TaS9yHc7A8A@mail.gmail.com>
References: <20201228094507.32141-1-bongsu.jeon@samsung.com>
        <20201228131657.562606a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACwDmQCVkxa6u0ZuS4Zn=9JvOXoOE8-v1ZSESO-TaS9yHc7A8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Dec 2020 14:22:45 +0900 Bongsu Jeon wrote:
> On Tue, Dec 29, 2020 at 6:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 28 Dec 2020 18:45:07 +0900 Bongsu Jeon wrote:  
> > > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> > >
> > > A NCI virtual device can be made to simulate a NCI device in user space.
> > > Using the virtual NCI device, The NCI module and application can be
> > > validated. This driver supports to communicate between the virtual NCI
> > > device and NCI module.
> > >
> > > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>  
> >
> > net-next is still closed:
> >
> > http://vger.kernel.org/~davem/net-next.html
> >
> > Please repost in a few days.
> >
> > As far as the patch goes - please include some tests for the NCI/NFC
> > subsystem based on this virtual device, best if they live in tree under
> > tools/testing/selftest.  
> 
> thank you for your answer.
> I think that neard(NFC deamon) is necessary to test the NCI subsystem
> meaningfully.
> The NCI virtual device in user space can communicate with neard
> through this driver.
> Is it enough to make NCI virtual device at tools/nfc for some test?

I'm not sure if I understand. Are you asking if it's okay for the test
or have a dependency on neard?
