Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458C31B0325
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 09:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgDTHfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 03:35:52 -0400
Received: from sonic311-23.consmr.mail.ne1.yahoo.com ([66.163.188.204]:37788
        "EHLO sonic311-23.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726036AbgDTHfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 03:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1587368149; bh=q1Er/SdqxATomBDx27mJAnsQxxrJWpCL+Y8MaW3053A=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Ps+ALXVhutmDhXtNcObwLhO3PW/T9rgTwS4W9/TwtezKw1CZdSdTX913drHcGCLopeX7pJmbWN+fsbXNIZ0S0CVJzF+nFNUPxNiZmiRr3lhegwcGPdM7BSLFPxlELLVkiVmK80Fs+TtLf9Kdit1YcDsLBUuIjPDYlQFsvnk+KrRjdwslLOYLM1j+ijv8xcI0u5X4zOLOkxkX5Rwkq/APSy2MS1LPpU3kds3WfPMhBWQDO8PTfHQM0m2+DsSPB/aqdiRPaPHl2iT/+kYG4Md46WMlxHwcbOhNwvm6QfNkoVaffX9WvRwKC6p6h4QDFqcgx2n2ERm+C1IZ1EqxG/+mPQ==
X-YMail-OSG: mLAm1a0VM1lB9oNa9YxWudeumslq9JmzzzQKai8YOwrU7Uou6DxjHP.yMbQeIgh
 6jyLirUs3ul7Br.NkQXboYOWF95jHCCbJGC_BlAcrAHKR9jB0o1wD9jB1roXxNeKT842V_c6zTOB
 .YEs_mn2duh9T6RXaYiQpclVl2H35JZGS45MYH7Vtw6vdilFbPcjApSRMhsNutxNmNyppos1u23W
 OFNlpFg4Dz0jGcpwSpAbjaLVaHWX8fDoVxUYzpBi79IBqPi2LjAvxg60WUQEOTYRHzsXSMi7kSsh
 i4BESLqStTqOfdCPCWxZ9c3TTQKvHMszagCV5_RamD2qnvpbx1nRVt8SxdRgyt7qM4l8DkAqGUJp
 hXlJw9LW7purnHHlJaIseahAbbEk6CUmb.uUEAEziF.sGU6l5.eKzfWa.3vvverBlYI680oFOsE1
 gsnEZUxDHym4rYTBNUzdDT5D.pgOaXTg2Z18wh7fY8gMj6I1PeRwi0wNIgDK8k4TsQfYfCLotjwj
 V4j1VZgeyFGwv1j3khMbtTsSlCQKIZ.FLvbJeyXonjwCJcgGobBAzEilGVS9ABEtZoCQuhKFbuhD
 SrXORn.Yb11nuqhYp4pNZ44fkr2y7rbZU_QgXNi4EJj4wl.5Gp40DPLdB83OP0YKA0i6SR0C1RD8
 EaBT7O22XgICGacdLGe9pSNCLgtbXBWpZQzbubCKTbd8bgKiKSYNEGxHNHgGRk_fN0OBpSlSCniX
 bmjedCEbfkT6u6oLs4IPG1oEIe0vJM_cq5d_avadQHz43u1UzikasVsc4ren7AkLSqUyJRThS6xx
 p2vpn5PfkDcwpHArxqdDAbTHR2zDyXU7JPZn441Xy3pofgJKryuZWIBHgbOcT6Xij8QgPEjmDjES
 ZeT13ntx.rtWRZ3iNbtGANQrD_q8RVUiSiF3BtKbm8HXytysULrWsfABTphHpvOxbYANiwlGLVeI
 5bFIrPH5n6mK4XxqNrP7uw_OQ2CPuqA2g5bPpgxyOBmAZ6dYy25a8vVAvmCcrWbqwyJPYnWhQXrU
 1uH8FOWH.ZpOsEOdBvmivT0B63VFpxEMzudvJ379fdwkqYImnc0.ERvKEXbR0vaut4Smr5KoP.5D
 yNhx_v6i77ru1gYvxPiGOK9awqF4.abTmrDN0VImML4yztNhGcF3gOKLZrOfRw5eam_e8KWlYrhe
 f81Xahwj_qI2ZxROrDCDDkqw0g9LnoAdeFdHS64i4cCwHVEAQ9Nkzt9KYve2AcQb21nHAremSZbE
 UWA7LDAbjU4MV4o9ClHXk.t.Lls9F5K8ezuXLSiJsjP4JHhOBdcVr1XhiBXsWRGB7dYZDTLfMDDg
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Mon, 20 Apr 2020 07:35:49 +0000
Date:   Mon, 20 Apr 2020 07:35:47 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.mainaabrunel126@gmail.com>
Reply-To: mrs.minaabrunel30@gmail.com
Message-ID: <579318633.3318034.1587368147698@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <579318633.3318034.1587368147698.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15651 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



My Dear in the lord


My name is Mrs. Mina A. Brunel I am a Norway Citizen who is living in Burki=
na Faso, I am married to Mr. Brunel Patrice, a politician who owns a small =
gold company in Burkina Faso; He died of Leprosy and Radesyge, in the year =
February 2010, During his lifetime he deposited the sum of =E2=82=AC 8.5 Mi=
llion Euro) Eight million, Five hundred thousand Euros in a bank in Rome th=
e capital city of Italy in Southern Europe. The money was from the sale of =
his company and death benefits payment and entitlements of my deceased husb=
and by his company.

I am sending you this message with heavy tears in my eyes and great sorrow =
in my heart, and also praying that it will reach you in good health because=
 I am not in good health, I sleep every night without knowing if I may be a=
live to see the next day. I am suffering from long time cancer and presentl=
y I am partially suffering from Leprosy, which has become difficult for me =
to move around. I was married to my late husband for more than 6 years with=
out having a child and my doctor confided that I have less chance to live, =
having to know when the cup of death will come, I decided to contact you to=
 claim the fund since I don't have any relation I grew up from an orphanage=
 home.

I have decided to donate this money for the support of helping Motherless b=
abies/Less privileged/Widows and churches also to build the house of God be=
cause I am dying and diagnosed with cancer for about 3 years ago. I have de=
cided to donate from what I have inherited from my late husband to you for =
the good work of Almighty God; I will be going in for an operation surgery =
soon.

Now I want you to stand as my next of kin to claim the funds for charity pu=
rposes. Because of this money remains unclaimed after my death, the bank ex=
ecutives or the government will take the money as unclaimed fund and maybe =
use it for selfishness and worthless ventures, I need a very honest person =
who can claim this money and use it for Charity works, for orphanages, wido=
ws and also build schools and churches for less privilege that will be name=
d after my late husband and my name.

I need your urgent answer to know if you will be able to execute this proje=
ct, and I will give you more information on how the fund will be transferre=
d to your bank account or online banking.

Thanks
Mrs. Mina A. Brunel
