Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7008E7017F
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 15:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbfGVNom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 09:44:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729418AbfGVNom (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 09:44:42 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2EB874627A;
        Mon, 22 Jul 2019 13:44:42 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (dhcp-192-200.str.redhat.com [10.33.192.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4726B60497;
        Mon, 22 Jul 2019 13:44:40 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, nd <nd@arm.com>,
        GNU C Library <libc-alpha@sourceware.org>,
        "Sergei Trofimovich" <slyfox@gentoo.org>,
        Networking <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>
Subject: Re: [PATCH glibc] Linux: Include <linux/sockios.h> in <bits/socket.h> under __USE_MISC
References: <87ftmys3un.fsf@oldenburg2.str.redhat.com>
        <CAK8P3a0hC4wvjwCi4=DCET3C4qARMY6c58ffjwG3b1ZPM6kr-A@mail.gmail.com>
        <2431941f-3aac-d31f-e6f5-8ed2ed7b2e5c@arm.com>
Date:   Mon, 22 Jul 2019 15:44:39 +0200
In-Reply-To: <2431941f-3aac-d31f-e6f5-8ed2ed7b2e5c@arm.com> (Szabolcs Nagy's
        message of "Mon, 22 Jul 2019 13:41:07 +0000")
Message-ID: <87lfwqqj3s.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 22 Jul 2019 13:44:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Szabolcs Nagy:

> (note: in musl these ioctl macros are in sys/ioctl.h
> which is not a posix header so namespace rules are
> less strict than for sys/socket.h and users tend to
> include it for ioctl())

<sys/ioctl.h> can be confusing because some of the constants may depend
on types that aren't declared by including the header.  This makes their
macros unusable.  Defining ioctl constants in headers which also provide
the matching types avoids that problem at least, also it can introduce
namespace issues.

Thanks,
Florian
