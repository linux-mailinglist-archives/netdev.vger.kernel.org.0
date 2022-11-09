Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBFB62260B
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiKIJAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiKIJAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:00:12 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CD91CFF8
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 01:00:08 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221109090006epoutp01bbf4f8e74e3372d370a57549e78756aa~l3vsTWcdy0240402404epoutp01f
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 09:00:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221109090006epoutp01bbf4f8e74e3372d370a57549e78756aa~l3vsTWcdy0240402404epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667984406;
        bh=v6iB3Og+Fz5pJZtnIT9S/HaFVgUz0/2Yc2pAGbd3HuA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=QwHhfgg4l63G9jrcuObVXdVPvbncQ2koRz0e6oTsmZUus9x+ytuCYMNDfW2+yjP7Y
         V+wqUIhZGfBMUnDktD7eHR41QIDeh3RNpUjDJiliTEs/IY9rqMvEopCc85Dy2P3YB1
         kEhB/VOoDxZoPpf1l8bIVyn409k58xTEzVaM8GZQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221109090006epcas5p2eb2efff75d8259840c9e54f0a4f74261~l3vrdKi8V2443024430epcas5p2Y;
        Wed,  9 Nov 2022 09:00:06 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4N6f7659QBz4x9Pw; Wed,  9 Nov
        2022 09:00:02 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.D6.56352.21C6B636; Wed,  9 Nov 2022 18:00:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221109085552epcas5p3c4307176f977dfcc9367f8ef4212a089~l3r-urENf2899128991epcas5p3M;
        Wed,  9 Nov 2022 08:55:52 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221109085552epsmtrp267b474c7cbf0bbccf855a0bb6c1cbe32~l3r-tg-Zm0659506595epsmtrp2X;
        Wed,  9 Nov 2022 08:55:52 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-84-636b6c12ee28
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A1.46.14392.81B6B636; Wed,  9 Nov 2022 17:55:52 +0900 (KST)
Received: from FDSFTE314 (unknown [107.122.81.85]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221109085550epsmtip16ba6fb60ad332760ca7fcf6f6a64fe7a~l3r94-Q3X2423724237epsmtip1Q;
        Wed,  9 Nov 2022 08:55:50 +0000 (GMT)
From:   "Vivek Yadav" <vivek.2311@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <rcsekar@samsung.com>, <wg@grandegger.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pankaj.dubey@samsung.com>, <ravi.patel@samsung.com>,
        <alim.akhtar@samsung.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20221025073230.3dzu7wli3goeuvre@pengutronix.de>
Subject: RE: [PATCH 0/7] can: mcan: Add MCAN support for FSD SoC
Date:   Wed, 9 Nov 2022 14:25:49 +0530
Message-ID: <005c01d8f419$12594670$370bd350$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEeBM2YDJcBkWM2A0wA+9uW0W1FdwJD6JMFAlcZ7Myvh0/RAA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmuq5QTnaywcaPGhYP5m1js5hzvoXF
        4umxR+wWF7b1sVqs+j6V2eLyrjlsFusXTWGxOLZAzOLb6TeMFou2fmG3ePhhD7vFrAs7WC2W
        3tvJ6sDrsWXlTSaPBZtKPT5eus3osWlVJ5tH/18Dj/f7rrJ59G1ZxejxeZNcAEdUtk1GamJK
        apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MFKCmWJOaVAoYDE
        4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMv5ea2Qp+
        clZ83LeKsYGxg6OLkZNDQsBE4u/yRYxdjFwcQgK7GSX+Nf5lgnA+MUpcnjmLBaRKSOAbo8TK
        DyYwHUdnHmSBKNrLKHHt4wOojueMErtndIJ1sAnoSDRP/ssIYosI6En8nrCICcRmFtjCJPH3
        fRmIzSlgK9H9dz47iC0s4CBx/HIzWD2LgIpEw4KjYHN4BSwlzl2HmMMrIChxcuYTFog58hLb
        385hhrhIQeLn02WsELucJCbMWQ9VIy5x9GcPVM0FDonDZ7UgbBeJj+tfM0HYwhKvjm9hh7Cl
        JD6/28sGYSdL7PjXyQphZ0gsmLiHEcK2lzhwZQ7QfA6g+ZoS63fpQ4RlJaaeWgf1Ip9E7+8n
        UON5JXbMg7FVJF58nsAK0gqyqvec8ARGpVlIHpuF5LFZSB6YhbBsASPLKkbJ1ILi3PTUYtMC
        47zUcnh0J+fnbmIEp2Yt7x2Mjx580DvEyMTBeIhRgoNZSYSXWyM7WYg3JbGyKrUoP76oNCe1
        +BCjKTC0JzJLiSbnA7NDXkm8oYmlgYmZmZmJpbGZoZI47+IZWslCAumJJanZqakFqUUwfUwc
        nFINTEcXL2Q2n7KlpvyYsuMdlcoZzopGyy4KnXBKEcm8oDTxs/KXNq2miy88HaadEqx6qlv9
        69gDkyOPL9d4zNxSezrkngL3JftZtT0cq7cJnnrXkVTGUxEnedmvp8LV/zrXLyuuB4zdIr/d
        biQJJvQedl4UntQ4t61JP/j/hKIIngBZzYeiRZdKVH7nHGP6aHfoAI9ZmcTGEz9fHHuqeU5D
        PEKx9LZ9ReLTTb9ZBHzd2PvfTpd6lCWRNqesR7QvzGRyeer69IcXF+UfV5uyfGIax7UTz2ZP
        0mzyNP/Y+86t7fMCZ83EhCBJTwF2zd783Es88lm3pV80LRRuvs9+e/GhFK+rc93Xlh31ywvT
        Oq2nxFKckWioxVxUnAgAWjxDL1YEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWy7bCSnK5EdnaywZKj+hYP5m1js5hzvoXF
        4umxR+wWF7b1sVqs+j6V2eLyrjlsFusXTWGxOLZAzOLb6TeMFou2fmG3ePhhD7vFrAs7WC2W
        3tvJ6sDrsWXlTSaPBZtKPT5eus3osWlVJ5tH/18Dj/f7rrJ59G1ZxejxeZNcAEcUl01Kak5m
        WWqRvl0CV8bfS81sBT85Kz7uW8XYwNjB0cXIySEhYCJxdOZBli5GLg4hgd2MEs8bNrBDJKQk
        ppx5yQJhC0us/PecHaLoKaNE09IORpAEm4CORPPkv2C2iICexO8Ji5hAipgFDjFJzP+zGmrs
        PkaJZ/O72UCqOAVsJbr/zgdbISzgIHH8cjNYN4uAikTDgqNg63gFLCXOXYeYyisgKHFy5hOw
        OLOAtsTTm0+hbHmJ7W/nMEOcpyDx8+kyVogrnCQmzFkPVSMucfRnD/MERuFZSEbNQjJqFpJR
        s5C0LGBkWcUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERynWpo7GLev+qB3iJGJg/EQ
        owQHs5IIL7dGdrIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwc
        nFINTFFr8riUPcqWmN9nibnM0SPAL37/4vQNKxe9nvfx4ac5up+SPjyKkJC5Wi3afZmvpWRW
        WnXo1tlVB2OfPm1NcXc5Fvg/5MPjRtfzvFvuHLmvyi+nUVVpHBHQa6+Sct6roOD0semTVhju
        27LOsrK9/ahE7XwxeaOXrbdutZ05eXx7i9jJH7YmYpu7J5gl2rU9OWzt1v24tTax1tPHP7t4
        f/UR88rC4+InQ55ZxFmFHD+++13H8uYOhu99e5JERY3zODenhl25ldmb9FEtUGMl/0Vbnm7R
        x1dWrj1+tVnu5urJxj1zDvz98ytkbVHthqyrnCp5IXbvnhsvKvi4bsMOUa6Nfxc5pddXXVoy
        s2faKiWW4oxEQy3mouJEAPPLfd1CAwAA
X-CMS-MailID: 20221109085552epcas5p3c4307176f977dfcc9367f8ef4212a089
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102614epcas5p18bcb932e697a378a8244bd91065c5496
References: <CGME20221021102614epcas5p18bcb932e697a378a8244bd91065c5496@epcas5p1.samsung.com>
        <20221021095833.62406-1-vivek.2311@samsung.com>
        <20221025073230.3dzu7wli3goeuvre@pengutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Marc Kleine-Budde <mkl@pengutronix.de>
> Sent: 25 October 2022 13:03
> To: Vivek Yadav <vivek.2311@samsung.com>
> Cc: rcsekar@samsung.com; wg@grandegger.com; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> pankaj.dubey@samsung.com; ravi.patel@samsung.com;
> alim.akhtar@samsung.com; linux-can@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 0/7] can: mcan: Add MCAN support for FSD SoC
> 
> On 21.10.2022 15:28:26, Vivek Yadav wrote:
> > Add support for MCAN instances present on the FSD platform.
> > Also add support for handling error correction code (ECC) for MCAN
> > message RAM.
> 
> Some patches are missing your S-o-b.
> 
Okay, I will add.
> regards,
> Marc
> 
Thanks for the review.
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   |
> https://protect2.fireeye.com/v1/url?k=0b321df8-6ab908ce-0b3396b7-
> 000babff9b5d-2a0bd0286d8759f0&q=1&e=fed9ba03-7d7f-4421-bf55-
> 28e9d29d5ad6&u=https%3A%2F%2Fwww.pengutronix.de%2F  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

