Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E87309646
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 16:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhA3Pe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 10:34:57 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:52337 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232144AbhA3OwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 09:52:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 692CF10A5;
        Sat, 30 Jan 2021 09:42:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 30 Jan 2021 09:42:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=v/1yXp
        U423VY9oBhdOW3MxCKKDbjDbYvqrwa5UXE6wA=; b=JvMprF4hWJPg3dJtD0At8O
        YLYVLoEaasi2pG+l4TCFnQtyAXPH6EskUDC9lj9yXILmA4bs2lMxhMvrM3dRVOun
        kXhilD1dus8cQg3QsnskTjecDlQOmSTSdlnyqZ9fXy0ALhfANKzKVV1KFKztxNEI
        4g/qURZ/FQ4Ccl9j+eyVRbEXX7ihETmoJgoL04faZs2ruMlUAVZTo/5+AXZ1ktqa
        kWo5O46EU17NXSWOtBYsOAHBlRjG7nYN3+VTh5ver9i4fW4Bud5H5J77cpmQLkdE
        pS/zAIPxfOgrmwWhDOKWFXR71khfoqeSdtK6EsC61FwW80T2jyiOrWknPAwQ7jRw
        ==
X-ME-Sender: <xms:W3AVYHmcDbrjnNON1bW9NiJY5Xnrrna2Mt9B6jNW11pwLItKQSP29g>
    <xme:W3AVYK1x4udn4FzcKZoDTzgiK8PYlvWfe8kfUVoFv9TmLT4xgJOuZBJi4UUS7HBCh
    X5YpjfJPt5zN1Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeggdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:W3AVYNosaPbyypHrZqLP-ZmJZPhWRfj-ZpZ0WN9bYeXPdR5-sC44NQ>
    <xmx:W3AVYPlggixbzQAviHHaetDEQjknq1mKz_GspP6bVz8pewqbrpYOYA>
    <xmx:W3AVYF3Ecqax6NnAkSl8FgrU48aFfz4ZkrigoYflXV_CJshcSYeG9Q>
    <xmx:XHAVYOzd8AreOmie7biZpytsT_T6hoL74SbxYE_yALtyDPUFozDBjg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2C29F1080059;
        Sat, 30 Jan 2021 09:42:34 -0500 (EST)
Date:   Sat, 30 Jan 2021 16:42:31 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Chris Mi <cmi@nvidia.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jiri@nvidia.com, Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210130144231.GA3329243@shredder.lan>
References: <20210128014543.521151-1-cmi@nvidia.com>
 <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
 <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
 <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 12:30:09PM -0800, Jakub Kicinski wrote:
> On Fri, 29 Jan 2021 14:08:39 +0800 Chris Mi wrote:
> > Instead of discussing it several days, maybe it's better to review 
> > current patch, so that we can move forward :)
> 
> It took you 4 revisions to post a patch which builds cleanly and now
> you want to hasten the review? My favorite kind of submission.
> 
> The mlxsw core + spectrum drivers are 65 times the size of psample 
> on my system. Why is the dependency a problem?

mlxsw has been using psample for ~4 years and I don't remember seeing a
single complaint about the dependency. I don't understand why this patch
is needed.
