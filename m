Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04A462AFF2
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 01:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiKPATG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 19:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiKPATF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 19:19:05 -0500
X-Greylist: delayed 550 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Nov 2022 16:19:03 PST
Received: from ci74p00im-qukt09082102.me.com (ci74p00im-qukt09082102.me.com [17.57.156.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33CC1DF32
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 16:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1668557392;
        bh=KkX2VtE2BagMQUs74ND1ZrgbbjxqcPIkJdZaRsxNODo=;
        h=from:Content-Type:Mime-Version:Subject:Message-Id:Date:to;
        b=CA4qpQyG4JGidXYMyd6qz+i3W/Ofko2D3Ewuad79nB43jvbzuSfzXsEASde8xWBuh
         CSivYIqikQQBFvfH8uB5xkgGY9GcOlj7UpnVfwzuPFFDQxvtMQbFe4ksgEY5h31/OC
         dIZhb3u+h5BD8aPsNO/TR5mXeuOhzX0qsAxerfWKt3EpreZs4Y3ffEboS4wfIjAwfc
         AutyF+OCGUJ86mjzskt/Mu7N3QGnmrrqMGY5Y1fafLe8GMyQy07CCizJlMKaJM3nd9
         DWyP4rmoIMR0J1uBWyznav8P1K/zxW2xxXK11Hh5HS3MipDcK4MibKMecEu13j3hRB
         5aCDkDgmAfiHw==
Received: from smtpclient.apple (ci77p00im-dlb-asmtp-mailmevip.me.com [17.57.156.26])
        by ci74p00im-qukt09082102.me.com (Postfix) with ESMTPSA id B533819C057C
        for <netdev_at_vger_kernel_org_jfadfw9b6n6d7t_a1bd1007@icloud.com>; Wed, 16 Nov 2022 00:09:51 +0000 (UTC)
from:   hotter_scads.0h@icloud.com
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Lenovo BIOS/UEFI 1.24 broke WiFi on ThinkPad T14s (Fedora 36/37)
Message-Id: <F5BA9F2E-41B8-4CC9-A743-75A7C94EC48C@me.com>
Date:   Tue, 15 Nov 2022 19:09:40 -0500
to:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-MANTSH: 1TEIXSUMdHVoaGkNHB1tfQV4aEhsaGxsaGxEKTEMXGxoEGxwSBBscGgQfGhAbHho
 fGhEKTFkXHB4RCllEF2tEGQV6HhtzGRJOEQpZTRdkRURPEQpZSRcHGRpxGwYHHBp3BhMeBhoGG
 gYaBhpxGhAadwYaBhoGGgYaBhoGGnEaEBp3BhoRClleF2NjeREKQ04XWmAeGVpiQFx9elB8X0V
 Ee0kHSUBIfVpfZ1p/E3lyeWwRClhcFxkEGgQeEwcdGEkfHx1JGQUbGhoEEhgEHhgEGBMQGx4aH
 xoRCl5ZF0tbSR1bEQpMWhdoQ2tvaxEKRVkXb2trEQpDWhcbGR8EGBkEGBgcBBgcEQpCXhcbEQp
 EXhcYEQpeThcbEQpCRRd6XUt5TEdDWxt+QREKQk4XbHBgeUAdYlJpGmIRCkJMF3pdS3lMR0NbG
 35BEQpCbhdjYkB7S1BtE3pkThEKQmwXel1LeUxHQ1sbfkERCkJAF2FtAXBmbWlkYRxnEQpCWBd
 mRmB9Yl0aRFhpQREKRUMXGxEKcGgXYHxzZUxlSAVvbF0QBxkaEQpwaBdkWUcbUx9vaFpPWhAHG
 RoRCnBoF295Ex0eTkttbmkBEAcZGhEKcGgXYVldAUNjf1xBXG4QBxkaEQpwaBd6Q15kWkt/eWJ
 uWhAHGRoRCnBMF3p9Tl9MXxlgYVpyEAcZGhEKbX4XGhEKWE0XSxE=
X-CLX-Shades: None
X-CLX-UShades: None
X-CLX-Score: 64
X-CLX-UnSpecialScore: None
X-CLX-Spam: false
X-Proofpoint-GUID: pJ43pHjvWPzVuonQc-cjbWpuMpU9SXSF
X-Proofpoint-ORIG-GUID: pJ43pHjvWPzVuonQc-cjbWpuMpU9SXSF
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=64 suspectscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=996
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2211150166
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

After upgrading the UEFI/BIOS firmware from 1.21 to 1.24 on a Lenovo =
ThinkPad T14s Gen 2 running Fedora 36/37, the WiFi stopped working. The =
WiFi router I=E2=80=99m using is Netgear R7000. The kernel is Fedora=E2=80=
=99s 6.0.8-300.fc37.x86_64.
This new firmware,1.24, was released two days ago, on Nov 13, 2022.

This is the kernel log with the new 1.24 BIOS firmware, which causes the =
wifi to never work, and the kernel just keeps printing this:

Nov 15 15:04:42 fedora kernel: wlp3s0: authenticate with =
9c:3d:cf:8d:41:a8
Nov 15 15:04:42 fedora kernel: wlp3s0: bad VHT capabilities, disabling =
VHT
Nov 15 15:04:42 fedora kernel: wlp3s0: Invalid HE elem, Disable HE
Nov 15 15:04:42 fedora kernel: wlp3s0: 80 MHz not supported, disabling =
VHT
Nov 15 15:04:42 fedora kernel: wlp3s0: send auth to 9c:3d:cf:8d:41:a8 =
(try 1/3)
Nov 15 15:04:42 fedora kernel: wlp3s0: send auth to 9c:3d:cf:8d:41:a8 =
(try 2/3)
Nov 15 15:04:42 fedora kernel: wlp3s0: send auth to 9c:3d:cf:8d:41:a8 =
(try 3/3)
Nov 15 15:04:42 fedora kernel: wlp3s0: authentication with =
9c:3d:cf:8d:41:a8 timed out

And this keeps on printing on and on, as the laptop tries to connect to =
the wifi router, and it never does. (To use networking, I had to connect =
an ethernet cable=E2=80=A6)

However after downgrading back to BIOS 1.21, the wifi works fine, just =
as before/expected, and the kernel prints this:

[ 221.928935] wlp3s0: authenticate with 9c:3d:cf:8d:41:a7
[ 221.941349] wlp3s0: Invalid HE elem, Disable HE
[ 222.487032] wlp3s0: send auth to 9c:3d:cf:8d:41:a7 (try 1/3)
[ 222.589808] wlp3s0: send auth to 9c:3d:cf:8d:41:a7 (try 2/3)
[ 222.592570] wlp3s0: authenticated
[ 222.600506] wlp3s0: associate with 9c:3d:cf:8d:41:a7 (try 1/3)
[ 222.603264] wlp3s0: RX AssocResp from 9c:3d:cf:8d:41:a7 (capab=3D0x1011 =
status=3D0 aid=3D2)
[ 222.634583] wlp3s0: associated

Hope this helps in figuring out what the problem could be with the new =
firmware, and maybe come up with a workaround in the kernel, at least =
until Lenovo fixes this in the firmware with a new release.

Regards=E2=80=A6

