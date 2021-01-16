Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18B22F8B60
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 06:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbhAPFFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 00:05:31 -0500
Received: from sonic309-17.consmr.mail.bf2.yahoo.com ([74.6.129.240]:42937
        "EHLO sonic309-17.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbhAPFFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 00:05:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1610773484; bh=swjFzKWryy3sOX8AFtSHoDzy7h2wolCnmw3X8FGxf9o=; h=Date:From:Reply-To:Subject:References:From:Subject:Reply-To; b=PucVy+ITc8rOTRG4EV9i04bjQ6JSa0m8kJycJ7QsEuNWR0mqVZO6PicWw4GVv/jXNUBP8Zu26h9ii8m+PzR5RWBJVskbEknhbFNXQSRJ7jUr2ok/6z4NpDDPVsQjpHdbP7uaDORUqAXruAeAcXD705sQ5672hD53NzyYoTYEKiC1CViEeZUHeL2dTPRK4CKTNWLLMU+Adg/2Lhc5S8tIEq2+iTkoFoWJyuH3poIdlmlbAkFUvghHOl7GQHBzSH2FakUmq0yhqHnGn9IH1uG+gdPTjPeknXcdZXa0yEMyQXFxo0Ul9tlbj68/6tpydsvfLx7UTeCNaeyf1/+qqHoCyA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1610773484; bh=Nz0vvdVfcuvBo8YFtWco6oIC7VD5mUokgXaxz10hTH4=; h=Date:From:Subject:From:Subject:Reply-To; b=ZM6LvOFsv5W0Y9Q6ASZA+WwJPzoUsDB1HC7Pn2z+Vi6FT85n3hZlhznfkpq4HeS5GksqhWUlMuCWNgHETopedZXI50Ujid5SqZTzPJXq1dgL8wBlpYcp4f6elcdClLb1NF27vPJID7ncCn38/n3zsLAZRHNkRy5lS8E+uRr/RMPEcJVHPu7p3Pf9QLiSJGddoEwGJMuBp+kVI+Jz7uf3G+AW8ojuFhOZswblbQpWAN5Iiw8gXTHzsc1G5ZQDlb3r6FnFlBwGpryCs84yfa91UQ6Y13Qr/+MFK/+G9HfeiTBxBmOfoh/lSUTzlzB+BZ+YNhk2oQMQ8ZnldfY4/Ut2ZA==
X-YMail-OSG: FLbC82kVM1kWWKCTsP537uUex9wSm.Z9J3AU_pPdrGNyrJYpyhUNFHPYaqCyJuA
 QYgSDRnXKK4VvCaod84LmKELleYFdVMe3X9NVXhzmMEDf19sVUh5M1OEnkwkSFD5v6F0o5NpHRBV
 vG9.fBF5pxuppmJhzlnhKy34OR3SwL33Jk6.7dSoXd8d_1Xkv4ptxVZp27H2Z.KTNKMH6GXCqxUY
 vpRQc0Xkn78Evr_r0Hdsp.L1Im8eSCGmGNA1GCIRKdsuCD06MLliuibiup1N1iwToZWuBK.qvH7g
 7f0BcbNs4PS9tC56it_k0KJcaO7SPmztedtP8pRuKVEprjiJPHRFEmcKANvtTTyHkpBdzrtos.et
 Bd1WFd8TN0bOEfXYW0ALpx5UEED1jXnwCbcvoxIvqYdd6zhfrpYe3eNVWSCU7WOtiAZvjBDMtlDw
 NPVNHYPJa6z1EkU2lYQTwccrUAmEukUUKWG69rZwZDH7o_ldd4C75DtgQhsk6ndamGhAun2ifYeR
 ch5994BDh0K5UWudLCcOmSqbEfhg328izFzIsfdEhdOQNXhHmX9YcCA2e8nrq1lgm5BZakyaq81C
 ndKFRI7u0kH7Pprx7.RtLj.Tqo2AM9u7aSCuvlkr8vlTai.i8kpJos1RoB9JMFtPNRGDlgD0a3wp
 RvkXWzdHxPdA66RMJRPfGVG.Y1nNES6OywWw5lm90GRQwxF2ZAensqHiSw9SoMmRuvS8S7YTxHIj
 rjRMidQb8HGUCpISgzO5wGnZEVATd68CbmGueyKzWVkS5I9DjOueeqxDyrgggFBQaDs9k64W7YUZ
 ag_qk5U9PDEJLUgVBZApOgI1f7vthYrK91duFg2JRtQt2UsmDrVa2xvqS_u7z5.RgLs4hJ6rmeyN
 l5UmXEQmFKTTKjHquHct29LJ00IWiVAv37D8yGfX6kUVOdQ7JkXM8jbuVoJiJx0peJjX81VzYpQC
 g6w_irgKvMmreactK1j0B9KY.VkdHTSUIM_yS2bWMq2UJ2XOw2V8Hs4pTlTr12IUyc1K_WThRcU3
 wDAPWfL0z3_rQko9wvdVv15C8.e.t3fx33557aDIcGHCSvyE.BL2OMbrmwyEIfI50ycJ.36s8fev
 xgHG0G.N.o1ihdAMMD28cmVTVwJljn55uiNQY6j2xqfir7hvdVtkyts_9X1f5iOnSIWCwIpY9P3u
 _tBHy4W3abEyGFpqVIKY90jLRFzhF97jaEZQWAHYMQ652gUBN4nahSAJHNylMn5wwh21_y9VAfLp
 vJ1YBrnD8B6bM8Jj7Avpf.Vq2N4GGYSdirPEvpFJrb_s0wZnFwzMZjdHkrmFKYZ3JyfHWXsX572x
 OpIQqE4YO4n41reeFZ.WQA7BbyTB_9u5.zQoDU0.RREb_7CKX2J3IxnVhNapQfp8p3809zM2vpcs
 haujvbiDtGQDWwi2OGX0aRNv3CdaQ_I178.yJnYuIte_r4SNHwkW46LEjCeTdaua9ADXZ.fBUQ.E
 avczMlbPIvvoHodO9cjXnNA.RG_JurxoYyH2yy3_XnPPpY076VjBF0Axuojqc_.tluFiW647Foh4
 MqlJel2ay0vZu2C4jOz.jKi5pDf3vHySE6McUY3pW8khQ.PbDS4bPwkESu.lfaB4l4H6q2T.XO.9
 CdpQBl9HVdKacdvV4_8U8SR_7N0VX9mobu4V99al3Qo5Vh7ggMSAIsmYEBN6oKoqUQ_r7zRqUYd1
 PuE009FFAQWiDB7Rij2KsmbB9Ca0XvGFdK.S_mignUchcT.hqhgBhZ.IZjd78yKLVxLdKREQffQM
 F7rppAf3AkoN1rGBBgNdvD1v.TmKFh0nzQh.NStU2YxWV2OsgLoIuVTHSM9CLjXCY2IU4U5eDChR
 c3cZLc.BTQLMcD5V1PQc3ljLIo3_ZsjxZ0VJiqlLRldIXDre27nxPTR.OGjEuTBcvPpaRV3kWtfp
 87yi0F6dpckuS_SpLWmuwLbEUBVeXgMB6rLiPmZMp56Xvvd2MsbR0jiLCIOWM52oil0FDJcQAnPi
 RWmJ9AahzESZ6gyKeDujeVAhnPI4pbl4LXj7XhMdxG6RyvQeKZIzewE0L1snVxGBTWofOtIjljaH
 p.CCHlVp4rLJ09QUc9PJglFQi8pITM9a28RxLMN8kpEKwyKK1.czFMDNKXfQ_y4YA1G58CCMf.JS
 q3gFM6T50Jn5hWRxAU6rlLYZcUwMntATP7z_97wJCBCTABhJdAxWzeKJQSKySboo9IAye261Bar.
 1_OND3NcGx4L2wOUfVK0fNJgVccx6ZiULSvCIudlX3asEqAziFDcq5RzAMqkChu6JKnnH.w7i2kG
 AfCfoz8xI74W57OTUox8Cvfyz.0UApBhr4CKAAj4bov5M6gY.CVdU2wHTSZUdsQbMUequaEOj_jo
 oWt.2EDmJ.OY6SvYuK5.eQAbLglr0Dol_wMh5P6.OOqwe1OKE8MlKY.VVBhT6UxMb8gRVizYzeW0
 6AhMKg2hXJysveuXy3lG7_JyWEXObpLJWmIRZYz7CVfXMpQ9T38_4meCeB8YmkskI40WuetscmeE
 tApRseqAOW_miFwZGYBJUYyuXrCZ.Q41G2jk_PFVYnZzXNGXJEUkeFzcqR7S75PgLxg38Lq2HYOa
 5CEy1ScqshdeTUzj0Yf1guZx6z84c3ny9wFC2evLZbqqfblxEf3Se81EtfZAiaLNbalJ2siVS78O
 1d8GNBZ5tEQCFt4PFg7sfXsEnchzUW.c9rxY8YaDysNt4GIqTuOwNp0F9jVGBbpkVxSytwLiTHxA
 81oZpUwVjF.Ghm4.r9TSbo.DCV7CegKjJZ.r1eJ0tgxboJE1nPeuAXA5nfDzOG2XDsmn54eE3O0j
 W.PJkHe6MDmWYSc0qWRmdXrtl1oGtAhx4NbdlAViv9GIFf1dxT5ipPhBkn6rps8Mzk9tw45BmQg8
 MBAM.e10KPlwb4avY2DdCs3kDh9LpY75aNVQ8B3BLIogJLGmOotuIhb00zNx4iBMAVlFJ7nFd1mV
 W7k0gD60EBSahRn8NLZBeFhu5drMX6rwq6RSu.gpDLlwZVSKu.73Cwc9PxHNsa9_8JYO2N4I7dhS
 vWNcaRKYMhDJVsKSNPea5SnQX7bp6f7Uqtm_mWLE9oUchdzr164CdqWA.epkVP4KB951FYnp46Gj
 Eexgi0gmXFCqATFsTfbhUFuHnMfYOEIGscDh14rw1apIamRVgiLmtc8nkFqe9S8k7Dt01A0BfALF
 GFFEfm6FPAnYY.Tu8_HxjhMfNSQZGkayBdhYVFz2gHk4d3jiNP3YV52wLGiMgCzsVjZ1kjB4jM6G
 GUBmP_smHrI9gkA.vgbMbF2xWiqJOd_9WGe8Sk1koUOpWJSweajqn0t2HRicGcvJn3ozwHlsl_b0
 5FMTwk4nel3GiVdc2KQ7P6fq15qVTZ.35TODCWEepMyu8zFHlP8_TPNH29FWeNG3H8l2VTJO1vlV
 _UUt.0iJZhfeEpx_m.POY1F3PsbmWcFlPGr5nr9nhxUVhLDPSZRYCabjC46Km362A8URpWBD.b4L
 FWp2wk3n.0XdFXRm4po9ZjKkxcyqFIrI27i2Yztzw7yoMO5fzNWnJ2_wfHXC_DJFB0F.kusSvCPh
 .B9roYvLDKyxM7p.VPP6oE_8BPGpQelGYQm1MP.PUTIjldYdDlruRQtLvjK9pFa96vUbfvIEauJx
 hIvEYg20QXKUvBC7abw7_BWKpj8b5OvZjcgNiCIu8CBsjVl4C2DNdQGR5Zj1dHG4La8gk8q64.nU
 bOqXlpJFWH.vFqbph8MYMXlmO9WgBt0mR4_AjHvXoS6w9E1xcFqHgKS7iPBpZZe6YvG1jiyzgyah
 oUG0IPJ0w8g0vfJs15.u64E_LqMPeCUzEVfKpMyW1Hc.MeSTu4R.iSwAriiARvgHjeELXACTvUeS
 LT8zSnqC.aw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Sat, 16 Jan 2021 05:04:44 +0000
Date:   Sat, 16 Jan 2021 05:02:43 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau17@edau.in>
Reply-To: maurhinck4@gmail.com
Message-ID: <1057593784.1519584.1610773363136@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1057593784.1519584.1610773363136.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.17501 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck4@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92021 The Maureen Hinckley Foundation All Rights Reserved.
