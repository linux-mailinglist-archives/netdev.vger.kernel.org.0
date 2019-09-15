Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D27B3237
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 23:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfIOVbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 17:31:41 -0400
Received: from sonic309-25.consmr.mail.ir2.yahoo.com ([77.238.179.83]:41597
        "EHLO sonic309-25.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725270AbfIOVbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 17:31:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1568583098; bh=lAh1VSII1GxH1Lprx9ZFG4FPrK3+vs4TTowEGakve2I=; h=Date:From:Reply-To:Subject:From:Subject; b=iI0bd9PBI0TILoLNWsXAUfBL9G97yl5i+Emj/gwGNLxx3GkmbPUDBtP0XXuBvFx2XtqjwPzHqoU0rBGM8HdUmgY/cGYxokQBgkJ+IjqjA879vPMmm9cdzLUC+ykQiejbcsBLIkeX+ThCFx2B0PSvxxjOcUYgsm8O2mgTpHoqepBk6CdqNGoqxrL2Vx46+Qwg1o4bfyn5YfEnHr8RRjbfE2eO5YU218olUOkKwHHHl0O/+lnLtnYOvj3b8rcal21uD0tgSWQ8tL9+jabh/ItZDdcalS55Ub83v/Kll1QxXIig3c/W7u34+5VYD/Dn1LQqf/qtyJ0j1pubpIGj5PbZzA==
X-YMail-OSG: X9QAg0EVM1kBlaaaFg7TycFJFuQW8o2Ap0LNhzHZU8exZcnbZhpOf0RXAL456vt
 FL_HhtkY8mk3T1E6DQD8FkjTlXNY43KTwOpUxGI4GwjJxJ.qdrTuSqiVyE7Xnjmuf0OkIEtAMjU2
 2uLYXJtFrKGXMoBHy_JAJedD1wafUE9I3hlYsub7oVO4N9qcHBfFhOwE0wFxslstgcDr6Q2Z1Tef
 9JHUtd3cpDyq9H9mtNBac5uow26_v30.w1CxsgJ2RjmIn2.oBuXh.sGQ6OS5PqUTnoG8azVrZbzw
 aXBbWWaE9ZTzacaj8T6zicEDxxNuzdcLgHPquVnFdv2Ak9qGwaHe7TxUrPDYNOdmXNBYXh9ueGFA
 tLNtbWDI7tIHimRBVzL2i4sC7A5LAgK5vE1kNLxTFf2O20sjcrpbvnWwa8EqNMfu2iZgWZp_yxqB
 q1.BaJghI4dVOKGfbj4arg7I1HLpc2nqddAXy_7NJ41Rr_Dhke14meY_eAfWeRhQ7gWcyW_2Tc93
 OFSyFYUGWpic88v7CNWunNVaHLNsNHCOfavwNsM9OYuTDGpnwzeILTvokEk4b.vsJbF9Guak4G6j
 pvHMYPO2_bzeUp_.nP07qtCHQvFU8mRlbyExjI8s6T_K0In9LSEedW1l_b.oZF_tqJW_NcO1Kij2
 zTX9Gt4AZThiVjHTkqaCN.aytncGyRCZFM0rfOJ2hFMUwhAkhT3SKPhfUC0wKUU40w1bDZBIgog4
 rPBlIEHh5ig89Q9QvMRmENIWRqLgSFaYFjEt0dfiiqi.BwgXBzty3I4irUp50iacio2Xtt.tqVtC
 ltIH7MaM_8iDKuX2FYOGx5xvHs1Uxy14YFfNikRjCPubXEejWwVm6EOxcJliboRfVNxPY3Inq.9F
 aG49fQC2xdMkeSjtzmyQJnwXWrVgIqpH_Z.iyaCUFxfRzEOyEXrh5cLRPHDGYHUtgYSV.SwCpQo5
 i48Wtzo7MOCmlNEuPsMdFfNp_yE3ai6Us_kQoeIiZIV4Sx0gkiazv7_ByGLTgnrbm.h40PCv6osX
 Nkp7VFtHU6cEwjjWow.HoNTOTtGSD..7oHGw_EPhU9US7KSHMHDDWIcAVCsaVnL_tfNTkUP_txxa
 rD1uxzb3OEs8H9P6Iv3aIk.gPhQldfvU_ANFqUNSIm6At7Izay4fzzrtAAn7eW3c2Ygz2unbxbjw
 TOUolgwBwRoA_IKaWXSyVGbheDT8pvNv5tsJ9Jlb6_oiMPL.evWPcqZAtUn4JaIcV365xu9jHopN
 GFkS07PLaUtPYFegJgX8K01v0WixPTFnR
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ir2.yahoo.com with HTTP; Sun, 15 Sep 2019 21:31:38 +0000
Date:   Sun, 15 Sep 2019 21:31:33 +0000 (UTC)
From:   "Engr. Issah Ahmed" <officefilelee@gmail.com>
Reply-To: engrissahahmd@gmail.com
Message-ID: <778257304.10244717.1568583093864@mail.yahoo.com>
Subject: INVESTMENT PROPOSAL.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Sir,

My Name is Engr. Issah Ahmed, I was a top official in the former government of Late Muammar Gaddafi of Libya.

My late master Muammar Gaddafi, the deposed leader of our country, died on 20 October 2011 during the Battle of Sirte. Gaddafi was found hiding in a culvert west of Sirte and captured by National Transitional Council forces. He was killed shortly afterwards.

We the official members continued with war till the early year 2017 due to the painful death and forceful removal of our Late Master Muammar Gaddafi, our country was totally destabilized because we refused to another government.

In this year 2019 all we the officials in the former Gaddafi government are being arrested, persecuted and imprisoned by the new wicked government.

Libya is presently not safe at the moment, therefore we all moving our money out of Libya.

I want you to quickly help me receive and keep the sum US $20.5million to your country for safety. I have agreed you take 25% of the said money for your assistance.

It is very urgent and Please reply me urgently If you can be trustful to help. I will be waiting to hear from you as soon as possible.

Regards
Engr. Issah Ahmed
