Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EDA4390D9
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhJYIK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:10:28 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33943 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230106AbhJYIK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:10:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A0EB85C01B1;
        Mon, 25 Oct 2021 04:08:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 25 Oct 2021 04:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/EGMzK
        IqVEykGMMra2oqezoDiZcJLEYHn1cr/vpfo88=; b=dfyYZeh8EvjZ3TOML+jqQA
        1ouYRlY0XO7VJXuwV8zLlhrD8qiabmXNdxi6tjxm6BKkeNKyF8J3l12maWleh/SM
        zcfzaMjuOmqnjcW2bwYbsA8IJOOaiVoNBQlGnIa8Y29wkllHiU3AuwWIIZoZIHkA
        E6G77grMxnQPU47yGqwr7ncvvWVn4MWPrem4qjdtjVX3i+Ga7jMa6HX1Pn2zQqiv
        id18xG183xTXkI3KOJCeiyDsVJJLUtPzXDGZuS119Yuq6AbPHAmLa5qKeVQB69Bx
        Gc2s7VK22X7KGBb+ZWrgqZpL/Tt5ZL/a1caHmiwgnre4MNnJQrmP+GmFAhF3yFbg
        ==
X-ME-Sender: <xms:5WV2Yf0mCAEtmzltYVSqKW8ucZx4t6OPWcDAkeFE_h1n9iqHYqXn3Q>
    <xme:5WV2YeEDsmIJrS-E6E79kxRzmLlfHK27XC4Y2lx5qw6VYLYutXshGQpLGsxpdjzgM
    SfsrAA8Yrndweg>
X-ME-Received: <xmr:5WV2Yf4kFJ7dkohTiMJ4nZvPhZBqKGkB5_Hd9lO3BSsFjldtIVgIrFjn53i-dHw3uBpamvm1hX9ldfwhAeY-tzcrGn0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefgedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:5WV2YU1g2wobWaV3m2B2DyjshIP7M9LgXafUiOFpdb8TViy8gEgonw>
    <xmx:5WV2YSHzLIEloMOy-j14a1IyU9Nf2NavHGazYcdl6saRYT5_Hfw4zg>
    <xmx:5WV2YV_H5aMu2EDTm6eFFeuMu6M7NSLYtCbhdh_zvAPuSesLGTfV6w>
    <xmx:5WV2YfNvqzQcVqiPxY5r7zB_VVZHYx6kfYVXxLxZF6DxDJua6grWFg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Oct 2021 04:08:04 -0400 (EDT)
Date:   Mon, 25 Oct 2021 11:08:00 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXZl4Gmq6DYSdDM3@shredder>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <YXUtbOpjmmWr71dU@unreal>
 <YXU5+XLhQ9zkBGNY@shredder>
 <YXZB/3+IR6I0b2xE@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXZB/3+IR6I0b2xE@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 08:34:55AM +0300, Leon Romanovsky wrote:
> On Sun, Oct 24, 2021 at 01:48:25PM +0300, Ido Schimmel wrote:
> > On Sun, Oct 24, 2021 at 12:54:52PM +0300, Leon Romanovsky wrote:
> > > On Sun, Oct 24, 2021 at 12:05:12PM +0300, Ido Schimmel wrote:
> > > > On Sun, Oct 24, 2021 at 11:42:11AM +0300, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > 
> > > > > Align netdevsim to be like all other physical devices that register and
> > > > > unregister devlink traps during their probe and removal respectively.
> > > > 
> > > > No, this is incorrect. Out of the three drivers that support both reload
> > > > and traps, both netdevsim and mlxsw unregister the traps during reload.
> > > > Here is another report from syzkaller about mlxsw [1].
> > > 
> > > Sorry, I overlooked it.
> > > 
> > > > 
> > > > Please revert both 22849b5ea595 ("devlink: Remove not-executed trap
> > > > policer notifications") and 8bbeed485823 ("devlink: Remove not-executed
> > > > trap group notifications").
> > > 
> > > However, before we rush and revert commit, can you please explain why
> > > current behavior to reregister traps on reload is correct?
> > > 
> > > I think that you are not changing traps during reload, so traps before
> > > reload will be the same as after reload, am I right?
> > 
> > During reload we tear down the entire driver and load it again. As part
> > of the reload_down() operation we tear down the various objects from
> > both devlink and the device (e.g., shared buffer, ports, traps, etc.).
> > As part of the reload_up() operation we issue a device reset and
> > register everything back.
> 
> This is an implementation which is arguably questionable and pinpoints
> problem with devlink reload. It mixes different SW layers into one big
> mess which I tried to untangle.
> 
> The devlink "feature" that driver reregisters itself again during execution
> of other user-visible devlink command can't be right design.
> 
> > 
> > While the list of objects doesn't change, their properties (e.g., shared
> > buffer size, trap action, policer rate) do change back to the default
> > after reload and we cannot go back on that as it's a user-visible
> > change.
> 
> I don't propose to go back, just prefer to see fixed mlxsw that
> shouldn't touch already created and registered objects from net/core/devlink.c.
> 
> All reset-to-default should be performed internally to the driver
> without any need to devlink_*_register() again, so we will be able to
> clean rest devlink notifications.
> 
> So at least for the netdevsim, this change looks like the correct one,
> while mlxsw should be fixed next.

No, it's not correct. After your patch, trap properties like action are
not set back to the default. Regardless of what you think is the "right
design", you cannot introduce such regressions.

Calling devlink_*_unregister() in reload_down() and devlink_*_register()
in reload_up() is not new. It is done for multiple objects (e.g., ports,
regions, shared buffer, etc). After your patch, netdevsim is still doing
it.

Again, please revert the two commits I mentioned. If you think they are
necessary, you can re-submit them in the future, after proper review and
testing of the affected code paths.

Thanks
