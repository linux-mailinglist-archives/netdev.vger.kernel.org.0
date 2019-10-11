Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E72C9D49C5
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfJKVSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:18:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:46926 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfJKVSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:18:01 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iJ2IQ-0006X9-VU; Fri, 11 Oct 2019 23:17:59 +0200
Date:   Fri, 11 Oct 2019 23:17:58 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Martin Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 2/2] selftests/bpf: remove
 obsolete pahole/BTF support detection
Message-ID: <20191011211758.GA12673@pc-63.home>
References: <20191011031318.388493-1-andriin@fb.com>
 <20191011031318.388493-3-andriin@fb.com>
 <20191011162117.ckleov43b5piuzvb@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZmWLQRxW_gnJEbxZPp6K_RPGXn-MYKetVD0P-yCHwTtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZmWLQRxW_gnJEbxZPp6K_RPGXn-MYKetVD0P-yCHwTtw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25599/Fri Oct 11 10:48:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 10:28:39AM -0700, Andrii Nakryiko wrote:
> On Fri, Oct 11, 2019 at 9:21 AM Martin Lau <kafai@fb.com> wrote:
> > On Thu, Oct 10, 2019 at 08:13:18PM -0700, Andrii Nakryiko wrote:
> > > Given lots of selftests won't work without recent enough Clang/LLVM that
> > > fully supports BTF, there is no point in maintaining outdated BTF
> > > support detection and fall-back to pahole logic. Just assume we have
> > > everything we need.
> > May be an error message to tell which llvm is needed?
> 
> Not sure where we'd want this to be checked/printed. We don't do this
> today, so what I'm doing here is not really a regression.
> There is no single llvm version I'd want to pin down. For most tests
> LLVM w/ basic BTF support would be enough, for CO-RE stuff we need the
> latest Clang 10 (not yet released officially), though. So essentially
> the stance right now is that you need latest Clang built from sources
> to have all the tests compiled and I don't think it's easy to check
> for that.

At some point once bpf-gcc gets more mature, we might need something
more elaborate than just telling everyone to use latest clang/llvm
from git, but so far that's our convention we have in place today.

> > $(CPU) and $(PROBE) are no longer needed also?
> 
> Good catch, removing them as well.

Ok, expecting v2 then.

Thanks,
Daniel
