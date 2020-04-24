Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129A01B6F2B
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgDXHl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:41:29 -0400
Received: from sonic315-15.consmr.mail.bf2.yahoo.com ([74.6.134.125]:42778
        "EHLO sonic315-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726175AbgDXHl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:41:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1587714086; bh=SGvvhU2UWXzbg2f9vxSHyVOB5gxWkye3IYlpV46W7BM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=rFOzgHRwkliQtoulAT31lfMzqG+BJMx1k4h2NbWKWqeyfzL8W+CkpmqGI6MP53DeCqxzRnT9ntqb1zs0+MLE5SnDt5H89oQzMIF1nfEYqg8JZF6RoFiyCH8RhtATyyj9be9eJuwfmAPQ3vkkqQbZqd8l5GltqVLDZFO1aEdW87VNI9m99hfGd42p8RGIB4EnY1JvtV31A/IiT5/ePe4eFeHseobKTL8SvaeRr7uT0dv+jHeJbXbHMahVpq5Sn41hrMF5FpK7qPIA0AqQu5dpgfpQqCRuAdV2B4SUSz/Qp0zzm6APdwqTK3LbqryXgjlhEkFBnVrMRwjc6SCSC350jg==
X-YMail-OSG: c3tze8UVM1kW_zp7IBFWwZvTxIDSheBmdR3EACeP4L6aec.3bJmRmSx0Gq2vA5U
 uWpttOl5hJfXSBZUAUAMJ.KQyat.7LbKJoqFOHhAOzs3b7iOqosJGgY1HatSbIWa.k30869xv.vg
 7ign2SNpx7_nXeVNlonoGL2_q0T63i1kTTvTgUCDALfRRgL.bbox9ScMmE6KfLoheZqlZ3UK8VYY
 HxqQIKUnWX1IH9Mf.JzwUygo5XiP8uAc1p40IJiygMrQkw4K40GiDjiedl0GN5NWbKR2CEM9f.cx
 vEjK0M_J.ALs8f61XCZzTI9mT03PA1lyVclYLq7cyBeb7DNmqzk9ygaFJKEjEvonFziT.BoWlNol
 XJkilb7ZarLZSSAvRayTT20q2T6BPjJSRTz68cT8XnZEl1bO14u2K3ilgykdl9MGCxBDxdoPow_C
 J2PaLl1GBzVIrGW0KEvyv4iv0TbvdEJhybEpMBpeFscw.Kyu2r_nvxvHBQIJXRlGNxpH4n229J_Q
 .zyHfqUSekcOPrOxfUAYIautM.MBjcoLDoqhdYKMXO3sk8I8CCDp32ar_7txdVCbEkZ.8UoYeeY1
 567V89UxsfSKCFRn3yF_xvPXVrgpVs.baWsqeQJ9xMd2EmaAj9lTl.wLPHWfNdGfng37cU0beQTT
 GqD6HZCQOmxVKT3Q1xuXYQOTpHOJtWrdE_mGME04uBYaqxIIZR7tzvu97X2XStYHCtTYRG1IQqCl
 T_5GqDNNsRvwgqEMF5HxZFxV2PhT5x4Yww0rEIpm176s63sE9OYLPsc8vrR2s4tU.1dLaSpw2nvO
 Eno6MbhxKDUH_2Cg8Q9W18RMASdGJAwUZRzScsndkfNKKjWhwQbGn1mh3.MMn5g2fKeZvUqa.92k
 2Bp5MM6tVQxYwWJQy.jiUiFNUa2AqlTBBOc53b9hUm3j.iJhbAjStkhBZzk5yAwcgIpBIejQlDCV
 5ZCBJ0NKZMnh3IdbQDWhBfZngPGolkwm4NiTXDJgHrWMr4FpwbBRSjFWpFZOE7aytJ9e1o8_Tsh7
 YXPyHDhOrfUP2D3PqnMBzuNkR.s8afzcrjbmNby8M0aEhvLj5518uw1SUeg8Tys61CdKOvqJzkSP
 2wA7C0ozuEk7WLc1FvGZuG1l4JponTb.Vww7KmEoHAbVWKxa3eis1cv_HfFeyi37dCSkIqierucL
 rEwIgVjhbrL1k29uG_zcQ3bqY1vYjblwoJSSqHWPP4RB82XFAeoHgvqC6PwSTRizMb9W87lb.ALW
 6fqhZZkvkUiJs9x_kxjU4w4seEZ6kQY4XDZRG564ZJRdnaub0gzTATto9to0M1cK.6xX1cv4F
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Fri, 24 Apr 2020 07:41:26 +0000
Date:   Fri, 24 Apr 2020 07:41:24 +0000 (UTC)
From:   Mrs Aisha Al-Qaddafi <ah1195485@gmail.com>
Reply-To: aishaqaddafi01@gmail.com
Message-ID: <1663639050.34748.1587714084532@mail.yahoo.com>
Subject: Dear I Need An Investment Partner
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1663639050.34748.1587714084532.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15776 YMailNodin Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.122 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Assalamu Alaikum Wa Rahmatullahi Wa Barakatuh

Dear Friend,

I came across your e-mail contact prior a private search while in need of your assistance. I am Aisha Al-Qaddafi, the only biological Daughter of Former President of Libya Col. Muammar Al-Qaddafi. Am a single Mother and a Widow with three Children.

I have investment funds worth Twenty Seven Million Five Hundred Thousand United State Dollar ($27.500.000.00 ) and i need a trusted investment Manager/Partner because of my current refugee status, however, I am interested in you for investment project assistance in your country, may be from there, we can build business relationship in the nearest future.

I am willing to negotiate investment/business profit sharing ratio with you base on the future investment earning profits.

If you are willing to handle this project on my behalf kindly reply urgent to enable me provide you more information about the investment funds.

Your Urgent Reply Will Be Appreciated

Best Regards
Mrs Aisha Al-Qaddafi
