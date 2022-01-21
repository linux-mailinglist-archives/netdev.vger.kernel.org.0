Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0F0496396
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 18:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351766AbiAURMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 12:12:22 -0500
Received: from sonic311-31.consmr.mail.ir2.yahoo.com ([77.238.176.163]:35506
        "EHLO sonic311-31.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbiAURMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 12:12:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1642785139; bh=SqWKv1UkNybJAVp7fOrKrSj64oAhTfKfR9pjRgvlnlE=; h=Date:From:Reply-To:To:Cc:Subject:References:From:Subject:Reply-To; b=NvX4GzeeuqN3oFLhkSztSUtZ5oSOCge/G6eLhO35ufnJSTTFsdaC4dH1npSIyNnlx1EBRmPn2gxNe2mB2ryxixgFItGYvFFupINJM27XhDj4mhgbRY/VuO2Vh71gHsxsfdY8qd8eZPCg6vZ98ME+t4/ytpubO0D8sbadiajKaoMg0Cj1aM4sKo8CjGwFwbdas4srgHIxnAy9vnZR4U9ApBSUlUsE1BCjxKWQegOY9lUaseeDkU6CCU2mMMXr6QFeNVP3XId6cFwzuzVg1BOpPhCjW1H0BnYdVlIL5TOdllBixpU8Hc4aiFxj/aHMg96hkFEzQcAY81WRNuty2zRRIg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1642785139; bh=MKwZq94j1m2T4Dv7ZLiTRT4yg7ZpyKhxSRbmjERnhG/=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=fNryayNt23cyCinjqZUbgFcxRh7Rr2+03uTvjrInT3OxKBq2Ux9k/zn+YKV7YgqiPwzwZH7tzV7FdOkvs6B20i1QLQHNBk/ah0RCNoruV/qWUGxvcxj7HwLRfdsEAIJtcq1FTe+JaBujp+4raY7ojLoG2Wj2cZtkvO1nuOzFnW3pZIxX9vcNnJUJ2w1xf6C9K1JqRkV0HYOHSlacCuF63EORNBER7pRsHgHXXva9rwsq3qY7wCPlT3RmTI2ZiM7/EtGHJBqZcZoO8vnGHVwf2xqozjA7SNwXVOYW5+PU9pWmU9X/niY5X00cS4paLkZyviKWMUyjNBB2pTeL1sLy8g==
X-YMail-OSG: h8__cZwVM1mOsf7y_8Ty2VFMz_Ek5p3FsS.qp_F34Isj4UIgeYWBrtcqp13z6RC
 dW0RyPTAJR7h1rPwYyWmL53twXWyYSm8TL1xqugd_bs6_g7Q7xrB8wDM_Eg7xrDQxx0HaeBhLlVh
 LdQzsS24wcnuIS.HNHXNl8NjvESLHte73Rc5eE80XL_tlpYHlYIjdUjWiVZL3BTfTl.GSQn642WW
 _xdpIuvFzec3_eRDoMn4YSgOydLu35lRW67MijhJsFZBFy9DLPyVg9fSPMO_Z5sb92oU6yVl_u0T
 p.ibu9xKvcyzkkwY19u0u91zI.5_rzmotecLA.om5VWAA.G7WN74Vd6QawWejeJyxfYfmtrIYQfD
 dTTa2qXkrOApyVcPyXn6ra6qez.9NwabIzdCSP.cTRPUi6t7l_YfTTQ8ZrnUVphOLgb6PrwqBS6.
 _wp4aVJO7vdvV8tddqJ9VdLNUCO7Y8ujAXO_xRpsp99lTP.n0Nt3cQs7_p0W1JJdjYpptcIlDsvk
 YBDqygjEKXL7QyKXKaxqW8jNBlu0e4cSzIMY72W3AvrFlEuxKsgdRi_LoXyJbLGQKqIsHOggKF1G
 wUd4mddw6N9vUfCHlMz._ymCdCSMycqM_DhATG3a0oHmxBi9mk4SyM3G8mvx7YPA58Jyuk2YrX5r
 T4DQd8_mk0wjBokWkq9KX3O5TAgDkN7IU1ZPpM_lAkvysia4vmzRD16G.Y2TLAB.unv48MOXbf.O
 o2PdJdQo7n1MUFTq1rIpR5_B9guniVc334BdRpeBj6smaej.mm2b4PlkTeKr6sJlu2HSKyFa_QjP
 J0rMUf91kXfLTwSrotanZYOfBsWb6TSL9PiGB.pBgiDhWqXA4qqvsddPi_na6amH0JvH3ETWvXef
 eEUQDSsEjUHz4kp5O.GCuwcquSfz6ViYC7XEzdmF5V0shEue.NZed81xPB86bplw.D1OIrMlOS.i
 TDxIRhuDP6ydWdDqZL.9CjD8q8jH.96Ia3uxdO_fA3gUfwe.UngqYE2MkqnPKXoYV8lmFu2KgQYr
 lFfczGexyV3zOCfpfzv6XMowyOtdjrGH94IZ6R7FgTvdueqAZfC.536e5AlIbvHrNtpBLKa3Luy8
 y56G2HSdIvXOBL9izwCbpFM8CbuNwbABig1.N60vKjC84o031IwHV0ZwDyn8L9DnU.Xlz6mZmSAc
 gXVUpy2fSleHj4NH_JYon908QwIIHksivzVmqek7MoKkNP4dn8qHbx7.h5romL.8KKoJsWfrMMpx
 e1nVqz.SoHhhgj7guFqhz2KCIKYnsA1veuq2T2HQolt38HBs4lS0RQtphor0gLI3VrO0THIIZS0F
 k5jqu89Qk241Ph9mQ7IfBnJaJjj.wsv.JLNAMxc9EVBUkxsHLs5ctAiDDw0C4eVSoMuolNWGgj61
 y5mG5jQtQFMTDczvw3kGIrUCNw2keKLoWsvsw.UsQo9jyKEzXtLCPYONDTTH8fWpW_BhonEEOpE.
 V6BFEnoCDTmX8GZEf9YCS2jcUHY3q8Ln71RkFqurqAqZ9rMvD5WfIM1PF9CrUA5riBc0rU4AI9Qb
 NbdYPoAMSJ4_fVA1HRFvXZUFyhCANXNdI_FOXarQAiQunc.we70izx1czAo8PrgzqBr3LUFXpTub
 v62r2hKawEMtti2aWRCg2lYz2jKJa2mRNV4fCyFYimIdm7PbvAGdIZfg367YjDAd.9ncFXeLWlUS
 odubro_jkck.bq7hxcsqQLIhNPzV.xvV2iVFQcY9u4AdGARtYhSCEiQQo_OTIvVshRAdkohxRXTw
 7uRpn4CAlLwP_7CT0fuB4wVMAzK8uKfdZ31DHIVP16dsxpDZuGXM.QckQDaFk.zMvUKOXkUxQX8j
 G9yIGua_WrnQ3QRUMqs6Ug40QOzxtzDHQWo5tGm8pYRMpYspAff5k3FtDeSagkFNMxfDnXsfJavQ
 pHy3l960muTtDwb904OjEyuUUX4.FMA4jGqJr_0FOoECd1KEDSeWSsOCSqJq1sz4iDtvwdwZYEUm
 dLDyigFZehkM7CidDxNtTNyZRU1YUc3C3vKW.rQCyZc9u64RCZJxSCfdOTzeQbzNzidd4ymCTlF9
 HnqcghnoRxL4Xb2EDlj7kTjpqdzfkoHieLmRAgpiMISD8PzdHL.ERETZS3hPlVce_zjGxH4S0yPA
 nKTQMcbiIW9RpEpF07scAFUHGv_r5qldmdkyvPMhheWxiKBFZAjnNe_niwW0uAIz8_51EGNSIhI_
 41rb8j0b5z9P3CbwSQUgSYI_9qUQN4m0BVE2ZYl2AlJQdXu0jXpCROsL8uhVK5IkDtHnqouUoDp8
 TiWk-
X-Sonic-MF: <htl10@users.sourceforge.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ir2.yahoo.com with HTTP; Fri, 21 Jan 2022 17:12:19 +0000
Date:   Fri, 21 Jan 2022 17:12:40 +0000 (UTC)
From:   Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
To:     Luiz Sampaio <sampaio.ime@gmail.com>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <larry.finger@lwfinger.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <1735835679.1273895.1642785160493@mail.yahoo.com>
Subject: Re: [PATCH 19/31] net: realtek: changing LED_* from enum
 led_brightness to actual value
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1735835679.1273895.1642785160493.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.19615 YMailNodin
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -        if (brightness == LED_FULL) {
> +        if (brightness == 255) {

> -        if (brightness == LED_OFF) {
> +        if (brightness == 0) {

NAKed. I haven't received the other 30 patches in this series so I don't know the full context, but I don't think replacing meaningful enum names with numerical values is an improvement. If the ENUMs are gone from a common include (and why is the ENUM removed, if drivers use them??), and the realtek driver still have such a functionality, it probably should be defined in one of the rtl818*.h as RTL818X_LED_FULL and RTL818X_LED_OFF .

My $0.02, based on this one only of the 31.

Regards,
Hin-Tak
