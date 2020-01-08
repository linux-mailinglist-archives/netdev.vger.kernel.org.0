Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E5413469E
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 16:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgAHPrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 10:47:13 -0500
Received: from sonic310-14.consmr.mail.bf2.yahoo.com ([74.6.135.124]:44144
        "EHLO sonic310-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbgAHPrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 10:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1578498428; bh=E+ks7AydzaUb4ISZTuxin7s0E6gVmk5020fTLYVYB5E=; h=Date:From:Reply-To:Subject:References:From:Subject; b=jVi7I+ElIEJEQSbYeQ/tTAfSgVPSJijBYygrAsTcWcs2UGaG46WNw2ihYhz+lqs9ejyCcaQNMhN7p0SJivy0AuiLs7RG4LZp3LJp6djh6gN9fgWJvwVYyeIYML757jl7z5pUAxoF9pL1lEr0ZG37XoIAqZHQOZeHsmK+2ZB40zq4IV/X0tGb2MmwWB6edME8AsACgYih6KKnTJhcOnzxXj3S7QnUehJyJi8L40xcxq40dOu4OvsaXajK5woqEyzENSn43ShpLbaenKjyj1DhcLt5sYCNODicvRTQu1kHSRhRG+sMyGFeb56XZYrvR9uVBjTAo5kfcBSOtT37b9sODA==
X-YMail-OSG: 8sqjnJkVM1nP67nn_Kedj.b6gjz1a5OuAJq6rqasQWOkVvwqHZHqKH_xShuGDwg
 ii6R4AjKC_LdUzwb4kiV3EkYRxm5Gc9Y711BKLauDr7zzhSU83zf6lULXcoYN98FPZHDIOe_d.o8
 yfigugyVqrhKMSjKwI3BaOzS2IpfZSU5hro5vJIwz_cn7oEQhsA5FGG7b2pwOLL0.p5XiZZCSw.9
 0e7gnKmEupfSVnDVlEfuUjfQd3DLvrTRi0SScqXHlaRhxYVcWfgrH3wt25Z5ZpSmJ0zPb2LFmm0O
 YwpnQvUCjSkgP6xnvcSQLIW7rYP6SvpOC3ZRR4KbLrm92SCvBWQqUNR4bEBK.pwHPkkiX75rbgpg
 qmBRmUpSCZApj.yTdPPQvbfjJ.DI0sXRBrsOvJQ9en1TViHiz4ijOvcA71iGZOcgHEax_bb9OAUA
 uXun7qJBPi5nkZ1OgXaTqWtoAdyo2KGxZ2QHffjl0VhNyp0ig3W0sHLZETjU4nMDrQIg5ETqQtuq
 4ZaWGg0XFQNEVtqUU2ZmFFm6Ucr33z8oUldGAtIreuLy4A6zxMvqVulV7E7.g3bSMK8CoN1KQ3u2
 4Z_W3nVNflKRrhVZce7AyWOgshgIe1bZqmX7zp3AkA0zpcdttnw35.IXqrdA3m6zgXqCqVuWKuwY
 vRAdzA7XJdbqmlUV.hsRDCF3V2q8FRMQUhJVpQYRcQRNcNnnu4fbryiyp3QKkFu8X0wSIPxa7LTW
 kiqDz8eTj_1_KRpD1DE11ZFP7sI27rDjiBvnhyot8grGnZnmOgau6P0vxKRyuFE_zWnXzsPwaR96
 ZBV_1IGtsjJw8lSg3j87fcasWOpZ1tiFg1Vu8A.9sGeVCx5wmlOQYIc7fn2Irltm9AdjPKdLXhWh
 HQa2IABkjm7REf322TzG7.zzEt.zSBGhVxUYrOuEBpHg3H9jOjTBj0fqBHtEZ3PSZNiWyA3p9UoS
 WBQSwUSY72Epa2KocV_H2WklUMRNmA2.atMktpSmJI20AxfTEVuswmqQjDO9qqUx2T1OJc63UBnH
 tCeUMPlP1fdf0Knb55Wz_GvNQR5bfkaSFIP.GDnG1oLjBOxNpFwXuBDubOhnDpNZGr_zgfewCEQ.
 UQNteDcRMBenTHfMdD8uhSig5cS7r4vuLZBJL9nzOOIZZ_XhIonJZLnzW4UxcC22SQikrI.Kc_Ss
 1GwIIvjaZ9BsbFNO0xB8ERm.YQor0nHvvMjb1IX4Qxgx9H84OgxShmWqlyZ6tVHbjN.HnHfNt87a
 yYwulDZ5qEZJfLC5jMzWebjNrljNeE6Xyt0NR_EVBSRsijLk8aroTslxDnj_y7CPasMUDCnIf_Mq
 ics.DU0_vpjochpAUFrIXWFo-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Wed, 8 Jan 2020 15:47:08 +0000
Date:   Wed, 8 Jan 2020 15:47:06 +0000 (UTC)
From:   Aisha Gaddafi <edwardben25@gmail.com>
Reply-To: gaddafia504@gmail.com
Message-ID: <1380056764.5547339.1578498426889@mail.yahoo.com>
Subject: Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1380056764.5547339.1578498426889.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:71.0) Gecko/20100101 Firefox/71.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend,

I came across your e-mail contact prior a private search while in need of 
your assistance. My name is Aisha  Gaddafi a single Mother and a Widow with 
three Children. I am the only biological Daughter of late Libyan President 
(Late Colonel Muammar Gaddafi).

I have investment funds worth Twenty Seven Million Five Hundred Thousand 
United State Dollar ($27.500.000.00 ) and i need a trusted investment 
Manager/Partner because of my current refugee status, however, I am 
interested in you for investment project assistance in your country, may be 
from there, we can build business relationship in the nearest future.

I am willing to negotiate investment/business profit sharing ratio with you 
base on the future investment earning profits.

If you are willing to handle this project on my behalf kindly reply urgent 
to enable me provide you more information about the investment funds.

Your Urgent Reply Will Be Appreciated.

Best Regards
Mrs Aisha Gaddafi
(gaddafia504@gmail.com)
