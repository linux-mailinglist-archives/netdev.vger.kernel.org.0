Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19425176402
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgCBTeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:34:15 -0500
Received: from sonic308-20.consmr.mail.sg3.yahoo.com ([106.10.241.210]:41198
        "EHLO sonic308-20.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727234AbgCBTeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 14:34:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.co.th; s=s2048; t=1583177650; bh=BrwQZanL+3cfs2fmVOVqrgvncAkf+Wn55k/6N6Nq9Vo=; h=Date:From:Reply-To:Subject:References:From:Subject; b=OoOVAguzSlCTfAxiFOydpp8ICAJUui9stVSE5agjdzjrF1kYzx0RQm1jC4WXLxpyyah4ibVRYStKtcDbRhIdE5NyflA1UvAnjHe79MGWHChlo7ltOOFMOJbPjbgUMUraign6Z5jxMWW1HNCbQ/ylyFmuvPD7JR+d/VIyNK/sJx/Uy9OJ2GiTAxoe9nGdcr52oT4KMDmREKFLVOuBD19NoOY6GulGZQcjXWL7fwN1USVNEwfZtTwK5e74ISM3FFilm4DKpHlQQ3CBjk3aOrWBPMisbZ8QKWaeqJX16rYC1mZR7AvkneZXzoNRXhV+wmoB5VhxACbb09A9EgbizKzt+g==
X-YMail-OSG: eX4DdzYVM1lEbd3R7FkGM5Tf8LXBCphYnzjbQ623bNXsYKVoOZ66JAmwbvl5zzm
 hgNeifDTWiftrNJKIZT3jkP4DwYQ8ucTOa0d0EGQ7PKkqmC0aDwOrOmsf_kavXOP_z218RpY5oi3
 0rxI6waamh5kJ03_ZZJhJISv3xR01yVgePzvpTL3x863HEQoeeP3Pb4_Doe_wy3W2HKCpkpcGQBQ
 ZEHd_2VKRtTQURqa9qh1okRUH4sLUEOEOu7DCmeXD7xtgEnZIF6NQtmlnvAqk_xHx42MXwYB8MW_
 9BYhdr_DMvdJ3OLDdKsRDzQlWeT6HCo_eIKACbPdyPW3eb0XjYm3aSmvnEaX.fmgBh.JJsEO2PKu
 6Q0ecB0FSM9IcC0NV5hM_3I_ExwmaxKNRApq6M7f5AoEPS6qW08ij8csTLqsfpwjmDS2x49NqZzV
 XTU7hbtPUAF5xryxqcpVfpvwDdGW3vtFaYZIMb1c5hU1myFSbiSboc2o5gIVvyWvk.8Y3pad.EmT
 SFJhPFcakFkRLbzzwSshCf8x7radpBIEKVR85wu9b.HcU4CcC_lqpKUpy1g3zLOV82BiHILaMypP
 Ehq8ZMphq4DkoGcM4OOVt4jmdzI1Hw1mUUleGN8.d2ToWHDI_FvWmqeir2Ki.6cG13m.yqODxrOJ
 1LX.cYvNKZrqXYczKumuVs4tH7ZvHt3FagDhNeFX9L1m24ZXatzkUOT1fLdXCcj8zFTYoQwStDIH
 uLnZughSZDl1ozodSD_zni9q0arNCvEkZMqRO.vgwFJFtxIeVkqjS32C54yL7QBPaBtvb7Hg34oJ
 fcLlFwXgJ7oNbu6rERYeGnTmknqWJsidJMxrz7Eo3.KO9jQfU6cVyxgqHjZHYei1ejxqn0ZSk4IX
 SQaaTKjdG0BiXPCCW_CMCN06qEElcU2cVFKF8emait.w2l6lG5.VkDfHKUlMX.IRWetKj_ypskMp
 Hqlt7a3y.9ZIToFdMyZ7Pccl3FlQcisklEXqx2SjVyB5qCKiiJOwdRYbsnvWoXiMcHRTNJsnCUyw
 .5oGAPTXT7KTwY63PyHcY7isyWTMYJc8UuIbMVgjw_Y6.X3XCbi6pCmmpJjOXEDteOMet8UKhhjO
 oxSV9MIRrKPJ7VZReO0AHQ9rAnlPs.5gpyDIb2Cr8M0a7HgeEtdd.ntCzggh7oOdjzDNaUo.9c4A
 dHGV3k0Ck5z.jV5TB2fMfJ0u12KIB9wYtC.1pBgCI5EI1W7Poi1HroRl24cKzxeEUkv5uKFf4Qox
 eRAQU7ZIDzZjLRFC30Mzz8xAX0HlyJNIEpP6l6iXL0Q.OlUhP0CNOX7pybSajeK5.csTDewQd
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.sg3.yahoo.com with HTTP; Mon, 2 Mar 2020 19:34:10 +0000
Date:   Mon, 2 Mar 2020 19:34:05 +0000 (UTC)
From:   Denis Aiden <wellbelt.truemail@yahoo.co.th>
Reply-To: denisaiden42@gmail.com
Message-ID: <1971730359.2653834.1583177645528@mail.yahoo.com>
Subject: SPRICHST DU ENGLISCH?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1971730359.2653834.1583177645528.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15302 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good day ,

I am Denis Aiden, it would be great to know you, i have a very important and confidential matter that i want to discuss with you,
reply me back for more discussion.
Yours faithful
Aiden.
