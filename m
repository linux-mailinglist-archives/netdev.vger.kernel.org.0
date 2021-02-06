Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B710C311E33
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 16:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhBFO7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 09:59:02 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41211 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230012AbhBFO64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 09:58:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 602635C00F7;
        Sat,  6 Feb 2021 09:58:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 06 Feb 2021 09:58:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=URCcob
        kKqLQS8W4sYgpUBzUkJgYtByBgc9tcfcd07v0=; b=TIKzHWC1Ab6ufIkjz0yP2d
        JCyooGGwVBylTDyRcOXLCOBilLXmb+WeelKPOYnDwaeoQKXDCiHW1s9Y8bCi97YE
        Hl7uPSHttRWGQ9yOwb4RhwDHeoPwxFIj7YB7Z4JOZmitM961S3cL4+3DozVJMpy9
        5Dm9pRcb6LcfOnPNMgI/yfv/5Uk+l6UQ+x3PBQgtLkxeXLosDEbgThodzCLce629
        QySe9gVF9XT93dqzjDEbW53gvt359xAMgNma4gf67XxNJ1zFC4ygoozk2JgiT4FO
        W6QcO3sILcoRZ/GQs4kvTkvl5bZvxEEguEya5SQoMK3WNPfm4D4Hn8zl7JWct/oA
        ==
X-ME-Sender: <xms:gK4eYA2VBrW-ZIMKPLG8REukGB68zVt0iHqjcpkklw2I8yYFBubx_g>
    <xme:gK4eYLFAqfNwbSwEZ-edePIlh2kfLKODtAWWC4hr3C6DevKWRtE3Dew7Ff5Tx3bRu
    h2frN3bUHDee98>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:gK4eYI7pu-cenXL4K7Lyucgz8wzXB0tEwhI8jTLsS3Sho5s4A7glNQ>
    <xmx:gK4eYJ1xozZTfqrszaXGmU6SmxszwgNWSfXjx21XMxZjK3ujVmXK9A>
    <xmx:gK4eYDEyqjqHfztFaO3TkQEepntx4p1J1c6O_x8vM6bWfCrDP3e7pg>
    <xmx:ga4eYIT0_LE2Rx_Lele0sqD4qv1vNUKInRWqGuo9uF43PCxpMsawoQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA4C11080057;
        Sat,  6 Feb 2021 09:58:07 -0500 (EST)
Date:   Sat, 6 Feb 2021 16:58:04 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, kuba@kernel.org
Subject: Re: [RFC v5 net-next] net: core: devlink: add 'dropped' stats field
 for traps
Message-ID: <20210206145804.GA3847855@shredder.lan>
References: <20210204114122.32644-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204114122.32644-1-oleksandr.mazur@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 01:41:22PM +0200, Oleksandr Mazur wrote:
> Whenever query statistics is issued for trap, devlink subsystem
> would also fill-in statistics 'dropped' field. This field indicates
> the number of packets HW dropped and failed to report to the device driver,
> and thus - to the devlink subsystem itself.
> In case if device driver didn't register callback for hard drop
> statistics querying, 'dropped' field will be omitted and not filled.
> Add trap_drop_counter_get callback implementation to the netdevsim.
> Add new test cases for netdevsim, to test both the callback
> functionality, as well as drop statistics alteration check.
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

Code looks fine to me, but for non-RFC submission (with actual hw
implementation), you probably want to split it into three patches:
devlink, netdevsim, selftest.
