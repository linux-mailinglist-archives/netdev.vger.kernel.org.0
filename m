Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F053C87FA
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 17:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbhGNPxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 11:53:08 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35653 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239625AbhGNPxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 11:53:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 7063F5C017D;
        Wed, 14 Jul 2021 11:50:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 14 Jul 2021 11:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ipmtRU
        Igf3L0in0VPeRm8RyFb6KTk8DzNVYnk43l6F4=; b=XzleKI3T9tGTqYto49SUZ/
        0Ogn296RCdDA5VKZF67nQEYwHOkt/j8OvIr6/S3ykMz0lowucHMdM+VvBQWnQH9+
        JRJ+u/EW2zxx9WU8pakPxVGC1fQj1Dgz1SgDrBYJBw1N3BOQxa6WZIAG2yM2UqR4
        ILi3vg++owqKcd6pHHPXXrFUKu7+z0qniK7AUZtfD3rHHZSM5kkv1+zOH/k858YA
        f39ixV6fgIPFqvJ3NmRnzB2zGsuUqn3ZzSwgga2HN0NCiGD/itc68PhKHdNBAcQV
        /9rd79jqG2XUlJFjHwStxf2HRz4kPNCTE6+Nzsvb5qkOrRL+4JQR0X+4ghSbw2oQ
        ==
X-ME-Sender: <xms:twfvYFWsvCsKay1Iq4ha84H6YJNuo9sfYhFOek2bEX5LtfhoTDdp_w>
    <xme:twfvYFnae_6HWVw66hAqBM9RP7L6eC-L-5fBetlJuqBsLoKHNZQY84FY8IXI9X42h
    09V0Z8myf38G_U>
X-ME-Received: <xmr:twfvYBZGVBDiW8taH0jgjPlQ8p85LUgqVU1BwiIcuUf2cB2Dqvglm-HPOENlkzLskHGQ9X68cXL8xmrtFyl0kXUBGo07jQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekgdeltdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfgkeev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:twfvYIUHBaDGZBFVQxACPkUTOC5mwUC0_cuTet1TvjMfgku1akHvzQ>
    <xmx:twfvYPl1xSe1BwzHE3eFCMw8LLHFZ5d70XfA4qA4eKxrQQi4yfSqSA>
    <xmx:twfvYFeNg4eXLs2-jBdn4vVaamz9O84q5b-FJHar7i5JxJCE4CAT0Q>
    <xmx:twfvYKvxwW3TYqmACVbHQDNMaaQ_5-83WH8tafBRfG4G0p2fxjSwjA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Jul 2021 11:50:14 -0400 (EDT)
Date:   Wed, 14 Jul 2021 18:50:09 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: switchdev: Simplify 'mlxsw_sp_mc_write_mdb_entry()'
Message-ID: <YO8HsWjq0Y1S08Uj@shredder>
References: <fbc480268644caf24aef68a3b893bdaef71d7306.1626251484.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbc480268644caf24aef68a3b893bdaef71d7306.1626251484.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 10:32:33AM +0200, Christophe JAILLET wrote:
> Use 'bitmap_alloc()/bitmap_free()' instead of hand-writing it.
> This makes the code less verbose.
> 
> Also, use 'bitmap_alloc()' instead of 'bitmap_zalloc()' because the bitmap
> is fully overridden by a 'bitmap_copy()' call just after its allocation.
> 
> While at it, remove an extra and unneeded space.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

For net-next:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Note that net-next is closed [1] so you might need to re-submit, if it
does not open soon.

Thanks for the patch.

[1] http://vger.kernel.org/~davem/net-next.html
