Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7676813644A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 01:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730062AbgAJASo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 19:18:44 -0500
Received: from mout.gmx.net ([212.227.17.20]:59623 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730041AbgAJASn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 19:18:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578615521;
        bh=dhRMh+bDL+tQE8WYmRZACm1FJHRz98vFOW8670MzROs=;
        h=X-UI-Sender-Class:Reply-To:Subject:From:To:Cc:References:Date:
         In-Reply-To;
        b=VbERxu+Qjyi5zHCBRyz2pdWtbWL1jWbo3VUkdJyvNoKTyXu+/R53cV6MBlvokhQNm
         3f9MEAAaG06xJII2k8tJrvUf6gygO2wmO4pPZlfSex4CruYkv6hYlREPqr2k1aIQEW
         gEoYeXwZikRdI5MmkT67iJdQq3aaif30Ft0x4u5w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([81.25.174.156]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MWzfl-1jDcmP1uZd-00XI2S; Fri, 10
 Jan 2020 01:18:40 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
 <20200109144106.GA24459@lunn.ch>
 <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
 <20200109155809.GQ25745@shell.armlinux.org.uk>
 <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
Message-ID: <d10c8598-a3d2-3936-8713-0763b156938c@gmx.net>
Date:   Fri, 10 Jan 2020 00:18:41 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:Q9PIWKq1n12jI7S0ondkaDZhjsHDf2lKEdezgVhX6UuKC1FakF/
 bQD85PnTZaM8X9kACGEsyRaBgoExbLM+asINbnQNQ9cFGg3+aHmYGZ2Ndde4OYmEtBV0wyB
 2hqb/9qmREUtVBSlG4F0nvQUKKiliPttZAOSPb/1Mmg7s+4nO1QoS4+Lblr1pNEHOEh2u3P
 jOLYg56FUPlffzfsdCeUg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:d91IWP2fYlY=:0E7zaLCXf9BfIow7MGwuH9
 5Fz5xl3WkWRcT08NMAxCTVZqX+1v59mdwWdh4W325gHNoHwXLLXMgbfDiG5CNAxyMAiiCNwhj
 e9MlOjgyb9xmIWvmEvIPbzM9VUjjkPbZToxHSB5dFoZq21KEDXIiUk1L3aJmV3Qr4Umrx6X3R
 oydqTzTrgCCnvRWwh4AUVQXaFoACUMmYL5ou62z3LxbE+JwFVfdcBcmVNeaBH9qh2Ss1SSHKP
 /C2yybeBfeMpe487oIozbLtQkY84yam3s62fq5XGcZQyaZhOwa+ZUWBuBScg59Ei5p1Ak8Px8
 qQN696bkcncDlHcF6Ml0Pg8BilA1Usho8g0/Z2h2mZixB/fXzALW4iUEAqR/w22TyH0gniErb
 +Ga67lrwxF3Jm6CxhNpsbALxYtpQm98xBWdOMV0jQFAW3+5M4R2mhwSdsYqEAHuI47waePGp1
 H+pKvLik5bOVXZt28m1/1nnfC1FwERP/uU7hO9Mog1iOlmC4/VhY9nFGVG3W297uCvpnzpdFg
 l33MTIW48087H/26CZ6MvrXmmyDFGj3LRNnwS6bEacVksCP7GvGnVmliOW49ikx03xsZhLyIn
 GXAkxzDHsfuwE4CKwj9x1RMQdTh0v8A2PXI4DcwMEClNFyFkcClWxWWG4T4z9o8GkfROi//c/
 Per/Tf/L9xYsxbR2HMiDql2SmdzDsjr4jZ8Jjm2HaLseBIOd52Swokfxh32I/+AIGVArDB7eB
 UNkcp0w7WkQ/PsaCwiBQclfem7Xhkt6Y54TL9t5FPwJyAz12QqS5n9B/ubA02PuHLG41egAmq
 k8bKBo00eidP+UyJMOSz+wlDwZ7Za9ovahFtJsWMSwbwr8mypzkvFTuva2BpeGhvuTG3nYn1m
 6rcc8hpOEmESLE3XdA2XU93GA+LrwMOdia8B74RhHi+/lawbvy1uyBKJ7xRiiSMRqZPe2gqyu
 TRzjFSJ5EMbk6lW22ASWEQCAtnO20ofEL473rGdsxTuEU0448+gpPDR2d5CG5G0sZ0J8xlwpc
 2CKYS7ZgHJoXwJH01qp8kbHtTBIGo86yoWgjOrRV6e5JUgU/9kVn9SBWgJz6ssFy/HjNlonQJ
 O+2q0jX/i2sIdTrNetegT9XO/Hqgxxmr9PUgXfQ3JPKPMM4pu9OCzP5gXZlc2WzF3dEzaRPr6
 S1P6piJaszJSI/QzTTVRnSB9gRDN5u2kQEsQVQhM7v+uwCRm3RkOVuCrJ1g+H/pymn7CSxXLZ
 IqSM0G3dplyGBOj0yQeINQbmJcANrL+jliBzPgQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/01/2020 23:50, =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=E2=84=A0 wrote:
> Maybe I should just try finding a module that is declared SPF MSA=20
> conform...=20

Actually, the vendors declares=20
(https://www.allnet.de/en/allnet-brand/produkte/neuheiten/p/-0c35cc9ea9/)=
:

*ALLNET ALL4781-VDSL2-SFP* is a VDSL2 SFP modem that interconnects with=20
Gateway Processor by using a=C2=A0MSA (MultiSource Agreement) compliant h=
ot=20
pluggable electrical interface.

Ok, "a=C2=A0MSA" does not explicitly state/imply SFP MSA but what other M=
SA=20
could that be?
If it is indeed SFP MSA conform the issue should not happen. Unless it=20
is just marketing speak and does not hold true.

