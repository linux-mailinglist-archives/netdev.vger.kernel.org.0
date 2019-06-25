Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E47955C9F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFYXsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfFYXsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 19:48:12 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 905A92086D;
        Tue, 25 Jun 2019 23:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561506491;
        bh=IIPnw17DMud2IaI5vgEyfR+P3UuBx+ITkJ6rG4E0/Zw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YdV2OgLAzb3QWIbIVBE+1Nl4jWGTlSEpUeKyjuhshQ5iyMDWHYzMnPwdXtw4XiTNM
         Qlxvmu3vya3XBKrFZhs2Es4bATlzE9X90mNaVtgT3Pb2Mf6AIFRrheD9lOiitAgGAM
         aOWIXSJfI4ZF3nZLsa28aqfknN+f2T7fsNojlPCM=
Date:   Tue, 25 Jun 2019 16:48:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     syzbot <syzbot+8893700724999566d6a9@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, ast@kernel.org, cai@lca.pw,
        crecklin@redhat.com, daniel@iogearbox.net, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Write in validate_chain
Message-ID: <20190625234808.GB116876@gmail.com>
References: <000000000000e672c6058bd7ee45@google.com>
 <0000000000007724d6058c2dfc24@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000007724d6058c2dfc24@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On Tue, Jun 25, 2019 at 04:07:00PM -0700, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
> Author: John Fastabend <john.fastabend@gmail.com>
> Date:   Sat Jun 30 13:17:47 2018 +0000
> 
>     bpf: sockhash fix omitted bucket lock in sock_close
> 

Are you working on this?  This is the 6th open syzbot report that has been
bisected to this commit, and I suspect it's the cause of many of the other
30 open syzbot reports I assigned to the bpf subsystem too
(https://lore.kernel.org/bpf/20190624050114.GA30702@sol.localdomain/).

Also, this is happening in mainline (v5.2-rc6).

- Eric
