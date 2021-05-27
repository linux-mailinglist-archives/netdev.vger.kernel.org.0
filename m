Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CF139266C
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhE0Ees (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:34:48 -0400
Received: from namei.org ([65.99.196.166]:50974 "EHLO mail.namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229579AbhE0Eer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:34:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.namei.org (Postfix) with ESMTPS id E7A544A2;
        Thu, 27 May 2021 04:28:11 +0000 (UTC)
Date:   Thu, 27 May 2021 14:28:11 +1000 (AEST)
From:   James Morris <jmorris@namei.org>
To:     Ondrej Mosnacek <omosnace@redhat.com>
cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, network dev <netdev@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
In-Reply-To: <CAFqZXNtUvrGxT6UMy81WfMsfZsydGN5k-VGFBq8yjDWN5ARAWw@mail.gmail.com>
Message-ID: <3ad4fb7f-99f3-fa71-fdb2-59db751c7e2b@namei.org>
References: <20210517092006.803332-1-omosnace@redhat.com> <87o8d9k4ln.fsf@mpe.ellerman.id.au> <CAFqZXNtUvrGxT6UMy81WfMsfZsydGN5k-VGFBq8yjDWN5ARAWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021, Ondrej Mosnacek wrote:

> Thanks, Michael!
> 
> James/Paul, is there anything blocking this patch from being merged?
> Especially the BPF case is causing real trouble for people and the
> only workaround is to broadly allow lockdown::confidentiality in the
> policy.

It would be good to see more signoffs/reviews, especially from Paul, but 
he is busy with the io_uring stuff.

Let's see if anyone else can look at this in the next couple of days.

-- 
James Morris
<jmorris@namei.org>

