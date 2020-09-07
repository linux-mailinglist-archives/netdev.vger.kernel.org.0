Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100BF26034F
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgIGRrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:47:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56358 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgIGRrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 13:47:13 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200907174711euoutp0152f3784ebeaa24512507411d323f7232~ykYgyymTX0317703177euoutp01E;
        Mon,  7 Sep 2020 17:47:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200907174711euoutp0152f3784ebeaa24512507411d323f7232~ykYgyymTX0317703177euoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599500831;
        bh=2f3Zlbb9MfhG3U2/hoCNyDLjCAD54iZz9Q/qF4M3Xus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZbOtOvAL1C8e8VMwvoFqv3ZPMAyEyAzYfKw//6sEB5r2fC4Etmsc5FCfe73QfN/M
         UqNJlErmQWNgfpyhjEYB4cVWnmfqyqAR1rm9fwa2lAgjrsT+si0Oeo67SFIvbtPRpY
         9+CESvRobfjRQ/XJWD4ubRodtRE6DQtwlQzPAeOg=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200907174710eucas1p1f644e6cc129e68610510e4cf2cd0fecd~ykYf7JaP-1825918259eucas1p1Q;
        Mon,  7 Sep 2020 17:47:10 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id BF.5D.05997.E12765F5; Mon,  7
        Sep 2020 18:47:10 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200907174710eucas1p1b06f854222c255719a63c72b043ecda2~ykYfaKHxg0045100451eucas1p1u;
        Mon,  7 Sep 2020 17:47:10 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200907174710eusmtrp2df84bfd6bc6cb18b9d95329bfb255928~ykYfZdNEG2165721657eusmtrp2T;
        Mon,  7 Sep 2020 17:47:10 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-12-5f56721e4ded
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 34.54.06017.E12765F5; Mon,  7
        Sep 2020 18:47:10 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200907174710eusmtip2e0d48ef0a4bfc9c6fa84403036f23177~ykYfN4YTR0136101361eusmtip2J;
        Mon,  7 Sep 2020 17:47:10 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list\:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Date:   Mon, 07 Sep 2020 19:47:09 +0200
In-Reply-To: <CAMuHMdWNdMEnSnLRkUkRmLop4E-tnBirjfMw06e_40Ss-V-JyQ@mail.gmail.com>
        (Geert Uytterhoeven's message of "Wed, 26 Aug 2020 09:13:14 +0200")
Message-ID: <dleftjo8mhqy1u.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+3bO2Y7L2XFmvSyRWkY3dFmZx250Aw+ZIAUWQq1VBzW3KZt2
        8R+ttFIqwwxzTqemXSzNpiy1ZrZMMS8zZmFRdNEyL2WkRYZd3D6D/vt97/c8z8vz8dGE9Dsl
        o2O1ibxOq1LLhWLS0jze6e+ri1QuaxhWsPZXNoK9fekWxRrtaSRrauqk2A8vrAI2q3eIYO32
        KhHbZTlHsebeZxTrqDcK2Uv2BgFru2hFbEXTKxHbXDSLTbc2iTbM4BzPnhBczfXnAs5cniHk
        bA9PI666NIWrqx0VcOdqyhE3avaNoKPEaw/w6thDvE6xfq84pu5HB0poZI5ktDeTqShHkonc
        aGBWgqElQ5SJxLSUuYYgvzQT4cMYgtzjDymnSsqMIih6KshEtMuRd3M61lxF0JSeQ+JDP4Ih
        U4fIKRIyAVBRscuJMxl/MI4LnDEEY6DA/n2nk72YHXD5aTvhZJJZADbHG9deNyYXgTXd6jJI
        mGAo+2JwsTcTAjUfX4vw3BNa8/pIHKqBPPuwywxMAQ2pg8UErrYFCt/2UJi9YLClRoTZB/7U
        mabKpMCF7FXYewaBxfiDxJo18LLzpxDzRrjTXkBhvQf0fPLEez0g25JL4LEETp+UYrUfVGbd
        m0qRwdnBawgzB2OPzk49VSmC5x1W6jyaa/ivjuG/OobJWIJZDLfqFXi8FK4UDxGY10Fl5QhZ
        hKhyNJtP0muief1yLX84QK/S6JO00QH74zVmNPkD2363jNWi+ol9NsTQSO4u+bI1UimlVIf0
        RzU25DeZ9K7qRheSkdp4LS+fKdnU0bZHKjmgOprM6+KVuiQ1r7ehOTQpny1ZUTKwW8pEqxL5
        OJ5P4HX/bgW0mywVBQu0sZu0v0rMn/NLPaICHvT5BVqDVycUKvL9+g0L1WW1hdsd1bzyq2Ui
        O3m9ug38U9wXnUq2Gfunye7PN90PGQr1OUZ31beKw/eZlCOh4Tktj7/5HowoUh+0N2Z1K8Le
        j2yPT5u3bfy6I7Y5rOd80ImQl68HvgVFdnvGTd+8xfuunNTHqAKXEDq96i/eJkCDiQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t/xe7pyRWHxBnNe8Vucv3uI2WLjjPWs
        FnPOt7BYzD9yjtXi2a29TBb9j18zW5w/v4Hd4sK2PlaLTY+vsVpc3jWHzWLG+X1MFoem7mW0
        WHvkLrvFsQViFq17j7A78HtcvnaR2WPLyptMHptWdbJ5HDrcweixeUm9x84dn5k8+rasYvT4
        vEkugCNKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5B
        L2Pnj7OMBQcEKjrPHGNpYJzC28XIwSEhYCIxcw13FyMXh5DAUkaJK0t+s0LEpSRWzk3vYuQE
        MoUl/lzrYoOoecooMXfVYWaQGjYBPYm1ayNATBEBXYk5P5lASpgFOlkllp+/xQjSKywQKPFg
        3il2kBohgQCJ56sdQcIsAqoShy4/YASp5xSYziixt3UvE0iCV8BcYumHWWC2qIClxJYX99kh
        4oISJ2c+YQGxmQWyJb6ufs48gVFgFpLULCSpWUDrmAU0Jdbv0ocIa0ssW/iaGcK2lVi37j3L
        AkbWVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmbGIHxu+3Yzy07GLveBR9iFOBgVOLh/eAVFi/E
        mlhWXJl7iFEFaMyjDasvMEqx5OXnpSqJ8DqdPR0nxJuSWFmVWpQfX1Sak1p8iNEU6NGJzFKi
        yfnAlJNXEm9oamhuYWlobmxubGahJM7bIXAwRkggPbEkNTs1tSC1CKaPiYNTqoFRYaFa3PT8
        vysWVTTofou/tqac40neoai85fK+jaq1nxmUnBi2fl7p+YarxnHbCW0V684v/3xXrbglxxrb
        cqdbffc90R/pG2tU/5qf+80meIXvCs+5dJEjjTtf2zxne1FVZ7a6mSksXe69K8uFnHVJWfZ7
        vy19+Ts19FjpMu0F+5Zy61TmbjypxFKckWioxVxUnAgA33f64AEDAAA=
X-CMS-MailID: 20200907174710eucas1p1b06f854222c255719a63c72b043ecda2
X-Msg-Generator: CA
X-RootMTR: 20200907174710eucas1p1b06f854222c255719a63c72b043ecda2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200907174710eucas1p1b06f854222c255719a63c72b043ecda2
References: <CAMuHMdWNdMEnSnLRkUkRmLop4E-tnBirjfMw06e_40Ss-V-JyQ@mail.gmail.com>
        <CGME20200907174710eucas1p1b06f854222c255719a63c72b043ecda2@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-08-26 =C5=9Bro 09:13>, when Geert Uytterhoeven wrote:
> On Tue, Aug 25, 2020 at 8:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
>> On Tue, Aug 25, 2020 at 07:03:09PM +0200, =C5=81ukasz Stelmach wrote:
>> > +     if (netif_msg_pktdata(ax_local)) {
>> > +             int loop;
>> > +             netdev_info(ndev, "TX packet len %d, total len %d, seq %=
d\n",
>> > +                             pkt_len, tx_skb->len, seq_num);
>> > +
>> > +             netdev_info(ndev, "  Dump SPI Header:\n    ");
>> > +             for (loop =3D 0; loop < 4; loop++)
>> > +                     netdev_info(ndev, "%02x ", *(tx_skb->data + loop=
));
>> > +
>> > +             netdev_info(ndev, "\n");
>>
>> This no longer works as far as i remember. Lines are terminate by
>> default even if they don't have a \n.
>>
>> Please you should not be using netdev_info(). netdev_dbg() please.
>
> We have a nice helper for this: print_hex_dump_debug().

It is good to know.

Actually I think printe_hex_dump(KERN_INFO) is here more
appropriate.  With *_debug() functions and dynamic debug enabled users
need to flip two switches to see messages. I think that if msglvl
(pktdata in this case) is not turned on by default and users need to use
ethtool to switch it, they shouldn't be required to fiddle with dynamic
debug too.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl9Wch0ACgkQsK4enJil
gBABSQgAny+wC1IDEaru39HexqqTPsadTBNssgte1kbooXvX8pDpAttJeryYX5WK
sUjSHqF290dL3qTu5MLYP4+GCWN0eCykHH33bYhkImSEmeLmiGI1psJotcdLR4Wl
1eLZBCbhjSHoBMbRJlXAp9zJi+t2/4USxrA6Tu+acHt8moa9UoVVgO4KZ/2EbWwQ
V7/HVZnaa1IQ31FtbunDdHGqvbTlRNccMt5F20ksgM0zTOfDLdYQRo85blfFlO3R
nCDXalGUg8qs7fasThmnXpg9jDEwDF4KvmKm9Q2nBifE2s5DdY5mC0XF7/m3Hmv+
FcvX47xKzrk7nH7EmcncoybkHU827g==
=wlMo
-----END PGP SIGNATURE-----
--=-=-=--
