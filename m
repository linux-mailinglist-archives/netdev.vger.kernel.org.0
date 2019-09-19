Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33050B80DA
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 20:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392057AbfISSaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 14:30:19 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:37874 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392032AbfISSaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 14:30:19 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 99AB672CCE7;
        Thu, 19 Sep 2019 21:30:17 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 8541B7CCB47; Thu, 19 Sep 2019 21:30:17 +0300 (MSK)
Date:   Thu, 19 Sep 2019 21:30:17 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Tyler Hicks <tyhicks@canonical.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        luto@amacapital.net, jannh@google.com, wad@chromium.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] seccomp: add two missing ptrace ifdefines
Message-ID: <20190919183017.GD22257@altlinux.org>
References: <20190918084833.9369-1-christian.brauner@ubuntu.com>
 <20190918084833.9369-3-christian.brauner@ubuntu.com>
 <20190918091512.GA5088@elm>
 <201909181031.1EE73B4@keescook>
 <20190919104251.GA16834@altlinux.org>
 <201909190918.443D6BC7@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201909190918.443D6BC7@keescook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 09:55:30AM -0700, Kees Cook wrote:
> On Thu, Sep 19, 2019 at 01:42:51PM +0300, Dmitry V. Levin wrote:
> > On Wed, Sep 18, 2019 at 10:33:09AM -0700, Kees Cook wrote:
> > > This is actually fixed in -next already (and, yes, with the Fixes line
> > > Tyler has mentioned):
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git/commit/?h=next&id=69b2d3c5924273a0ae968d3818210fc57a1b9d07
> > 
> > Excuse me, does it mean that you expect each selftest to be self-hosted?
> > I was (and still is) under impression that selftests should be built
> > with headers installed from the tree. Is it the case, or is it not?
> 
> As you know (but to give others some context) there is a long-standing
> bug in the selftest build environment that causes these problems (it
> isn't including the uAPI headers) which you'd proposed to be fixed
> recently[1]. Did that ever get sent as a "real" patch? I don't see it
> in Shuah's tree; can you send it to Shuah?
> 
> [1] https://lore.kernel.org/lkml/20190805094719.GA1693@altlinux.org/

The [1] was an idea rather than a patch, it didn't take arch uapi headers
into account.  OK, I'll try to come up with a proper fix then.


-- 
ldv
