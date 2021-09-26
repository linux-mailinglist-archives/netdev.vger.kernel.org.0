Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00AE41899F
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 16:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhIZO56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 10:57:58 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:44631 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231849AbhIZO55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 10:57:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5A6CC580E5A;
        Sun, 26 Sep 2021 10:56:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 26 Sep 2021 10:56:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1SwiLo
        0OKzrgae4gARfd9XtQ8Pfr/C7RtDkZYQvq+Zg=; b=KBG2mbIWFypeGTDA9ukwZC
        Savr3ve9ghFgzW+47++suGkjfTn8IUgdskA1e1Fmq+2Zq65GqH8vzvr/rp1w4zuF
        WHyhzfZbYSwjgTImHz0ce55HU9h0rf0nI8lt+Xu6oLVTSUN+ZJdFlq3gZouTev6v
        AZ50bV6l9xWh7R5PropJfcGY0I+40wasmcYkVCSl1fo6oGkEmmCGuSEYR3sMKkjt
        S/WBzvQ4to7Ythk3Y+qj2OuS5EqRs8U8qfPDccFDg10R98P11jm0ThngMC0bWnRr
        pT4oRUoxf4oztch6dNt4h3oiK2AIOib/gA49p0WDrMSSBDspfP54i03xpTpWCklg
        ==
X-ME-Sender: <xms:EopQYZuKY-wnuTHI3n3YNNlj836zAWFflpNAqplVMrOL5Y2tNxWHkg>
    <xme:EopQYSdiw41V7repoJJNFKpvgH4U2aBdDU5Pj0MNb3GrPksmrsPyf-jGHw2tJVSkB
    gd1N5HMqXap-Yw>
X-ME-Received: <xmr:EopQYcwstCsOU4Z_p68cMIlcEMb3hVnYwslc6YfFWgOB93fhDAaFtaha-7si25STMNqTY_HRq0425NLsRqbHBICeGlzqhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudejiedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:EopQYQPH6fS_kSAXkwpoRrga7m7P7o_kMYSgUegnKfpcyPV56t8etQ>
    <xmx:EopQYZ8yXp1UBxlU1AWoyJrpuNoSGVm1Egd65OrtWZqGjWYuSr1yMA>
    <xmx:EopQYQUEEbB_HClKbhfwf5wQ4Cqon53BsD1txQrhSArqcRAjYdcKKA>
    <xmx:FIpQYeYCbRFkSd5u4Mh_xIjItI9js46gZfOLDMA8h_Pobpt2EHM_sA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 26 Sep 2021 10:56:17 -0400 (EDT)
Date:   Sun, 26 Sep 2021 17:56:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v1 11/21] mlxsw: core: Register devlink instance
 last
Message-ID: <YVCKDR1pyHaH2sR5@shredder>
References: <cover.1632565508.git.leonro@nvidia.com>
 <ca198a30949abb3bdf283ff87e6e718be355d0cf.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca198a30949abb3bdf283ff87e6e718be355d0cf.1632565508.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 02:22:51PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Make sure that devlink is open to receive user input when all
> parameters are initialized.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
