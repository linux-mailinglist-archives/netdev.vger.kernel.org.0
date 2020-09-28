Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D324427B8F5
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 02:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgI2Amp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 20:42:45 -0400
Received: from mout.gmx.net ([212.227.17.21]:59979 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgI2Amp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 20:42:45 -0400
X-Greylist: delayed 3436 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 20:42:45 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601340164;
        bh=j6zMKpsI607MfsSYIQwxjgqLj9lNoOPTuI3PKAy6k4E=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=aL/oN60O6gBCOlnKTv9Z7nzjb2dA8KL6Ql6UYmoDVh/izH6P7GTt8i29rtQvSl5fe
         QsR/ZSkLkHKdPnuMMzQvJCjMWD0rvK5mC5+Ew+2wz42484NkPlgJCJSeaMnN7tPweY
         RwAp1UhEu55tdgWaLPRJj7pW80VOdvbM1PPF7GSY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from PC1310.gateway.sonic.net ([173.228.6.223]) by mail.gmx.com
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MFbRm-1kCZkN215K-00H7MS; Tue, 29 Sep 2020 00:00:58 +0200
From:   Kevin Brace <kevinbrace@gmx.com>
To:     netdev@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@gmx.com>
Subject: [PATCH net 0/4] via-rhine: Resume fix and other maintenance work
Date:   Mon, 28 Sep 2020 15:00:37 -0700
Message-Id: <20200928220041.6654-1-kevinbrace@gmx.com>
X-Mailer: git-send-email 2.17.1
X-Provags-ID: V03:K1:FzWmR/b7+/+8aqhhfQfMt8aeSfEMB0V3B+3DdoXegkjhtMmvSF2
 9hfSxRYyG2Z3ZvpNCvhoIxWjPFaWRFbd6TI39u8wFc2mjjkE390/rtv46tyigjktcSz0Mhf
 VTnVqqem/HxXF7snDpQXiJNmlP/gMF78vXd+p5nu14yjpRMPRkb4zE2swwWM8iOuhdGecT5
 L4XqvzcECPcIBSY6gEnug==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LLBVCA4cXFI=:vpu178Mwm4livJa+/iHmvi
 B9r/ELPKWmdh+nzV610vHR2pVybbtfoWYSHfwqzzv8TcXzuHJ5+QJkxrwxSo0R/ggaPQ3X4/m
 7DwEMZchrcF7+GHI3lpEycdoek+nznSBHuwNeRezBk0ZR6uW91C9sDOck3YsTdqPjMTptyXQ5
 diSW5oNAm5vEIivEGEwszIdUwXlTVv29e3HXbkEKGIm5BD/XYolMxM5g15Qei80n7b0Z3Ujfz
 uniDbvyA9iKGknxFdEcL19ybLfoTSs3fYlaEtjBJkSJ6RTgcAfUNt4Ka8zEbOu/CmOGTqWZpq
 dfOwThKCgHE/tdj5sG5fT3NzSX3d7QMIrV0dFIkS87yOA4sG3t38eWVTZr9adCJrXSGK6KNrE
 Q8Unva5SPHgecRoxWsO6fH/2SfZja3zY0X/1iJgX5QekzwGyopjj7E/y4SaehA5BtUKUNpku6
 D+P10P3dYwHtYbqg+v/B0WuW1c4c4eaeEg+nn3lov1htnfwHdzcCdu8Itm0dN4QbNA5Wm4rAs
 cuaODC/JLrNnER7Izg+Z1A8CF1OVbBE9Nchl83HsvQP3y/6E2l+IWtLiNEORtQctWXoVKiN7b
 l/u1o+8nqNaGvyRTIWBCCUhI/O0oBjhVt4/ZmhJxWQKIs9dkUyDCMg0ImKOS/W2rhkQhsm3bK
 zVTJAFjvee9xm/TFEHnZgUvvhM47v5GIT2IDdqwob1wJ7lD84trOCliDKYTfdOwgXhNdnUs2/
 tKtpdHmxOiG0I13FfMFzhvsAkdOVNE4A0eThdsXMw2aiLhPlVAF9VYx1qygq9Cue6TSmqZFVe
 8rx8ci4JB/BgAtIJzduxns4nRvfI1B+zEYMI9Gb+06DDVRb9sadF5HIhi3I1X9tzFTa6KXiHE
 68ltwK9smZi/V0Lb20YUa0/l4ADiJEXsgpb8BIfSW2FgWfWYKdnGrtC725qgkHPsSSS9CycwW
 BkF4rzYrMeUpWtOf08PGrtcvFyMdJWyPDMB1+qKXDKi9GW7IhaHvQHllaPHHIUijvJR3x0dGu
 otuWWt/hVvR+1M4nXhTKcHF53oVQXxQhJg42vYIOSzZae3L5OiUHNDUpwAIdsnTTXd5j4Z5Vh
 /Uj0JAZK5LPRn7jw7meLoJD57phHNkYJuwjyog9dHkMPw5ZHxuiXOuf/fTsr9RM0ngUkOGoaj
 nJoFsaEvWDBu2nBn/NgVhkaUgO3D5HO0JREXjS1aGSuniRxtYIiR32/pLvIrSdhqN1pdHJwYa
 mwUuHyh9RrxbkyNSr7J2lOjmyhe8WZeLnDwKcgg==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I use via-rhine based Ethernet regularly, and the Ethernet dying
after resume was really annoying me.  I decided to take the
matter into my own hands, and came up with a fix for the Ethernet
disappearing after resume.  I will also want to take over the code
maintenance work for via-rhine.  The patches apply to the latest
code, but they should be backported to older kernels as well.
=2D-

Kevin Brace (4):
  via-rhine: Fix for the hardware having a reset failure after resume
  via-rhine: VTunknown1 device is really VT8251 South Bridge
  via-rhine: New device driver maintainer
  via-rhine: Version bumped to 1.5.2

 MAINTAINERS                          |  3 ++-
 drivers/net/ethernet/via/via-rhine.c | 10 ++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

=2D-
2.17.1

