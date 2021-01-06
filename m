Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE722EC1A7
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbhAFRB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbhAFRB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 12:01:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8923F23132;
        Wed,  6 Jan 2021 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609952473;
        bh=Z2KRyDfJPSLu/00pFs7dpyH4JX/cDDDyqtla9ACYJ+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oTB6IyStibaIcTssg8nT78WaHLImp5vGGcRP6virCQURXnqJkJEJDYGhd9hmtbf0U
         6Rk6dzVq9eEg/ovMoF7cx+c0Rr74QrCrx/6hGYR/dd2oW4G0oM9QABM3exNrq3Zars
         /qaUguXHkFr2MGEo3tCQ/4gW2epW7POguoOQX3oFlQHn+7TdF0EFXY/7KRbubaMHel
         RwoA+Yw/tdrKMM8P+78PXV9f2o6OgQz4vItuIDYQN4rbwimi2ZpTtvgBLJOwtU8EYc
         oDJ2ad3M791aG+MZWJTDJ1zktR27F8GTXcZXYQgyUFgZBzcT2ayI3/U6KBdcpDywMP
         zrc5xNR9+7dtQ==
Date:   Wed, 6 Jan 2021 09:01:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next] nfc: Add a virtual nci device driver
Message-ID: <20210106090112.04ebf38f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACwDmQCTj1T+25XBx8=3z=NmCtBSeHxHbUykA6r9_MwNJmJOQQ@mail.gmail.com>
References: <20201228094507.32141-1-bongsu.jeon@samsung.com>
        <20201228131657.562606a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACwDmQCVkxa6u0ZuS4Zn=9JvOXoOE8-v1ZSESO-TaS9yHc7A8A@mail.gmail.com>
        <20210104114842.2eccef83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACwDmQCTj1T+25XBx8=3z=NmCtBSeHxHbUykA6r9_MwNJmJOQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 08:16:47 +0900 Bongsu Jeon wrote:
> On Tue, Jan 5, 2021 at 4:48 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > thank you for your answer.
> > > I think that neard(NFC deamon) is necessary to test the NCI subsystem
> > > meaningfully.
> > > The NCI virtual device in user space can communicate with neard
> > > through this driver.
> > > Is it enough to make NCI virtual device at tools/nfc for some test?  
> >
> > I'm not sure if I understand. Are you asking if it's okay for the test
> > or have a dependency on neard?  
> 
> Sorry for confusing you.
> There is no dependency between neard and a NCI virtual device.
> But, To test the NCI module, it is necessary to make an application like neard.
> Is it okay to just make a NCI virtual device as a tool at tools/nfc
> without the application?

Meaning the device will be created but there will be no test cases in
the tree?

What we'd like to see is some form of a test which would exercise the
NFC-related kernel code on such a device and can signal success /
failure. It doesn't have to be very complex.

You can build a more complex user space applications and tests
separately.
