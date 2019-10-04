Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357D5CB783
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 11:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388376AbfJDJnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 05:43:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41571 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388326AbfJDJnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 05:43:24 -0400
Received: from [185.81.136.18] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iGK7M-0008KY-Vt; Fri, 04 Oct 2019 09:43:21 +0000
Date:   Fri, 4 Oct 2019 11:43:19 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     shuah <shuah@kernel.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        bgolaszewski@baylibre.com, Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Subject: Re: Linux 5.4 kselftest known issues - update
Message-ID: <20191004094318.3gzcfpr6kdj76pll@wittgenstein>
References: <a293684f-4ab6-51af-60b1-caf4eb97ff05@linuxfoundation.org>
 <2a835150-d7f1-1c4a-80cb-d385f799dd14@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2a835150-d7f1-1c4a-80cb-d385f799dd14@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 08:30:55AM -0600, shuah wrote:
> On 9/26/19 11:41 AM, Shuah Khan wrote:
> > Here are the know kselftest issues on Linux 5.4 with
> > top commit commit 619e17cf75dd58905aa67ccd494a6ba5f19d6cc6
> > on x86_64:
> > 
> > The goal is to get these addressed before 5.4 comes out.
> 
> All of these issues are now fixed, except the bpf llvm dependency.
> These fixes should all be in linux-next if they haven't already.
> 
> > 
> > 3 build failures and status:
> > 
> > pidfd - undefined reference to `pthread_create' collect2: error: ld
> > returned 1 exit status
> > 
> > Fixed: https://patchwork.kernel.org/patch/11159517/

This commit is included in the following pr which I sent just now:
https://lore.kernel.org/r/20191004093947.14471-1-christian.brauner@ubuntu.com

Thanks!
Christian
