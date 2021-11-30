Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BC6462E9F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 09:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239652AbhK3Ij2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 03:39:28 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56715 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234779AbhK3Ij1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 03:39:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 885E05C0138;
        Tue, 30 Nov 2021 03:36:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 30 Nov 2021 03:36:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qfmn4y
        RhLRAg0V9cxCqYmHuC23s1vVUxybGCfaEHsDw=; b=HC99zS781M/ueYiHkg/Qkg
        zJIDUHkQqUQqxz8C9jf/EBHiRTI9bbNSrB72X2XU9Ln/M/6ATxF0AUiw7EIkuHfF
        agq7eDZRuN0g2JBty8pyT65q0fKBrDo7ACvX0JALLmYFjPBwjinXDXeR9fwMagS7
        pbu7p/cmE8XRuO7ZSUAudcsidMxeyQ7iByIWv0jvF2sDqv8o2OLVEKv2mwiUKDmR
        DwSWhAgFAR7KR4XmHpOq4wl3PkxjlIzBEA7NvAoJrDUgzQWCtRrhYQXqhxbNdZEv
        f+cu87G6T3124Rto79qNQZ3wEEIWRX3T0JRBosl+LEyD9MCetV/VQNuTMSnae4dQ
        ==
X-ME-Sender: <xms:eOKlYY9rmNI3j9K7rzNGLpjMdaLSK70f_OQBXx3VcXs00JrNDbd0Mw>
    <xme:eOKlYQtiUg3UWLa_vM2fycVb1C7L_rf82Z6bvS1FQamWa1CpifXxnGyqLNzqsALKz
    WQhpsHOQE7InlQ>
X-ME-Received: <xmr:eOKlYeD4rZNuf-C5TbCkgL_TQy2hqPF7_O32T9KF1di8X6oMViwy19k-bBVSis6etmDEWOU88UXat-zWZG0xvldL6g5Ikw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedtgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:eOKlYYejDyIxHbhf-TQS3MIzN2fTYWb09EQ2Uu2fbD7B0_Hqv7XXaA>
    <xmx:eOKlYdOuS5zb6uylTS-o5Fjh87NuSN2lJ-TbsK-EVgutAOOvNBKX3A>
    <xmx:eOKlYSmetTDS-eMITUOMd0iAva8IoJ9QvCN0p3O_Q8vRGfOgXTdgow>
    <xmx:eOKlYQeFFIblr_UZnIp97YtKoF1GAZu9ho0OeFSwHGDE0w0yKiDFKA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 Nov 2021 03:36:07 -0500 (EST)
Date:   Tue, 30 Nov 2021 10:36:02 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and query
 transceiver modules' firmware
Message-ID: <YaXicrPwrHJoTi9w@shredder>
References: <20211127174530.3600237-1-idosch@idosch.org>
 <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 09:37:24AM -0800, Jakub Kicinski wrote:
> On Sat, 27 Nov 2021 19:45:26 +0200 Ido Schimmel wrote:
> > This patchset extends the ethtool netlink API to allow user space to
> > both flash transceiver modules' firmware and query the firmware
> > information (e.g., version, state).
> > 
> > The main use case is CMIS compliant modules such as QSFP-DD. The CMIS
> > standard specifies the interfaces used for both operations. See section
> > 7.3.1 in revision 5.0 of the standard [1].
> > 
> > Despite the immediate use case being CMIS compliant modules, the user
> > interface is kept generic enough to accommodate future use cases, if
> > these arise.
> > 
> > The purpose of this RFC is to solicit feedback on both the proposed user
> > interface and the device driver API which are described in detail in
> > patches #1 and #3. The netdevsim patches are for RFC purposes only. The
> > plan is to implement the CMIS functionality in common code (under lib/)
> > so that it can be shared by MAC drivers that will pass function pointers
> > to it in order to read and write from their modules EEPROM.
> > 
> > ethtool(8) patches can be found here [2].
> 
> Immediate question I have is why not devlink. We purposefully moved 
> FW flashing to devlink because I may take long, so doing it under
> rtnl_lock is really bad. Other advantages exist (like flashing
> non-Ethernet ports). Ethtool netlink already existed at the time.

Device firmware flashing doesn't belong in devlink because of locking
semantics. It belongs in devlink because you are updating the firmware
of the device, which can instantiate multiple netdevs. For multi-port
devices, it always seemed weird to tell users "choose some random port
and use it for 'ethtool -f'". I remember being asked if the command
needs to be run for all swp* netdevs (no).

On the other hand, each netdev corresponds to a single transceiver
module and each transceiver module corresponds to a single netdev
(modulo split which is a user configuration).

In addition, users are already dumping the EEPROM contents of
transceiver modules via ethtool and also toggling their settings.

Given the above, it's beyond me why we should tell users to use anything
other than ethtool to update transceiver modules' firmware.

Also, note that an important difference from the devlink implementation
is that this mechanism is asynchronous, which allows the firmware on
multiple modules to be updated simultaneously.
