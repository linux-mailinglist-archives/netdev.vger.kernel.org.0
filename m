Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7E525B31C
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 19:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgIBRos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 13:44:48 -0400
Received: from sonic310-14.consmr.mail.bf2.yahoo.com ([74.6.135.124]:43815
        "EHLO sonic310-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726355AbgIBRor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 13:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1599068686; bh=jWkEiPOACWs1i5M04y3GgVdWsjT/ugAWzGwT5xxbmKA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=CB6s173sfApH0MdvgePxBLi39eXJ4iX8bWfObExgzo1CKb1vYsZblgs3wN+aM8C9aFnZqA2qz8+8m4g414hOFQRbF7dLlaJQ06a99/qu4jWIVG7w2kZcSFSLQHwGHJlq23CegkyB8bg5GSP/2c1bMsOCwsGx/2Gz3ByUJE+uJYO6VFeg108MBUoPgaIL2t0k4HcUlsHh8o/tbkT+Yw6bt++qHu2dlDKHvBbKUgzssVhjnsonNhA8Yy4kPu+Xlh8B2gxFaEoQMYLK9fBwqzfKepjaaowp5G32wUg2XdlEjzCv946X8pFvofp5lOZFa+dKTFazTpMqf3aHwvhc8ta/MA==
X-YMail-OSG: aTgmw4EVM1nWi9k_OmLGOkpHNvUvUJLd2ITtzz9fI4g0B0_D_tgZId_3pHje0ym
 YvPj37i8sABv03.6R2NZiFAiAzQYH9HF8rkUt12Z2UaIiS_6wUboIfORYaD.C.R78ulyJ7gkvwcA
 2FNY1Qb49hCSLcf.H7WX3Q60g1B5gDqvbqY3c3dvLA3XHeDMTa7RL2JUedvV_vVJ7Z36LTE4duI_
 qeTzcBYwwoDaK6EPYu2xdBQArSRpp00tPyjjA9UP.FKAdjhtjYC0iW62rv62LlUqvnIyG_hFAO_n
 c8kiV4HAcBEzIHYqNhPvbkvLbSxVixeQg5yVUlI6gAuKBtjWgw.wATFMTVoTEEtOAFAAC1uMV0A2
 Gbmua7G9rDKO1OhnEWzMBgGddwAIsPwJM4rsOBCXxakZgzjqhOgyaEyxORCH9U62FZNXqzf8_bvy
 Gly7Gp3c40njmWnK6.EPvj5he0xf9EFNAggNRcllnvUBau0Vxi5VADHCcv3DOfn.uby1.c5M0czO
 drRXzobPt7zfkYbk7ltFDdhbbf484BM8XYEb_BO2LzpHFGR7ykJ89haFAMjtEnX8HTDrPS4_Ebt_
 l8qOCNDtrJUddmtE7KfERN.jDtNQImSbnUW50DNafWPY.jeX.oYCS1hj21c_eugL0S71XVVWWK8c
 LcxItq2cqZWVORs7nfJRfQ5XX7rg9WvN3HOwF2HTt1lnNq8frHgnpPHDhluGiK82PlLl7bYAAosY
 7NT4OwdzjKqzzuXdtObRyllID9B5xNYpHj1EhPf4iG.qubASBBy_YUttWPibWa48XWUErywKCzaT
 r.8Ig8nQmIzy7mnk9vqHhCJIf7IflhmcN4UUhkHKZMvDXTwCgM4ToiCRUUtb1LGLPWjULEGBP_nS
 9ZloZdoWaeM_2XBb47sn1nIJWcUHVeuFVmixIr4rWGMp2ekY5pfNZMChtvUbTg4ieJd_QUj2Tu8h
 LcE2KS0vW2k63CMhOMD39MGaDeo3Y5m_TBZZ0icKXg.ww4uLcnThtAJ7VurIPyssPqSP0sfabP0h
 5ciYtAlzc_Nq34V31_qoqbATs67ynhOsuscYWh6viCBlrP3tqK_aG62CII03GWBPq4n8jJCfo8Ym
 K2SZfzADEPgqr_FiYr8As6BKkHm6c3FBDdsxdtIO_baYx6u7w7OKq6W6yXvRTCoV_He0TrRLLMdS
 osGlcFI4MXxz_2zY2FgyBGeeMOgXdmI6ACWF3DlI_NxC7e5A.0wzO4BCfeaisfGBXe2wmZ8gyv_e
 BXjsuByZHAjQBmOfKloSYCUVM8Dx3mcvnMvomqnG4qfZ6PhgHO.kuLvxjsRyzHMvw52q39uTsR8d
 ELzSejKELo3.SsWmKY_EhpBfhUBRJG_ALLU13CpJlzImxE_9aIAfB_foASTFcGovXyb6j7nRhmLt
 IroO7k5HIh6xOY.72wZKNkSZp7FnlGgpUvHEyi_qXKUJC3Q--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Wed, 2 Sep 2020 17:44:46 +0000
Date:   Wed, 2 Sep 2020 17:44:45 +0000 (UTC)
From:   Ms lisa Hugh <lisahugh531@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <331296667.1628467.1599068685734@mail.yahoo.com>
Subject: REPLY TO MY EMAIL FOR BUSINESS(Ms Lisa hugh).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <331296667.1628467.1599068685734.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Dear=C2=A0Friend,

I=C2=A0am=C2=A0Ms=C2=A0Lisa=C2=A0hugh,=C2=A0work=C2=A0with=C2=A0the=C2=A0de=
partment=C2=A0of=C2=A0Audit=C2=A0and=C2=A0accounting=C2=A0manager=C2=A0here=
=C2=A0in=C2=A0the=C2=A0Bank(B.O.A).

Please=C2=A0i=C2=A0need=C2=A0your=C2=A0assistance=C2=A0for=C2=A0the=C2=A0tr=
ansferring=C2=A0of=C2=A0thIs=C2=A0fund=C2=A0to=C2=A0your=C2=A0bank=C2=A0acc=
ount=C2=A0for=C2=A0both=C2=A0of=C2=A0us=C2=A0benefit=C2=A0for=C2=A0life=C2=
=A0time=C2=A0investment,=C2=A0amount=C2=A0(US$4.5M=C2=A0DOLLARS).

I=C2=A0have=C2=A0every=C2=A0inquiry=C2=A0details=C2=A0to=C2=A0make=C2=A0the=
=C2=A0bank=C2=A0believe=C2=A0you=C2=A0and=C2=A0release=C2=A0the=C2=A0fund=
=C2=A0in=C2=A0within=C2=A05=C2=A0banking=C2=A0working=C2=A0days=C2=A0with=
=C2=A0your=C2=A0full=C2=A0co-operation=C2=A0with=C2=A0me=C2=A0for=C2=A0succ=
ess.

Note/=C2=A050%=C2=A0for=C2=A0you=C2=A0why=C2=A050%=C2=A0for=C2=A0me=C2=A0af=
ter=C2=A0success=C2=A0of=C2=A0the=C2=A0transfer=C2=A0to=C2=A0your=C2=A0bank=
=C2=A0account.

Below=C2=A0information=C2=A0is=C2=A0what=C2=A0i=C2=A0need=C2=A0from=C2=A0yo=
u=C2=A0so=C2=A0will=C2=A0can=C2=A0be=C2=A0reaching=C2=A0each=C2=A0other

1)Full=C2=A0name=C2=A0...
2)Private=C2=A0telephone=C2=A0number...
3)Age...
4)Nationality...
5)Occupation=C2=A0...


Thanks.

Ms=C2=A0Lisa=C2=A0hugh.
