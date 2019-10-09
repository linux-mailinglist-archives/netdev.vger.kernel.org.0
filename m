Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9CBAD1903
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbfJITeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:34:24 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58807 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729535AbfJITeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:34:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9DC682201F;
        Wed,  9 Oct 2019 15:34:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 09 Oct 2019 15:34:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SrTlps
        G/IJ/DERzTLlyvVCwmW48YzV5h+1epja3W6Pw=; b=U2y0iXVJW+wRY+w7ljL+Ju
        Ek7ZtB407JBRoTxragYrZ7rkPjbzgJGte4jRH4Oeos9ke+PSB5mxzTHhkZcDkg5/
        5rBfpqUKfAdQX+/wHxrMuR7FWANB/nwA+/D4d1i6aNJoVAOtRfJHOslRNrZGFs/n
        z4uyXRq+7i54UygUa9HIlvUjCKSghz14TGAzu7AJdoRstr1IpsYAuplsIH311E4u
        w1UWBnU/jm9gFjXWpaZL9yku8stQCvloDOgYIg4MB1jzDrGU1uEFO3EhMJbybZc6
        Ozd5kRgTU2ETSnmMmIMXwNjd5Zc4bcDjYbGM5P/6wRMeoynhi+vAXsRMjjqCSmqg
        ==
X-ME-Sender: <xms:PjaeXZ34XiiM9kyu3_iIhchwcWbKnsUmzlW4VyA-pAfxCq0hnBfRXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedugdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuffhomhgrih
    hnpehoiihlrggsshdrohhrghdplhifnhdrnhgvthenucfkphepjeelrddujeejrdefkedr
    vddtheenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdroh
    hrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:PjaeXbg2HymMiHc68IKh3WLBGPj_1Xo-PF_QKYFFVbGEZmG8NV3Gog>
    <xmx:PjaeXdav_hZ0aS60u1CMaV-M0A97cPswZ3DJjAMm7BiynHQhLxPUiQ>
    <xmx:PjaeXbQI4GQVFjMzfxnvRVAZkF-d05q9rys3LhgL8kIDROvJ1yM-zw>
    <xmx:PjaeXfOlt0VkiXwefzdeByM67DXhFR3DhcPgSBtlzSbUhHZPfRVmsQ>
Received: from localhost (bzq-79-177-38-205.red.bezeqint.net [79.177.38.205])
        by mail.messagingengine.com (Postfix) with ESMTPA id E367B80063;
        Wed,  9 Oct 2019 15:34:20 -0400 (EDT)
Date:   Wed, 9 Oct 2019 22:34:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, idosch@mellanox.com, jiri@resnulli.us,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net] Documentation: net: fix path to
 devlink-trap-netdevsim
Message-ID: <20191009193413.GA25127@splinter>
References: <20191009190621.27131-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009190621.27131-1-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 12:06:21PM -0700, Jakub Kicinski wrote:
> make htmldocs complains:
> Documentation/networking/devlink-trap.rst:175: WARNING: unknown document: /devlink-trap-netdevsim
> 
> make the path relative.
> 
> Fixes: 9e0874570488 ("Documentation: Add description of netdevsim traps")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>

Thanks for fixing Jakub.

FWIW, someone already sent a patch [1] for this, but now I see that it's
marked as "Not Applicable". Maybe the expectation was that it would go
via the documentation tree? I just checked and I don't see it there [2].

[1] https://patchwork.ozlabs.org/patch/1171361/
[2] git://git.lwn.net/linux.git
