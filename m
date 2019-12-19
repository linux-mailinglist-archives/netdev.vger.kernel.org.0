Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D2D1265E8
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfLSPkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:40:43 -0500
Received: from sonic302-20.consmr.mail.ir2.yahoo.com ([87.248.110.83]:37599
        "EHLO sonic302-20.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726751AbfLSPkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 10:40:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1576770038; bh=HmqrXXQfx6qKUWQVWEU+ksZXqOEsKT2N61KT1pL/YcM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=mTznz2wSg6A6ByKyjizYE7pSJJlA4MN2Guseih4ZOnYHHp348ffNAPmyeA8oSpASX/UxTo6sE4yqGPPP8NVYZxl+L+Uy+r77UryJ8MbSrgqbQXpm5mjGFe7UPDIBWPEn2WQG+l6RqwRFjcN9n4/M5EvN2HDr5LzFnS0MqyaLaS+BxEthgBPACa/C5qrXdLo/RrE8Coljbq0P+LxdaTlEWdmkeg9BWBBo682/VDHTYSRbKn/ywQYRT6inOk/DW0UFQ6pzA3c3on0S4T+wTZmRccqXaUvwVZtk1009hEiQUF4zr4NA84DOg2pYDwPDV9i7yfOut740+v1zufjJyEzpZA==
X-YMail-OSG: akTdtdEVM1mA4_IxZ4Z05luJd32QhBJzqyAVdY_Q0uyufDl4CSPvF6Y5KUaV44h
 OKRA36yT4kLAKf4X4WcaTcdrYnS2pgaSGqlFRxcC57Ixxovj2gy6U8yyWJJBgLU8ABfFzPvQMddJ
 Hae5h4Jxli_tIEFcMiYBFYtxFDRaCNNGPnunLhcjDuj9Wtg.kYtdc3O0._cTi.Znf4WNDynqvHSQ
 46VFjau162zV6fWseeHEP69eaE95.fWY751Tf_zk9RdLzm2gbIzM.3mNkOhLqSXc9NC9WoHsp7rR
 A5Oj4sqGno8NQSaHO2SK_aSGs72l6iGtVLWOTNJJI_2TiKxutTCyHfFVWTPtnbVXsj0Cu0tq9k5m
 mN4tH2EY741LGQoL6HPd7fuw9qxCPFCGoQ.ylvghHDC_u489Qg7to8HNFGfP75lDg7KPemVG0G_g
 Cbx0ZAukyiXLA.OxKc.xuM8s4OAdG43MxyrK.1jGA1F96IJU1S7v9fN80z06CSq.GTosWDs9BXdR
 OQjdnAY5pt1rJa7mJOd3VVKfInzGtNTtA.kBrC17ZwdWC88d7PC4OwocUfvTup9Ex8v8sak2uvIp
 Pyf3p0k3YajI5bhKjGgZzT7kfhIoto2pwVhHC1eSyzYtkIilcgjc3UevjDSyGf.TugZFucu0YcDU
 YbCoMTgiOQpjcPUZ1_n6J8nsgLyXgRUvfF.D_Kzdu5g4855_A5oGCvMsfEbgEpqjlui9ookRO9nc
 FtcDSNjR_D24.ehfyqun.JaFRavF8vJ2ayncP8qUfeQUwgqITnhmnTWYQdRd.jOr63TdQBBucCeV
 qIE9XmlVJsv7VEQWhpCmYBwQy5_vW2K..59Xiw3ZsS5wMl_pPBlHQPAabjbtbxZgLs4lwH2jYprJ
 _3X8e6pcUiXhED0NSSLE4vIA_J71JBZqo.DloeJdnWL5vjY5N0iF8Y_AVh.o2rehOqYRDJ5P2SDv
 bKEGyR5nr.f1NGxxzGv4hZl0fVK_ahUmtLk6azVcah_5xWh0T_ECE9CtMg8Fqyq39HXAJfTW4jd3
 keC8rhfFxkWs8IwJ0.rOP98Q3WOnUxfN0hNBlEDHOCdMO9Qjn9RvweKk7QM0WPW_5EndloXZlT10
 cTCtOoRyFsa8UjnFhQryurWIH9Wd3Lce5xD8RTiq4NRNu9c6z8P685Ey5snR_OoVnlLeNU2X3dZ3
 6mbJt_S5hUl6bFoAl5uZHJvgQpB0gGAdKLqf10i8X9E.maQGLAjuH258qu_JvEgDsZnVN.4uh7bq
 2Y7kvMShectX1T.lN1cqQ6Wzf_A2Scw3xtKyhc5Qa45y8EGRYJfngmWTs2qZWCH9e4hsOEzmCdn7
 f4Ac4ZPsrgb99eQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ir2.yahoo.com with HTTP; Thu, 19 Dec 2019 15:40:38 +0000
Date:   Thu, 19 Dec 2019 15:40:34 +0000 (UTC)
From:   Wilson Smith <smithwil456@gmail.com>
Reply-To: smithwil456@gmail.com
Message-ID: <922625577.2393156.1576770034174@mail.yahoo.com>
Subject: HELLO FRIEND! I AWAIT YOUR RESPONSE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <922625577.2393156.1576770034174.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before I introduce myself, I wish to inform you that this letter is not a h=
oax mail and I urge you to treat it serious. This letter must come to you a=
s a big surprise, but I believe it is only a day that people meet and becom=
e great friends and business partners. Please I want you to read this lette=
r very carefully and I must apologize for barging this message into your ma=
ilbox without any formal introduction due to the urgency and confidentialit=
y of this business and I know that this message will come to you as a surpr=
ise. Please this is not a joke and I will not like you to joke with it ok, =
with due respect to your person and much sincerity of purpose, I make this =
contact with you as I believe that you can be of great assistance to me. My=
 name is Mr. Wilson Smith, from London, UK. I work in Kas Bank UK branch as=
 telex manager, please see this as a confidential message and do not reveal=
 it to another person and let me know whether you can be of assistance rega=
rding my proposal below because it is top secret.

I am about to retire from active Banking service to start a new life, but I=
 am sceptical to reveal this particular secret to a stranger. You must assu=
re me that everything will be handled confidentially because we are not goi=
ng to suffer again in life. It has been 10 years now that most of the greed=
y African Politicians used our bank to launder money overseas through the h=
elp of their Political advisers. Most of the funds which they transferred o=
ut of the shores of Africa were gold and oil money that was supposed to hav=
e been used to develop the continent. Their Political advisers always infla=
ted the amounts before transferring to foreign accounts, so I also used the=
 opportunity to divert part of the funds hence I am aware that there is no =
official trace of how much was transferred as all the accounts used for suc=
h transfers were being closed after transfer. I acted as the Bank Officer t=
o most of the politicians and when I discovered that they were using me to =
succeed in their greedy act; I also cleaned some of their banking records f=
rom the Bank files and no one cared to ask me because the money was too muc=
h for them to control. They laundered over =C2=A35billion pounds during the=
 process.

Before I send this message to you, I have already diverted (=C2=A33.5millio=
n pounds) to an escrow account belonging to no one in the bank. The bank is=
 anxious now to know who the beneficiary to the funds is because they have =
made a lot of profits with the funds. It is more than eight years now and m=
ost of the politicians are no longer using our bank to transfer funds overs=
eas. The (=C2=A33.5million pounds) has been laying waste in our bank and I =
don=E2=80=99t want to retire from the bank without transferring the funds t=
o a foreign account to enable me to share the proceeds with the receiver (a=
 foreigner). The money will be shared 60% for me and 40% for you. There is =
no one coming to ask you about the funds because I secured everything. I on=
ly want you to assist me by providing a reliable bank account where the fun=
ds can be transferred. Make Sure You Reply To My private email: wilsnl74@gm=
ail.com
