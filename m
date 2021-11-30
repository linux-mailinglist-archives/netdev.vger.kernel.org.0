Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B992463001
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 10:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbhK3JuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 04:50:11 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47587 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240328AbhK3JuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 04:50:11 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 05F845C0117;
        Tue, 30 Nov 2021 04:46:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 30 Nov 2021 04:46:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TdGnsP
        MpHdhEUgYd+x6DQ+EtpxfxerJd/7IvyvpbzI0=; b=gYBobs2RZgFB2kLXtzxrBW
        JlSLoNhJBYCrSgK9kxbARR3jsEQ/QfzwEopgrBfPREyk9ayML+/nQrNKUSmRW9jy
        VnLMFyweGrzDRqJyPN3+ffFeLb4UpdvMdQZlaFivtFCSi7a4jujGlmyvuRw+CK5R
        5w45YOzuqMomizfMUlfuc4nx4/Zkix+Df+sWEdSqfp/PCmUsuEQXW21k+uleQsW0
        dKx+3atYaQweG4U/AmoMa/wWn9aT0yzIV4oWeTkz2Bc/Bg7A2H89vcDuJAGxoG4+
        qR1juYa74V5Xuzp3zlBYZghMC8d4PLgVHqXr0j/lb97eiYRRBWlurT4ns9PYfY6g
        ==
X-ME-Sender: <xms:C_OlYTQ9qZp5mJVmUVoHlRMP1EDemAhVA0CG0vct8pqlWPMjpymmrw>
    <xme:C_OlYUzj8bJvue9wbjcdQvqJZa4_EBPpM4cFWhX1CNSGIqRYMp3C4bDVeMaKFezTL
    -U1NVhMs-QKO3I>
X-ME-Received: <xmr:C_OlYY1npOwGShJc-RKFqQ_kdqn5cXUYinSR4ydq1_1qTxXauIrLJPSBb9a60-TjZRnJVZh_m6IQqF3nsjlCOdsvfw6Nuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedugddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfejvefhvdegiedukeetudevgeeujeefffeffeetkeekueeuheejudeltdejuedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:C_OlYTAx6HfGLEtw-yXVEbFXfPhOaY-aSPGUiT7ECWwPmy2LecJyYA>
    <xmx:C_OlYcjVkd6NkxcrFeG2FFDj4-6usOpK5tnRvMWqGSY_5hvpGHrG9A>
    <xmx:C_OlYXpScM9zkOFlkKUeKGPL0lFM1w1jPBDkxfjK_BZoQnGkj4Qs9g>
    <xmx:DPOlYYjYCsR_olR79e-lo5RA1Erfv8qJxRPkG9jhh6fh38eBiT2bIw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 Nov 2021 04:46:51 -0500 (EST)
Date:   Tue, 30 Nov 2021 11:46:48 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, andrew@lunn.ch, pali@kernel.org,
        jacob.e.keller@intel.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and query
 transceiver modules' firmware
Message-ID: <YaXzCKEwuICECkyz@shredder>
References: <20211127174530.3600237-1-idosch@idosch.org>
 <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaXicrPwrHJoTi9w@shredder>
 <20211130085426.txa5xrrd3nipxgtz@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130085426.txa5xrrd3nipxgtz@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 09:54:26AM +0100, Michal Kubecek wrote:
> On Tue, Nov 30, 2021 at 10:36:02AM +0200, Ido Schimmel wrote:
> > On Mon, Nov 29, 2021 at 09:37:24AM -0800, Jakub Kicinski wrote:
> > > 
> > > Immediate question I have is why not devlink. We purposefully moved 
> > > FW flashing to devlink because I may take long, so doing it under
> > > rtnl_lock is really bad. Other advantages exist (like flashing
> > > non-Ethernet ports). Ethtool netlink already existed at the time.
> > 
> > Device firmware flashing doesn't belong in devlink because of locking
> > semantics. It belongs in devlink because you are updating the firmware
> > of the device, which can instantiate multiple netdevs. For multi-port
> > devices, it always seemed weird to tell users "choose some random port
> > and use it for 'ethtool -f'". I remember being asked if the command
> > needs to be run for all swp* netdevs (no).
> > 
> > On the other hand, each netdev corresponds to a single transceiver
> > module and each transceiver module corresponds to a single netdev
> > (modulo split which is a user configuration).
> 
> Devlink also has abstraction for ports so it can be used so it is not
> necessarily a problem.
> 
> > In addition, users are already dumping the EEPROM contents of
> > transceiver modules via ethtool and also toggling their settings.
> > 
> > Given the above, it's beyond me why we should tell users to use anything
> > other than ethtool to update transceiver modules' firmware.
> 
> As I already mentioned, we should distinguish between ethtool API and
> ethtool utility. It is possible to implement the flashing in devlink API
> and let both devlink and ethtool utilities use that API.
> 
> I'm not saying ethtool API is a wrong choice, IMHO either option has its
> pros and cons.

What are the cons of implementing it in ethtool? It seems that the only
thing devlink has going for it is the fact that it supports devlink
device firmware update API, but it cannot be used as-is and needs to be
heavily extended (e.g., asynchronicity is a must, per-port as opposed to
per-device). It doesn't support any transceiver module API, as opposed
to ethtool.

> I'm just trying to point out that implementation in devlink API does
> not necessarily mean one cannot use the ethtool to use the feature.

I agree it can be done, but the fact that something can be done doesn't
mean it should be done. If I'm extending devlink with new uAPI, then I
will add support for it in devlink(8) and not ethtool(8) and vice versa.
