Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954EE322948
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 12:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhBWLJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:09:23 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36405 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232351AbhBWLI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 06:08:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E284F5C0219;
        Tue, 23 Feb 2021 06:08:02 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 23 Feb 2021 06:08:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U2I4e7
        bo/e7cpkkwZVTL9XRDCAR7LL7Oi+fIECKIm3Y=; b=Gqv/rqXZ/jmbnn7bIE2bk/
        mJjV77zkcbMwDXps+l78qmV0K3Ijxnd1O/SrsyekHnhDITSwlqeZGiJlG2tfm7c/
        U1p0QKo3zWyGvtULcLLgxkfnIqmbbeXMLjVuZSulKMyG6yU4oZt3qX5qTULcaEtc
        2edfHoN0dz2eiQfh7N13B6PF2FWDAcvcVce3+XkKzBmyq4YAx0faay/U+dAZz6wI
        fRsShZBG++OgyzzpTIfGIqtq0oJROet1iNTer246APWD8PJi9BeZy1GWpKBONLqQ
        F0HFQeDd62upVDbb7lLPH6kudPOqF6KyxhbaMAIp8IndTr8er5rMQf+ejtHc34oA
        ==
X-ME-Sender: <xms:EeI0YCQ6vH6BDER0E9H9M3fykyQHASYN7ckTOZ4s5U4XWYx72oCHvQ>
    <xme:EeI0YFtiawuLx2_s3-1yD4F8ksq8Km5Nz3_0zNHIIho4_rZY4BiDkyBLSpF5B2uzs
    Y08tQUhiKknQGU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeehgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:EeI0YHYgwdaSmfxn7eiV2lhhj4V5NPERIekF9IPddwdpJc0pTahkxg>
    <xmx:EeI0YKvBxNG9XWcghHictaqW7drYJ6YuhVZxB-IjNy2OnJFMA_AmIA>
    <xmx:EeI0YJHK_sURjGq6oUdDa2Nabuq5qGeeUDnY30kJiV9Xum7fdU49Rw>
    <xmx:EuI0YEqWA9OgQdELllh9zGzMH3XwyjTBLnkNEEwqqxRbNeZE_mXCrQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B440240065;
        Tue, 23 Feb 2021 06:08:01 -0500 (EST)
Date:   Tue, 23 Feb 2021 13:07:57 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netdevsim: fib: remove unneeded semicolon
Message-ID: <YDTiDezR7JmWIzq7@shredder.lan>
References: <1614047326-16478-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614047326-16478-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 10:28:46AM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/netdevsim/fib.c:564:2-3: Unneeded semicolon.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
