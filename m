Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB012E77DC
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 11:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgL3Kuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 05:50:51 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:54743 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgL3Kuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 05:50:51 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 0D7F39AF;
        Wed, 30 Dec 2020 05:49:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 30 Dec 2020 05:49:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YDHFjg
        vHwzkhjLyFLCWnqvCXL3fYINzbOxnJ/e3Y7Rw=; b=In2x+CzY/aIHD944haER51
        lhkBkUECBEfj+fTfj1s9G+IFC2rD3DeTq/dOIJpobmS8sknfgjo1CVKMQOZCZ4PG
        wFg3qgqirtnM9pmWlyHZbdtaFkEB4cpRRqhpCW8lQHG07SqhY5Isb2BfgESeFJZ0
        yWHeaZPtdfwle9oiKCOYlAoZAM/2kamzYL3H2eOVFaqHEr4qVw4Nam4jGbpacuEd
        qDsYTAtCrdZxCy3Y9UV7PcP9DEGHUfdL/xDMar/dY+YxGMiSrkovfHABwIA1DwR/
        0mTqifwrxL1JPOkn4uC0KjM9aTgQXRRf4sOKcnmkFnHbZ/BNiKEmNQ0lL0sxKZzw
        ==
X-ME-Sender: <xms:R1vsX0OEW9PiJKzStrdkxhut-i0d7ciI5lGrsADxMuqEfZO1e3tjCQ>
    <xme:R1vsX6-ehYaPvOED-ODQybmYKEQzrW9bc1rrTMcL9-L2etwuAncJVFUH0OmadV6jx
    jnRvTW-bY3IiSk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddvfedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffheeuvdehuefgvdethfeuveegveevieevieejvdeujefftedvleekueelledv
    keenucffohhmrghinheplhhipheirdhfrhenucfkphepkeegrddvvdelrdduheefrdegge
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiugho
    shgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:R1vsX7QiKlbUARMVNGFjwJv2TeeWrI9RLxUOnfljb2mCFmvAe96Hjw>
    <xmx:R1vsX8vq8eUShw8i2mieQ8xnA4NMIHPkepHinptXBUfy_a5SrAp_OA>
    <xmx:R1vsX8ceW_oNNM4LKYtj-9yw3bzqi-CI3tB1ScobL1zVr_0Q24Xq9g>
    <xmx:SFvsX9qdaqY1dnKubhvJ3DXZ1TLVLHwWQ4lUZEg6aDGQRtl9f0kP6w>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5400F24005B;
        Wed, 30 Dec 2020 05:49:43 -0500 (EST)
Date:   Wed, 30 Dec 2020 12:49:40 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlxsw@nvidia.com
Subject: Re: [PATCH net-next] net/mlxfw: Use kzalloc for allocating only one
 thing
Message-ID: <20201230104940.GA386343@shredder.lan>
References: <20201230081835.536-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230081835.536-1-zhengyongjun3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 04:18:35PM +0800, Zheng Yongjun wrote:
> Use kzalloc rather than kcalloc(1,...)
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> @@
> 
> - kcalloc(1,
> + kzalloc(
>           ...)
> // </smpl>
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks
