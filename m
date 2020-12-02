Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172ED2CC2A1
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgLBQoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:44:54 -0500
Received: from m42-5.mailgun.net ([69.72.42.5]:13863 "EHLO m42-5.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbgLBQoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 11:44:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606927470; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=x4cIxSBcjhpcKfa2p4OGjJ4Byo4Zvn9hisavK59owIM=; b=Z6O55mNSvBCFzoDPqk0pyNCOiDgjQuBBkoZT+hdMI/wzFio+t9Qancme1yg10gvpe+4AlDBH
 yU6ud9+3cla8aIesJBPB6SVlsMJq/5tlwXFzdEMxsJuremZsaTc54+r2vMGPP2ZN2hYP99ip
 vWV6uqlyTq4yho2w9sIdx6w4i5s=
X-Mailgun-Sending-Ip: 69.72.42.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5fc7c4652ef3e1355f9b8e52 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 16:44:21
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A322DC43461; Wed,  2 Dec 2020 16:44:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 39FE8C43460;
        Wed,  2 Dec 2020 16:44:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 39FE8C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     Lee Jones <lee.jones@linaro.org>,
        Tony Chuang <yhchuang@realtek.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba\@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for .probe, .remove and .shutdown
References: <20201126133152.3211309-1-lee.jones@linaro.org>
        <20201126133152.3211309-18-lee.jones@linaro.org>
        <1606448026.14483.4.camel@realtek.com> <20201127073816.GF2455276@dell>
        <1606465839.26661.2.camel@realtek.com> <20201127085705.GL2455276@dell>
        <0f8e7ac5a30a4f63a0a6aa923fa6d100@realtek.com>
Date:   Wed, 02 Dec 2020 18:44:15 +0200
In-Reply-To: <0f8e7ac5a30a4f63a0a6aa923fa6d100@realtek.com>
        (pkshih@realtek.com's message of "Mon, 30 Nov 2020 00:37:10 +0000")
Message-ID: <87lfegi2e8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

>> -----Original Message-----
>> From: Lee Jones [mailto:lee.jones@linaro.org]
>> Sent: Friday, November 27, 2020 4:57 PM
>> To: Pkshih
>> Cc: Tony Chuang; kvalo@codeaurora.org; linux-kernel@vger.kernel.org;
>> linux-wireless@vger.kernel.org;
>> davem@davemloft.net; netdev@vger.kernel.org; kuba@kernel.org
>> Subject: Re: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for
>> .probe, .remove and .shutdown
>>=20
>> On Fri, 27 Nov 2020, Pkshih wrote:
>>=20
>> > On Fri, 2020-11-27 at 07:38 +0000, Lee Jones wrote:
>> > > On Fri, 27 Nov 2020, Pkshih wrote:
>> > >
>> > > >
>> > > > The subject prefix doesn't need 'realtek:'; use 'rtw88:'.
>> > > >
>> > > > On Thu, 2020-11-26 at 13:31 +0000, Lee Jones wrote:
>> > > > > Also strip out other duplicates from driver specific headers.
>> > > > >
>> > > > > Ensure 'main.h' is explicitly included in 'pci.h' since the latt=
er
>> > > > > uses some defines from the former.=C2=A0=C2=A0It avoids issues l=
ike:
>> > > > >
>> > > > > =C2=A0from drivers/net/wireless/realtek/rtw88/rtw8822be.c:5:
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/pci.h:209:28: error:
>> > > > > =E2=80=98RTK_MAX_TX_QUEUE_NUM=E2=80=99 undeclared here (not in a=
 function); did you mean
>> > > > > =E2=80=98RTK_MAX_RX_DESC_NUM=E2=80=99?
>> > > > > =C2=A0209 | DECLARE_BITMAP(tx_queued, RTK_MAX_TX_QUEUE_NUM);
>> > > > > =C2=A0| ^~~~~~~~~~~~~~~~~~~~
>> > > > >
>> > > > > Fixes the following W=3D1 kernel build warning(s):
>> > > > >
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/pci.c:1488:5: warning: =
no previous
>> > > > > prototype for =E2=80=98rtw_pci_probe=E2=80=99 [-Wmissing-prototy=
pes]
>> > > > > =C2=A01488 | int rtw_pci_probe(struct pci_dev *pdev,
>> > > > > =C2=A0| ^~~~~~~~~~~~~
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/pci.c:1568:6: warning: =
no previous
>> > > > > prototype for =E2=80=98rtw_pci_remove=E2=80=99 [-Wmissing-protot=
ypes]
>> > > > > =C2=A01568 | void rtw_pci_remove(struct pci_dev *pdev)
>> > > > > =C2=A0| ^~~~~~~~~~~~~~
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/pci.c:1590:6: warning: =
no previous
>> > > > > prototype for =E2=80=98rtw_pci_shutdown=E2=80=99 [-Wmissing-prot=
otypes]
>> > > > > =C2=A01590 | void rtw_pci_shutdown(struct pci_dev *pdev)
>> > > > > =C2=A0| ^~~~~~~~~~~~~~~~
>> > > > >
>> > > > > Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> > > > > Cc: Kalle Valo <kvalo@codeaurora.org>
>> > > > > Cc: "David S. Miller" <davem@davemloft.net>
>> > > > > Cc: Jakub Kicinski <kuba@kernel.org>
>> > > > > Cc: linux-wireless@vger.kernel.org
>> > > > > Cc: netdev@vger.kernel.org
>> > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> > > > > ---
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/pci.h=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0| 8 ++++++++
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/rtw8723de.c | 1 +
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/rtw8723de.h | 4 ----
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/rtw8821ce.c | 1 +
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/rtw8821ce.h | 4 ----
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/rtw8822be.c | 1 +
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/rtw8822be.h | 4 ----
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/rtw8822ce.c | 1 +
>> > > > > =C2=A0drivers/net/wireless/realtek/rtw88/rtw8822ce.h | 4 ----
>> > > > > =C2=A09 files changed, 12 insertions(+), 16 deletions(-)
>> > > > >
>> > > > > diff --git a/drivers/net/wireless/realtek/rtw88/pci.h
>> > > > > b/drivers/net/wireless/realtek/rtw88/pci.h
>> > > > > index ca17aa9cf7dc7..cda56919a5f0f 100644
>> > > > > --- a/drivers/net/wireless/realtek/rtw88/pci.h
>> > > > > +++ b/drivers/net/wireless/realtek/rtw88/pci.h
>> > > > > @@ -5,6 +5,8 @@
>> > > > > =C2=A0#ifndef __RTK_PCI_H_
>> > > > > =C2=A0#define __RTK_PCI_H_
>> > > > >
>> > > > > +#include "main.h"
>> > > > > +
>> > > >
>> > > > Please #include "main.h" ahead of "pci.h" in each of=C2=A0rtw8xxxx=
e.c.
>> > >
>> > > You mean instead of in pci.h?
>> > >
>> > > Surely that's a hack.
>> > >
>> >
>> > I mean don't include main.h in pci.h, but include both of them=C2=A0in=
 each
>> > of=C2=A0rtw8xxxxe.c.
>> >
>> > +#include "main.h"
>> > +#include "pci.h"
>>=20
>> Yes, that's what I thought you meant.  I think that's a hack.
>>=20
>> Source files shouldn't rely on the ordering of include files to
>> resolve dependencies.  In fact, a lot of subsystems require includes to
>> be in alphabetical order.
>>=20
>> If a source or header file references a resource from a specific
>> header file (for instance here pci.h uses defines from main.h) then it
>> should explicitly include it.
>>=20
>> Can you tell me the technical reason as to why these drivers are
>> handled differently please?
>>=20
>
> No technical reason, but that's our coding convention that needs some
> changes now.

Yeah, please fix rtw88. Just like Lee said, pci.h should have "#include
main.h" and not require other files to include files in correct order.

> Could you point out where kernel or subsystem describes the rules?
> Or, point out the subsystem you mentioned above.
> Then, I can study and follow the rules for further development.

I have not seen any documentation abou this, but it's a general rule to
keep the header files maintainable.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
