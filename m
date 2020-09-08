Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286A6260D19
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 10:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgIHIKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 04:10:51 -0400
Received: from sonic314-22.consmr.mail.ne1.yahoo.com ([66.163.189.148]:42559
        "EHLO sonic314-22.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729257AbgIHIKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 04:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1599552649; bh=BvoxAevyYyKF7R5+AtKYL5iIy7FXR8NNJE0+LP7mOpA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=pXDPhq4NKbBQCjSUkVTtnZiMNReW2laZQHMXUaNzz6oCRpDYlcBTHZjac+r3mabj0CPxdMemxsIIOPebU4Msbl9YJuijiLkyNhbGn8/Fm+XPhfCvnoZ2p4g7P1TDTBzxLmt+lkhlDs2c5WjyqJ1XbiERzqmcPhHdFLFPtu5ttGiV5Thwrlk9s3paCfnHO8A6srtPs791kt0upDlsmB9BwZEnAEFxEnQF1O0LFA68TJl6PDY0etG9zuH9DShtv/yAMYioJ4ZfgfFJHW9WRWq6j5a/q70v2iHMHjMQTsET5LpppMx2kuebsbDDxHgF2LUiX3im/wZed/edB1kzwUhXOA==
X-YMail-OSG: vO588iAVM1l21GSkIqI1H8U4EwunWFHVhcfUGxlqlCpq2IXwu8vD59lTGfL_Dnq
 .hXnlCyVgZWeZ10eReAuzDL109ge7lEimDCdiqJJNrgTN5zRGVWONMZwab_Tg1NsCrR9iDHhcFOd
 mHVV51I3k_8AEjkPAv7nmhtzxqVwK4MbuwS063qlULjtYMluTAblifYQg0cAcHedfbjY0Yfr1PwM
 i5WHHih4TO9der3FKkHvd4BHQEm8hnqrc2z_X2XT8QGVCMGxrA_LRtxoBZpqQN3BWdHlX2W_7Mlm
 Sckzy9.Lm0xpSG.Wx9SvvNxyX.x.z8xqaVzDDJhgiRwBdjMuT7HrR5Q1i7e.KrzUJKtsVlv3NuyK
 gE423oa_xlNdhIExTWor..ZZCB2WoZfA2d_5csHbAb2a8bXJUMdV5p5ydlqiUb7ezt4W4sTPEs50
 hi10RYc9g9m27oybFGVN7fSnVg5AZksVY.lcgaDKKz7PcLQwUz5Z4q_7B7KgyI2H5Zrg7Bkfz1N1
 YwyzmWcE9C6YrIndXWYcHhrexYzIhwKgQAn5UGWl2weFda92d9ZmeMf5c9yNYpJsC1_sEuIRQfjk
 .vZkV2T2zFlDcG__5z6C6guiR.Izv3ibYWU_uonxhF.JQldag2IbqVK9rjQuhH4hq_TS0DdwHj83
 ARJ8peMxGXMEjBTsSlL9CUxC91ySmyHxHwESfog9hu0wtChD5FBgf5o8M8PfnmpGEujPac7.G4P6
 PKiDOuZAOtW60QQlXqOTTtP4Lv8SkReJDQzP9sKPcoSjruhNQfQg9VVWHS2zhVkjAFpGUspV7HAA
 KonwCuyurJdtEjBKx0jEr7b6paY8HyrKY61uWMCtu5hfa17CXhRo2zYICbhykUgxIkG9C9SB1t1s
 Kb053Pr1IZzJDOa0DF6y6Shg8.OHhIVvKij2wyxwWEm5BcpRqOOD4KbS3gBDcfNxd48SCSHIxyc_
 ix0DsEjyZT4tbQ7G7w9_gEOEuasWoPY6SCyeYaxIQLvGYXiVHYg3u2I7hvjss7.neuE5A75oXitL
 2ZiS0xURvLy8MleQwUmpIv4PyagxqYNCyaOtZOu1VrErL3JD7zzPhD5S8igtNGt6izohD8eepGjj
 AGdpGl1KQD4Y3lG81eOrXnhLXLj.V_6dKaloLqDokAU3tyYOwpxfhNL9w9f_LMCvKG180GEHn4.z
 c70krad3CEIOZuCfRBVp3uPOv5CGxMb7FbeXJY2DDaZvzosEKL_Oth3YMZZaX51injDKWAfXhspu
 fqwE.sSbvI5Qo5iEO4N5wwubxjGEhakM9Puveo5VXNsjNW1mr.mi.uLlThCAejpFPptr2hCMgUQz
 cE3M99APfY4y6zFEL8__gH6ShhLSxgh2VfJaiwY557bgdXdt0ioLo3lOipG8.HNB3DHeHkR.WXxk
 UmkwKGRckCeQcEduNToXtZCirs4exyvr3Bka0BiyngNlQSsXpJ5gSrQ0N2Xnmxqn3VJ5TJibmhOf
 RxQJ3RKYhWAAih0tjOiL7
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Tue, 8 Sep 2020 08:10:49 +0000
Date:   Tue, 8 Sep 2020 08:10:44 +0000 (UTC)
From:   herry mike riddering <herrymikeriddering24@gmail.com>
Reply-To: herrymikeriddering24@gmail.com
Message-ID: <1491499353.4235954.1599552644236@mail.yahoo.com>
Subject: PLEASE HELP ME.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1491499353.4235954.1599552644236.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PLEASE HELP ME.


My name is Herry Mike  Riddering I am sending this brief letter to solicit your support and partnership to transfer $10.5 million US Dollars. This money belongs to my late father Mike Riddering, my father and my mother were among those that were killed on 2016 terrorist attack at Splendid Hotel Ouagadougou Burkina Faso, my mother did not die instantly but she later gave up at the hospital.

we are from USA but reside in Burkina Faso, my father is an American missionary, before my father died with my mother at Splendid hotel,

Check out the web; (https://www.bbc.com/news/world-africa-35332792) for more understanding, I shall send you more information and the bank details when I receive positive response from you to follow up


Thanks
