Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB3F432521
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhJRRgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:36:14 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:33455 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234141AbhJRRgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 13:36:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6AF10320157F;
        Mon, 18 Oct 2021 13:34:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Oct 2021 13:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UzKObu
        pR1nGbqgeiPXiDKZcY67QhbGnTmQUMpYRjjlc=; b=Q5pYx6dSeB4gK/vgq287gm
        ovSJIHCjvdV7zp9Se4XdzUzJFJ/rdnjMsamkyNGTJoQ1zJSg4CKn9RdYbpp9U6/D
        JGfxB2mpQuQTIihB9mzs84VMSvL2T+sNaTnrurwxNLf8+6Ob72qZOj+CMQLPdSFZ
        BgLveUrc4jIgj3AkTa7w12Zp7/mwXO5PrMJEsaT6twDTLifhPcqZSR5/01K2bKes
        9EvdEUfZ9ZriSDemPLBwfgB+yTEAlxagV9Y3qxNrhuRZclVJwmI27nfQc0DqgHD8
        ExkZxUkMzZ/MMNKnOzUJHfEMOpjpUfnBjc2uLiQoOKahZwgft80W20LMQCVFjCVQ
        ==
X-ME-Sender: <xms:CLBtYXRyCOZY3oFH8bf83Caf1lOaRR14eYAS-XtH5Lx8GYPeLG15EQ>
    <xme:CLBtYYwPU-uR3icG7WjGd58Wf-dzRTk6BlH7AZn5F0d1RXLgGpuis-h74ag8fAmMW
    rIZ7_VTcbJIKVA>
X-ME-Received: <xmr:CLBtYc2-xYawu1WsksNzKiYKwiNLupVLq29scA9ksKNNFnG9gWAtgbNy7kZc5RfIrh33Oe3nsvC8tUea0Ncn9-XHHj8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvtddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfg
    keevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CLBtYXDXffujbCFzxO28C-wrVEOq8mNgU1TYdV7KvAXE9X4ubYxXmw>
    <xmx:CLBtYQgfpxugb6ILKBuxTwKFVuPZkzG5ukopSxPIO7ogbAcFTP8-uA>
    <xmx:CLBtYboCUPjzSgEVq6f2yZKxl5pv1ZRzewV4Rb6C9e2BxcrOKJ8OAA>
    <xmx:CbBtYaatOPzkpCKrXEeLzD-x6UutszdX3tpOD6vBz_0mqodB5r3Cww>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Oct 2021 13:34:00 -0400 (EDT)
Date:   Mon, 18 Oct 2021 20:33:56 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vkochan@marvell.com, tchornyi@marvell.com
Subject: Re: [RFC net-next 3/6] ethernet: prestera: use eth_hw_addr_set_port()
Message-ID: <YW2wBJ7yoUaLkYVv@shredder>
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-4-kuba@kernel.org>
 <186dd3ec-6bab-fe3c-cbab-a54898d51f57@pensando.io>
 <20211018071915.2e2afdd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6dc4c0b4-8eaa-800a-a06c-a16cbee5a22e@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dc4c0b4-8eaa-800a-a06c-a16cbee5a22e@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 09:26:21AM -0700, Shannon Nelson wrote:
> On 10/18/21 7:19 AM, Jakub Kicinski wrote:
> > On Sat, 16 Oct 2021 14:19:18 -0700 Shannon Nelson wrote:
> > > As a potential consumer of these helpers, I'd rather do my own mac
> > > address byte twiddling and then use eth_hw_addr_set() to put it into place.
> > This is disproved by many upstream drivers, I only converted the ones
> > that jumped out at me on Friday, but I'm sure there is more. If your
> > driver is _really_ doing something questionable^W I mean "special"
> > nothing is stopping you from open coding it. For others the helper will
> > be useful.
> > 
> > IOW I don't understand your comment.
> 
> To try to answer your RFC more clearly: I feel that this particular helper
> obfuscates the operation more than it helps.

FWIW, it at least helped me realize that we are going to have a bug with
Spectrum-4. Currently we have:

ether_addr_copy(addr, mlxsw_sp->base_mac);
addr[ETH_ALEN - 1] += mlxsw_sp_port->local_port;

As a preparation for Spectrum-4 we are promoting 'local_port' to u16
since at least 257 and 258 are valid local port values.

With the current code, the netdev corresponding to local port 1 will
have the same MAC as the netdev corresponding to local port 257.

After Jakub's conversion and changing the 'id' argument to 'unsigned
int' [1], it should work correctly.

[1] https://lore.kernel.org/netdev/20211018070845.68ba815d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
