Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E30203C06
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbgFVQDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:03:06 -0400
Received: from sonic316-20.consmr.mail.ne1.yahoo.com ([66.163.187.146]:34180
        "EHLO sonic316-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729416AbgFVQDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 12:03:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592841783; bh=cK2qy9Lv5SAgMg9nAvfVmkJPj46H3ss3vOVyjpHm6Nk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=X1Zodn3b1d9bxZcBH0N9TgTf9YfBl3U2QJzYHSaJPYdzJwBbzEavzeL/gJXV2ycW0mqXZtEKQD9ReLy0JXFFGzFBIgEFSXxeBuNMESSKehALEPZoMvP43c18oXlhhUGy+8EIFYFZBcwMNk9l3rjKkeVlqwgUiVLTYatAUcgh4L+Ov2hRRj2awLxfU5ZPULR8xHOhLmQ12yUfh9RKfdWstk6pO3OzliGwvEbpAQEx5O9Az+eGkQepdQ6GCdt/JuD+vnaBtQnB/OISpLBtQrTLwWUSzS82NpYCX7pPa+ZbKSQREq5w2C9YkPAoLSBeN/Qt4XIx1O+CncwIi/NTZPyjvw==
X-YMail-OSG: _c_7JnwVM1kEr3wslaQSx_gAmmXMn1NGF02UTuGBvqvJTQQWyHTqqe2USf7isSG
 WRqSWohyBUPtILYiRTympUKz8Z76pDkEp59sEVj8TtnI.x5gvMB0skDXbbrEtGxtXtYV6xvwCrwI
 YB7dx3DsAP.sM6MP88wGfoQ.0ac71Gps89EUczCJTMuGZqFhEsxeAaeuwc_mWe9pRpRen7CSng0B
 T8fHFVmskeJ.D3a_XIjBspRugieOMC9A8u8n.xT.v7zbgqM2ia3017_ZhQ6oVsmXMzr9xFnn1VO8
 F6OlSgV7yhmluew3VcYEq2kGvh1p7Fv1WuiqDen31btbd2ZUjA5EGxMy0WhnrCpJQ2o1tU7VFvTX
 9QVWcrGa3v1Cdw5zYj1o9ScMz9d7goOj8kAoOqjsg0aQfpw3vcFjSWeWUYPykLjHovKbVc_j6S3e
 kEzOJlEAHgBGIz1yzpySfkPvr2yAhHppqbfwV9Hug4lbzXboH7PH7dIQvdLKYhhN7BOtDD4VQ7gL
 aYwxCJf120KJubZmP0_yb8oDk3mZNUSLV5gjyPnVdB.PVI3RfW4lpnSyTxGKa.lfWvqQim9YulbH
 W4x5yi_tJSyKERGRnRgBCrABqaQO4pjJ9PVrV1TS1X4decUo6tlrvuOpYTMGFDZTnVfnC1JbAnnk
 Ir89IiBIXvKVrvJVvfZGacnoOyrUVE8pe5AQcUB75mUz3b5Hg3t72mlNaANSUkeTf9Cw_Q3JUwMd
 BKaYdx7sFUAZksCjcD.FC5mMvrmvWbId8nDdRB1F3v7HuqBFJqVYwTIWb3aBUh4LYYj1VXWMT3GA
 CQNc9zhgXq.mlXabmw40TqO7AT9Yr2NMEpNVoOWi9k5fGubauUDQPTLidJUrrMgJ39yWA2vR8jQs
 j_Vx9m7NaXwIyJlLOc5w9kumCVABPmE0l8VhLoK1D5uj20DzLrPKIHjlpk8kF6LLRBLsdcw4cxh9
 rBvpUMAAPaGL79ZKczFo.i5ckWTTgOUV_W9tuIedYlf5AIXQowcwIoFrd.A4fQahQBfE.Jfgd5O9
 5Ow9jUz6nLcYkPnU4epYoiJPC3Fa16zRnguVUFFnZxwhvtfXEMDz0nO.bwNkr3ahFlr9WK0WyBm3
 DW7W25UpVPQrAWKXf.ppP9tXUNvljF_XYsGsonNXFPkoq1ONmDDbgkZtW699c6M1Gf3rFW6UEQ7v
 ngaXr7yg.fYY7bOtHfp8yFgsFVTH3mG5zc_GvJsSdg3DswMqzytFZ6SrzxI8g5U9cm8fQ9tyo0vF
 ZuMeDZpYHlS4lANx9OScMLEjH.YiMHTiegAj7.kUyf7KdhNS1WxnjaEuoUjn3Nc8pAoiTNEY.Uw-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Mon, 22 Jun 2020 16:03:03 +0000
Date:   Mon, 22 Jun 2020 16:03:01 +0000 (UTC)
From:   Karim Zakari <kariim1960z@gmail.com>
Reply-To: kzakari04@gmail.com
Message-ID: <180200008.1872024.1592841781795@mail.yahoo.com>
Subject: URGENT REPLY.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <180200008.1872024.1592841781795.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16138 YMailNodin Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Good-Day Friend,

 Hope you are doing great Today. I have a proposed business deal worthy (US$16.5 Million Dollars) that will benefit both parties. This is legitimate' legal and your personality will not be compromised.

Waiting for your response for more details, As you are willing to execute this business opportunity with me.

Sincerely Yours,
Mr. Karim Zakari.
