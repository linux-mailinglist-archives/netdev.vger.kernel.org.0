Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99F42AB116
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 07:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgKIGF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 01:05:59 -0500
Received: from mail.lth.gov.my ([210.187.87.182]:58590 "EHLO THSBG2.lth.gov.my"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729524AbgKIGF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 01:05:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; d=lth.gov.my; s=lth2020; c=relaxed/relaxed;
        q=dns/txt; i=@lth.gov.my; t=1604900328; x=1636436328;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HqgD/9hdEi5MVEsUFRj+EpK6m79beQbDzCw53BVveS8=;
        b=Itaga1ezIbpmDhPQ8NQNHGC64FdyJOti/A6OI5r/vQ6tPGLg71mse4a+cokZhVwk
        ly6mSAhuXHmZfmAY6n6X6nrMD3Ww240zKkzRR7zJrqm/8iTdFXSzpOXF269PN+/T
        xPFjaUUEx1XYwbVMzoq/jUe3dkjYfNPcRn9048EsIa7Wb12gXcxlsi+lH2lLco2K
        tae0YEnlCP6r43GGlrKXxMvD/SzZY32O3RG452hMB5eTNBVXiWu+rXp6jm3h9+Jb
        UARxexyGrj2WNUQwLzEsSZ3U8SGNMg3YOBzov4ojxpmofbZ3d0uvD9ubRuhs6JR9
        jm0dIDp02vMBLFYZKn4lFA==;
X-AuditID: ac141e14-6cdff70000002394-b2-5fa8d5e7fc6a
Received: from THHQHTCAS02.lth.gov.my (Unknown_Domain [10.5.32.223])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by THSBG2.lth.gov.my (Symantec Messaging Gateway) with SMTP id 09.5D.09108.7E5D8AF5; Mon,  9 Nov 2020 13:38:48 +0800 (+08)
To:     undisclosed-recipients:;
Received: from THHQMBX02.lth.gov.my ([fe80::40ba:65cc:fa66:a790]) by
 THHQHTCAS02.lth.gov.my ([::1]) with mapi id 14.03.0361.001; Mon, 9 Nov 2020
 13:50:36 +0800
From:   "Afiq Farhan b. Azli" <afiqfarhan.azly@lth.gov.my>
Subject: =?koi8-r?B?9yDXwdvFyiDV3sXUzs/KINrB0MnTySDC2czBIM/CzsHS1dbFzsEgzsXPwtne?=
 =?koi8-r?B?zsHRIMHL1MnXzs/T1NgsINDP1sHM1crT1MEsINDPxNTXxdLEydTFINPXz8Ag?=
 =?koi8-r?B?1d7F1M7VwCDawdDJ09gsIN7Uz8LZINDPzNXewdTYIM/WycTBwN3VwCDXyM/E?=
 =?koi8-r?B?0d3VwCDQz97U1Q==?=
Thread-Topic: =?koi8-r?B?9yDXwdvFyiDV3sXUzs/KINrB0MnTySDC2czBIM/CzsHS1dbFzsEgzsXPwtne?=
 =?koi8-r?B?zsHRIMHL1MnXzs/T1NgsINDP1sHM1crT1MEsINDPxNTXxdLEydTFINPXz8Ag?=
 =?koi8-r?B?1d7F1M7VwCDawdDJ09gsIN7Uz8LZINDPzNXewdTYIM/WycTBwN3VwCDXyM/E?=
 =?koi8-r?B?0d3VwCDQz97U1Q==?=
Thread-Index: Ada2WrRimBtUGyHYSeyhf4C1BBI3Yw==
Date:   Mon, 9 Nov 2020 05:50:35 +0000
Message-ID: <A048555A387939469CD0266C5594BE3F2278F0B3@THHQMBX02.lth.gov.my>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [196.170.47.86]
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Brightmail-Tracker: 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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=F7=E5=F2=E9=E6=E9=EB=E1=E3=E9=F1 =F5=FE=E5=F4=EE=EF=EA =FA=E1=F0=E9=F3=E9


=F5=D7=C1=D6=C1=C5=CD=D9=CA =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8 =D7=C5=C2-=
=D0=CF=DE=D4=D9,

=ED=D9 =DA=C1=CD=C5=D4=C9=CC=C9 =CE=C5=CF=C2=D9=DE=CE=D5=C0 =C1=CB=D4=C9=D7=
=CE=CF=D3=D4=D8 =D7 =D7=C1=DB=C5=CA =D5=DE=C5=D4=CE=CF=CA =DA=C1=D0=C9=D3=C9=
 =DC=CC=C5=CB=D4=D2=CF=CE=CE=CF=CA =D0=CF=DE=D4=D9, =C9 =D7 =C2=CC=C9=D6=C1=
=CA=DB=C9=C5 24 =DE=C1=D3=C1 =D7=C1=DB=C1 =D5=DE=C5=D4=CE=C1=D1 =DA=C1=D0=C9=
=D3=D8 =C2=D5=C4=C5=D4 =D7=D2=C5=CD=C5=CE=CE=CF =DA=C1=C2=CC=CF=CB=C9=D2=CF=
=D7=C1=CE=C1 =C4=CC=D1 =DA=C1=DD=C9=D4=D9 =D7=C1=DB=C5=CA =D5=DE=C5=D4=CE=CF=
=CA =DA=C1=D0=C9=D3=C9 =DC=CC=C5=CB=D4=D2=CF=CE=CE=CF=CA =D0=CF=DE=D4=D9. =
=FC=D4=CF =CD=CF=D6=C5=D4 =C2=D9=D4=D8 =D3=D7=D1=DA=C1=CE=CF =D3 =D4=C5=CD,=
 =DE=D4=CF =CB=D4=CF-=D4=CF =CD=CF=C7 =C9=D3=D0=CF=CC=D8=DA=CF=D7=C1=D4=D8 =
=D7=C1=DB=D5 =D5=DE=C5=D4=CE=D5=C0 =DA=C1=D0=C9=D3=D8 =C4=CC=D1 =CF=D4=D0=D2=
=C1=D7=CB=C9 =C2=CF=CC=D8=DB=CF=C7=CF =CB=CF=CC=C9=DE=C5=D3=D4=D7=C1 =CE=C5=
=D6=C5=CC=C1=D4=C5=CC=D8=CE=D9=C8 =D0=C9=D3=C5=CD =C9=CC=C9 =DE=C5=C7=CF-=D4=
=CF =C5=DD=C5, =DE=D4=CF =CE=C1=D2=D5=DB=C1=C5=D4 =CE=C1=DB=C9 =F5=D3=CC=CF=
=D7=C9=D1 =CF=C2=D3=CC=D5=D6=C9=D7=C1=CE=C9=D1.

=F7=D3=D1 =D7=C1=DB=C1 =D7=C8=CF=C4=D1=DD=C1=D1 =D0=CF=DE=D4=C1 =C2=D9=CC=C1=
 =D0=C5=D2=C5=D7=C5=C4=C5=CE=C1 =D7 =D3=D4=C1=D4=D5=D3 =CF=D6=C9=C4=C1=CE=C9=
=D1.

=EE=C1=D6=CD=C9=D4=C5 =DA=C4=C5=D3=D8, =DE=D4=CF=C2=D9 =D0=CF=C4=D4=D7=C5=D2=
=C4=C9=D4=D8 =D3=D7=CF=C0 =D5=DE=C5=D4=CE=D5=C0 =DA=C1=D0=C9=D3=D8 =D7=C5=C2=
-=D0=CF=DE=D4=D9<https://mhall486.wixsite.com/my-site>

=FE=D4=CF=C2=D9 =CE=C1=DE=C1=D4=D8 =D0=CF=CC=D5=DE=C1=D4=D8 =D7=C8=CF=C4=D1=
=DD=D5=C0 =D0=CF=DE=D4=D5

=E7=D2=D5=D0=D0=C1 =D0=D2=CF=D7=C5=D2=CB=C9 =D5=DE=C5=D4=CE=CF=CA =DA=C1=D0=
=C9=D3=C9 =DC=CC=C5=CB=D4=D2=CF=CE=CE=CF=CA =D0=CF=DE=D4=D9, Microsoft =D5=
=D7=C1=D6=C1=C5=D4 =D7=C1=DB=D5 =CB=CF=CE=C6=C9=C4=C5=CE=C3=C9=C1=CC=D8=CE=
=CF=D3=D4=D8.

Copyright =BF 2020 Webmail Inc. =F7=D3=C5 =D0=D2=C1=D7=C1 =DA=C1=DD=C9=DD=C5=
=CE=D9.













































































DISCLAIMER : This e-mail and any attachment ("Message") are intended only fo=
r the use of the recipient(s) named above and may contain confidential infor=
mation. You are hereby notified that the taking of any action in reliance up=
on, or any review, retransmission, dissemination, distribution, printing or=
 copying of this Message or any part thereof by anyone other than the intend=
ed recipient(s) is prohibited. If you have received this Message in error, y=
ou should delete this Message immediately and advise the sender by return e-=
mail.

Any opinion, view and/or other information in this Message which do not rela=
te to the official business of TH or its Group of Companies shall not be dee=
med given nor endorsed by TH or its Group of Companies. TH is not responsibl=
e for any activity that might be considered to be an illegal and/or improper=
 use of e-mail. The recipient should check this Message for the presence of=
 viruses. TH or its Group of Companies accepts no liability for any damage c=
aused by any virus transmitted by this Message.

Lembaga Tabung Haji, 201, Jalan Tun Razak, 50400 Kuala Lumpur, Malaysia.
http://www.tabunghaji.gov.my
