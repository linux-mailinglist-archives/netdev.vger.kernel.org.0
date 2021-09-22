Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EB241419E
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 08:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbhIVGXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 02:23:41 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:57003 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232570AbhIVGXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 02:23:40 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 8EB733201CF8;
        Wed, 22 Sep 2021 02:22:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 22 Sep 2021 02:22:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FxOlqX
        be295nOShnbwm0vH+4KEHmjGRkKffE/LvQIG8=; b=B/uKbHU/4yHRmy8ekiRoYo
        y29eNFNK3C3MqHLZ/TpJHAe2tJP7was1/4rsbTMP0JXOhfp7eyWQAiMBPwkUalzP
        lNlg/VMlhTEuf/GZ+iWwGUW357FwnHbMFL8a1odtUOiAqyoArvAJ8uCdgQZ3e7L4
        YbS8sAeYxJ8QTObi4iKfWKybuHUUCzKkdy3Zftc3tqZZZwnhUtpozf+6zMj4YviH
        vaVGwxhPfjEpQN6mZMihhG/yhc63D6mLx+UVtKdTFUu34iBqm8fNwEyT0MCzUiCi
        Hvq/y5sTzv1DgW9xYlobhHZ2nhpcDuUNiHjVfJzfY5PFRUA/fb8gg7EdEo5MXOgg
        ==
X-ME-Sender: <xms:kctKYYlTbXyUEWhXxgnbAJKwzXAoauQ5Pp9GF3mns1-cZEcnT-mtJA>
    <xme:kctKYX3D20vHMdOHDH-3opUa7dnlT3oGD9w2zC_YB53hETvwcxcD2YwmeePldzj8R
    rF4wroRDh8DNQE>
X-ME-Received: <xmr:kctKYWri0FKGOViCtNkz0u7GsVUXt6_DVOMJgpmJOmCb8FMGVDMwMO-kXgUVCrfz1oa4CBDBR4VYwQqrCoiFW3SNNHNCBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiiedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:kctKYUkP99iOdwA7vV70_zpMp7duypnGQW9HuJO7Rx_Ov7XF-I1bDQ>
    <xmx:kctKYW3cfPo64an5WdAI5FAfRi3GgQYDRUXqNGsn9Uuyko60W_Bf6Q>
    <xmx:kctKYbtklhBX49WPf6wC2F1-loEhSG5OgHbN_VWifgUqOFHaM_41sQ>
    <xmx:kstKYQqt6lfSuI-vuA9J7knt4heRYYZOyapQa09PZ2qlTRmZd_A_AQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Sep 2021 02:22:08 -0400 (EDT)
Date:   Wed, 22 Sep 2021 09:22:04 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <YUrLjGJwMc/UpqOK@shredder>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
 <20210903151436.529478-2-maciej.machnikowski@intel.com>
 <YUnbCzBOPP9hWQ5c@shredder>
 <PH0PR11MB4951E98FCEC0F1EA230BA1DAEAA19@PH0PR11MB4951.namprd11.prod.outlook.com>
 <YUny/edqnbdTFnBS@shredder>
 <20210921141445.24ae714e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921141445.24ae714e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 02:14:45PM -0700, Jakub Kicinski wrote:
> On Tue, 21 Sep 2021 17:58:05 +0300 Ido Schimmel wrote:
> > > > The only source type above is 'port' with the ability to set the
> > > > relevant port, but more can be added. Obviously, 'devlink clock show'
> > > > will give you the current source in addition to other information such
> > > > as frequency difference with respect to the input frequency.  
> > > 
> > > We considered devlink interface for configuring the clock/DPLL, but a
> > > new concept was born at the list to add a DPLL subsystem that will
> > > cover more use cases, like a TimeCard.  
> > 
> > The reason I suggested devlink is that it is suited for device-wide
> > configuration and it is already used by both MAC drivers and the
> > TimeCard driver. If we have a good reason to create a new generic
> > netlink family for this stuff, then OK.
> 
> For NICs mapping between devlink instances and HW is not clear.
> Most register devlink per PCI dev which usually maps to a Eth port.
> So if we have one DPLL on a 2 port NIC mapping will get icky, no?

Yes, having to represent the same EEC in multiple devlink instances is
not nice.

> 
> Is the motivation to save the boilerplate code associated with new
> genetlink family or something more? 

I don't mind either way. I simply wanted to understand the motivation
for not using any existing framework. The above argument is convincing
enough, IMO.
