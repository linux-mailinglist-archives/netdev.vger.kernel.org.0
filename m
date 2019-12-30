Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72C412CF64
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 12:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfL3LRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 06:17:53 -0500
Received: from sonic305-20.consmr.mail.ne1.yahoo.com ([66.163.185.146]:40720
        "EHLO sonic305-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbfL3LRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 06:17:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1577704672; bh=YooljpITC31Cc9KXMfJzAPmr/1tCBEdX27fhfqn54Fs=; h=Date:From:Reply-To:Subject:References:From:Subject; b=A2XCFyk4duRb/fGdv/yAELWvo1IA9p9zTOt8l2wRUUNwXpOLfXdyiB/dSsNstgc0lRrgTk/dirJI0uQg9wx9d7uuy00L5dpMuIqsjWoLjHxO9dJ1JoyUi10RvZUk7kPvmxfBlunx6345feQvtb8lEjlCOQ/KfiRUS4dNDfeNqD0c5uijWOySpATd16fU/j8AmvugHQDzaVYP9KQE3vE3kpbEOMNDDKfH13uD33jsPiRDMYN2die6DAUxcncryMneJDpvBiXLTqV0eFjOJ+pDEKdhnsGrgsqEMKZjzpO1Zmb8J1498eisi7e02UcXzD6s1BEAKcBJmtNjntEkuBY3Pg==
X-YMail-OSG: VVDV58kVM1nKuaw85KELCtUlOyH7sot2AFQTQIUDRqraNEgNdmbbUCTn9X_7O21
 P10CoFjqnU1a8iFqRtqrbj_jW8e_pP2zPbur2PuIUViCJKlk7Y0yhRl1Z9nP8uGCvEUd8KQIl5XS
 j_P5oDdFhZMKfmF6eK4NaIG5mI1_9l34wdV0NJepsZXApCfksrsWaW3Jc74.3RCmmdxi4jSQuRHW
 lIIzp5rxY_aycggEBVEStrNqf1Rhg5GmYt9CocSlO6OPgNTEyECiYfH9RvbBL8NMMN0_hjrcKGGH
 XGKu8Q2PgkfcLJIiKIWIFopgHy.MPP4vhfMK2pTCGyVc01BT2TtZMM1.MaUFP6gBwDvRZyggujqm
 hTWDgWIXBV8.XlkqqLJGqvXHQdWn6VF0XpPzJTUBK9zWpPAElR5AF8sNZ89R65zawDdBfj.Z3CO7
 pkUmoI8xuBZdE6TcoKPld12SRXYA6fnKlx93eT6SplfQJaDqNVlYEJw0Rdfm7uVrMmKcnkKJm6Fn
 lNKrq_iCc9_evq3iEVo0CkmG9HfPYtJPvkOZ4vmqeglxqW5pYw0IT50PKgHvwQmIsGSA0rUIVEuK
 4yx9KSP2NCONn0GpMK12fP65gfH9ANd_4wzgGHVzqRa0oH3_JmANQ.fhtLecOdelyf40R3X_r_.N
 ySfAy8xTNXJpk_OXDxg0lwqTkZr6EO.2.AHfZunYNzLRAJsvpnQ9UHKxCp0E2F_OU9kqHUg3CgKZ
 oP.xTrpE7qHEHufFquhfhwbR7qZDxgFo_p3HNJzE9MGmbpMuRTsi3rp2Xx4AOft2D3TFv0VwShwU
 0AsAbnBDpbbN05x3RHkefJBsQDM9dMcp3uE_l7w99113R0P7TZgxEwk857rqst_SzYcgpTODdLdo
 vaWWFS99ZSykZUceLPuXYDaFH5nDAKeDmOVNTUt6TI8ljvUORAsxUhrq0mj5RwnS1THq6D_WoYep
 Wkh_oo7LSwvBS5LEhbCmgTgcHKdBflUHA0b0ayyhBgpTmyPmsmYmVpLBlpp0zTa5jeEpN7TRZ16B
 Plkc.JjelzClJUPzXXWn51UCYhtrwT7ncneerePwA4NOUw2qX_Czz.XHod_5CFmiLbAaAmSgdBcr
 Ivt_e9XpulUSVYo2CWbKQIbsayQzOzV9rnM45bknhvj6BrGxV_b4d9trpdHu1FuWcm8Gjr6iQvmD
 .Fnlu5gSnM.SYAGe6kkfu9LUcTiR8wlZbFfzutT2yq4IkvxayxKaACZ865hXHfFLH39gB3PLXD.q
 jzyvUTj65vyldpIbV4goEKyx5o1qAZVFS2MNCPBSFtFYpwKE3PKeYvsFuuyRpdOzFh9lZM0H3OOr
 7Rhw-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Mon, 30 Dec 2019 11:17:52 +0000
Date:   Mon, 30 Dec 2019 11:17:51 +0000 (UTC)
From:   Lisa Williams <ah1195485@gmail.com>
Reply-To: lisawilliams003@yahoo.com
Message-ID: <2065593099.4789026.1577704671254@mail.yahoo.com>
Subject: Hello
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <2065593099.4789026.1577704671254.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2)
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Hi Dear,

I was just going through the Internet search when I found your email address, I want to make a new and special friend, so I decided to contact you to see how we can make it work out if we can. Please I wish you will have the desire with me so that we can get to know each other better and see what happens in future.

My name is Lisa Williams, I am an American, but presently I live in the UK, I will be glad to see your reply for us to know each other better to exchange pictures and details about us

Yours
Lisa
