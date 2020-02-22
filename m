Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19BE1168F57
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 15:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbgBVOfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 09:35:02 -0500
Received: from sonic316-11.consmr.mail.bf2.yahoo.com ([74.6.130.121]:37100
        "EHLO sonic316-11.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727259AbgBVOfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 09:35:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1582382100; bh=BwDPrsA2+wE7onqC1JBBbTtzaCQs5syyrmDpzadvHSI=; h=Date:From:Reply-To:Subject:References:From:Subject; b=I7B73B7Du/7lfAIQ7VDJ12j7SoIFWMjozRJS2DAT3gb/n7YwS80fqNfTphYTpKgZ+BTpSEya6uX7x/ZMyc+SlzL9uzeZ22Lk5sQ9aFMGqxwo5s97uk4zIlO8GqIAHicbVHUedwkQ0b8ivrJxEebCpW9/OaqoK3geioUimFEQW0tH/eb7s4rIE8LB4JH6nBWXxAmk2fF+/21xvoTcg1ZVneuVmsxlfgh1jd/PSf/ji25J8iXAO/unLl+JOgowofQsKAy0LvDjeu523og0z7EXCCun85qxPSSFucjuwR1KxUl882uQ2qBVKIAJkKqH7O3pyqE18BAfj0MKDqOJ38xADw==
X-YMail-OSG: 5vtwVsUVM1nlJTe1KwTRUbz3svlc50sfE96KeUL1f0GHnVqSRdxXySekwgAv2yz
 fXlhDUD9EPAYIKNYwzSxMREI4z0yS3bGXqtQjEOTx1BM1gPZp0a6MJ6ufQ.oyjHfCF4QayTdQKZT
 gLQh3EyXODKDZ1uscrEtOqIPU0W9diqUBJEQoLVHyO_GG_ElOYacuijsThTKEdqSWWU.pcRFTuL7
 ZnVW26aJpqnV0MLAhMA4oZDRRi4duZABiJTqYVWcqC04ukoUfgvBGZNKOEctCrV6Jx5AM1FAN5.g
 Pn5yM3isf9BBAMfnm3tNT1LaZE_CCwvrU2nYOS3o32WQOtOZR4b6ulHjoiq8jgr0PC0beajB4IZq
 06jK4ATxbJrJTebjuRuNXckznN0PZSB_ZYgW1n7ECQ6J74B7UsRxzHQAcz4dZsfdAj5kfiztzWYU
 Enr_go703NYlT7O0DGP3Ukd33lajeh.I9WN9BFxad020FTjWRJ7BM9gb4vh6ww_TniGX8om09EPf
 jcM.Czq6Kwie52RGMNUQ4sZaKJP8z0jgM4kqBYm5S9sWRV1cxCpZwcSnPCYXN97pJayImd9C3G3p
 BcE4FVtdyD84W2AFUV.vDg_f4NI4iwXDg2mGd0jE.riECuci0vieuFATicOpfF0CM3omttZ.3Elu
 ev.6v15Cv6wwwjURcpBpYkFYwAzdPm5FmJGNT2yiXUI2lMDp8rsP_zBG67vjKnHIacsnjTJyv38S
 Fc.VcG6ACsCX6zXouy4BM00m6gUQelZlHWww_bNKIchXmrd1Uj0GmQs3dfUgmOiC3sGdUnPlGh9F
 WNq2SPlgESO5NJ6EMXzFIPH.gk_9iOa75FPTP6PGAwLCX8KcZAS2jMRZ9RBKyJgpNP00PW09UCPl
 2pW1JMcX4KAsyHb49R11m.yn4pO4OWFyFxQrygTnQh1U546_RFJmWaKRGllWkKneZTgTVSUGzECP
 E57VATjEGtF86C3cHEY.5H5aem9K_XN7pF4rBflN.lryadd0JgRXBl57Uqn4BVMEQDVY3yY8XbWk
 ggBsGXyyTJ.mwewPbjGsOISQ4OHPoiw0E5nB0Z5PzK56YjC088sx4hsuijx7Ad5drPqJzcJmLvC9
 V842T6Iu6Y1UVmzpOPdTcn3AOlsrjEaiCrinG22dpEOFlKnDArMzWbY24mjEpLjerUbCcq4IdKSD
 FBbxVAxFN8.xKC6qVzJT9vkPkSMx5G_H4VGoew0onZL_G0Bim4uS1tFftgnUIxKkri0.ONisrSSC
 aSujVejttvPCK00Hg4cd09VTIgkT_5VtBY0yRkfpke2_HvPmPLt4BsslfPL91RAYsVtz1f76Av8p
 JpQI-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Sat, 22 Feb 2020 14:35:00 +0000
Date:   Sat, 22 Feb 2020 14:34:59 +0000 (UTC)
From:   Lisa Williams <lw82831@gmail.com>
Reply-To: lisawilam@yahoo.com
Message-ID: <1557056426.457732.1582382099727@mail.yahoo.com>
Subject: Hi Dear
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1557056426.457732.1582382099727.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15280 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Hi Dear,

 How are you doing hope you are fine and OK?

I was just going through the Internet search when I found your email address, I want to make a new and special friend, so I decided to contact you to see how we can make it work out if we can. Please I wish you will have the desire with me so that we can get to know each other better and see what happens in future.

My name is Lisa Williams, I am an American, but presently I live in the UK, I will be glad to see your reply for us to know each other better to exchange pictures and details about us.

Yours
Lisa.
