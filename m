Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E841B05B9
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 11:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDTJeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 05:34:09 -0400
Received: from mout.gmx.net ([212.227.17.22]:40055 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgDTJeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 05:34:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1587375247;
        bh=J2Z74hgcwHHGGdPBH0C5iJA/8hhsUGYOmZw/I4UMpV8=;
        h=X-UI-Sender-Class:Reply-To:To:From:Subject:Date;
        b=gmMgEL5cSTvGVtaAbzAXtlXT5QPF0UUEFn0fgGs0KA/iF5/7Ha72HT847BodVZ1UU
         P+78j6K13ULQ0h0AJDU4uNn4/QPHUlt0idCNg4homcP65QCN4H1+21LsJze8WiyqqQ
         Sxb83M5lmDvfQOb1GD53Et/dzGUmkXQQwnt0aEsU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([134.101.139.191]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mirng-1ilurz0ve0-00eqf2 for
 <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:34:07 +0200
Reply-To: vtol@gmx.net
To:     netdev@vger.kernel.org
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Subject: [switchdev] bridge fdb vs. switch's ATU - connection timeout when
 roaming from LAN port to WLan port
Message-ID: <5c0744ff-d233-8135-50ac-4e7cfbc400ba@gmx.net>
Date:   Mon, 20 Apr 2020 09:34:00 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:YN04cE4ovlppuxwjwdlzv9ZfSdmqeK3qFT0ETo1/QWl5aEsNJPq
 GQV5IyRDlCSJ3aqHDLsFhn5qws0E+Wovpi0wDMZQ+LLR8jh6pGHvrU8eB+ajRLEa0OerMHE
 Y4RkBlL9qbfgT0NyTlmP4o3IvURQ+DUwMfs+FXZ6YDNwtRLocqfy3ToDD3KAy4QUCTYFDKn
 lv6tcXAd0v9emnP3LcfdA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Fcl9jH7N1Ow=:ebSlaAfjdh+Kaq1/2s5XMb
 0eB8zn/WdV5rWX2+fBYrF/Or40OjxwtVervREWp05ddEjlGRpl+hw4RxlxaLUqCA0TQzJ8bEc
 DTI+xIisXVBxdWCUGo0ckl7cv2MHaCdwae7QnGl91u1YHxHakUYEIePIalZ+t/U/tCO56XRpL
 D1IboDwHOig/xVMX2zkJB1K/U8p2oBS18C4XIUSDpFt/025dptj5OPiQqyCCK1hLeo7WUMgTS
 mwJURV0CEqmjHFZVi/etyplWcEWFGux8JMdE5KUMsHURB5xjuRNoy3CdILUGf8UaFxCiuW8ZA
 Jpu9nw+uOL3C0bhC2PH6UuhhjXbMWyIeAQU+naxxGJfiCIkRTyRGJYPN7lcxLr5Unv5fxmnkM
 RWdqR2SycNwycCTrSJZXVlnv2Y1O+LN4ZGR9bz5za2JcRvidvBkWDNRlDNh0RohBFDWcTYeCh
 10Vn4StGOKg2/a4nJF4A6i+mI6UMVuZhD8j4nZRodbDv3znt1313ZYnDV3a5eI6oQow+3S7P8
 UljmXr/f1NelIfZoDqthnoto9WmnxFt35N20Oqb/wGRSVA3YS8KFc0wgHveEtVzuQfQT0uJwf
 7QnrNIxco9W01gcTT1b4Fqn6qryJtuZ9N/dJkr37yj2lqOc8px8HoGQgf5hJnjyO+BZ88sC1/
 xWH1b75aaeo6iFylXGNwqKQAq9BLA2kld7TULx+Xaob0fG6KAIDXU6viYKnAKAPIw24ylZG/4
 AUbXyFFOJ+9vfhuePpomFKEVSr4G83tasp62o8QesbREABni32r0V/2hCPs08ncim2QVWPA5U
 oNEm5nUonNGB7F/psw7nm+T93Kba20repUzmJGu7QPeAHCVfQtkDCWiIikVFyA7RFWB76/Rv+
 RkIRAPgO8NY0DOHFvFL4w1YHLt5/WHUDto3c4J4YxU3buO2DbNuXX45iMxl1iiA6hv75rIe2I
 RtfzM7kVAeyZgYAZ8FcL7l+fJgKj2eCqh+B5Dfqbh1CY2cryRpCee3P/cjjqNm4iGuWOvELBz
 XhRTy4rcXRRbl07nJzuFLErekLUVnPfMs6X7jy8OCHTK3fwbn1GoeLXtXexKVrPDYx3MaJlIf
 +XxSXBzfQGSeqSlt5mEYivq/KjC32BQt4C90qoMKse0ko3Qt/cOEEeSAWrN4NG1Pe2pcXEACu
 4XRf/s4v/iKDHIR8enYDYkqfaRDuklcj0GG2aI0rcH/g4MHcYH6bMnY8DlAC8c10Rw6Go=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HOST config
* kernel 4.19.93
* SoC Cortex-A9 (armv7l)
* switch Marvell 88E6176 via PHY lane (mdio-mii) to SoC
* switch's downstream port driven by DSA
* switch's ATU=E2=80=99s /AgeTime/ control register default value =3D 0x13=
 (19 x
16 =3D 304 seconds)
* WLan card via mPCIe to SoC
________

Moving a client node from a (HOST) switch's downstream port (either
directly wired or indirectly via wireless AP that is wired into a switch
downstream port) to the HOST provided AP results in the client node not
being able to reach any other client node connected to a (HOST) switch's
downstream port.
Only after the switch's ATU=E2=80=99s /AgeTime/ has expired (and the MAC a=
ddress
of the roaming client node been cleared in the ATU) the client node
(that been moved/roamed) is able to establish connectivity with any
other client node connected to a (HOST) switch's downstream port.

Whilst bridge fdb is learning on the switch's downstream ports and the
WLan ports the switch's ATU is learning only on its downstream ports.
That sort of constitutes a communication gap and leading to the
aforementioned connectivity issue in the described roaming scenario.

Should switchdev be expected to communicate (align) changes from the
bridge fdb to the switch's ATU and thus prevent the aforementioned
connectivity issue? Or else, how to remedy?



