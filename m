Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926B32821F3
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 09:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgJCHOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 03:14:47 -0400
Received: from sonic304-20.consmr.mail.ne1.yahoo.com ([66.163.191.146]:46742
        "EHLO sonic304-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgJCHOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 03:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601709281; bh=1vzYvJqhZgfQUYiR7O5spAErsUVIQgHKZjRZswzrVtg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=mml5BguhHP4V07nVvJV+57wigXxFIYpEF1PFsLMTWC98Y6u9LvavWFk8T6jZplq1i6q4d7mDztU5m4bA/IKh3qZaFxHxQ/XdkAsOUTwtWDnU0yQhgXU3KOWyEci/q4+eSeQf6OXUhsD27ZGl8KRRrvYUw/+rqPRzpLtHemEypoemMqsS9T+I3ZN9ZPYUjewEuWCPQc7IyhoEWPavR330DX0gGvErusQg76XBonC35W3cWP5FZm3GPTcCnTgZr5jV7mIVTWkJpAEfpX9ye5u30oAefk/ojgf2zk1nMEibXEFybG7R77h7dKeEqAZHBXR2NT75WoIHcYjLxR4GfjGvzg==
X-YMail-OSG: 64gYezwVM1niKcbe3Nx4ocDWS6ezAfiMRLEq444uw8Bn2SyXOVDmD3JkCMrDN7x
 EFhtl_WMNUNJ6Q3PwEA93D01LcYNS_vz.HvFmbjYWg07X13YyiJefl_yaVlk_5tiKSd1wwOYBher
 U8JtrmaeK71_HxW6OtTQ4eYKV43AQHCOQu9MtgcHdR6doxtCCk2qoBmGGiqbzwFuHyWOK4Gs4so_
 Di_ylG42U3ehFIHbPyo52l6TCKE._wd14gQ8gqHVF.P2oz0g.4tdGmV1w3wYvyQt._rR62wZRreE
 U23SE8DRomelDe4seTdTrP_dGu22Z_oAWZKlgg1R8A.SgCq8OBqxLJI4ZuhW04fwnV2N377VPKv6
 iH7mnRPvg_m_4MzysvlaM0ySJK6Vfvok7Rqv1jT.tXPkyLeZkiT05jIBJUcV7YUr3iho3sqBDCtQ
 uB3_sTTYkF8xHa5uaTA7txx2FqkoZ01GXz60U3PeDCGxvnu.fReOr4rKhigm5aq_deNfe.G3GVqH
 b9JpQYeHP_JkvYxw.vdeQo4_IumCrNdrAZsU1acdIg_qzYxIm8k1GIEdKezEjDcoPniXb7sxvhV1
 UCqnhZpqqZOwz3x7bMVtFRAYVwd.wTBnrpNb9H4SHPMJ5Rw1.IKr4cEJ_b9AeKQVEwT0pZLd_sGH
 6HzqS2wub6F1vRzhzaRWO.4qiICn5sKr.f.zL38QpCNEJYNDrs.MYMCRd9dVGxSiL8RjaX0PAMWg
 0AhATvjScxHZNEgChphcZZIHtbAdTyoRBFIizLAzKtjoKSUFwhmabPd06xeNkl6CwR1BGKM64KzM
 RmuBX33_BdWmdIhJsQhz2JarSunOtO7SX9m2IodTfuaSf61njfSL9jRaAwTzwu5dteuXg3ADBM_q
 p7l9PdT1kf3jyg0_FoDimi86syGdZruafrgclS3LSIbNzrsc.xiditXew4axIdlSoQwElDo_R2o2
 .jlsy09svGaSnJWJ4DNIVVfO8gamTJxDICdwiJKKcZkIFrhrodZ.E22_8ujf8xffd_Y9A3pKO13V
 Pio.q9yh_0OXuJ0uCeH.y6iuqMCMXVmn8bWcSMtvIFZG53CZKONSSgTKJ43ytjBL_54lvLLWBAwF
 l6fRgqLXLPWcorK49HqO8XdMAr.xkj.gftPYnXpN9L2xvIBtWm5HFb2G8U12z4w0l5npN67BG_Qc
 Zf2Ho11IKXy2nU8CjNS40NGCPPxafP.bMwQO.CHmPCkefEQd6A_RnWq2pfTEIfs.B7oaAHzie_2x
 .fTREm_46c6DSyKgc8FWz6k.qys7izdBkm0AW8KbAN0yDmv4No3_0XzYEfHAeTWwXrcMPT_vkpG9
 fkCC5zJdgrObgfS1KofegIkil2UReAcdi4Fb3xHK6lxh.3Bbxx.0D9M1EsQ1FAvjestR3eVe_08G
 nsEPqiDhWT_.z_dFaUpYrfEm7co_S__CHha_t
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Sat, 3 Oct 2020 07:14:41 +0000
Date:   Sat, 3 Oct 2020 07:14:39 +0000 (UTC)
From:   Mrs Maya Oliver <infomj@mail.bg>
Reply-To: mrsmayaoliver1@gmail.com
Message-ID: <1581236319.1475182.1601709279707@mail.yahoo.com>
Subject: Good Day
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1581236319.1475182.1601709279707.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16718 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



My Dear contact me here; mrsmayaoliver1@gmail.com

My Name is Mrs. Maya Oliver, from Norway. I know that this message
will be a surprise to you. Firstly, I am married to Mr. Patrick
Oliver, A gold merchant who owns a small gold Mine in Burkina Faso; He
died of Cardiovascular Disease in mid-March 2011. During his lifetime
he deposited the sum of =E2=82=AC 8.5 Million Euro) Eight million, Five
hundred thousand Euros in a bank in Ouagadougou the capital city of
Burkina Faso in West Africa. The deposited money was from the sale of
the shares, death benefits payment and entitlements of my deceased
husband by his company.

I am sending this message to you praying that it will reach you in
good health, since I am not in good health in which I sleep every
night without knowing if I may be alive to see the next day. I am
suffering from long term cancer and presently i am partially suffering
from a stroke illness which has become almost impossible for me to
move around. I was married to my late husband for over 4 years before
he died and unfortunately that we don't have a child, my doctor
confided in me that i have less chance to live. Having known my health
condition, I decided to contact you to claim the fund since I don't
have any relation I grew up from the orphanage home.

I have decided to donate what I have to you for the support of
helping Motherless babies/Less privileged/Widows' because I am dying
and diagnosed with cancer about 2 years ago. I have been touched by
God Almighty to donate from what I have inherited from my late husband
to you for good work of God Almighty. I have asked Almighty God to
forgive me and believe he has, because He is a Merciful God I will be
going in for an operation surgery soon.

This is the reason i need your services to stand as my next of kin or
an executor to claim the funds for charity purposes. If this money
remains unclaimed after my death, the bank executives or the
government will take the money as unclaimed fund and maybe use it for
selfish and worthless ventures, I need a very honest person who can
claim this money and use it for Charity works, for orphanages, widows
and also build schools for less privilege that will be named after my
late husband and my name; I need your urgent answer to know if you
will be able to execute this project, and I will give you more
information on how the fund will be transferred to your bank account.


Thanks
Mrs. Maya
