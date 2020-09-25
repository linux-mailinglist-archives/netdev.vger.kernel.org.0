Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813E72791CF
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgIYUO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:14:28 -0400
Received: from sonic304-10.consmr.mail.bf2.yahoo.com ([74.6.128.33]:44069 "EHLO
        sonic304-10.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725272AbgIYUM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 16:12:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601064746; bh=y7/6PoXzaW0h4W9s9bqlC8tqSJXdjtS0RNLprnUmNTo=; h=Date:From:Reply-To:Subject:References:From:Subject; b=TIOfvelN1/d1TpplJ5WcwPvtlt/3ti1/3i/MMPZZGzWH+cJWLWGY9pPOZsgixNw0vs7EbdcCC5NBMO9kle3i9XaQ/pn5TG7hV/yMvrrb55ZO3VFztMRfHGDEBpfHuuxfqeFzjvHRTpPSGj//UqZzYwBVRyeMoVimxI/qBU+yewfjA2vHDkpVp/R4JXrYhW+28LlN9pZCXAWRUwoXIRQhQxVp9iUftFlnxaBFywNjwdn8TofHuaHgnRbYanvUpCmBy5xf/sVS9DVmI6STv4bQCUbSJ2NE9hQM0TDcaa/18RwhK9cNI9DH5EtTcd542tTV18AddvXMfJQvaJHIzgdtMA==
X-YMail-OSG: GZymsdwVM1kbE_4MFgVFEAxKRfeLuV1lKsi6lnqpD_h5ckT09JbAUbcnHB.pZGL
 BnaXGG.hF30lILkepkPl4YYGPJ.lFyvPpcuimXHpxXiAxBu1HskP3w81MrWc_1x8MZeIOXaQ0EiJ
 PlNUOFtwgEGJeY1Hso0F341LyTu036WBspV4Eudz3.FXe_aEDqrkGFXgUQ7M606bRPoCw5qY3KLk
 X.PekEmExSojs6n5qB4IxyedAowqzE9xQL8MxzRRdvS1DYayoscBZW5pKh6Pq1GspNXyWQISiTpF
 ndjH8dtkX3bZAEXU9wg3qGGQ8YkvzvukymOAGz7nM5xnkMvLP2jtFg49y8TmjZCpn6DjFvi3sk0J
 mRIKUSPEOWFLxxjkq4eO.GCisEv6swbZiKH67moLtRbMyji5y2iLDT.U_RoXssIY2QABrC68aZGD
 Zm.W354BTvK2WKedphmv6Kd2o0kb3K.adxjbjunGwMXY07LSa0kdtNcS2bgP540OSB_pruRwMwSm
 G3mOOJZKJgwRqREjDLVzuGZIjagmCQ_MRal.ZzzRW9nhPNum7lLlyXLKZVneyQxq_ic36SDto8Az
 Ru0Dk3O_9pvTBc7MPvUv9T7ConZ_InSv6.DBoPZoZZTU2sBwWLniq4VTgFs8kUjU.BSclXjtQENQ
 F2S.y7htFNGiYEkzQg1kiQ0iTfu.1lSSCI1aJD97t3F.wphL4fikleliCTXKiPNUBKppCNtlAI2F
 Y.oujp5ixu3laCE1zD5Q9wOgxhAM9BmyagHMQ02c8R7zyxWf3jBpK006WPAaa68K77Yeg7ANygHT
 fwQJTLGJvUFdIs5uGTfkw_I8J5yd9GJDZZIhLg4OunvbMF0Leh.SOq6O.zNrOYGM9eKtjAKYsD6F
 MGzOH65XuGLeoFKSCoSrLlIsHA1gteNDtJj0XW9wjRH5wh1ixgeav.oIpsEiQqAM9rkozdb2c3Xi
 aegXdpBvqvlLE_T7BJGLhBlIc15oWpQ6Prix9ZZ_3uFUgoL_SsUgL4o4YdGuhXTWfFiopG62KGL7
 az6ZUEqA42jVodh57uucSzCt2y74d9ctnn.U6a2QWAc7ZxaruzNUpWwnJqVfFZQM4edF7yUTo.X1
 o6UIoVR2SlIHzYBn9898ONcKqYur18LslMJh0kXSNMcYxQ7Pbz1LMzpFMPz600Y0XT3h_ESp_UT1
 9j39dv2vAQkuGtJYRf4Jspfe9KPmMQW6mNxys.jS7gfDOKE9kbRfW8wWxKRXWLO7oH8bpd29XuJ5
 dDcndt1bQWoPkimF1gKepa3JeGNPlYrkPGjcejvjRwWn9mJqXhSDeWXH82_XcNI_SyXj7Dckeh9S
 o2JBjztdoqQ1QE0ZjTaNxRUh7.VT6ehavf2RKEiqMNIzqYJugygWOdl8ywGvTsozTpn9_HxXQJUk
 rzKMX_U7NxfuxeMGQt.QQ_kjd2bAwvIgeEfU759N0HtSJZj.EsDt3
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Fri, 25 Sep 2020 20:12:26 +0000
Date:   Fri, 25 Sep 2020 20:00:23 +0000 (UTC)
From:   Sophia Lucas <sophialucaspatrick@gmail.com>
Reply-To: sophialucaspatrick@gmail.com
Message-ID: <1060480006.826933.1601064023155@mail.yahoo.com>
Subject: Very Urgent
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1060480006.826933.1601064023155.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16674 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




My=C2=A0Dear


My=C2=A0name=C2=A0is=C2=A0Mrs.=C2=A0Sophia=C2=A0Lucas=C2=A0I=C2=A0am=C2=A0a=
=C2=A0Norway=C2=A0Citizen=C2=A0who=C2=A0is=C2=A0living=C2=A0in=C2=A0Burkina=
=C2=A0Faso,=C2=A0I=C2=A0am=C2=A0married=C2=A0to=C2=A0Mr.=C2=A0Lucas=C2=A0Pa=
trice,=C2=A0a=C2=A0politician=C2=A0who=C2=A0owns=C2=A0a=C2=A0small=C2=A0gol=
d=C2=A0company=C2=A0in=C2=A0Burkina=C2=A0Faso;=C2=A0He=C2=A0died=C2=A0of=C2=
=A0Leprosy=C2=A0and=C2=A0Radesyge,=C2=A0in=C2=A0the=C2=A0year=C2=A0February=
=C2=A02010,=C2=A0During=C2=A0his=C2=A0lifetime=C2=A0he=C2=A0deposited=C2=A0=
the=C2=A0sum=C2=A0of=C2=A0(Eleven=C2=A0Million=C2=A0Dollars)=C2=A0in=C2=A0a=
=C2=A0bank=C2=A0in=C2=A0Ouagadougou=C2=A0the=C2=A0capital=C2=A0city=C2=A0of=
=C2=A0Burkina=C2=A0Faso=C2=A0in=C2=A0West=C2=A0Africa.=C2=A0The=C2=A0money=
=C2=A0was=C2=A0from=C2=A0the=C2=A0sale=C2=A0of=C2=A0his=C2=A0company=C2=A0a=
nd=C2=A0death=C2=A0benefits=C2=A0payment=C2=A0and=C2=A0entitlements=C2=A0of=
=C2=A0my=C2=A0deceased=C2=A0husband=C2=A0by=C2=A0his=C2=A0company.

I=C2=A0am=C2=A0sending=C2=A0you=C2=A0this=C2=A0message=C2=A0with=C2=A0heavy=
=C2=A0tears=C2=A0in=C2=A0my=C2=A0eyes=C2=A0and=C2=A0great=C2=A0sorrow=C2=A0=
in=C2=A0my=C2=A0heart,=C2=A0and=C2=A0also=C2=A0praying=C2=A0that=C2=A0it=C2=
=A0will=C2=A0reach=C2=A0you=C2=A0in=C2=A0good=C2=A0health=C2=A0because=C2=
=A0I=C2=A0am=C2=A0not=C2=A0in=C2=A0good=C2=A0health,=C2=A0I=C2=A0sleep=C2=
=A0every=C2=A0night=C2=A0without=C2=A0knowing=C2=A0if=C2=A0I=C2=A0may=C2=A0=
be=C2=A0alive=C2=A0to=C2=A0see=C2=A0the=C2=A0next=C2=A0day.=C2=A0I=C2=A0am=
=C2=A0suffering=C2=A0from=C2=A0long=C2=A0time=C2=A0cancer=C2=A0and=C2=A0pre=
sently=C2=A0I=C2=A0am=C2=A0partially=C2=A0suffering=C2=A0from=C2=A0Leprosy,=
=C2=A0which=C2=A0has=C2=A0become=C2=A0difficult=C2=A0for=C2=A0me=C2=A0to=C2=
=A0move=C2=A0around.=C2=A0I=C2=A0was=C2=A0married=C2=A0to=C2=A0my=C2=A0late=
=C2=A0husband=C2=A0for=C2=A0more=C2=A0than=C2=A06=C2=A0years=C2=A0without=
=C2=A0having=C2=A0a=C2=A0child=C2=A0and=C2=A0my=C2=A0doctor=C2=A0confided=
=C2=A0that=C2=A0I=C2=A0have=C2=A0less=C2=A0chance=C2=A0to=C2=A0live,=C2=A0h=
aving=C2=A0to=C2=A0know=C2=A0when=C2=A0the=C2=A0cup=C2=A0of=C2=A0death=C2=
=A0will=C2=A0come,=C2=A0I=C2=A0decided=C2=A0to=C2=A0contact=C2=A0you=C2=A0t=
o=C2=A0claim=C2=A0the=C2=A0fund=C2=A0since=C2=A0I=C2=A0don't=C2=A0have=C2=
=A0any=C2=A0relation=C2=A0I=C2=A0grew=C2=A0up=C2=A0from=C2=A0an=C2=A0orphan=
age=C2=A0home.

I=C2=A0have=C2=A0decided=C2=A0to=C2=A0donate=C2=A0this=C2=A0money=C2=A0for=
=C2=A0the=C2=A0support=C2=A0of=C2=A0helping=C2=A0Motherless=C2=A0babies/Les=
s=C2=A0privileged/Widows=C2=A0and=C2=A0churches=C2=A0also=C2=A0to=C2=A0buil=
d=C2=A0the=C2=A0house=C2=A0of=C2=A0God=C2=A0because=C2=A0I=C2=A0am=C2=A0dyi=
ng=C2=A0and=C2=A0diagnosed=C2=A0with=C2=A0cancer=C2=A0for=C2=A0about=C2=A03=
=C2=A0years=C2=A0ago.=C2=A0I=C2=A0have=C2=A0decided=C2=A0to=C2=A0donate=C2=
=A0from=C2=A0what=C2=A0I=C2=A0have=C2=A0inherited=C2=A0from=C2=A0my=C2=A0la=
te=C2=A0husband=C2=A0to=C2=A0you=C2=A0for=C2=A0the=C2=A0good=C2=A0work=C2=
=A0of=C2=A0Almighty=C2=A0God;=C2=A0I=C2=A0will=C2=A0be=C2=A0going=C2=A0in=
=C2=A0for=C2=A0an=C2=A0operation=C2=A0surgery=C2=A0soon.

Now=C2=A0I=C2=A0want=C2=A0you=C2=A0to=C2=A0stand=C2=A0as=C2=A0my=C2=A0next=
=C2=A0of=C2=A0kin=C2=A0to=C2=A0claim=C2=A0the=C2=A0funds=C2=A0for=C2=A0char=
ity=C2=A0purposes.=C2=A0Because=C2=A0of=C2=A0this=C2=A0money=C2=A0remains=
=C2=A0unclaimed=C2=A0after=C2=A0my=C2=A0death,=C2=A0the=C2=A0bank=C2=A0exec=
utives=C2=A0or=C2=A0the=C2=A0government=C2=A0will=C2=A0take=C2=A0the=C2=A0m=
oney=C2=A0as=C2=A0unclaimed=C2=A0fund=C2=A0and=C2=A0maybe=C2=A0use=C2=A0it=
=C2=A0for=C2=A0selfishness=C2=A0and=C2=A0worthless=C2=A0ventures,=C2=A0I=C2=
=A0need=C2=A0a=C2=A0very=C2=A0honest=C2=A0person=C2=A0who=C2=A0can=C2=A0cla=
im=C2=A0this=C2=A0money=C2=A0and=C2=A0use=C2=A0it=C2=A0for=C2=A0Charity=C2=
=A0works,=C2=A0for=C2=A0orphanages,=C2=A0widows=C2=A0and=C2=A0also=C2=A0bui=
ld=C2=A0schools=C2=A0and=C2=A0churches=C2=A0for=C2=A0less=C2=A0privilege=C2=
=A0that=C2=A0will=C2=A0be=C2=A0named=C2=A0after=C2=A0my=C2=A0late=C2=A0husb=
and=C2=A0and=C2=A0my=C2=A0name.

I=C2=A0need=C2=A0your=C2=A0urgent=C2=A0answer=C2=A0to=C2=A0know=C2=A0if=C2=
=A0you=C2=A0will=C2=A0be=C2=A0able=C2=A0to=C2=A0execute=C2=A0this=C2=A0proj=
ect,=C2=A0and=C2=A0I=C2=A0will=C2=A0give=C2=A0you=C2=A0more=C2=A0informatio=
n=C2=A0on=C2=A0how=C2=A0the=C2=A0fund=C2=A0will=C2=A0be=C2=A0transferred=C2=
=A0to=C2=A0your=C2=A0bank=C2=A0account=C2=A0or=C2=A0online=C2=A0banking.

Thanks
Mrs.=C2=A0Sophia=C2=A0Lucas=C2=A0Patrice
