Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F9B309A20
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 04:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhAaDrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 22:47:06 -0500
Received: from sonic317-16.consmr.mail.ne1.yahoo.com ([66.163.184.235]:35557
        "EHLO sonic317-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbhAaDrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 22:47:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1612064778; bh=h/9a/Fy6iXiOd5QokDs7ep8voH7YVL4u2LG3cYHR+ow=; h=Date:From:Reply-To:Subject:References:From:Subject:Reply-To; b=LD7RcsbeAax3D+VrhYTdaPeBjn5/I1rh1lmgr1BaBLBuC6Sx5NOBwT26brWelEwUCo4Kn73YGkpXWIbjPAQlm0d3CPX7l/KvD3y7glYQjBIn12oObcbKxNmhYAulAhErM7C9BPN8FGAZGqsj8ayY41Hv+3D4CBqgt3kfBm+gH2nYTZyC9iT0F+a4Y1IR9B4aIJ3AyPL0bkGvnhYpwwvktgvkwAUJtmWdPcMgoE/wT+o75qDy/lOSRkbShJSmGPvQd7x68izOYtL59VTVTY8mAN3x25lAMHWnMqSHXpb6krsIgMCYKa5tlK2sgA4ZF194K1nPsAb43/DM4kV/+O4o/Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1612064778; bh=bwSq8eTetrEi1SxkfQHcbezN/dMUDb/1h2GM0nnmR+S=; h=Date:From:Subject:From:Subject:Reply-To; b=nWdOHSBFS+TJWPSKQVfCEqCW8bg5yACDN6utLMh1Ec37W2w+qfKtYNsQ4CQm1yXcjueFmCtRVmXF2QqvOjPlra6PonZC03u7eJj60bpzVZrbRwSQKBlbSsOg81P/VWs8lVoiqiwo+69xmtP+aCBBnWh/TvvUhj/MsGpzFFt406Z0a8dLj9qgIqjE/JEr2/KvYTOxD87hvxJFJ1pbxUo64t4akfX30kn3p7PlPTe71Y3zTBwMH48i5seibabYJ2Pg210kbVbYPvZ4W+g/cu3v2U+eQB1Oy7Xgt9fmjUxgnuw8HSGkL4lDElxOJdT9U03sNAx8Gm5rHMrgOmJhM8NxmA==
X-YMail-OSG: ArQskI0VM1l__QwG8pyZbBHNzgMTsKA3g5fWbR3Ie2aLHKLx6Ezt_IfjbOETWJ0
 L71rGKdL5qQ9kpwOepgjdfC65Itxp8uRqdOtpDQNNz2FdDQrX7SUeXn8ItCIMBOJLBobPxQEqPY3
 QOtVaVaFXXZ9f3zJ3sCEdi4o5wZPbUzhkRvXUAO.2wdjyBXKdRoOPYIOxRDH8i6SGHFXqevPUKH0
 yT7luZANmkUcdBfGYiDyfuYXhMRA.d.WU7l8YXsqyGwmjFh0hhUKvOVAS4D5yo_TBDJET_d0Xh13
 2wVAZEU6ec.9_cLv70Bs5FFq6dY4733ibF_J26UD0wC14x1LDAj5sX9vnqCZTFlLL2fhd0mtbAyr
 u3XiV.ZMMom7dO_CzOSanS82bpgAmf0R_vgYI4LExePvGyCpGlZhN7OpS9DM5KJ34bkLKC0kk2ff
 J1TtEW1GGtmIUgpaKAw0qRsMEZBf2SMqpSbbnzHNuJ7B_E825HAuudaa2jidi3vCrPhGLrJBCE4g
 6J5eCdQB68wAx5GSj_fFL18NRGRRdktGLDTm_JaqkZ0Lz9MBqAuYHbLwn878oMmuQdopxnbSsRan
 wwwowaJG7_TUqBgyqy_sfceN_iOFjG0Y9p37y7JrL5DXkyZ0tHZ423CYlA9Bftb2Ogn61bxNHb0h
 YMFhRlZI52MnheGis4gdjcJnFCTRrGHD7eXJzXSIL1M_.oVA8oohm0mhq7_uiyDlU_pD4m0TGtNg
 pRQR_1ZrZWPglZBBNHmB_jQMdPdC9f68Z6Q40gWYz1ogja58ERQgN5jaedPHhjVD5CeDK1iJrsNT
 eC_wfJ268hi8s_dYu0jFJ8JdoAW5Pb4BqzmziiZfYA1c3U.oAieNtLdvy8QKkuvOrpksKWEK.vkP
 U3CVl4_Cz9pmwewWqWgOdXf3pMgRMzjWZs..SDvClMQKGn8G0Jrw39txP8zVhc3zNE14NWRwKyPH
 .UhXXPAXewl7k1Fy969xG.JkJXZth_faDGWjQJuPLG6M1jVMaMy3F8AN5uxHS.T7JCRGoGOIMKlR
 iyS8SHaehhOdRSYf7VNf.CFYCf3RFaoSxEYry4MqtMQPujQwxAa8ymgfG3NIwkosXxJx2njlwO1_
 W645rf6nMrqlkzAC_vDJ350OMuP.WfnKuoQFNJa.LC4VOvW.mKS0tkP3FX5pHKjXvxZMJNxoflan
 ZmfVTPGlbOFJwl7opKAcDFpbNJWEnaQk6QTh5yzyFdfYUHmmapMPFFdp9J8JCL_iFuQ48xGYNfcE
 9i_RS7Fr6pX9h5CtoGqCIVXTH5QTHsnC5zUE1az4TgrV3b5Yvl2ZXfOnt1wpcykleHb3aSRrslWN
 91ljPRnf691jSXLWh4K3EUSeVbBb9CkxbJhLeoJOAVDNzZIa62C02.Nf3m7BdB.q_0r6R6qLNt6u
 PDVTQhXPzIDXWUnpZ9ic1BVvMWyg27dlA30zswk7VpbxgtWfmDokt9xFKFtzKbVwzb1B4XBggcBn
 4mQkO4hxptBrc5LTajR1ZzDGmyusHA_Uf8EOd3kjpeVU1upnT7zQlwWEBTEzi9iLRBuItvkiUV4E
 bh9pkoCtToRuZT64is893RqJ7jnXdW69qKPSVNdf6cAJLmFXd9yBIaqz_RC1yJuajCqvXWscL7..
 yanpMT7ukIxIMSDSEz.yrWV8YzS02zTgv4rQu5jZyC5nncQfuTG8G707JCU4qGKSOJgEtl4UQezT
 hxXXO_2SZ32t1K_SbOZuhUW16mCxDBQfOzwIvppuI.ynavjJMqwNnrvNnMrVi8FzkxwcFrMgQo3t
 kB1tuicUlV9kF2XsUEoDpdXayZXlZ0c3osPRjtrcE6oJXxkS2Y_8FTclWntHQN7Xn5L1qyHDVJS1
 YsvUMonUlHaYviQwYhOoV04ZCa5XCtvzeMGKvgZIWptMB5MI4Pt15SNQBjV6qaiSPbburdlZv0Tv
 gEMrg7U9qzACsRRcysGrG1nf3IZ8C3e31F4Cr.T0GHKChtRTS1JIaW6.or2qbq.XlmlpgmUO9_C0
 gLJ3NXQn0fezdqh_GXxDoVBe5y84yQs6iBcV.JHijWSYHBNFJoUBzM95KSFZlv9EBvz8qkwzQes.
 tdShxudoBxUdMPSyTWr7JpZ_Goue9osq6DIzf4paYp3KZkWRNGp7GYTcIErzWgS0PYF9hIwvSceY
 X..tPChereN74EpR4V.NuPQUpn2DWEuHbWwRJZ9cZ2WKm_tKF5xpeWt_H.Uofo41EwTS7phIu_kS
 w_PPNpGF_Hu8MWaeQrNYhoC78YnT.MdPXZLEjy1J7u_CTYtM3B3XKTP9MdlrFi8MANaQKvB4lo5H
 McTLZf4sl4_vJ8QnOO0_3O1SrMRgcOVUONyLeb1zbZyMjgyeCwJppO51zH6mK8.IzvlT.B2fQWMM
 tCVeZambnr0hc7DR8Mg2VlZdse771eFLoYuAAm_OzHnjKpIB45lwL8147qJN.kP41dg8Uw0BBmyU
 vVwLTkfEPY5SfabJXWP9C5A7bNzTZH_OmjjtP0TOdx0nxaYgPuXpEQo92vb_DvH9_y7NyyKh6XCg
 Aimorpv806Npppd.PZQabkrdXmx2tmMctP9kTrjcUP.rmXkg74z1V0w3ujzJa65aOJ7.4PNxzBCB
 .k1ReeTBz2fgB5glZiavu1qu7uKgfjAvy0MX949q_YhSkW1Q.nbXPmskjzuJjrR2J5Rx7CAtH3Iu
 6MGmz78q_k5fdFVOWbYI.ChqrQs6BdABuzCITtDdrWXZQSelYRalZHhbgFkGwz5y0HA8jqhE8_6l
 BOBOYjv7fqTaOVFVSgjWIu_U.b.p68PXTJyeUCoKgPxG7B5VTiYeculonFtVU2OqbxnIsi3tSovi
 QGQl7jtb6l0s7V.mrRNn0UwzQzyK7DTyz4wPY6SXOvixxHHI5TOzS22bgCG1OILVAEXW8EHfgwvN
 Rl9f1yPZnbYT3C6aF0IyzGGmJZwT5CJC80KT2IWG3PzY0LNZClGCWemgQu9ejjX9T8SEh6isxfOz
 v0oWdZnsZvS9ZsomrAGrVp2zxUMzC8JpYEp7Q8D9WOTQAxVVdIUisVVWZKVCHGMxjRhob8a.IvUx
 rSEVh4pCn2Bvg.QbAufgt3iqUOUBtmsE5zAvDO6I.82vxKQwquy0XDfu0ANIMhJzOJPJTJOKxEVN
 amnsA0nTa7p0d2X.7OkVZmL9HW0_6l65WuMqSLg3rV8uIwLvmbWsmGVAz4tX0votio15DVqCm6AV
 rrAJ8b5V1djxF5Gqj_DmvTRSEjLWsFQFcRWCvpnU4LX0OhyqJRxA8oMcBs0rsuzpUsjFDsCvJ4RE
 KFPad45BFoirWgKr4ziZfBzP_9fVaMs_nCdOOM.nWgCw0pleeP4RMKFGV6c.v0WjWfFOVVYAcPof
 smou8LotKMu7Fl3aJLG3RXXfLkvk4fwzDjXta0cGKdzX6D15M4xXuG0D5HAfrrvbwwX2F2sJY3Ht
 utgwZM2RKbjiDLUNdmouYhhe.N01tVxde4klAiZqIZnom5kj_reuXJghXfBtd1kwpn0f3bXOCMs1
 thn35AU.xvGEdv_B7o1XgcDE7mgy.93mugSTpUQO0efVh2fmW71S24DjXcqnmNt_gx5o3oJM8hx6
 6Y5l.t9o6bKv0z9rbB6Ii0JmZvZGymG1RN7Z9_oEebrCbhNOyNGXwzTVug1rA.FM_3JniUmARj08
 _FeUbW53UrffJ6R2Wc3e_1vbYE32h5yfCXUYk.d9sCw0.j0x7L7S015cCUkfkObBTeLp_nSx_qS7
 rK5UKYUJfPLi9rZ4-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Sun, 31 Jan 2021 03:46:18 +0000
Date:   Sun, 31 Jan 2021 03:44:17 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau41@cgjzo.in>
Reply-To: maurhinck5@gmail.com
Message-ID: <1534961888.701285.1612064657992@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1534961888.701285.1612064657992.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.17648 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck5@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92021 The Maureen Hinckley Foundation All Rights Reserved.
