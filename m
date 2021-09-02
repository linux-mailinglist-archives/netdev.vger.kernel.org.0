Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52EC3FF749
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347770AbhIBWlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347746AbhIBWlQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 18:41:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A74C861057;
        Thu,  2 Sep 2021 22:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630622418;
        bh=H+GPf6wJaEdDSAyvDP5hq9eNmuYoqm6Sc7Ob+DUWTBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WqKQOeYW/KukgDkoZhOlt7XkZT9OCGav6INJHiJdk2/xy4aafjGiVdjsdg36PeQev
         SxN8caKQIGqM7kF1KY/i8bn1VQL6Gc0WkJ/7N4PefeN2uFaGSHz+Hy+8P72K6kNiX3
         KYLIvdSNxC2IYK4r/7D+JX51vOCbCiwzCazdxbXiAEQGeZ+c7M7BjUaVTzO9+UOUpa
         L1Uc9dPSPSlVB8v39SoS5VcQe4EyG7yPKE49wCUCd17ZXlrw7AI/MGsdCHhxua2ShF
         BHtAPoRrzB687QUAQJBAkJ/6hMhDtpgG6wKAzgXIvCiS3ZAbUYg6g+5Rk2+koAy8XO
         /3kvtQfHrHitA==
Date:   Thu, 2 Sep 2021 15:40:11 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     syzbot <syzbot+8a8ba69ec56c60331e1f@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, ast@kernel.org, bp@alien8.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rafael.j.wysocki@intel.com,
        rppt@kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Maurizio Lombardi <mlombard@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>, andrii.nakryiko@gmail.com
Subject: Re: [syzbot] bpf build error (3)
Message-ID: <YTFSy7Sg57I79GwU@archlinux-ax161>
References: <000000000000d0dfda05cb0697d7@google.com>
 <d85f7e26-9b37-d682-d15a-0224b8c5e8c1@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d85f7e26-9b37-d682-d15a-0224b8c5e8c1@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Thu, Sep 02, 2021 at 11:46:21PM +0200, Daniel Borkmann wrote:
> On 9/2/21 7:34 PM, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    49ca6153208f bpf: Relicense disassembler as GPL-2.0-only O..
> > git tree:       bpf
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17835513300000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=bd61edfef9fa14b1
> > dashboard link: https://syzkaller.appspot.com/bug?extid=8a8ba69ec56c60331e1f
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+8a8ba69ec56c60331e1f@syzkaller.appspotmail.com
> > 
> > arch/x86/kernel/setup.c:916:6: error: implicit declaration of function 'acpi_mps_check' [-Werror=implicit-function-declaration]
> > arch/x86/kernel/setup.c:1110:2: error: implicit declaration of function 'acpi_table_upgrade' [-Werror=implicit-function-declaration]
> > arch/x86/kernel/setup.c:1112:2: error: implicit declaration of function 'acpi_boot_table_init' [-Werror=implicit-function-declaration]
> > arch/x86/kernel/setup.c:1120:2: error: implicit declaration of function 'early_acpi_boot_init'; did you mean 'early_cpu_init'? [-Werror=implicit-function-declaration]
> > arch/x86/kernel/setup.c:1162:2: error: implicit declaration of function 'acpi_boot_init' [-Werror=implicit-function-declaration]
> 
> See also Stephen's recent report:
> 
>   https://lore.kernel.org/lkml/20210901165450.5898f1c7@canb.auug.org.au/
> 
> Maurizio/Konrad, did you have a chance to take a look?

This is fixed as commit ea7b4244b365 ("x86/setup: Explicitly include
acpi.h") in Linus's tree.

Cheers,
Nathan
