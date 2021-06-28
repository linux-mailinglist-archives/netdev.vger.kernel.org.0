Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7403B59D2
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 09:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhF1Hg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 03:36:29 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:37325 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232415AbhF1HgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 03:36:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id CAE0E580563;
        Mon, 28 Jun 2021 03:33:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 28 Jun 2021 03:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ntdq4y
        gMPnixY9DYrZhapTgZXq2nZ2pxOMHsssk055w=; b=tb2rJVNYQHhBFtT8ODFLuK
        cKIBEkYRxEcXSfWtiAHMIt5KpVJu2UoOmeNK4jAR7xdk8QI/4WiyJr5im1eGvicE
        XwcL7JxOenEWNkWEKeV/uod+HFLuZaTDI7chscbQb2so8TDk0/9VDLJ5QgSSWjZe
        pu3JZv6+Tlm6/HMo7OqwZhQ+3d+rZ4Tlkd9v8W2UEj7KctUI3b7xmKccB2tRUbrY
        gT0ejmrmZtY3LLujtXEAiN/Hx09JzERa19s0Vxvg11s15SxkBeaR4eQq/ti7FUIo
        MIjahaif04OG6FYs4qnw7vct33vupJL7OyWs0vSQ3gQr/ER8MBF0WdVo2JOYyAKw
        ==
X-ME-Sender: <xms:ZnvZYOclUKjPVLrLHM3lDcImwT6vAfUbtHDzDFa2_6GXqK44lq4EKw>
    <xme:ZnvZYIPJFzc-6_bvsxVPptk3n22k790ShrMuBV2-rgueP2ZdZMEiOfhv7yOvlBRLV
    HziDaO7_bdmoxU>
X-ME-Received: <xmr:ZnvZYPjWUCo3JSt4gIHj0nxm1CwGEs_wTGUNV9RoKzW-PSUIY-d5Xi7BxOZF5bgv4KCDRm-mdv74IMEQY_gN6Feh-wmT8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehfedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZnvZYL_DESdDp3lIBb-IJtU9aIPFSd4rfqShZq1s4Jq6bN5GUCQ5fg>
    <xmx:ZnvZYKu2xer7U9rGLiOWnAQXJbHLvk9ID0VgbYdw-CX4TgUIC1bQiA>
    <xmx:ZnvZYCEF18j2xm4cJzzwu8p0-dfuhyvBP77wZDPOqf3WwbDDunS3EA>
    <xmx:Z3vZYIBtQwALR73p-y8mv9X0NW7m90127QGSpGfiUesdQuQ7u7F06Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Jun 2021 03:33:58 -0400 (EDT)
Date:   Mon, 28 Jun 2021 10:33:54 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to write to
 transceiver module EEPROMs
Message-ID: <YNl7YlkYGxqsdyqA@shredder>
References: <20210623075925.2610908-1-idosch@idosch.org>
 <YNOBKRzk4S7ZTeJr@lunn.ch>
 <YNTfMzKn2SN28Icq@shredder>
 <YNTqofVlJTgsvDqH@lunn.ch>
 <YNhT6aAFUwOF8qrL@shredder>
 <YNiVWhoqyHSVa+K4@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNiVWhoqyHSVa+K4@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 27, 2021 at 05:12:26PM +0200, Andrew Lunn wrote:
> This API is not just about CMIS, it covers any I2C connected SFP
> device. I'm more involved in the lower end, 1G, 2.5G and 10G. Devices
> in this category seem to be very bad a following the standards. GPON
> is especially bad, and GPON manufactures don't seem to care their
> devices don't follow the standard, they assume the Customer Premises
> Equipment is going to run software to work around whatever issues
> their specific GPON has, maybe they provide driver code? The API you
> are adding would be ideal for putting that driver in user space, as a
> binary blob. That is going to make it harder for us to open up the
> many millions of CPE used in FTTH. And there are people attempting to
> do that.
> 
> If devices following CMIS really are closely following the standard
> that is great. We should provide tooling to do firmware upgrade. But
> at the same time, we don't want to aid those who go against the
> standards and do their own thing. And it sounds like in the CMIS
> world, we might have the power to encourage vendors to follow CMIS,
> "Look, firmware upgrade just works for the competitors devices, why
> should i use your device when it does not work?"
> 
> I just want to make sure we are considering the full range of devices
> this new API will cover. From little ARM systems with 1G copper and
> FTTH fibre ports through to big TOR systems with large number of 100G
> ports.  If CMIS is well support by vendors, putting the code into the
> kernel, as a loadable module, might be the better solution for the
> whole range of devices the kernel needs to support.

If the goal is to limit what user space can do, then putting all the
code in the kernel and adding an ever-growing number of restrictive user
APIs is not the only way.

Even with the proposed approach, the kernel sits in the middle between
the module and user space. As such, it can maintain an "allow list" that
only allows access to modules with a specific memory map (CMIS and
SFF-8636 for now) and only to a subset of the pages which are
standardized by the specifications.
