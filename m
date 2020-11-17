Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56B72B5582
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbgKQAEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:04:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgKQAEv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:04:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6B0E2464E;
        Tue, 17 Nov 2020 00:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605571490;
        bh=FcffOXR/r1uiRRR/FyFhnr/qAwFf853MFMEt/cKtKgs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TztPkA02Qde/ydp63vCmfxQz6DiEWupihPaKsra/0+72GOvNEYuvZo5ELIiSEr7vi
         PB0UEnxLDs91OeGo6NU27HTUWdZBOgMSGvTQQteWpyE2T5d7i96yUKCx79FY8+TXCi
         17cql7xNMD4LhkjNSbVCDuyGTx9/qw/GMY3id92A=
Date:   Mon, 16 Nov 2020 16:04:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
Message-ID: <20201116160449.0cc0ee76@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116235405.wkyyhqznocit4vj2@skbuf>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
        <20201019200258.jrtymxikwrijkvpq@skbuf>
        <58b07285-bb70-3115-eb03-5e43a4abeae6@gmail.com>
        <20201019211916.j77jptfpryrhau4z@skbuf>
        <20201020181247.7e1c161b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a8d38b5b-ae85-b1a8-f139-ae75f7c01376@gmail.com>
        <d2dbb984-604a-ecbd-e717-2e9942fdbdaa@gmail.com>
        <20201116154710.20627867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116235405.wkyyhqznocit4vj2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 01:54:05 +0200 Vladimir Oltean wrote:
> Yeah, I think Florian just wants netconsole to work in stable kernels,
> which is a fair point. As for my 16-line patch that I suggested to him
> in the initial reply, what do you think, would that be a "stable"
> candidate? We would be introducing a fairly user-visible change
> (removing one step that is mentioned as necessary in the documentation),
> do you think it would benefit the users more to also have that behavior
> change backported to all LTS kernels, or just keep it as something new
> for v5.11? 

Yeah, I'd think that's too risky for a backport.
