Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CD2245FF4
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgHQI1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:27:21 -0400
Received: from sonic316-55.consmr.mail.ne1.yahoo.com ([66.163.187.181]:39553
        "EHLO sonic316-55.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728105AbgHQI1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1597652838; bh=wQR2TNpnSC5+pl+9xCwBDdU8shZ+1jYIhLI8TGcKGS0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=A3JTaVFwPbh4PXb+tMIM3S1HzE4+5o+RB3qk2JaOUjjOAYTwn7Vc0hmdS7QWAxLZq7Can3i4YAYz7kjgkDpcI+S+L2bdQM9YWeUOo3WFubu/dOzm9znbQEq1OQECVQwh7oXXT0AiQcnV+XXRwL4Sb7Td5PMuJpyuGWNaLs8Vz1O70KIVziN9nZPBxFrDmsHtwqSVjmEsPczHdaOrI09TF92EwdWMcO7ATsEn5g+ynG/7H2RMMszGqFrXmky2Sdol7jE4hTQjcHiFjGUuG1SXDH6SHK3WP9i4X0tWLGcPapzQX1bd7HL/qq73dFYhQT8YhfNpK5sGU/K9kjw9+/dVPA==
X-YMail-OSG: IbjbnlcVM1n9aMntHEeMUNqbV610FoK_i8_h0K9R2y403JE3Ijn4VSq1uhLML.i
 3_Si5N4zLeWoa90L6CVPuHISP6t.vatSWWne8KC3ED4byCy0Y3oMx1L2X1XDlK7j1Rrqw.qvYUqO
 XEU4hOep_5xDJ9D_qH.v9ZV89_0pNdHL50nQNYsXIRqOK48J2PrEkcraqJE_toiatD9SbC7GbRkz
 o3hz.LrzVPnFkWbhyCjLeHqyrbpWzmtV4g0SspuDhQfh0ZUhHI.Z_vvIC9lo3b8B7DBymTEGCyDR
 VA4Zgza587wXLc5xA_VyeV6uOHADXR20mitR7vmeW5qfUAfIL2_XnMQv1f7zqyU7qimvDawBq0NY
 2TrzOi1jTrYMz8_0ENH8pUfwvzRJh0Fcr92Vtjkahirx7bF1K3bHl8Z2gHZmwA07mW26HqED8B4D
 OiX8KAPgM.w00yieJt9Yb7rt0HlFlPWfk9QLJkDotX04AsznkWt.6Rc33Wqy1yokHRVrDb6fVpbe
 .kVWD2103HyXxGebhOCaY_8ca7ZwghASYS4IU2hQUPdinK9nq2tXnPp0f7yXr20etR9su7HlVj4C
 JUWfCLlPkyorehP7kdH4IzlHvCNtV6QSGm7Dgwyy2QGm_5hl5fbaRadbdjikGKwBvnZ02lOtULdV
 eqQ_RAsChS8UdSL96v0PxhK7kQOQ7XAxJeXFK23U1hAvwqmWbVc0Nh_uUKkJWVVV0IetR8tsCfCA
 V1n8QcyrL5uXVvqHmcZNnPP1y40D6O59cNBTTTWyNJm3ee71MY_5Ljb85KYGA5DQj823A4k7jJzl
 834PBf4AeyH0dLxkp246pEvqVjvHHb74s16CdzsV21y5Hz9Y2ZrygdxTqL04xCrsYrup4HjQO7wl
 Sauqncgnqav.TChKB8g1Q83HQkJaeDDg9WyOqUiETC0P10v.auYensLqcYfqevH0TvVVTk17Rusq
 a7iPeR_6w_e.U8UQfa1LYseojG93mYX7nw69qUet5qKHi9ZkpTI6ByNMtFRAopZEenglwEAMg.r_
 RpQyfig7qnD35DacKebO5epZRIOGfbqF11tRAG4F4i0PL4T3zpyvzIyaoUq8OIhAx4pXCpyoPeeL
 _WNETEavebxkLyx6LpvVe5RmLhYB64ZSnwBgeMS1RJnFA6cXNSC5.ZlaW6Ze5vbXFSzXuD1b8aex
 2n3qsHyS.epucwOd0Jhpua46cVO9ncxnkM6coouJUEithPgtSns.3Tb5XRA1vyUNfLbg0KXHqN0o
 3RckJ_Mzq_nYf3N.eC53m5lcUeQFQU7k6f86juqLRIGH4Mb36gTTns05kC2uInTuTnq57gMOS36p
 nK3gvOO2aV70ol8T_MnMFkHPM_GevAysaCyXAtpvxZ.pDkmNorZ0.KLTp5sWVqgrNxraVyQ1l
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Mon, 17 Aug 2020 08:27:18 +0000
Date:   Mon, 17 Aug 2020 08:25:17 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mua11@gvsao.in>
Reply-To: maurhinck2@gmail.com
Message-ID: <457980743.3021322.1597652717729@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <457980743.3021322.1597652717729.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck2@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
