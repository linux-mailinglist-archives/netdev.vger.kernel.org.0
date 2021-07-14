Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820BE3C8B82
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 21:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240130AbhGNTVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 15:21:15 -0400
Received: from mout.gmx.net ([212.227.15.18]:40427 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhGNTVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 15:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626290286;
        bh=EoXSwy+fW6ghWG0TQaT/zkaBFwDcOT3bRgwvcHltpu0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=MvRluLCYFcZYltN5od85vFFGK0EyW8v38WmMBLky9fv6tiMN8hYZ+TT8RqS9/JgHp
         akGDgVU2spZ/CC2ddqD+Hs3Grb5Es/Gkl9eIdhggCukyTP/6WHl2xk8+mcm9mYZ8hm
         6NnOXmp01bnhy3kImV8Ufvfgp/qqlZh8ytl2gjS8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([149.172.237.67]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N3siA-1l4K6Q2Vxg-00zru8; Wed, 14
 Jul 2021 21:18:06 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     woojung.huh@microchip.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 0/2] Fixes for KSZ DSA switch
Date:   Wed, 14 Jul 2021 21:17:21 +0200
Message-Id: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:nwqFjUBmaB3/A5aOPF/z/2YXnqgyqkkSbk/dLM7zlFzi4p1vnkj
 A3S5LqXHcSXdYfRXMJIbrry/w9xjTOeBAkbilR9e1EOS/NvM3GlnAwANkCBmhjOUF9+5T/I
 EoB5xtOk59m2mhZxOa2z0p6LXoOCpT9jFIcN0tOYY0z4lralkYnl2mbiW6srNKYK0wCRjR9
 oMwUgi/e8Wr+o98GiLoWA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wbx8xxbWpb0=:w/ED9uvDo9gQp4fFR5JXcR
 NHe2Bt3R84JfebNMRt7otL7SBPOoUWcUK1gTk660WBvivV+YUjNXsY1hR1uaBw1ZK4QX57XNj
 CeDA9dZKUiGi1Z+WIGMZuaaR3FfOm+PiPhhaLhYF5yYdlhaXN0vGj6WxP7j8649BFZFhBoQcq
 XaUeGPPwiKrpkwm2Ql2MYCRLNaD61S93n/ALh3QbBhB8YUFezB+Ti60Er59POnGPrVelvzXIE
 I+6srtm4EXkYWY+y/g879d8czE/GVymn34rqIFCuu5DrY/tYiXHX3b0gbDxP4jbLcwRcjOhS5
 SxpMH1Jt5jujQvJUt1lg9syCACslvyTtRgBSwMBhEa67+1nQETK4hAnHn6tU6WFTD18HHoIqK
 VKbvPoW+cZhK2iHf3JciCoeDdXU7iz5FxsglMcFPWLra2xlJkGEn9qAxNljbSQWG+RXdMJ3Yu
 yxUdqwvFlMDQ0ZxEDREjjWDV36xYJad4sE5q3J2uEC9MQXyyYZdcLQxHXmK4qynXIRozmKHtO
 FoVdKE86t00cbbETe1pHhfWxZk2+FUEm0hutpENeytX/K7cwAj8ueeU9Rida7lzXqcHcuSV5b
 LK1G8kYK40k6c2/fACQDHs2HFcz+IU9545keoXsxQDg/MyB19ggMWTbEllnn1qywTCpRBho1s
 SBHNvAtp4fl6rvC2QFsdqzLFewPIt6RdLgYQW/p/dztnXMyQVjBiL/oSUplku+ljn7t+yDqHV
 OgIBZkQlA92Kxed6AmVacZN2oamvEn0fHI32HxMMWzhuS69VMsjCbyGdKx1yK8S+AYxrMw3Ot
 K+oSFYnr9oEKKwrpEqObSlwZhFAlPyvP89lLURSdaQfmb2dKkEow2wUD8xLSXeJiuXbv+uRma
 SHmO+k9gSUj4JNE2SvuRM6gsUfaQossG0p6kKNwS//W2nkxCJFOkq84vyLnQbCKw8Q6+T4fzD
 eK7zsZcwPCaaBKDxQr2h8KUdkWQ3d6LobV6aH5N6YMS4st2z2JRUxnNVoVXADo00/kxfRK4Pu
 QO981fiGL0ui6Ra0kNYFKhMk4BF08aeWXawezF90jb8+QM+sOY8LQa743aWMDQfMfeyRWYShX
 uaTuvmrZu9Hm576Gtst9IUjY7RRaFiONmGd4jvioHc+aca7bXfvFht1Fg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlc2UgcGF0Y2hlcyBmaXggaXNzdWVzIEkgZW5jb3VudGVyZWQgd2hpbGUgdXNpbmcgYSBLU1o5
ODk3IGFzIGEgRFNBCnN3aXRjaCB3aXRoIGEgYnJvYWRjb20gR0VORVQgbmV0d29yayBkZXZpY2Ug
YXMgdGhlIERTQSBtYXN0ZXIgZGV2aWNlLgoKUEFUQ0ggMSBmaXhlcyBhbiBpbnZhbGlkIGFjY2Vz
cyB0byBhbiBTS0IgaW4gY2FzZSBpdCBpcyBzY2F0dGVyZWQuClBBVENIIDIgZml4ZXMgaW5jb3Jy
ZWN0IGhhcmR3YXJlIGNoZWNrc3VtIGNhbGN1bGF0aW9uIGNhdXNlZCBieSB0aGUgRFNBCnRhZy4K
ClRoZSBwYXRjaGVzIGhhdmUgYmVlbiB0ZXN0ZWQgd2l0aCBhIEtTWjk4OTcgYW5kIGFwcGx5IGFn
YWluc3QgbmV0LW5leHQuCgpMaW5vIFNhbmZpbGlwcG8gKDIpOgogIG5ldDogZHNhOiB0YWdfa3N6
OiBsaW5lYXJpemUgU0tCIGJlZm9yZSBhZGRpbmcgRFNBIHRhZwogIG5ldDogZHNhOiB0YWdfa3N6
OiBkb250IGxldCB0aGUgaGFyZHdhcmUgcHJvY2VzcyB0aGUgbGF5ZXIgNCBjaGVja3N1bQoKIG5l
dC9kc2EvdGFnX2tzei5jIHwgMTggKysrKysrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwg
MTggaW5zZXJ0aW9ucygrKQoKCmJhc2UtY29tbWl0OiA1ZTQzNzQxNmZmNjY5ODFkODE1NDY4N2Nm
ZGY3ZGU1MGIxZDgyYmZjCi0tIAoyLjMyLjAKCg==
