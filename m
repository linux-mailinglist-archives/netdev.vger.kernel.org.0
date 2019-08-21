Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9725C98444
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 21:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbfHUTWo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Aug 2019 15:22:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbfHUTWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 15:22:43 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0F5630833CB;
        Wed, 21 Aug 2019 19:22:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C53C04513;
        Wed, 21 Aug 2019 19:22:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1566402203.5162.12.camel@linux.ibm.com>
References: <1566402203.5162.12.camel@linux.ibm.com> <1562814435.4014.11.camel@linux.ibm.com> <28477.1562362239@warthog.procyon.org.uk> <CAHk-=wjxoeMJfeBahnWH=9zShKp2bsVy527vo3_y8HfOdhwAAw@mail.gmail.com> <20190710194620.GA83443@gmail.com> <20190710201552.GB83443@gmail.com> <CAHk-=wiFti6=K2fyAYhx-PSX9ovQPJUNp0FMdV0pDaO_pSx9MQ@mail.gmail.com> <23498.1565962602@warthog.procyon.org.uk>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     dhowells@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, keyrings@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-nfs@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Keys: Set 4 - Key ACLs for 5.3
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19087.1566415359.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 21 Aug 2019 20:22:39 +0100
Message-ID: <19088.1566415359@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 21 Aug 2019 19:22:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I added a bunch of tests to the keyutils testsuite, currently on my -next
branch:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/log/?h=next

See:

	Add a keyctl command for granting a permit on a key
	Handle kernel having key/keyring ACLs

I've added manpages to describe the new bits, but I wonder whether I should
add a manpage specifically to detail the permissions system.  It'll probably
be useful when more advanced subjects become available, such as for specific
UIDs and for containers-as-a-whole.

David
