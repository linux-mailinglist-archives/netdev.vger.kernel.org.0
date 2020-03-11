Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7858181900
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 14:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgCKNB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 09:01:27 -0400
Received: from sonic313-20.consmr.mail.ir2.yahoo.com ([77.238.179.187]:45086
        "EHLO sonic313-20.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729358AbgCKNB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 09:01:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1583931684; bh=fS/zxrHouko99SjSRCxizGsNzMnjKizx90/Fj98ATts=; h=Date:From:Reply-To:Subject:References:From:Subject; b=jWakx0tUO/jgyRyso8D/IYMlzN1/YGvKASbhcje9V+Qi1eElpMbmpOzfThB0HbOHjbBqsqKNTcF+uSkVK3XaUaNi5el3m4yUnrlKCMkHrte08oEFRSR9rAxesV/Gqy3liJTHRfAP/elbfR/Sayc9WyBgnnDbosh+A2qWbhPhspwxk7hFJQpFNBsuMjaWhd7JPMCN4T5s/r5VVxeeU6VBIc03fesrItwJ9JPHEcRBA+NBmbghtOmZAu1kBpBmg1+lNMyXk+YCW8Zp6mv0CB3RbaYvBtae7VLro3sO59333+gyTBTZZEqXDc/jPvyO0nTbpQ2jeeZHRUMFrDuqVdEgjw==
X-YMail-OSG: OoSwBE0VM1neE4MoZGFdkOu7a_T6h9yYYTprAglEPoPjaqJeYzN0cH5nCK255fZ
 baqsxDBIrlHT64zjrxXIH3KZOuU7EKAz1wNmOEHTeyegsiH6ugENU1SKSA0P7gVwxx037oHTlkKD
 VOOFvOJ.TfWAcD87ORlqAbiqNpQvJd1Qbo9GA0kAU_IJASSZXZuyZ5XHAImghOKuPSXECHrMPc1t
 CJDjrqyUyYwXNg6ZVXMPaUf23OCvbhw211gdDVwB0SQRdSr0.ZVVRsxVqArEojEySqlxeJd3WbBr
 qkbmTIyL1tEVfkU4Lk3bCkCd6kB5mMD2C6r3IHKdj5.xnZWgVCDapoDMv52KWtjxPpIEpcWU6rHQ
 mhGQwqIMrE0jR3vtvDj9JaoWo9bBdcEIkl_nQ0VPgzhBRbjcmx4uKL9PHdcNs51cvRGlGXX7Y1Xn
 .lvrPYYVnr6XTzeBI9L8VO_DaA9nB9j88tvOGaaGF1sI2121A8L.sgrFdpUhW99pEGaP5DXDp5Le
 9LKq1PmS.yi_t8PyI4mOPN2zzyhO5eHw0asntBhIsVn069MFbrx2GZzCVXIYGJMXwnu6ZfGIZwVS
 mS.xqeZGBfSfSleNT5e6zly3_E5Y8zCJxbV.Y7bNGcfKrzPw324dfgwx5bxJYgq6xzACsIbftC5l
 idvoOIRu9BFRBHzRWwbI86LSiZBupvtIuro4k51Nl31JDg4XNrT596XrQ.utIkdpG3dMYGrH8e5b
 Gej03NNuI1Tr.obHhSpd20.9JVlI3iY_A8wZ5CBspJLi8EYxSwykcWI20IEAgN6Es4Z3Kk.G.m4d
 SzaXvQ0_vx7lU_VubG8f7gA1XKwupGcKabEatMCuGiM21PfmTEX3_m4_qX0R3PIDm4qesyfu7zpX
 NgpWIt.tebXWNfONle8SLgt6WN5.7sfXRdQYR_RH8bqd53FJDZX51UEfxHzk9dyJ.63dLLgXlnPN
 lX5AIvGGW34.HsNmNn3QEsHIP3KYlvEWurUW38ht9CtQSzJ1HrBR5SZaKd6Cx8EP8m6Upqa_DXgQ
 Ax1pdNnLFnCZVVt_b42T01j01jYGEn2LGDngiljBcTY1z2UulQc5qGu6VjuiF1ooo1sWXgJkvQep
 C8ttsznHQ1Q5GGMBKsz8AOQSx1cblw0J5nTTRENlBq.77EX1KBLzRBIT1gdnI1Ov05U4eAOCSFLj
 .i2JbYISYFk.YXGnvunNgg0_sTBKj6Meer_NfFIGJzEmiBWB6OuS88SFGDywd1FygNSjInx013ls
 GotJSqia0gp1rlrKCWGCx6yE9Bi1I.Yti_hugGfO40rNKicDo4RFnEzp_URTUxrkD.VKwuSBMY54
 2IDQgrpvAS5EsPOLs6ine4d9c7Lk8
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ir2.yahoo.com with HTTP; Wed, 11 Mar 2020 13:01:24 +0000
Date:   Wed, 11 Mar 2020 13:01:22 +0000 (UTC)
From:   Dr Delight Haji <drdelighthaji@gmail.com>
Reply-To: drhajidelight@gmail.com
Message-ID: <81383165.421864.1583931682618@mail.yahoo.com>
Subject: With Due Respect.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <81383165.421864.1583931682618.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15342 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:43.0) Gecko/20100101 Firefox/43.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi friend I am a banker in ADB BANK. I want to transfer an abandoned
$18.5Million to your Bank account. 40/percent will be your share.
No risk involved but keep it as secret. Contact me for more details.

And also acknowledge receipt of this message in acceptance of my mutual
business endeavor by furnishing me with the following:

1. Your Full Names and Address.

2. Direct Telephone and Fax numbers

Please reply in my private email address (drdelighthj@gmail.com) for
security and confidential reasons.

Yours

Dr Delight Haji.
