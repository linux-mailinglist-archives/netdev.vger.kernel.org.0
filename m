Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCA75BAF9
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 13:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbfGALqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 07:46:08 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36744 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727128AbfGALqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 07:46:08 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hhuky-0004UT-J6; Mon, 01 Jul 2019 13:46:00 +0200
Date:   Mon, 1 Jul 2019 13:46:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, fw@strlen.de, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Write in xfrm_hash_rebuild
Message-ID: <20190701114600.gvlpwdajyxobqujy@breakpoint.cc>
References: <000000000000d028b30588fed102@google.com>
 <000000000000f66c6e058c7cd4e0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f66c6e058c7cd4e0@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com> wrote:
> syzbot has bisected this bug to:
> 
> commit 1548bc4e0512700cf757192c106b3a20ab639223
> Author: Florian Westphal <fw@strlen.de>
> Date:   Fri Jan 4 13:17:02 2019 +0000
> 
>     xfrm: policy: delete inexact policies from inexact list on hash rebuild

I'm looking at this now.
