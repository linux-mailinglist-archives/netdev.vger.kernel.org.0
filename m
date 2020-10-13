Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9178A28D015
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 16:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbgJMOT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 10:19:59 -0400
Received: from sonic301-21.consmr.mail.ir2.yahoo.com ([77.238.176.98]:40877
        "EHLO sonic301-21.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729330AbgJMOT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 10:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602598796; bh=HfEvBbm4fkgLsQ3nxduGtdO9bUQ7AvBvw/hw+XWESMA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=bWu9bwYzG2JEztmRm7z1eaf4pP8e1q0eStQJDLO7PcwF81WqzcdUD+rNMiBg1QzsXfjQ9gjK7yIO2aHkdPRcJm7ugrua2W4LPL1rvH2y7u+NVJpeROLDd/GRdATMhnIlSxGBYoQymHz60pJbaCeNmxJwblJyH+lnQ/TSWHvLPoVrwJnvl7WmnD6REj8Jk7DBUQh2VLOItnbLeIbYLj4xLUVl5rANDdcu1MVFKA2eO0MojUpz9MHKhw3AQlRNv7UyXSfET5ti+gXSEzqZaOAJFLWDfGvxBeRcKlAGElH/cVipNEdQlB2WL0D/8kUMyGDoBLWLaiEOnFwNF5DGROnnkA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602598796; bh=g2PTBWY6h0DnV9qQmDVoQV2LiVWzsine8FfdBmUFlIC=; h=Date:From:Subject; b=eLzF+u8EM7NCStSACnUh0tjzvkYjrCFsXJTGlq0g8cIE6Tnu22VUGSAlx6k9cEBBXGToXVbIFaiBlX58YROVWwRpjvgF0dCU4WEk9AVr85icHKw3hrgb8SLuwa3+SMUNYjOkoONAXOvtO90XUo8UTdpmqWUnBc76PfMcvP39PJ9r0KpC3lMLX6YCkbtOB9NWK+JlzWzCjGghiDsG6TFSo8wFJPMeMrOp5qbc6QNp3x+lC4Xnv1EpTLNytblEOVQg3+CdDZufaVgP5gMhAtbwX7BCuKFWVQD/SId21erSl0lSFSwsMUHvzT1N+7MkJTjMOP4oJYqut0EqVguPDOnqPw==
X-YMail-OSG: 0TvHez4VM1luyDHrZkDCiGlTnEwAN57uhOXROe73sXDfH9eJvSn4_69LWbAfa3R
 LnCxY5m9hXU7h3AHWrH96tPMiZH9b6HPm2oAg7_d2w9ILDutyYxJ6Sw0gEPU0ToA2o5Vpf6rPHUa
 cNgqwitD4vgXvXMlVCtI.pI26mvOeqXc2.xoHvLRnWpSxBwthYeWnTrd4a1qgS521DP3gZ2X258M
 mYX1kD7YaNCTydKxPPvY5pg1v1njMHNs7NXg5LUxtdCxjEuDi2KzEKsRSmnOK9Cu8Amj11eai3tV
 izYKsA5NPjPA3VieA8gk6pe1OCe.F4pCzuY1jcsyPt7LXTFWJ1Xym1TZtzN7mB71mS7r.hIZDOfo
 zJFNcIU9dU_cQkEcXmyT3b2NPHZLeSqmInYfT6mlD9ES0xPm_Vo2rz50bXx4CWuTgT6dVlJN6WWP
 gwtoM8.ZonmIvuC5Ls4CuR8Utyyp7sbL3VfZHYQpQ0r4t70wRnNZvI_gKtHUf3bJ.WAnt8jg3wXh
 0IqTyvX4snWEc18R9SQ.w3jbmz79Ef.1vpu82GJVE0MYBNZ_ysXrQSZXQQC08FFOyZA7Z5y_b6qd
 P2CS9e5oeX.E4xYXGzFWBI1QHz4aJC_DurmxCRfwt.cfVLtaxdDtzteOweh41ES6B8KWCboTff7K
 HZcyYBRfdC2PHimuwKqXFwEdruM4cieFipKAhHNHTxhEwINL.Z2MiHxK9As.hfEosc9.LcCqoiOY
 EzPtBNA2kteUQrZ0n4S9OYqpqWR.0tLm6a8Lw4iMO_fipDnZNS3fBeWKN.w4PCXjq.Q86_9xOGKK
 NztcQqf4wQgkGsGhZzyik0lxuwlHj3ciIOo6r7e8Qc6hxgIcZAG.xDY3iuC_OA7i0vqXj7Zqxh4H
 I7UFe1fwOp7t3Ls_uuepQlrFHIfUk7350eUllmXDqlsVXgJSdTH6.j7NjyhCuoxo55wFEeUzOyuS
 i62JGvRtoIZBPvxfkNx4U8fmhRVPgIRJoVhVJdBoN7UeDmaFRL2pH34AQiHcuyQH7iNgod_pAYQ9
 32XzaAPfrHo4e329bEDLfvkpAZIK2slC0vf6tw8ZAGEZqCLVdcf0Z.Hd__FU3p.VGfN12YuDTLLh
 br1p2mzg8xH2QkigCmgukltxYvMp0jMt9.89AVw_NnuhkxGtb4LQXHHoX2vOLYSMb4UDFjzueMrS
 eajDMgLKekt61HWZfaKCwyNtKPEmRC8PYQM4t_KAIJklPXl7FwsxLGHycwwjn2DYzqtIj8bs7Joa
 8U_A_FUDk1_RR9SdZciiSTxO.c_R_jPliOfHmbB1I6_TySBADLhX5Y0ZOTiIwUQ7A8fm277o.CUA
 kdt9dASUWmN1Tf7vu96DXh9v15ErM7MRBFjgkky.68XU9Xq.gfqaKVK4WSaqNu2n7k8eIkDsa.Et
 XSZ1IRxEZi9nWAZaCAsSBInTcYqa_wdzwCtLUG7k24yoQf1qa77MEqxlC
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ir2.yahoo.com with HTTP; Tue, 13 Oct 2020 14:19:56 +0000
Date:   Tue, 13 Oct 2020 14:19:53 +0000 (UTC)
From:   Aisha Gaddafi <aishagaddafi002019@gmail.com>
Reply-To: gaddafiaisha0101@gmail.com
Message-ID: <955271187.385689.1602598793665@mail.yahoo.com>
Subject: Dearest One.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <955271187.385689.1602598793665.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16845 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Dearest One.

How are you today, I hope my mail meet you in good condition of health? Dear I have decided to contact you after much thought considering the fact that we have not meet before, but because of some circumstance obliged me, I decided to contact you due to the urgency of my present situation here in the refugee camp for your rescue and also for a business venture/project which I need your assistant in this business establishment in your country as my foreign partner as well as my legal appointed trustee.

 I am Aisha Muammar Gaddafi, the only daughter of the embattled president of Libya, Hon. Muammar Gaddafi. I am currently residing in Burkina Faso unfortunately as a refugee. I am writing this mail with tears and sorrow from my heart asking for your urgent help. I have passed through pains and sorrowful moment since the death of my late father.

At the meantime, my family is the target of Western nations led by Nato who wants to destroy my father at all costs. Our investments and bank accounts in several countries are their targets to freeze. My Father of blessed memory deposited the sum of $27,500,000.00 (Twenty Seven Million Five Hundred Thousand United State Dollar) in one of the Bank here in Burkina Faso which he used my name as the next of kin. I have been commissioned by the Bank to present an interested foreign investor/partner who can stand as my trustee and receive the fund in his account for a possible investment in his country due to my refugee status here in Burkina Faso.

I am in search of an honest and reliable person who will help me and stand as my trustee so that I will present him to the Bank for the transfer of the fund to his bank account overseas. I have chosen to contact you after my prayers and I believe that you will not betray my trust. But rather take me as your own sister or daughter. If this transaction interest you, you don't have to disclose it to anybody because of what is going with my entire family, if the united nation happens to know this account, they will freezing it as they froze others, so please keep this transaction only to yourself until we finalize it.

Apologetic for my pictures I will enclose it in my next mail and more about me when I hear from you okay.

Thank and Best Regards,

Yours Sincerely.
Mrs .Aisha Gaddafi
