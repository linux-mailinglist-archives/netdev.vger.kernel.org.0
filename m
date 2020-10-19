Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D04293128
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgJSWVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:21:21 -0400
Received: from sonic307-22.consmr.mail.sg3.yahoo.com ([106.10.241.39]:38113
        "EHLO sonic307-22.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726730AbgJSWVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 18:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603146078; bh=RchYhSnUH4D8ir65x6OKK1yxktPnAGhcFCbackPivPM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=M8yPQE++9rBoSi6r2VImsrQXY1dZ0RwG9RROdbO1tFrG5Sfm+mZLamVhl8OXrz+L8C48F2tFRGV5MsEC7N/UJo/7csMlWwnYAXn/65RvdUZE/GTh91xLqTTLHS4Kneq5DO2mkmrd47Ri4dmEkdl6dbbsfs1qp4LdZerU8yQoApB0BwhIjjm4yy8m2W2P/n+bMUK27uSv/9nwaVcqznVMNWcLXCVYg9z2MVGaJ1NcF3iddJ0bGkapQ5bs8IpkQLBUexDrS/sieRNQjgovKjSf50gJS9J1kFtHemzIjLyHNzaPR0lzjLAfmCyePkkLsFXP4HuubgR4QdBmilvi5bb9Uw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603146078; bh=TRWfeXDBWu77Gyd83GEHGvyvGNd1SU5iyGZqsMdo0hh=; h=Date:From:Subject; b=tjDOR/wDnuPz/V7Kq8FrgclPzLQO+lW1h48/2jIJip49+Hbevd9Zxn9SDZKWErdUXZ135x42H0/pLb+jvSYCvwth5lTMgsfUHXWupnbnC/ox+7ndhgZa4M6OsBdN5MDoc6oHhbNWINwLEp17Bg+tEuYLkwIGpjm3Zjo7mh+mX8RJMBtfgP7f1X0qEeEQQvng8R91QT+Fi6OXUmBoVmBu8Q760c5hBJlcOG0UMD8d+buq1W906pITjI4ek6lWEwSEU19cl/cfh46HTpoctOdFCDmQ+l3TxBC5H7LQ4eUrOKAiWso27Hn8uwRQ5B63kPdEZ8uq/AFp1j0UXzQ2xO/t/Q==
X-YMail-OSG: kAi.BCEVM1lumlzjTsXJKK2nJH443v9AcsVFoF2BPWIQnI2GClC1Ixx48Wo9Qu3
 Q_mhtwn.mpctmZaVViKiJq56LmCaLwJMjYelgujRPYw4TvshR56h7Wjv7wCCj2.c48LbKm.WOadc
 otDl6af58LYJVZtwBsS04dRmCFMILUurEVWu7XVcutlUpT2czBDv4qxoPRWMTLuR2D5kwycdK1G.
 rg.OhtnIkwRJHbtVpusW9LSWvMPhFr65BhIoVG.E1NNoUWfjnSDGynkzU_GmYZzYbAPoVAuZ8dg8
 15qpvsOzu3JvLmESGGnqypTu9PJRZ_4M66CvQ8UwPOXzuVPhfA9BIzrg7XbQ8BgtmN6bwYgilUki
 GXXo4T0HtHBRAs3TZjQAzxVUjfrk8ZxhjyLIuD0z0kD1W1u4jHYKSFe0H1EO7tmt4pWiY1WoAUoL
 nXSKCty09KAFQubixFx4eDQ6Rxq1K66.0W_n1_pbHYny7A.4FqBsp5M01pZk9F_o0rziI0uKA27B
 dOiVAODa.9jbWkvims7swdRVGM4NkPOQfF4aDFws4C3Ef4EysmBGYGMy5YCB.4vHYJv.0JKT01MK
 1TDQY9PK_j98vEIU5DaIuvyRtrRUcO.l6mApSxbLwAgRXXHpX2XOnxFDk9_nxmwo2pVVKc.nbBue
 lhWWUyX9t874k5gtk8goEblr7PFMR910OSy626_YQweLKMMl7Dj.zjfFC0Q6hnqeHB8AvtBkesFs
 OyKUhCAb88xOkgXfJC9PPhApmf9DGdmlI.H9E.s75sdztUuQFq6atv7mL0VQFn0M.Tp5zB4AhhAT
 B95Ie7YPPegCbH0xY1GEk4zuAL.64pe0iZz.I18UXf3fUTleDrD0YWedtjAmyCst.akuTWJfGU0f
 KQ9EvEDnLcsUZ2tu7vDjHOkLgQ1thWuKTmldbaT0N9vaKXjiAnYBGFKu8SWuW6vOVzSoix1XKwK_
 cHfxYy1ABD2EK6rh37aaCaLE1maje5t5d.rhrlprWWi9NbyGm2D5jklMk5vXZ3F4NPqiNuC9V7PV
 s6ZpiptRBWgZtradnDq.I1r3izynIGEg3.tZBhFpPT2XOYg8_vztDZj_YMLIiJweK3MwZoZAEzLj
 Zb5cXVpjW3uZCFIQzPOGGlkajkE5eTCoToL91Bbnp9nQV4rSWeeAST0ZZ2bT._iN.ntHnGhehClI
 Nl2L3FEJuDl9z60dqnpHZna63Od96ZcStjZRS2oqzYoC_2ZF6HQIhIJlIpsdPXDgmZ0uRB0hcmwy
 R7_EUWdyfjkXu_t79mwBcHAYpQbMnI77sJ7XeDBUOBRBs5pquM7zNrUga2.lPmNz4IEQL3aZ8wmz
 yO_3ZtXLbp1w8XfSkMwWsZMPwbqB3rIMQoTTtvLCG1P5Y4wL5rHpbXZLiALxuRd9X8WX0K8lvScC
 T.nT61o6xc0Z5ejbC_UZX_XrqBiK6zNpzwZ.PyIKm1zTVrdPGE7a_oPuWgZj.KLPoz6lHUVY1q3Z
 NmMRRt_g-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.sg3.yahoo.com with HTTP; Mon, 19 Oct 2020 22:21:18 +0000
Date:   Mon, 19 Oct 2020 22:21:15 +0000 (UTC)
From:   "Mrs. Grace Williams" <gw78986@gmail.com>
Reply-To: gw78986@gmail.com
Message-ID: <220474977.794929.1603146075326@mail.yahoo.com>
Subject: FORM MRS.GRACE WILLIAMS
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <220474977.794929.1603146075326.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello To Whom It May Concern,
Dear Friend,

Please forgive me for stressing you with my predicaments as I know
that this letter may come to you as big surprise. Actually, as my
pastor advised me to reject earthly reward and thanks by handing the
project to someone I have never seen or met for a greater reward in
heaven waits for whoever can give such a costly donation. I came
across your E-mail from my personal search, and I decided to email you
directly believing that you will be honest to fulfill my final wish
before or after my death.

Meanwhile, I am Madam Grace Williams, 53 years, am from UK, married
JO Williams my mother she from South Korea, we live together in USA
before he dead. I am suffering from Adenocarcinoma Cancer of the lungs
for the past 8 years and from all indication my condition is really
deteriorating as my doctors have confirmed and courageously advised me
that I may not live beyond 2 weeks from now for the reason that my
tumor has reached a critical stage which has defiled all forms of
medical treatment.

Since my days are numbered, I=E2=80=99ve decided willingly to fulfill my
long-time vow to donate to the underprivileged the sum of Eight
Million Five Hundred Thousand Dollars I deposited in a different
account over 10 years now because I have tried to handle this project
by myself but I have seen that my health could not allow me to do so
anymore. My promise for the poor includes building of well-equipped
charity foundation hospital and a technical school for their survival.

If you will be honest, kind and willing to assist me handle this
charity project as I=E2=80=99ve mentioned here, I will like you to Contact =
me
through this email address (gracewillia01@gmail.com).

Best Regards!
Mrs. Grace Williams
