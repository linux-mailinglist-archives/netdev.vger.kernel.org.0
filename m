Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A2B18F52D
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgCWNCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:02:46 -0400
Received: from sonic308-56.consmr.mail.ne1.yahoo.com ([66.163.187.31]:45496
        "EHLO sonic308-56.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727608AbgCWNCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 09:02:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1584968565; bh=/GcFFbn2btZiSKYiGCo/BleXlnSRHZPoMjv/YxR5ftE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Sk5A8IMhdqLgo/PrHvwOLGF/GhbK5x/0pgVWx5iaHL881X9S6LEND0Q2UMARjJUGSltIx1U+2u8eM/Lp6QZWKfMPVxNRKmjthOucE6lw2gGti3b8ulmGCDnDCNxdY6z5XC6iudAKFchf3DZgwlOiuDKJYBOqUyE9bq1CXA4zozlbJ6Qp0v8tZZFJiA/ywCl+SxQvqM9LgM+/T6klBvi6wAB3gUiKQZ1xv3ymxbnBR/csCipXMlUi7h7H049rjTRdW+ZahH+0+q+41M5aLb5mBHAgatmsuyedt54FyVgsDNcf3SY+d4jWQQXISr3umMhhE4ajdHV3TGHfaolZTt7OIA==
X-YMail-OSG: PEk.NYEVM1n5Brrvby.ZDNhOE017tzxG8m6JYI3cLW0pSnHM6SOqCDFS3PDF9SF
 QC5RySrn_93Sxqlj.11E3RyUNVkN.XbL4nAhCOKO84tCN.xG2bUoMHii2W7yAadUWlWUkJoIPPt3
 3mfJfq2ktGdhu6evdGau4F.bl77BeNh8WWBBHvnFNfk1hziELYkN7YGb6e8T3.xqzPAZRDo5lQbd
 z2aUAp2gKwxad_k0b6WBf1U6hhLR_ZJj4iq34d3r1VHSvK0TDOjLXPpzmNyslHHYQgBF.Fq4ekQH
 joIp7nHdK9IpxjXR6sBTuIg5p5XapEM5ldZ_6tUfP46NnoRk7hhEdpllJHEpLS4h7JeGcuT.Pceg
 ulbuZsA6ndWrYRa_N6scqE3bNVag1906epLdkQiwDGccDAcwlPI5BAzvYDup85QGRk5doGPatSCp
 uRjJSbd9UyzOFSg9k.MUCGLNtYQXDiijWt7znQXstbnQPxsOeDsV3Th5G92zFj7Gx.g6v.TzozoU
 p_kdBwZ64GSQ.jp7nqSw7Faqjw1P9hkAKFikWIVrd3TcRu2ARL3bP3bWKSNCrOuokFCo6gdWdnXl
 _al.ENU2ZOUf43dBRgpXxIw05Mhmx3EsFJS9Q5OdbxuUeq7AbLqXuI4Bw4CeWer.ckGlYy1rdJb3
 m_gMJFLV8J40z62C9u765SaS_0btsOFCnQFIATH1FmxSr3GYcGqmZolVAC6AWGmwSkOMoezgQ3au
 ECGqB12FsoYbMUZ8XILKrO4et1v4aN67G_U.4kktZ1W1d9AxnNUOG9Xe4nv3jVLMgWQ1ybmjVlgJ
 RHt0Vq_RcHeSz0DYsrbopDl.prhsvfjEP4_QVBqAC29XuJcNQmSOphzNx1RW6OTFcd_E_SVF6Uzq
 NOqkA8LcPqcAFcCo.fabxSPHUuGIppIXHnuUyDGjf0QNlV8VvWmQeTGejyaHZZFiljLh2plXbRwZ
 quvLJDsSGLewHbkqXZyHB_y.w3zoD5MGa033kDlCHyoBOlTUXTbssTWJiGASCLrOEVqGg4ry5njt
 jzThhgbAZEqBs0zjkau94cazr7YxYYGbOlLN4Otjj6_1QnyNQnQnHN5ys9jJsqrRIeqs8DYBLycy
 mi_Ku8vZPs_sLvPw5_9ERYVXJ8rPJFOj3T8J1VGyWPRZGfcp3hMUi5bJG63.2vXgP8Rur.aIHIhB
 _9Es96tQxhEHKqhY_JuEszgDsGP9DmaIAJCwXNVNJHNuWn7wzTGio94T3TMVzLxihuSKSlXB7uFA
 nKjn64l8c_Y0v4OD1ZtLXs6hYCO3jJ.cte2T3w3jNZZdXchFm0z71DJ2nG9iY53RVBKOIkw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Mon, 23 Mar 2020 13:02:45 +0000
Date:   Mon, 23 Mar 2020 13:02:42 +0000 (UTC)
From:   Jak Abdullah mishail <mjakabdullah@gmail.com>
Reply-To: mishailjakabdullah@gmail.com
Message-ID: <1760040451.489513.1584968562275@mail.yahoo.com>
Subject: GREETING,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1760040451.489513.1584968562275.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15518 YMailNodin Mozilla/5.0 (Windows NT 6.3; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greeting,

My Name is Mr.Jak Abdullah mishail from Damascus Syria, and I am now resign=
ed from the government. I am a member of an opposition party goverment in S=
yria and a business man also,

I need a foreign partner to enable me transport my investment capital and t=
hen Relocate with my family, honestly I wish I will discuss more and get al=
ong I need a partner because my investment capital is in my international a=
ccount. Am interested in buying Properties, houses, building real estates a=
nd some tourist places, my capital for investment is ($16.5 million USD) Me=
anwhile if there is any profitable investment that you have so much experie=
nce on it then we can join together as partners since I=E2=80=99m a foreign=
er.

I came across your e-mail contact through private search while in need of y=
our assistance and I decided to contact you directly to ask you if you know=
 any Lucrative Business Investment in your Country I can invest my Money si=
nce my Country Syria Security and Economic Independent has lost to the Grea=
test Lower level, and our Culture has lost forever including our happiness =
has been taken away from us. Our Country has been on fire for many years no=
w.

If you are capable of handling this business Contact me for more details i =
will appreciate it if you can contact me immediately.
You may as well tell me little more about yourself. Contact me urgently to =
enable us proceed with the business.

I will be waiting for your respond.

Sincerely Yours,

Jak Abdullah mishail
