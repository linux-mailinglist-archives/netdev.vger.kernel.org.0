Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63F6367CDD
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 10:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbhDVItp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 04:49:45 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:34579 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235004AbhDVItp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 04:49:45 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 27720126F;
        Thu, 22 Apr 2021 04:49:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 22 Apr 2021 04:49:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7HPiV0
        pnyAEMImm53FuY3vNQrk11H1LMSrVINkNhiyM=; b=neIGLIaxdPcRasYSeqIEvp
        TNau8m6yL0WjIGwDAUSpa89HeRV2ebX5OUDn7cUaitg9SYKZnQ/Eyw7XjAP9xASy
        +rTj4DDfvWNmV6eRY9M6Wj6mKnXIOSzZWwHBzBvF4khAWcuAnyavLKF0UCyvIHj2
        yD7HWNb8A/7b6Vm6LRKpvTHn5ibQHVQnEhqp92JnBcRF4YW4BP2AoGXw/M67pCZr
        z8EjOj591TmYsdF/dnaLSD8v+ju/alXsS8sFHTl03cYPubRUTH/SmyiAxCvkW8o3
        pW4eEVMMBSjh1o16TotQn39QrekWWWyz8THHh7Ry+D9E4lSeErddxf81ZdV8wxHw
        ==
X-ME-Sender: <xms:hTiBYExpasN1LKheZHX1Sn2c8HELW3v2SbQva_TH56bo1JCFFSqgQg>
    <xme:hTiBYIOebjFrP_KW0K7z6YbXYrVwplUb3W0FFU2PdTsxuzOjRK7v4nh0VVZnIPy_6
    uC7JFNrmgnzIok>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddutddgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepgfevgfevueduueffieffheeifffgje
    elvedtteeuteeuffekvefggfdtudfgkeevnecuffhomhgrihhnpehkvghrnhgvlhdrohhr
    ghenucfkphepkeegrddvvdelrdduheefrddukeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:hTiBYDMlbMoYsFjzc9oFCe1Uf9MXcnCgv86ZZ7470mYWTRjT15Ds0A>
    <xmx:hTiBYKSVJqB63-jbPGAiA_1Tf-_IsDur21jGk3TjDvb8ZIQXvfZJtA>
    <xmx:hTiBYFAYDhWUlE7vftKBtOeJ19wtQK35mguyn5Ey_pfS1Bn4AKFZdg>
    <xmx:hTiBYLbpSTscO9qBRcf5nQtOencic-cPaGT0C5B8DzdizL29pcUgyA>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 394741080069;
        Thu, 22 Apr 2021 04:49:09 -0400 (EDT)
Date:   Thu, 22 Apr 2021 11:49:05 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool-next 0/7] ethtool: support FEC and standard stats
Message-ID: <YIE4gZWsjrHNrZGA@shredder.lan>
References: <20210420003112.3175038-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420003112.3175038-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 05:31:05PM -0700, Jakub Kicinski wrote:
> This series adds support for FEC requests via netlink
> and new "standard" stats.

Jakub, you wrote "ethtool-next" in subject, but I only managed to apply
the patches to the master branch.

Michal, I assume we are expected to send new features to next? If so,
can you please update the web page [1] ?

Thanks

[1] https://mirrors.edge.kernel.org/pub/software/network/ethtool/devel.html
