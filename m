Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19476408785
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbhIMIwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:52:14 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:52817 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235987AbhIMIwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 04:52:13 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id B658D580B05;
        Mon, 13 Sep 2021 04:50:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 13 Sep 2021 04:50:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oEBMjG
        HbxkehBrxFgJqADlnGq31HX2RE4tw3YGcGOxo=; b=f35bXpQY4Dkcqm2P7Tp3sF
        uumChSSx8jFh7qOKyLaxeRTr5e0PSckEp04xgcGNXxkxo4AXRXZeFmCoXwSoS8zz
        ps5NQYIakD6Owa0YnOvN89SO75qvV1qQEzEP233A380UH2+jdxA0iUHv/q98oslE
        wcvd+rn1QtAZvPk/G7NxK25CrK/ivKKTR/ybuQYEmGlMYMBEqugBi0IPuSRieYBn
        tQVMZ0hzLKK5x36ORsDFEbTiKI1zIhfuAC6RV4g2/QRRFPNGDkqX3UtDih5krgLm
        o28yvTFXn5W/iOGBryVWdSWM3Ne2aoAWqBq9Nm5uWQGCa81yQZ/NpTBMba1fygeg
        ==
X-ME-Sender: <xms:7xA_YRDbnwoIwg1Mkok3tynI4u6_OZb2oZANpU-hMY04g1FcCDMcHg>
    <xme:7xA_YfjBlj_R4JgSeJ_J4oEtCbVeYIf4UN2G_EYZtte6XV9g2r8GE3vG6J2rvNcPR
    t5FouFOJPXkDf0>
X-ME-Received: <xmr:7xA_Ycm-dV0Z4DqdBDA44yjluaAo9IRItj0kgiIJzxSwuJQ2NLLD9HaWuvc4odd4srNbfKa0wGNCo7KZVD41fmhBZSMOMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegjedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:7xA_Ybw9uggka_pKgpmH_Ezv20W9TEz1eM9dqYTKIblStIMy018Z0Q>
    <xmx:7xA_YWT1VjigWlHdo9Atx-hTkQxxmDMQvLhEvhOaJmgVULCEGOWyBg>
    <xmx:7xA_YebvlI4FxCy66gU5jxA7JHZ1C_tW5Y-n3jImh_csP77blIGwFA>
    <xmx:8RA_YSbIfpC1B94dnYQ_r5KoDOw950dNMBzVAhXwys3VXemZ0CrDKQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Sep 2021 04:50:55 -0400 (EDT)
Date:   Mon, 13 Sep 2021 11:50:51 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <YT8Q6yWQGt0/B2iy@shredder>
References: <PH0PR11MB4951623918C9BA8769C10E50EAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 09:21:15AM -0700, Jakub Kicinski wrote:
> Mumble, mumble. Ido, Florian - any devices within your purview which
> would support SyncE? 

Sorry for the delay, was AFK. I remember SyncE being mentioned a few
times in the past, so it is likely that we will be requested to add
SyncE support in mlxsw in the future. I will try to solicit feedback
from colleagues more familiar with the subject and provide it here next
week.
