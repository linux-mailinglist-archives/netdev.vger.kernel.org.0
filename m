Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304B44DA39A
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242723AbiCOT7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351691AbiCOT5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:57:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EEC5623E
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 12:56:08 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 972EF1F38C;
        Tue, 15 Mar 2022 19:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647374167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CVdE+h2wM6DyrenDVxZtt5mIU9OuSJm8HvfZs4z33jU=;
        b=EI/hjGm9FkAL3PkGWZ54p3jXw4bKmeUrHEnHItTKty+8SSZC/S6ydtCtYOwqbM5yiZwSWB
        4vpygbGj4GdYWuLMQyfJfKeUEVqQd6Zk0uQeURLfNka6DY4V3J2WpStiBsLnPPmSbxa97+
        MtZYenZtIvNAm01Zw8+u+9JWS1YyPuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647374167;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CVdE+h2wM6DyrenDVxZtt5mIU9OuSJm8HvfZs4z33jU=;
        b=EjK2mJEYcHOC01iUBXM5EsLbxxUs+z+1iRj+IoDww85ZPR3j+CKcZSri4wyzgEPdB1JwYj
        SWTjqAe8NWg4jUDA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 23209A3B89;
        Tue, 15 Mar 2022 19:56:06 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C21DB602FD; Tue, 15 Mar 2022 20:56:06 +0100 (CET)
Date:   Tue, 15 Mar 2022 20:56:06 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jie Wang <wangjie125@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, huangguangbin2@huawei.com,
        lipeng321@huawei.com, shenjian15@huawei.com, moyufeng@huawei.com,
        linyunsheng@huawei.com, tanhuazhong@huawei.com,
        salil.mehta@huawei.com, chenhao288@hisilicon.com
Subject: Re: [RFC net-next 1/2] net: ethtool: add ethtool ability to set/get
 fresh device features
Message-ID: <20220315195606.ggc3eea6itdiu6y7@lion.mk-sys.cz>
References: <20220315032108.57228-1-wangjie125@huawei.com>
 <20220315032108.57228-2-wangjie125@huawei.com>
 <20220315121529.45f0a9d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xpblcuxtmltbzx3n"
Content-Disposition: inline
In-Reply-To: <20220315121529.45f0a9d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xpblcuxtmltbzx3n
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 15, 2022 at 12:15:29PM -0700, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 11:21:07 +0800 Jie Wang wrote:
> > As tx push is a standard feature for NICs, but netdev_feature which is
> > controlled by ethtool -K has reached the maximum specification.
> >=20
> > so this patch adds a pair of new ethtool messages=EF=BC=9A'ETHTOOL_GDEV=
FEAT' and
> > 'ETHTOOL_SDEVFEAT' to be used to set/get features contained entirely to
> > drivers. The message processing functions and function hooks in struct
> > ethtool_ops are also added.
> >=20
> > set-devfeatures/show-devfeatures option(s) are designed to provide set
> > and get function.
> > set cmd:
> > root@wj: ethtool --set-devfeatures eth4 tx-push [on | off]
> > get cmd:
> > root@wj: ethtool --show-devfeatures eth4
>=20
> I'd be curious to hear more opinions on whether we want to create a new
> command or use another method for setting this bit, and on the concept
> of "devfeatures" in general.

IMHO it depends a lot on what exactly "belong entirely to the driver"
means. If it means driver specific features, using a private flag would
seem more appropriate for this particular feature and then we can
discuss if we want some generalization of private flags for other types
of driver/device specific parameters (integers etc.). Personally, I'm
afraid that it would encourage driver developers to go this easier way
instead of trying to come with universal and future proof interfaces.

If this is supposed to gather universal features supported by multiple
drivers and devices, I suggest grouping it with existing parameters
handled as tunables in ioctl API. Or perhaps we could keep using the
name "tunables" and just handle them like any other command parameters
encoded as netlink attributes in the API.

Michal


>=20
> One immediate feedback is that we're not adding any more commands to
> the ioctl API. You'll need to implement it in the netlink version of
> the ethtool API.

--xpblcuxtmltbzx3n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmIw708ACgkQ538sG/LR
dpWCoQgA0Q5YOr++Lebl3n/kF9YYxGQmNesJHsdve5R4Ol6L/SQ9Wzs9B09njcAi
B77Oy5ewbQg1XAH9VATqnLtfIdFI6W+W64QxNlAfu8+G3HYtrYEuBKVUYL7NKfpp
9++UZqizc1DbBo4g0h7zIrgzf8xG7FiPUstkSLIMlWuxyCowfkTjSNYTM7Odt7Dq
vGUhPIvTzzsRgw4obxm2oHbG+0c07SmHG1PX3VEEeskWjo7YCzk7+8QjNZsDVr3r
CgJ2faJxVxjj3+AUoBA6hSB1TTcGT+dGIhnAbvRxaAAxOZ92wQt74wpq4+YmTC6V
Hq3CUmWLe22NsbLn4mADd0iAa2DaQw==
=A1Ho
-----END PGP SIGNATURE-----

--xpblcuxtmltbzx3n--
