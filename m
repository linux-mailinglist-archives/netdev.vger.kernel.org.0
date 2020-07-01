Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EAE211528
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgGAVbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:31:17 -0400
Received: from mout.gmx.net ([212.227.17.20]:56595 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgGAVbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 17:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1593639070;
        bh=zqWSwl2AJtvgxDBP32VoOmVWiXJSvCAasb54QnLrPRg=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=id94US90xo9fPIfnm+Ilily+qrKUXhH5xCoXIv/RL1rFaKZ+Y65KWMrGj2U9AhA03
         2i/hK8Y4ZgGt1ywMe08UafUpdHwAYatx+MOCI/+URHObhLjmocm2D2T/Nm0BUXG52w
         DJi5dpyCvbsOs3U7S3JIkZVYG+yal5XbXhxGu58g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([79.242.178.121]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MhlKy-1jDIpZ47pw-00dnN8; Wed, 01
 Jul 2020 23:31:10 +0200
Date:   Wed, 1 Jul 2020 23:31:06 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [RFC PATCH 0/2 net-next] 8390: core cleanup
Message-ID: <cover.1593627376.git.W_Armin@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:+RPCkUo96WNnhWgyvC1iT/rBocJfoPsrWeZovnZdXjSRxmvWpal
 HGC+05O4l6Hsvlyx+4LF4FIEuS+rrGASgW4+zkz5W97Q7n626cv0ObyDLMP0lKdsidh6vK0
 jRwiSq9eYWYPBlLSHn4SDkKNNs3E9ox5AYjaHq60eDZy8sKR2yC7o6wnWE+88iGFr8hMsrK
 7SahOUgXCTyVW0iwrrzmA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EoQyuoN63ow=:RGCwFEMOuWLffTClJf2KA8
 CiDO+5ddoIG+4GyRHnDKAnYwIQktXCyYr/nB37R8BA48i0qLEqr7uYXn6pWVgSXw3UJE3IV7T
 Aa0xG0J/T8jt7xnFVfZAoCj7V/byu05AbXSjLxjnnO8JPfQrFxINJRtcn13ctB2mheRlaODts
 X06lMeOQRIEPOBLUUr1x0t+urctN8UTgw+4UdZjOrVbUNJzOdJpAyU4UFkjGBDv8BcvBE56j3
 hk7e2rDZHLWSbFjtrqoLyCknP9EMHXDQ4ZgAJcC5uxTanf+/t5MsSj5J5edga/Foj8iBHuluN
 OKkw7n0SEzULIKB2m+Ql7rVEExw7NqWBgwrfAp4WY9D78q6QJMc+KZTxuTWOANzLGuiiGGVsY
 elvux0kxlue/0AIoozxHEeOTef91i1Er2Y29yZe8bDef4wuM/sEbkJld1XRXuZrJveFZm1F1m
 U4+zFqiNaHdrP4Ktnj4TqYhE+lCR2tr0z8rrj/k0Gre1WGe0Sfq7JxcVYRNmm5c7Eh4lCnOKn
 B24WqoOYjtVphjgFFOzGm//Xhpp8gDR8yVfA6SOFzuTKIW2tcA3FPc1LbkczveRM82YqhwLn1
 H5JJer24mbOUYpx7RQnsyX6782+UnlZm1/gKlmFmlzJD/cix5wIU+l17EiDFNoz9KrjFOSV+i
 lQ0ybbjRqtiBX5Y9HDdxsdf96P80kQMdeS0zbQjB0le5edUHzb0u8vqQwuMoQKbh6BLvSO50v
 L999RiBJagIas7JJoeTUxT7mhAGgw+M/IYE80gLN+jNkxPCbOYcO2zmiHpJNXbWjRYUDiZm/G
 ygkiyt5M8EH3QYvq+DlYO0a+IAOt1lwXyZkR/dLdvr9rBGU3Fl0YYh36CN+RxcBZX7isBtL6i
 KO78cU/G/uEettW3TsjKFych5OPpC8ZC/nOmLZZ677sVxHJkzXugx9pZAd/0MHL2gXEFG9Yp/
 PO9VYQi4Qz47F+luTW5nqLBvMu5LbNLmRIR8XfQre8B74xLeMdyQUGMbBL8Pdoxy+3Nma9pi4
 RkxK9WQpsktA6hEzLOxN+6sYh+PQ/k8Mk0pqrjipRZf22rVBm6x3Lhf2T5+WuH1MD4aJk1ZMN
 94hQjcood/ww134oVZYX02G/Cv/nNhXxBkzDHIsYLjrFQbaAdBx+rcTMaJsklThSKZCgtGQ1Y
 A8rm/6RU7u3OIS0vLjJNeWU+C3wWqrCQwZ9cQvzbCasIuW2whel9tHLp+fiv+eOV1Bc+o=
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patchset is to do some
cleanups in lib8390.c.

While most cleanups are simple checkpatch warnings,
some unnecessary librarys where also removed,
reducing the library size by ~4kb.

Functional changes include the removal of all
module-related stuff from the library to prevent
conflicts with real modules using lib8390, which
requires changes in modules depending on the
module-related stuff and the unnecessary librarys.

Basically all modules directly including lib8390
need to be checked for missing librarys/msg_enable
params, but so far only 8390.c has been modified to
support the cleaned-up lib8390.
And since 8390.c is not a full nic driver, the missing
param was omited.

All patches compile successfully and appear to function
normaly under 5.8.0-rc2 and a RTL8029AS card.

Armin Wolf (2):
  lib8390: Miscellaneous cleanups
  8390: Miscellaneous cleanups

 drivers/net/ethernet/8390/8390.c    |  25 +-
 drivers/net/ethernet/8390/lib8390.c | 585 +++++++++++++---------------
 2 files changed, 299 insertions(+), 311 deletions(-)

=2D-
2.20.1

