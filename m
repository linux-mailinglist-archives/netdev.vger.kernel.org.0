Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313B610E010
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 02:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfLABkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 20:40:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbfLABkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Nov 2019 20:40:04 -0500
Subject: Re: [GIT PULL] seccomp updates for v5.5-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575164403;
        bh=ajBvj1IaLYQkSA/v/7Hod991P4s7CVCuIKBejh5pxg0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=kDQly26WJo5YJvsn/LzUkhhjzAbbvTcxecHnSpiUFC8U97ES9N5DdXAy/GZSEdcMO
         okriinkm2YBXTi6WKKnlrAzV0PoPrCF2os90+EL++4P9JWLP7OjusJhRIZ5c4SPwIf
         trItpK1jsUwqxZLH+Rd885EDUMUrMh7dkdsR/JSk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <201911260818.9C5DC1E@keescook>
References: <201911260818.9C5DC1E@keescook>
X-PR-Tracked-List-Id: <linux-parisc.vger.kernel.org>
X-PR-Tracked-Message-Id: <201911260818.9C5DC1E@keescook>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git
 tags/seccomp-v5.5-rc1
X-PR-Tracked-Commit-Id: 23b2c96fad21886c53f5e1a4ffedd45ddd2e85ba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b94ae8ad9fe79da61231999f347f79645b909bda
Message-Id: <157516440360.28955.6948106020327612727.pr-tracker-bot@kernel.org>
Date:   Sun, 01 Dec 2019 01:40:03 +0000
To:     Kees Cook <keescook@chromium.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>, bpf@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel test robot <rong.a.chen@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Tyler Hicks <tyhicks@canonical.com>,
        Will Drewry <wad@chromium.org>, x86@kernel.org,
        Yonghong Song <yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 26 Nov 2019 08:25:28 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/seccomp-v5.5-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b94ae8ad9fe79da61231999f347f79645b909bda

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
