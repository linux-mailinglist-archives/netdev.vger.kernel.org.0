Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B6C42CC93
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 23:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhJMVQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 17:16:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61226 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhJMVQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 17:16:39 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20211013211434euoutp0261a7b9355d120f4b3ca174c7e4bb235c~ts5DRFEKX0065100651euoutp02K;
        Wed, 13 Oct 2021 21:14:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20211013211434euoutp0261a7b9355d120f4b3ca174c7e4bb235c~ts5DRFEKX0065100651euoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634159674;
        bh=bthKVrL0rMsj28gO8Sc58m+2qv9YgG6IXI0hZZkUkX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ion59YZKhPKeTek/atE2cfmdFAuoX1b4VAakTiymm8hmhZkunaGvcF9X5nv9HKXNj
         xFHaBaJ0w4NcbgdIz5mjtWtOaAR12vwO9EFX7QXJLcoTF/kyLUvi8wEagumX/TDexh
         X+4nlvCm+3LG/OhT02xepQ3vc48hOvF3iQpdhH1A=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211013211433eucas1p24b4d0aee259c354a57468dd48277b1aa~ts5CU_KLu2981829818eucas1p2z;
        Wed, 13 Oct 2021 21:14:33 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id CE.00.56448.93C47616; Wed, 13
        Oct 2021 22:14:33 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20211013211432eucas1p2cb6a119feec2c1a2c067d2753d69509d~ts5BfAzeX0326603266eucas1p2w;
        Wed, 13 Oct 2021 21:14:32 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211013211432eusmtrp1be814491c5d54a20762c39c463e07d5e~ts5BeKizI3231332313eusmtrp1R;
        Wed, 13 Oct 2021 21:14:32 +0000 (GMT)
X-AuditID: cbfec7f5-d53ff7000002dc80-c0-61674c39faff
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 38.02.20981.83C47616; Wed, 13
        Oct 2021 22:14:32 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211013211432eusmtip13f0bb3ce9849cd1e0c0c604ebfa3c4d6~ts5BLFp9R2401424014eusmtip1Z;
        Wed, 13 Oct 2021 21:14:32 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolni?= =?utf-8?Q?erkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH net-next v16 3/3] net: ax88796c: ASIX AX88796C SPI
 Ethernet Adapter Driver
Date:   Wed, 13 Oct 2021 23:14:20 +0200
In-Reply-To: <20211001153940.28c5d60d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Fri, 1 Oct 2021 15:39:40 -0700")
Message-ID: <dleftj1r4osk43.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf0xTZxTN1/de32u3kkfLxk3dFsS6DTYLZEafmRrImHkm/oFxI6hz0OlL
        MdBiWrqpy2bHQKQpyIRKQTYVnSKO37T8CGxLV2Sssw/pBrjIdLAUpTZgmBkyhmt5mPnfufec
        c79zbz4Kk88SSuqgPp8z6DW5sWIp7rz2yLtu0w6tJnHYHsHw4y6MabU3E0wtX4gzZ91egqmb
        sRPMSPAWwZycDGAMz7eQzJCzjGDaJkcIxtdTK2bs/LcixmXrQ0yje5xkrp17ninqc5PJNOsb
        uYGxHVduitjumnGSbWsoEbPtF4+x3V1zIrasowGxc20vpVF7pJsPcLkHP+QMCVuzpNmjg0Xi
        Q//A4fkJHzKj4igLklBAr4fh4hbCgqSUnK5HYPm3kggTcvovBD/6dgnEHIK/+33oiWPq9qRI
        IC4jcPx0GwnFVKi448MtiKLEtBoaGzPChihaBYXt1XhYg9FDOPxQdB4LEwo6C473tZBhjNNr
        oWSgVRTGEtqGwPy9Ioxl9EYIjNqWIz1Hb4JF/wNS6EfCYPWfeBhjtA6q+fvLIYD2SoCv/YoQ
        oqbC1PDjFayA6YEOUsAvgKfCuhwU6GNQcWqD4LUicNbO44LmTbjlXRALOAUunp3FBH0EjAUj
        hXcj4JSzaqUtgxPH5YJaBU0ne1emKKF0un7lcCx09tf/f7jKgI0sRzE1T61T89Q6NaGxGB0H
        zT0JQvs1uHQ+gAl4CzQ1zeDnENGAojmTUafljG/ouY/URo3OaNJr1fvzdG0o9BE9SwMPu1D9
        9AO1C4ko5EKqkHmi5eoQUuL6PD0XGyVLyuY0ctkBzZGjnCEv02DK5YwutIrCY6NlPY5vMuW0
        VpPP5XDcIc7whBVREqVZVN48uXomzi8xG04Hr5/J/fQC+0qBb5d4qTsnfeyP/Bvk0if3+MQx
        Z7x6QrH3cEZrcK+pMPHu26+b6AufU0cXCHtn1lzGMypL1eWvv/x1R5eNzUve4qgk0+pijpSl
        je/uK73rCiwuYpi/ePV3m9HAF872x9iGKzFJzpStv20r68z07Hs/4TMpaFMfuqte9K0teG/U
        5vab+/ETo/teTp+pS76/feHdn+/g2Z0711U6Fsny1mjdoHXNs6etby18cP3qxzG/p8YxU+y9
        Vb0o0ho/pOq1DpZ4GI/il0RszZ6bwXRlyjv8NlFpfkVCjqfg1bQz+/3rd6Y8wjyO+Y2hmV5j
        zmwsbszWJMVjBqPmP31z3J4DBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xu7oWPumJBkvvCFicv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVpsenyN1eLyrjlsFjPO72Oy
        ODR1L6PF2iN32S2OLRCzaN17hN1BwOPytYvMHltW3mTy2DnrLrvHplWdbB6bl9R77Nzxmcmj
        b8sqRo/Pm+QCOKL0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLL
        Uov07RL0Mq6fbGUr+C1R8ePRZcYGxnaRLkZODgkBE4nn9x8zdTFycQgJLGWUePmqEcjhAEpI
        Saycmw5RIyzx51oXG0TNU0aJqdcvMYLUsAnoSaxdGwFSIyKgItGyeSYLiM0scIVFomO/H4gt
        LJAg0bZ3AzuILSQQLPG18TkriM0ioCrReXwjE4jNKTCVUaLhgDCIzStgLvH6+lSwGlEBS4k/
        zz6yQ8QFJU7OfAI1P1vi6+rnzBMYBWYhSc1CkpoFdB2zgKbE+l36EGFtiWULXzND2LYS69a9
        Z1nAyLqKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMJa3Hfu5ZQfjylcf9Q4xMnEwHmJUAep8
        tGH1BUYplrz8vFQlEV7DjNREId6UxMqq1KL8+KLSnNTiQ4ymQK9NZJYSTc4HJpm8knhDMwNT
        QxMzSwNTSzNjJXFekyNr4oUE0hNLUrNTUwtSi2D6mDg4pRqYIudYft78P9NK6OyaCcdy3r+5
        9i6Mx6Yk3/fWntVHbgfE8F699+x8ttSMw5lmAnXKFReuJQeueCt+74JITpLHEz4l2dbZOz+Z
        rtS5KH2t62tqwrFpMtcdet6vefflzp/Vxg0d/rNzxG5GnLY9+EZAIee754mfjB3XUy7uP/xB
        YF8Hg2hnsKxnzPEr68/f3chwsezFDVfnw0+eG4R01bj62FYtP6QtvsokJH+5766ieZtf3mU5
        9TLz6dqrK39bl24Xvr7rhb3977OJ04+e+cHwv9lGO3ZdZH3Ce4+TpzzOx1yQ5Prx3j/pAev6
        Qp/45Bn/j5RE5ApkLj15ra9Y8prWhT6BzJZHOnZPN/45c/nu1hVKLMUZiYZazEXFiQDQ1YfE
        egMAAA==
X-CMS-MailID: 20211013211432eucas1p2cb6a119feec2c1a2c067d2753d69509d
X-Msg-Generator: CA
X-RootMTR: 20211013211432eucas1p2cb6a119feec2c1a2c067d2753d69509d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211013211432eucas1p2cb6a119feec2c1a2c067d2753d69509d
References: <20211001153940.28c5d60d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20211013211432eucas1p2cb6a119feec2c1a2c067d2753d69509d@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-10-01 pi=C4=85 15:39>, when Jakub Kicinski wrote:
> On Wed, 29 Sep 2021 16:08:54 +0200 =C5=81ukasz Stelmach wrote:
>> +static char *no_regs_list =3D "80018001,e1918001,8001a001,fc0d0000";
>
> static const char ...
>
>> +static int
>> +ax88796c_close(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +
>> +	netif_stop_queue(ndev);
>
> This can run concurrently with the work which restarts the queue.
> You should take the mutex and purge the queue here, so that there=20
> is no chance queue will get restarted by the work right after.
>> +	phy_stop(ndev->phydev);
>> +
>> +	mutex_lock(&ax_local->spi_lock);

This was a bit tricky. The function now looks like this (details in the
comments). In theory there is a chance of dropping a packet if the
ax88796c_work() runs between phy_stop() and mutex_lock(), but I'd say
the overall risk is negligible.

=2D-8<---------------cut here---------------start------------->8---
static int
ax88796c_close(struct net_device *ndev)
{
        struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);

        phy_stop(ndev->phydev);

        /* We lock the mutex early not only to protect the device
         * against concurrent access, but also avoid waking up the
         * queue in ax88796c_work(). phy_stop() needs to be called
         * before because it locks the mutex to access SPI.
         */
        mutex_lock(&ax_local->spi_lock);

        netif_stop_queue(ndev);

        /* No more work can be scheduled now. Make any pending work,
         * including one already waiting for the mutex to be unlocked,
         * NOP.
         */
        clear_bit(EVENT_SET_MULTI, &ax_local->flags);
        clear_bit(EVENT_INTR, &ax_local->flags);
        clear_bit(EVENT_TX, &ax_local->flags);

        /* Disable MAC interrupts */
        AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
        __skb_queue_purge(&ax_local->tx_wait_q);
        ax88796c_soft_reset(ax_local);

        mutex_unlock(&ax_local->spi_lock);

        cancel_work_sync(&ax_local->ax_work);

        free_irq(ndev->irq, ndev);

        return 0;
}
=2D-8<---------------cut here---------------end--------------->8---



>> +MODULE_AUTHOR("ASIX");
>
> You can drop this, author should be human.

I looked at diff --stat and decided it is OK to put my name there (-;
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmFnTCwACgkQsK4enJil
gBDFBwf/XLDy/I0kOtPuYUlDjRPL45fOD6Ne9jVgrZYvI+/0c+llvxsMtQCXVNS4
Bi8zKK95J8lgj1oTziC44gKwNcIBVw2Q64DKC+JF8puIb8SrbcgbW7O7iN1NYDCu
2ugPHcRM7MEkhRMU1pwTx2fdnYKnZgKuJEe7z6awJ0o5zMIitni9GeKwQwJS5nxE
2Ly0XWzuJXzYlvXZQ+B4veZaxU6Gn2E6TqUlMoaJk9+DffB4nHfmrQyVOi1r6jW3
ae+7lJF6WdcAkB6QalOtJuSeRO8hk/gOzJsdf4FFQzcVhEwIoiKm1zw+eKiLFP0D
HJ3NN5zWRZm5Lu28Ou3H3qS7X16mxw==
=3sB5
-----END PGP SIGNATURE-----
--=-=-=--
