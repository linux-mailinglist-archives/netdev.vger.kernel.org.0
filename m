Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15CC19E718
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 20:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgDDSiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 14:38:09 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56297 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726187AbgDDSiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 14:38:09 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 034Ib7GU017545
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 4 Apr 2020 14:37:08 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 80DC1420021; Sat,  4 Apr 2020 14:37:07 -0400 (EDT)
Date:   Sat, 4 Apr 2020 14:37:07 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     syzbot <syzbot+67e4f16db666b1c8253c@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, adilger.kernel@dilger.ca,
        b.a.t.m.a.n@diktynna.open-mesh.org, benh@kernel.crashing.org,
        davem@davemloft.net, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mareklindner@neomailbox.ch, mpe@ellerman.id.au,
        muriloo@linux.ibm.com, netdev@vger.kernel.org, paulus@samba.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in ext4_da_update_reserve_space
Message-ID: <20200404183707.GK45598@mit.edu>
References: <0000000000008c5a4605a24cbb16@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000008c5a4605a24cbb16@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev

I'm curious why this is only showing up as failing on next-next.
Let's see if it fails on the ext4.git tree.

From the bisect logs syzbot is able to repro on all of v5.x and
v4.20.0.  However, I'm not able to repro it using kvm with either
v5.6-rc4 or the tip of the ext4 git tree.  So let's see what syzbot
can do with the tip of the dev tree.

						- Ted
