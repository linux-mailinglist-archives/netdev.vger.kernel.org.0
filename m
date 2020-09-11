Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C20226655B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgIKRAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:00:23 -0400
Received: from sonic307-8.consmr.mail.bf2.yahoo.com ([74.6.134.47]:46357 "EHLO
        sonic307-8.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726146AbgIKQ7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:59:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1599843581; bh=KhejUjG+aIFEdaJtUCWO7uMjCXcLLdLXH7PJ9JLxOyc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=kD61wPDO4nOuo4/QLlbCCYPC4MSbu3x5uLhcqJSGTsr02qaqfP6qKxwHqRvu583NhMC1/0GjQX1sCpMIm6GRv1aIJqFo8DE8hJ4zLu5wK47mCV6HplYyPAxHoObBc0GSkZ2uG7+Kz0Juk8MoWWCONntegAh0K7kCq1C4dI99p37t76RQsH0HI5cCRRxAhHEtDyNVhzZDIS9fv/qzs9DK0y7Nvz7lfG1cP5vDs3VxkD7R3E1p66JpSgdxdYoFFm5ef7b9Iecm1CbuRVGUU5ivhjQaSROz0V/xQiokU4WQ0Z+DH7cLDQY2ZWXrj8OQlXTFiMi2k4eLd3S7rNVJWkTXfw==
X-YMail-OSG: j5RveUcVM1k3JmdajW0mBJMNtz1IlwmSf_T_KWyueTbHhjxA6kzqzF6XinUvFxb
 a05IIt08Q907ybMlzZDBQ_m637GxxsG4e2LeH2DR0d0pM0sy4zuJ0X0cY2_Qhs6x8sAqeNjR5_Sh
 NiXpdhdwRJk9xh3h7IlGA3Uvx6LhL9zzsdDwFvH9oUZTXfT4Ve_Q1bC0DeQHLWIpnwqKcDfzevUe
 .CKpfZACdolEhS7vymov7cr.azgYPFzuJJXeY5sRgz4.CJ0dV94TFkbcDpfph91dK5qHDAN.x.8u
 Y4GwttS82OW7JFi9bxRsklCoAjyz_CC1ZCeW.X_bBJyzTSf4qZiMGeI.SXWwRqaod4S9AFY85cf0
 mBtV1Oc2ZR2Gjtca4dmiIqLUDG6cS2FFNBPfQ6YNdCIqNWMSd1T23tKh9s1gfJkIiJa4dL6xNPfe
 niNaIuOh9NAvbnDy4kzKef5x4ZWz4wJR8IEa.JzNEUF2BwkANyhVmcj2pCd8D3LbEW1Lf3gJPwGQ
 MZKYs87aXKQyIcWQMANoEgDPJoNKPBhP1AbfKI17levmtIvAF9.kQFYzLQyvcI6tnzu0F8SBrZcA
 NnEMhU3a.pkVPMROK.2_vLcsEzx0B4QPS4zxblQZbJhSG0KdyFHMUk.CazZ2TzWUCn3etWQQ0Clv
 8V.Gayys9QmPwmsACkuoMmWM3EX7YKtPPLdOV2IYia5f0eqLbzgO6Fwb51yvBz0EWufMiFF0uy3v
 mT1XLTy9G9uHErkJqApgbR.D3UozCEVZicTSd.UyiTcp9ufeItg2ZblXG3i3nxU.IWSPAaHj0V4M
 ou9CfWvzZGYPPaA_D70NqxBjnD7NUJd29lqi4khWSoxac3ym6Hcf2pkqQf6iXibkIMqzvJaiiR_l
 SQEiPc4v1LRzRAlT0G0XNzmlWNwCfcf8VSXfLv8aCwXGDhPo.Kot7vPQ0WxhTVplnGXC_JIdv.mx
 I5.P6zX.7Fjan3OCNcqZKoCUbeWkhDfQzsgbELYOLelCyl2uJGdinH4vHwssDZxmsDNs68mLEBii
 OAobID5SaXDipn9x89KE6cEGn.mJ3yiQR8.9BMHJE0HicIPa6nJmozAzsPU9kgXT.0XthNf2k.Js
 hced8bco88.ABej.jEwPKA3gwkCV3gIyyJhGZy2OKgYkYUpaLIAlwNw_pO3Gr_ZA0fkwjaReLYTk
 q1cNOyiuQcMx0ClGpNDKgtjFudoNzO9UqZqV6aluBO7uPsa6oSXHtl4K1NjlrIdZ6IrZ7HcfNoQq
 _mrTm30ckhy1DLHmSMw5o1LUpKJPx_ECtUdJlnk27JXTXGxZDX4O4U8dCgMIPutpiTt6yDDzxcLy
 5vDD2A2qu5siM4Fyy0DoB5ZEK3M18lBnwW4qlE7MB87D4vbvuNa2cvrmaUCsXq2Ph4FqUfdCK.vh
 YWodXw95uOgCq_i9E1TWpE.tfydtbW5PiaGDwaSnBaODmUby4k1Gl9ryTQ8eHRjk0tRaW1ekXDVI
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.bf2.yahoo.com with HTTP; Fri, 11 Sep 2020 16:59:41 +0000
Date:   Fri, 11 Sep 2020 16:59:38 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau58@righbv.in>
Reply-To: maurhinck4@gmail.com
Message-ID: <269078069.1158266.1599843578128@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <269078069.1158266.1599843578128.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16583 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck4@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
