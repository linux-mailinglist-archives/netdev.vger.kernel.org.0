Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C2B42A14
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439880AbfFLO6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:58:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:48238 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436945AbfFLO6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 10:58:46 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb4i1-0000HS-S9; Wed, 12 Jun 2019 16:58:41 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb4i1-000P53-Ml; Wed, 12 Jun 2019 16:58:41 +0200
Subject: Re: linux-next: Fixes tag needs some work in the bpf tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <20190611200556.4a09514d@canb.auug.org.au>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0918037f-bc79-394a-bdbc-88e70989436b@iogearbox.net>
Date:   Wed, 12 Jun 2019 16:58:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190611200556.4a09514d@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25478/Wed Jun 12 10:14:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/11/2019 12:05 PM, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>   605465dd0c27 ("bpf: lpm_trie: check left child of last leftmost node for NULL")
> 
> Fixes tag
> 
>   Fixes: b471f2f1de8 ("bpf: implement MAP_GET_NEXT_KEY command for LPM_TRIE")
> 
> has these problem(s):
> 
>   - SHA1 should be at least 12 digits long
>     Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
>     or later) just making sure it is not set (or set to "auto").
> 

Fyi, fixed this up yesterday in bpf tree, thanks.
