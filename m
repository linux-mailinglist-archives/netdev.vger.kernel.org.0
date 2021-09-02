Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F097D3FF5CA
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 23:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347522AbhIBVrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 17:47:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:48642 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244085AbhIBVrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 17:47:39 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mLuXP-000GF4-02; Thu, 02 Sep 2021 23:46:23 +0200
Received: from [85.5.47.65] (helo=linux-3.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mLuXO-0006U6-KK; Thu, 02 Sep 2021 23:46:22 +0200
Subject: Re: [syzbot] bpf build error (3)
To:     syzbot <syzbot+8a8ba69ec56c60331e1f@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, ast@kernel.org, bp@alien8.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rafael.j.wysocki@intel.com,
        rppt@kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Maurizio Lombardi <mlombard@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>, andrii.nakryiko@gmail.com
References: <000000000000d0dfda05cb0697d7@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d85f7e26-9b37-d682-d15a-0224b8c5e8c1@iogearbox.net>
Date:   Thu, 2 Sep 2021 23:46:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <000000000000d0dfda05cb0697d7@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26282/Thu Sep  2 10:22:04 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/21 7:34 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    49ca6153208f bpf: Relicense disassembler as GPL-2.0-only O..
> git tree:       bpf
> console output: https://syzkaller.appspot.com/x/log.txt?x=17835513300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bd61edfef9fa14b1
> dashboard link: https://syzkaller.appspot.com/bug?extid=8a8ba69ec56c60331e1f
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8a8ba69ec56c60331e1f@syzkaller.appspotmail.com
> 
> arch/x86/kernel/setup.c:916:6: error: implicit declaration of function 'acpi_mps_check' [-Werror=implicit-function-declaration]
> arch/x86/kernel/setup.c:1110:2: error: implicit declaration of function 'acpi_table_upgrade' [-Werror=implicit-function-declaration]
> arch/x86/kernel/setup.c:1112:2: error: implicit declaration of function 'acpi_boot_table_init' [-Werror=implicit-function-declaration]
> arch/x86/kernel/setup.c:1120:2: error: implicit declaration of function 'early_acpi_boot_init'; did you mean 'early_cpu_init'? [-Werror=implicit-function-declaration]
> arch/x86/kernel/setup.c:1162:2: error: implicit declaration of function 'acpi_boot_init' [-Werror=implicit-function-declaration]

See also Stephen's recent report:

   https://lore.kernel.org/lkml/20210901165450.5898f1c7@canb.auug.org.au/

Maurizio/Konrad, did you have a chance to take a look?

Thanks,
Daniel
