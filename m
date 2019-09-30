Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8B9C26C8
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732410AbfI3UkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:40:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:60488 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730607AbfI3UkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:40:04 -0400
Received: from 15.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.15] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iF0KT-0000xK-7e; Mon, 30 Sep 2019 20:23:25 +0200
Date:   Mon, 30 Sep 2019 20:23:24 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] tools: bpf: Use !building_out_of_srctree to determine
 srctree
Message-ID: <20190930182324.GA20613@pc-63.home>
References: <20190927011344.4695-1-skhan@linuxfoundation.org>
 <20190930085815.GA7249@pc-66.home>
 <ea108769-1b3e-42f8-de9c-50b4a563be57@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea108769-1b3e-42f8-de9c-50b4a563be57@linuxfoundation.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25588/Mon Sep 30 10:25:56 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 08:16:55AM -0600, Shuah Khan wrote:
> On 9/30/19 2:58 AM, Daniel Borkmann wrote:
> > On Thu, Sep 26, 2019 at 07:13:44PM -0600, Shuah Khan wrote:
> > > make TARGETS=bpf kselftest fails with:
> > > 
> > > Makefile:127: tools/build/Makefile.include: No such file or directory
> > > 
> > > When the bpf tool make is invoked from tools Makefile, srctree is
> > > cleared and the current logic check for srctree equals to empty
> > > string to determine srctree location from CURDIR.
> > > 
> > > When the build in invoked from selftests/bpf Makefile, the srctree
> > > is set to "." and the same logic used for srctree equals to empty is
> > > needed to determine srctree.
> > > 
> > > Check building_out_of_srctree undefined as the condition for both
> > > cases to fix "make TARGETS=bpf kselftest" build failure.
> > > 
> > > Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> > 
> > Applied, thanks!
> 
> Hi Daniel!
> 
> Is the tree the patch went into included in the linux-next?

Yes, both bpf and bpf-next are included in linux-next.

Thanks,
Daniel
