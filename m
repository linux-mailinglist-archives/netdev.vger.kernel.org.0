Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE30E82418
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 19:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfHERjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 13:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbfHERjI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 13:39:08 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 74DB8C056807;
        Mon,  5 Aug 2019 17:39:06 +0000 (UTC)
Received: from rt4.app.eng.rdu2.redhat.com (rt4.app.eng.rdu2.redhat.com [10.10.161.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D7C3E5DA60;
        Mon,  5 Aug 2019 17:39:01 +0000 (UTC)
Received: from rt4.app.eng.rdu2.redhat.com (localhost [127.0.0.1])
        by rt4.app.eng.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id x75Hd0BJ023399;
        Mon, 5 Aug 2019 13:39:00 -0400
Received: (from apache@localhost)
        by rt4.app.eng.rdu2.redhat.com (8.14.4/8.14.4/Submit) id x75Hcnwa023396;
        Mon, 5 Aug 2019 13:38:49 -0400
From:   Red Hat Product Security <secalert@redhat.com>
X-PGP-Public-Key: https://www.redhat.com/security/650d5882.txt
Subject: [engineering.redhat.com #494100] Question on submitting patch for a security bug
Reply-To: secalert@redhat.com
In-Reply-To: <CAJ7L_Gp2HJoFOVxTgakCJw3LMuiPY0+60-giOtw3OwRD6zyNTQ@mail.gmail.com>
References: <RT-Ticket-494100@engineering.redhat.com>
 <CAJ7L_Gp2HJoFOVxTgakCJw3LMuiPY0+60-giOtw3OwRD6zyNTQ@mail.gmail.com>
Message-ID: <rt-4.0.13-23214-1565026728-1358.494100-5-0@engineering.redhat.com>
X-RT-Loop-Prevention: engineering.redhat.com
RT-Ticket: engineering.redhat.com #494100
Managed-BY: RT 4.0.13 (http://www.bestpractical.com/rt/)
RT-Originator: pjp@redhat.com
To:     b.zolnierkie@samsung.com, bob.liu@oracle.com,
        chuck.lever@oracle.com, davem@davemloft.net, emamd001@umn.edu,
        gregkh@linuxfoundation.org, kubakici@wp.pl, kvalo@codeaurora.org,
        navid.emamdoost@gmail.com, sam@ravnborg.org
CC:     airlied@linux.ie, alexandre.belloni@bootlin.com,
        alexandre.torgue@st.com, allison@lohutok.net,
        andriy.shevchenko@linux.intel.com, anna.schumaker@netapp.com,
        axboe@kernel.dk, bfields@fieldses.org, colin.king@canonical.com,
        daniel@ffwll.ch, devel@driverdev.osuosl.org,
        dri-devel@lists.freedesktop.org, joabreu@synopsys.com,
        johnfwhitmore@gmail.com, josef@toxicpanda.com, jslaby@suse.com,
        kjlu@umn.edu, kstewart@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-serial@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, matthias.bgg@gmail.com,
        matthias@redhat.com, mcoquelin.stm32@gmail.com,
        nbd@other.debian.org, netdev@vger.kernel.org,
        nishkadg.linux@gmail.com, peppe.cavallaro@st.com, smccaman@umn.edu,
        tglx@linutronix.de, thierry.reding@gmail.com,
        trond.myklebust@hammerspace.com, unglinuxdriver@microchip.com,
        vishal@chelsio.com, vkoul@kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
X-RT-Original-Encoding: utf-8
Date:   Mon, 5 Aug 2019 13:38:48 -0400
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 05 Aug 2019 17:39:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Navid,

On Thu, 18 Jul 2019 01:30:20 GMT, emamd001@umn.edu wrote:
> I've found a null dereference bug in the Linux kernel source code. I was
> wondering should I cc the patch to you as well (along with the
> maintainers)?

No. Please do not cc <secalert@redhat.com> on the upstream kernel patches.
It is meant for reporting security issues only.

Going through the patches here

1. Issues in ../staging/ drivers are not considered for CVE, they are not to be
used
in production environment.

2. Many of the patches listed fix NULL pointer dereference when memory
allocation
fails and returns NULL.

3. Do you happen to have reproducers for these issues? Could an unprivileged
user trigger them?

> Also, I was wondering what are the steps to get CVE for the bug (this is
> the first time I am reporting a bug)?

Generally CVE is assigned after confirming that a given issue really is a
security issue. And it may
have impact ranging from information leakage, DoS to privilege escalation or
maybe arbitrary code
execution. Every NULL pointer dereference is not security issue.


Hope it helps. Thank you.
---
Prasad J Pandit / Red Hat Product Security Team

