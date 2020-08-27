Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED24253F5F
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgH0HjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:39:25 -0400
Received: from sonic309-22.consmr.mail.ne1.yahoo.com ([66.163.184.148]:39787
        "EHLO sonic309-22.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727084AbgH0HjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 03:39:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598513963; bh=MWL01jPVJXuBFzguUnxzZVCMkBAhTvIWLeZZqdlFV60=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Kls3yU2rQ29r2QG5HkE74646PjrxgHQsGB/IzsAuC68gvVNDhj9kPwdeDwh8ZnNOEkVW1Fczgna8bahiCVfpHxAPTFoxEqpNdih81y6WTPA20GSM+CGxhbj/23+3a60AGiIChaCr06qpW+FZXi2xqiOtY/qxuU269ASdJ1T+59xtUx1sGj9BTK9UXAPWa3CmetoH9VNixie3cEeCKhO3wGzo6C+fmrj8bmRMi86kuYcndLeMV4N8wr3Qgl1sxh/i/RZcE7r1gBc7jp3uWPxys+jfh6X81LDSVlZ7yndD0ZohUjEjTAKd0h56FIQJHESKGOpLxEqB7tBqMSNF8PSdKg==
X-YMail-OSG: ZiwVlT8VM1mPsalRrNc8p6nW_nqfiMCue8UhkwefUc2j4ZEXtcGIC_YpuhnQqz9
 Y5xWevl0NKbRc9r2HO39Hwvnt_5xIFYBg_92QFP0lkBbH4NOiDLSl5bjk1cTmT.TIuXnrYmQgUDM
 zxkTBGgKf2eNV.5WUejrf.47YYfZra7PXXwt.OB8SJPCkePoxI3VGh68YWnhfPgo8CkK8rt3Ph6Y
 ik02cfNkUTos.on5tXGBttpJ2zz59EO7Q18YnoveZMiQ08x8pxVFHhzH9kJtxnP9cuTE7kc9hEEw
 7CAL3P9eFM8yDpbhXQW0vF4CanlUTxo.Tlz6_fBVKCBPrPqKKRZw7tRhVX6duuMiYuEbFq42CkXc
 ii_vc_p.tx5H7ezWcuJ25uSp1cQUMqSZsp_sxfi.luRixS8zGA0jsfrV7lGsnhsb0S7HY0x8mbCA
 3NdjsSeEzkZgSL6LEampt9U8fVlboyle898cJIXSsIR7lYIdrTReG4XJBD8MF5yJynR7F07n50yo
 HfHNT3Pn8WLKGGX0pAoL4_GEZ7quAL1h6uU4m3XbUe02QtkR4zTDZe0t_E2dcYSBNpUNAhJdsh0x
 nWIgqMtUMXNfEXP2Con4CncZDcvQ4P3nJSgxIXsyGXnUZzS5ZOnCuIORh2JOB1NfzyUDHAtEbkmr
 b0cEPVKdMG1.dZ4WYTTWnj.mSwKf.FoS24DmQx5fjVjLDhlYhwf7mATf.CNxoCpCOquSv3.KOFIC
 ABdeVCbZBGS35Ts9d_V5CF8.aE8r6Gg2_QCh1jtBBfqXGAGdRvju.d1gRDgMHAUuctjSGZMZGqV3
 9XHZJN7BLfEc9H8e4pcAb.q3wnhAFgSP9KsFhpswznoVy91RUCr0szBMxxziM0akbncZuqFsJ9qW
 C2qZxTxcqcLmAcliUcrXRKgu1rGdjpttufgQ5gVwskIyaPDokwDI4FEAnRB6O69j..MBdWbucWAR
 opOS.dlGnchQhL6ekR57mK18ShHjfnftvJNaTxxy.QLzYnBwjanfVmubb3eUJXENxMHhc_Qdg.R1
 sU0WVwCXq53OzAc8EA0FF3evDH083e.uvryZ_95E64DrgvPPTJNP5NUsD817L2NOET8aZfAokuql
 KX3rL93yVraQOgRSxb9.F15QhZY2REjlr9j.z2zpliKdiFV6mXiGdfoM3GB2vDsK4ElVHOWi.5kB
 YLyPKSfrGF24H42Gs4UHXjKPCCpiuI0bayXIgjZEpb1IRkxtW9rE955T7XKfuLC99TEhhfBaMEHE
 FdwJti0DO_AH5UmiczdyBmABoP6F4gtxbJyBHtqeYFo1._dAPpb1Eb5je4KDB83ou1c3GqX7Co9l
 9oBpwcREqVNgybBPZCcEOvGtNbLiiXw7vYL9rbVSkzsdi6qw6nvuuEvfFDsFtoFGC_Gp041KbYFH
 QUCoAhIyCxm5ppExJ7a1S2IeaWj9__zyKvxLNX8OhQMKDk0DfarA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Thu, 27 Aug 2020 07:39:23 +0000
Date:   Thu, 27 Aug 2020 07:39:21 +0000 (UTC)
From:   Mrs m compola <visacarddapartbf@gmail.com>
Reply-To: mrs.mcompola333@gmail.com
Message-ID: <1168566880.8332029.1598513961274@mail.yahoo.com>
Subject: Dear Friend, My present internet connection is very slow in case
 you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1168566880.8332029.1598513961274.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Dear Friend, My present internet connection is very slow in case you
received my email in your spam

How are you today?.With due respect to your person and much sincerity
of purpose,Well it is a pleasure to contact you on this regard and i
pray that this will turn out to be everlasting relationship for both
of us. However it's just my urgent need for a Foreign partner that
made me to contact you for this Transaction,I got your contact from
internet, while searching for a reliable someone that I can go into
partnership with. I am Mrs.mcompola, from BURKINA FASO, West
Africa .Presently i work in the Bank as bill and exchange manager.

I have the opportunity of transferring the left over fund $5.4 Million
us dollars of one of my Bank clients who died in the collapsing of the
world trade center on september 11th 2001.I have placed this fund to
and escrow account without name of beneficiary.i will use my position
here in the bank to effect a hitch free transfer of the fund to your
bank account and there will be no trace.

I agree that 40% of this money will be for you as my foriegn
partner,50% for me while 10% will be for the expenses that will occur
in this transaction .If you are really interested in my proposal
further details of the Transfer will be forwarded unto you as soon as
I receive your willingness mail for successful transfer.

Yours Faithfully,
mrs.mcompola333@gmail.com
