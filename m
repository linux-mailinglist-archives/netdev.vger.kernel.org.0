Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C470291816
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 17:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgJRPng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 11:43:36 -0400
Received: from sonic316-20.consmr.mail.ne1.yahoo.com ([66.163.187.146]:34413
        "EHLO sonic316-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbgJRPnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 11:43:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603035815; bh=ShrdGJTCUVMCJqYIFt8iS0epc16DuED8/NfeEkfRx3o=; h=Date:From:Reply-To:Subject:References:From:Subject; b=tFEGz+RkfL+PZIrtgJeWde7ftz64atm0XTvj6QTPfR3MYcWxvfD49HEds5xi5XsyAczL2DCnu7TiY6D742Ukg9Am7jRc1ttyv3LXeGDViANaimebQF8cJpL4tq4vK3dNaMLeAJAaAmJoV4ZU7huxlDB635faKMXfLdRxu6hMRJaD1HWm2V1Rs7wyz83qzYYO7xTBEdw6olZJQxbRyJJ3v5VVrk3bX7rSS2zoYsGc5vJJ50aaIGfUKn0RSLSEbsP6HetD5k0izVstNLhLR5MQb9Xec0uEkgRTRt041/nUjK14UrmoTU8tzyZ+oRkESNOqMXumpvnechcMQTVaf3yOcA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603035815; bh=zax5VsgMmnG3QUGZiQlv1/V0hJC1R/q3NQ9EDdFcNJK=; h=Date:From:Subject; b=fzTn1HhEqlMstZLA/oGCcEYZ620KcGXlWEpWLGnincUksBfAK7fwkZLKhzQZoNbNCGgPytEPxjZUj1UsuboIL5cvA3Hlr36a3MdkfkVyglFyX7IyJvZncEJTpl0s4MUfjusCMUgM+NLPlsku16QFlAGq+xWQA/bQxonOUqVnyLUY52fIBCEjntefjeQsye83Y3q1E9qxE2Xs1xwyj3RvcRNnJf4flZxFAuhmm0uu9qM677fLGaNjCK2ou/8mao5SMhyGfi1bHAG1ZXBoOnTO0Y9ANGzeJ3zGeTBZ6aKi6w+g4y/NbvRLuhUAsAravC8BQcSubs7n4T40Gspkh+9EDQ==
X-YMail-OSG: _t_XlyEVM1llOrb_IeNAJ7zkxRkBVMx5dDhXxzp5VA5VO7lQyz8sj_ue2qDitz3
 Dj__2j03nw8.KLM5gHKjWL7DYShGLQIrV3TKbF.C3ZExRR57c3.pDEf8IE6uNxnu2TNNJRuqDreY
 nKhBaY.A1O0oTr7He_wv6QuXOWvpnh0pDoAmHd3SytBQvVM.WtWKZ6DhV.AntwksDWGpFgG0Z1a2
 e3y.p_x4rc.zReXeFJJKQXwbDbE0zb3WEqiRhewYNQ95pxlPstT8qEu9BZXcfw0r0evAqswBegf_
 C0gDAyrCnmbKUQBC07TwWXaBkDCu_32pzFHJM1cigD3fOsBbpaR9oqkyoFYOdjwCzfUJ3Pj3eS_i
 mocnVhRPOZeoQlXfzFDUlPLp4YhutymN5_eX0bS.pKWg8FnUtI5T_lhwtqgTDxMm8VU3O2qcMuoS
 xZcKAecx5G_1.l3CgiomaAUhm2MdrnG8weI1Fc9HYQZgPUt7RjN14bjm4H16abqA4ekdlbfTrtLD
 t57rFskDGGbWyOlmKasB16CsAnbj4nB4Svc75wHG05DVN4IXqH8hOXnl2DCRmWDrhcAGu0NDOHL6
 l_7BfaPOAamPgnYG2YMGwgm8n5577BnRcLk3A6QKPyJgpxCMqQpkeIihF38vcRzlNJmzOHqsdW_K
 ACKb8MA3JC169INhj1zRl6iVL50x059Kr82PSUTK60640FxodaVmP146FR99j6TbJZ71g25imY0O
 irWRCHPkREI6.ZaBiFy1Cxlb0hg0HXpMo.KjTLVcnl8qJXr8uh.JiUoENur0WaChFTp9_gMICrbE
 fK08m1rxlCJ1YYLFgNa3xxV878sF6WAO9nFMdB4rpd7qXuq9XDfOxgdYLHvPpGxYtMX.ERAa5SZG
 k2Ncjtgvts8V9ODZSsL1l80j19p4.gxHNku3.2vl8Q_HexSPliwyIzmfb4NQYUmOOysZZjZscl4e
 l4b6AyEezC2wkJATBuPMbpEuAY_UbRZ1WXILxR06DpMRjfh0KyXp3GQsYD2BqRM2l1r0pEyVUtxK
 f3yX93bfPeVmnMW9Ji_gjhozgz28yzObHv38rV9oqjVVnc2GBvklV5jbnUc_EeDNXz8KyTzqnlNA
 bghIQ8YM9iwGmnO38s.q.gocNR.RBYH8ZBRIYYPa_UX4JXphfcdtNjik4LmzBy1FzG6zPd52.O.a
 _ynPL.cIK_Hn32TE57N1GUwfadVREiD4sNp1_4NWVHAT_Im9uXd8VRVGLSodMZ513byhjgFHy0cg
 6xLn5ZHDaP9lTdGZEXoJxzG4gNH0A2zm537UJuSrI2gfo4mKW0kb9zbpDkUsqIljlcq.UJSFXR.K
 H2hNGy_EeSwsSz3NTfkgExWhLw7nmQB7QQhDtQh0A.1mE3hrbzvHOHIiJz_zO4OV45vLPQBnChMC
 s4zlsR_XhgGLw1LekYCjjhfs.Yoc0hc7Luzyl9Es6oygsPQA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Sun, 18 Oct 2020 15:43:35 +0000
Date:   Sun, 18 Oct 2020 15:43:34 +0000 (UTC)
From:   Ali Shareef Al-Emadi <alishareefalemadi465@gmail.com>
Reply-To: alishareefalemadi465@gmail.com
Message-ID: <401880578.747846.1603035814237@mail.yahoo.com>
Subject: QATAR PETROLEUM INVESTMENT....
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <401880578.747846.1603035814237.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Greetings.

I am Mr. H.E. Ali Shareef Al-Emadi, Finance and Account, Qatar Petroleum. I have $30m for Investment. Contact me if you are interested; I have all it will take to move the fund to any of your account designate as a Contract Fund to avoid every query by the authority in your Country.

I sent this message from my private Email; I will give you more details through my official
Email upon the receipt of your response to prove myself and office to
you.

Email Address: alishareefalemadi465@gmail.com

Regards.

Mr. H.E. Ali Shareef Al-Emadi,
Minister Of Finance.
Qatar Petroleum
