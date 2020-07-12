Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1513C21CA1A
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 18:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbgGLQKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 12:10:38 -0400
Received: from sonic316-26.consmr.mail.ne1.yahoo.com ([66.163.187.152]:36800
        "EHLO sonic316-26.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728862AbgGLQKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 12:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1594570237; bh=AEu8nK9QzTA2tbqo2l5BVwPShMs+2VsmLoZOZv6b3Lc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=NsQWxkJ+lOuhGLUiCTFmJvOOjLoEbPdnFO4HO54Z8YfwZx1DtULAPE05dHXFNTSnhj7nR8LA361FCxuyfI6imeLKxsHpI21C5hyAfpUyznxNDgfismtdo4txF9KikO6pJquhey2w9qnPeI6+SyRwaqDoGEym7IbfPEbaVpR/qXt534JtAr/tfgAXayFrefwMmS8PT/0Mn+Rb3BgB8Fg0XGgtsvWML0JnfKONSUe5HUgKyTMc1oqXBYfq0BdKky1y1rIdxdHRDEamubOaTsnh27F9ParoAr59U2ZFHYKcxwZHqqj9gIo3CHZGh3cr8IFyzFswJliQPxwqRmYVjeZEDw==
X-YMail-OSG: GKIt6IAVM1kD4hOzUL6CjZCzraKdh92hSTJ3DPiVSlWinlC7dK.bTAxYr97q9aH
 70iXSorKydn9Zp0OQSBUCpItLwIKlnqdDl0fE6C9VYIUu.6hQldEXUYdZt4PdKJakX8AC_XlygSn
 e9Boja1B1dJY1c1MhaLEoR7wKkiMR7pAz2TSBmphxZ9DSlLgPkL3C7tFSJP2cttd0YH5a_db0gVg
 b0m_IDZzm4EYaozVi06khYKEYisg0PxVMZPTD2GSFzpf90ZVod0WjQFFtl3r_LQ9WbFHzVDX41oW
 X1EbmUdkta6QBYmp2aZyQzZddbdNfBI9PglBlZgFJhhH7HYsJc8.Vn1asyE9IqMQ7dxGymgX4zmi
 qj6kic_P0WMi6USpj7dGYzLs07fTR7ORP3E6ArrkdPPKizItEZhzEyAZgGn4G1OLRU9AgDoiVy4v
 lZhSGBXRjv3o1PrQrnESQWWRBsK8aOKFy_psxxoHwFhH19bMBR4prGKH8HDF8Q8RFpubUGRB05ou
 vaJf0gh9CVye.lmtQGREj50910VnUTRYxRP4i4cHTc_OK1.97kGG4jcdx9cPDmgaYTmCtTOavNpK
 CN2YwqHTD7oBfLv2mZa7cibjlrCqRQ8k61vfDQ5zRlwGxnrxnTwceQjcibknADmEI85H8PfwYqhE
 sx9EKXUOdCpG0Y5T9m6yn7vTKA0Ilftqn4UmLIYa4r_6.b8wpCzAI5_eyWT3Eg90vVyvEzjK8TnK
 1cfykEOE3RW_pPLQvKh3TlpLW_e7rddPLtbHbmks1wTsSE_0bRB1oadYFkrpZ7f.X0_DRS4HQz1M
 3yw261.HyyT.4By8qBJeMg2LGRoIwwdpNhwkZq7aYoxVtaR3cuQZAXCN.f7GyuVwxAyUm1BDKxra
 3EBrPjhUuM4am9YDaQW_z3aDatGPubJdMCc_.isDHqqRBJwPKA1arYwO9W_kGbxvN1FvkuwmXHDi
 uwNMAIqgSXl8zJY073vnwhBt8f.l4_s7LKh3K.YcmMNmPwY6fIFTm2dZNjydHJW4F9STcAp0SU_k
 33AeZNKN.UNU8D6QIeye8IzkaX9HH8n35fdUM0opysuOI9YT91GEEk4D6TWiq4V8q1N5vx74ya2S
 2KskIkVyGJhbbUv2kHNzFiz5MNMS0QWBpV6V.LKPe2GKCDa0LvI_UHUrT4x1oOqqhgRvo4L4t8VZ
 q2h74cUFqQyZpbEk.cIgbQSbOTN.UrFtBKWVTfUJ9JZFpcqf6e5AcmBkoTizmBhtTUeqzK2nOmeE
 xvDNPjp_5wjoWrWm_zmN49ol0TS4VqsqykBJGQiWdwuE3VY_hjYh6.uNgvs8HWw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Sun, 12 Jul 2020 16:10:37 +0000
Date:   Sun, 12 Jul 2020 16:10:33 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau3@hgvt.in>
Reply-To: maurhinck8@gmail.com
Message-ID: <1818866906.432399.1594570233605@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1818866906.432399.1594570233605.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck8@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
