Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A497631ED4F
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbhBRR2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbhBROHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 09:07:12 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7204C061756
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 06:06:29 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lCjwq-00072Z-5d; Thu, 18 Feb 2021 15:06:28 +0100
Date:   Thu, 18 Feb 2021 15:06:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+b53bbea2ad64f9cf80d8@syzkaller.appspotmail.com>
Cc:     syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: WARNING in dst_release
Message-ID: <20210218140628.GD22944@breakpoint.cc>
References: <20210218122415.GA22944@breakpoint.cc>
 <00000000000002cc3e05bb9c8436@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000002cc3e05bb9c8436@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+b53bbea2ad64f9cf80d8@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-and-tested-by: syzbot+b53bbea2ad64f9cf80d8@syzkaller.appspotmail.com

#syz-fix: mptcp: reset last_snd on subflow close

[ This patch is currently in mptcp-next ]
