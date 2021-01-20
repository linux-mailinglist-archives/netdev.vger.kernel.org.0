Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505162FD644
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 17:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391765AbhATQ7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 11:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391591AbhATQ71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 11:59:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9399123358;
        Wed, 20 Jan 2021 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611161926;
        bh=4tPb7oiOpgfhTD/vQJqPmDd/sTB+82Wa1AHcoottGyY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KfNFDIPAC8s8Fq/a3t9aRYfnQ/1rDk0g0PAx8gLUKIydbRyOjOiAgGXOyi2DZqZYt
         keogDWt0stVw1jzFKOSwuHQ5utGSK0QZQRrSvirhqFaeM/BbS6yEOpW82LExzwdX3i
         LUcA9PiqRv4F0ILPPwK1/GSiAsGIxvXh52pvzLsLiB8Qf7XPfu6zD7NBjT+9phMTg0
         VvTL8OhWbMUx/tO96tF/x4Ggvlx21M/XCYTY++KYhNRD77KIchemfTLl6O+crkPD7/
         tbB0BMSWdNX0Di8iTY+tviGBryKwCasoRO24TqIBkAGFcw+bg/LcT66D24HRVt17Cb
         sZkwU95FNLKtw==
Date:   Wed, 20 Jan 2021 08:58:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net] net: nfc: nci: fix the wrong NCI_CORE_INIT
 parameters
Message-ID: <20210120085845.11d43647@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACwDmQBZ-LVursCYmtngyv3yFCQ9_Jkip03VZ8cd1auNu86V8A@mail.gmail.com>
References: <20210118205522.317087-1-bongsu.jeon@samsung.com>
        <161110440860.4771.13780876306648585886.git-patchwork-notify@kernel.org>
        <CACwDmQBZ-LVursCYmtngyv3yFCQ9_Jkip03VZ8cd1auNu86V8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 18:54:17 +0900 Bongsu Jeon wrote:
> On Wed, Jan 20, 2021 at 10:00 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> > This patch was applied to netdev/net.git (refs/heads/master):
> >
> > On Tue, 19 Jan 2021 05:55:22 +0900 you wrote:  
> > > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> > >
> > > Fix the code because NCI_CORE_INIT_CMD includes two parameters in NCI2.0
> > > but there is no parameters in NCI1.x.
> > >
> > > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Could you merge this patch to net-next repo??
> NCI selftest that i will send will fail if this patch isn't merged.

It happens periodically, should happen today or tomorrow.
