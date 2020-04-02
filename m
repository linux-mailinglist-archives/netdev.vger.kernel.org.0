Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E58D19BE56
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 11:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387880AbgDBJEh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Apr 2020 05:04:37 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59771 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387473AbgDBJEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 05:04:37 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MRmsG-1jn6Qy3Gsk-00TBEG; Thu, 02 Apr 2020 11:04:34 +0200
Received: by mail-qk1-f172.google.com with SMTP id x3so3159124qki.4;
        Thu, 02 Apr 2020 02:04:34 -0700 (PDT)
X-Gm-Message-State: AGi0PuYjs9YqvhaDo1KAmTmos3P0evqO5bQUe8OSJuxkk/ELur8A37GD
        AoYnd+PQG1X/wgsfeLylPcRUkrSeZiqA5l8td/A=
X-Google-Smtp-Source: APiQypKBfQsYykcFkIqBe9jjU7uR9/oyFhIFaqxhu6VwqBavKfsvvOXvcqhwXwws5y4l+ZBftGfEqBmfQCje4QargqA=
X-Received: by 2002:a37:3c1:: with SMTP id 184mr763949qkd.352.1585818273400;
 Thu, 02 Apr 2020 02:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200402084801.soysci5abrazctog@falbala.internal.home.lespocky.de>
In-Reply-To: <20200402084801.soysci5abrazctog@falbala.internal.home.lespocky.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 2 Apr 2020 11:04:17 +0200
X-Gmail-Original-Message-ID: <CAK8P3a05J5b2UkkqYgM1MvOb79cax-rPd=htzHYN5+GZSkeMjw@mail.gmail.com>
Message-ID: <CAK8P3a05J5b2UkkqYgM1MvOb79cax-rPd=htzHYN5+GZSkeMjw@mail.gmail.com>
Subject: Re: doc: Leftovers from CAPI remove?
To:     "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Florian Wolters <florian@florian-wolters.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:a+/OOngsJ21qtkmsP4JZkmDMtFpklq8rxnT8dcDChrwKSPrjAbu
 4xzgvWZZ0z+58hEkwkGeGGEbhP2dp9cQ0gUJ+2QkH6HzmGzXDr2tNLnHRkBOU6qMJXrJxij
 H/MkVS+Z5HaWffv8m56Ko/ibB44b1kOhDRBSAXYMHybLIARWKNiZ2zG0RU3Buhl6aYmAsfK
 +w3XpIc/Ln7qYYakvbjmw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PD4TBDejJFg=:UCUxr+ccPsV8MuC2+ijdmO
 J35z7IUjx/ATnl3A2Dqg2f1k0ZFT1j5OB9N+tyRoAf/8vd6jsN2s2Qftx/BzNOPmUehJqiX73
 oqY/wqajEmewIorATtWPWZC+4Gm0cP8SGYHxUtki9d3uFOFi2+K2BydSAKGMQGGaz2Cfj/V0m
 U2iCtz7qBC6J9W/Thwtxs8S/pxhTqvwO2wH9ZANp/0bvF/Hq5ZTfcMgd2ayRCewuDA/OaGWmx
 WVM6PuyIQNpawVsw6JQAnnkUaQUc6ETedXPFqSZO7pKRkcOb2j3vdy0nl0tG8o8/5fj2+d6AS
 TTp/MrqIP2mDVbXsmRjwN8RF+Qm+V54W6gLqxb/W2dJaA5xlgYWGFohndNeLmbe2lW59T0QP0
 YeHGCE3Xycw5TC4aBMJhRzHz9qpjbWmq/Ysb7MsYUeIoJfnMUrM53QntKIgnJp2WenCXFdTqb
 E6WWtI2OGZ22wHhZX+1wJhZJYCF5kWlMt1wpQM/SMa1ne+gaIqNgno6CLGqSCT6ubU9hYwJ9b
 ql9B/vbMUtpBZeJ9cFPFquIzifg1qsd+N6enFC3suZTUpQ6p1qa6OiDbjo0EwWWL5c/V4voUW
 LvNV9nHecVwpoX5wm/L5tUlFgnelbeEyqg4vL+IRx5iVeO2UDjxAxLfQRDrapV2O1dKmsCn9Y
 gTkMa86sBamu1IKzGwdH6F+n0jhMnTll1b13YelzD/KY0MsBtqgk4VzAXiXfleRd457Fnrxf0
 s73tqZuj5FfRtkEUf0kDMxNrOkVrGBxwHzndDL+OiKpb0TMInXzyiRKnFCXwhzhonNn2S5Bd6
 cieGNj4zZS/Y4Gt7ghEqW901nZIrjVD7dbc6ZrZMzIOj5ib+C0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 2, 2020 at 10:48 AM Alexander Dahl <post@lespocky.de> wrote:
>
> Hei hei,
>
> when accidentally building an old Fritz PCI driver¹ against v5.6.1 we
> hit this build error (which this mail is not about):
>
> /home/florian/.fbr/fbr-4.0-trunk-x86_64/buildroot/output/build/fcpci-2.6-43.x86_64-5.6.1/fritz/src/main.c:371:3:
> Fehler: Implizite Deklaration der Funktion »register_capi_driver«; meinten Sie »register_chrdev«?  [-Werror=implicit-function-declaration]
>
> A quick grep in master revealed there are still hints to the function
> 'register_capi_driver()' in file Documentation/isdn/interface_capi.rst
>
> I suppose after removing capi parts with f59aba2f7579 ("isdn: capi:
> dead code removal") and merging with 7ba31c3f2f1e ("Merge tag
> 'staging-5.6-rc1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging") these
> are leftovers in the documentation, which should be removed, right?

Ah, it seems I missed the removal of 'struct capi_driver' that is no longer
referenced anywhere. I removed the documentation for all code I removed,
but stopped after recursively removing more unused code after I had
not found much any more. I can submit this small patch if we think
it helps, though it wouldn't change much otherwise.

diff --git a/Documentation/isdn/interface_capi.rst
b/Documentation/isdn/interface_capi.rst
index fe2421444b76..897175cffd8f 100644
--- a/Documentation/isdn/interface_capi.rst
+++ b/Documentation/isdn/interface_capi.rst
@@ -70,19 +70,6 @@ messages for that application may be passed to or
from the device anymore.
 4. Data Structures
 ==================

-4.1 struct capi_driver
-----------------------
-
-This structure describes a Kernel CAPI driver itself. It is used in the
-register_capi_driver() and unregister_capi_driver() functions, and contains
-the following non-private fields, all to be set by the driver before calling
-register_capi_driver():
-
-``char name[32]``
-       the name of the driver, as a zero-terminated ASCII string
-``char revision[32]``
-       the revision number of the driver, as a zero-terminated ASCII string
-
 4.2 struct capi_ctr
 -------------------

diff --git a/include/linux/isdn/capilli.h b/include/linux/isdn/capilli.h
index 12be09b6883b..3c546103f60e 100644
--- a/include/linux/isdn/capilli.h
+++ b/include/linux/isdn/capilli.h
@@ -81,15 +81,4 @@ void capi_ctr_ready(struct capi_ctr * card);
 void capi_ctr_down(struct capi_ctr * card);
 void capi_ctr_handle_message(struct capi_ctr * card, u16 appl, struct
sk_buff *skb);

-// ---------------------------------------------------------------------------
-// needed for AVM capi drivers
-
-struct capi_driver {
-       char name[32];                          /* driver name */
-       char revision[32];
-
-       /* management information for kcapi */
-       struct list_head list;
-};
-
 #endif                         /* __CAPILLI_H__ */

> ¹we still have basic ISDN support in fli4l [1], although no one is
> motivated to maintain it, there are still users, mainly with local
> PBX installations …

Which of the many isdn stacks (i4l, kernelcapi, misdn, misdn2, ...)
do you think are still in use there? Do you know of CAPI users
that are forced to stay on linux-5.4.y after the removal?

      Arnd
