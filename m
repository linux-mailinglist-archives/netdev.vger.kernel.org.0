Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1807321ED02
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgGNJgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:36:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59361 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbgGNJgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 05:36:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 044095C0158;
        Tue, 14 Jul 2020 05:36:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 05:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ikp6IE
        9N1Xr46q5bU05QaviFnf+U/vK1Pwzbeox1CaY=; b=juo9EVQAOypmGYCFhp1QoT
        DTEMxgrf4n1cR0nG6Pr+641n41oQYvy5v7/BoUbv7S0E+DZzhILmW0qyO1OE9fXZ
        uk03BdZ8t+l3aGC6uPt5EGpY2NK5+NG4mFBDXX+EkZ7mWrv0cyXGQG8BuV9VMXtF
        Re2WNs/i0gKIG2/TdVf4LE9zGa4d8DUSXZZBk90byTZbSBFnYg+5snx2gLLt6zHn
        2oWPWD642OHJofRXX0/1w4mDTn0ieXeiWXAqIGY1qX8Kj2z5aS0hf3gjZVXk/aBx
        0F2IA6aqpxsQjEHVI6oFUaXQi0T8LxisvoymoHY2uWPnzWZsKC1OgmF60WKtqfLQ
        ==
X-ME-Sender: <xms:n3wNX7QMlr56-Ng-RV56l1s70DxTOZeChbhVfhwEcD3pOubxEL1IEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecuogfuuhhsphgvtghtffhomhgrihhnucdlgeelmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephedutdegkeevveettedvteeuveegjeffteekffffhfdvgedugeejteeuvedvteek
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghdprghpphhsphhothdrtghomhenucfkph
    epuddtledrieeirdduledrudeffeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:n3wNX8w8MwuZU-2v2XiriVvx9wTiOdvxcCi3aTRdUu10QH_fOgQLcQ>
    <xmx:n3wNXw2D4LiHuUZWz47oQrLJs6y9-mSysHgqk2ayjI-dNYWKNFQufA>
    <xmx:n3wNX7DmNMgTbJfvOLqkqVHaqcNu8rbFqZwjoCxnkHGzZ4PyhL5Vyg>
    <xmx:oHwNX3uLMswQwNL0idO_LFJwQ_Ftfmf_0pAlQh_ZhGRDCHlGgDrb5w>
Received: from localhost (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 311E03280059;
        Tue, 14 Jul 2020 05:36:31 -0400 (EDT)
Date:   Tue, 14 Jul 2020 12:36:28 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     syzbot <syzbot+dd0040db0d77d52f98a5@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in devlink_health_reporter_destroy
Message-ID: <20200714093628.GA274556@shredder>
References: <000000000000dd436905aa5a9533@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000dd436905aa5a9533@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 03:55:21PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    71930d61 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10c8d157100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4c5bc87125719cf4
> dashboard link: https://syzkaller.appspot.com/bug?extid=dd0040db0d77d52f98a5
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1421cd3f100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ccfe4f100000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+dd0040db0d77d52f98a5@syzkaller.appspotmail.com

#syz fix: devlink: Fix use-after-free when destroying health reporters
