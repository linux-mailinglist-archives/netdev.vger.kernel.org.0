Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B34235B34C
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 13:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbhDKLJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 07:09:41 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:43721 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235247AbhDKLJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 07:09:38 -0400
Received: from [192.168.178.35] (unknown [94.134.88.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 13BF5206473C4;
        Sun, 11 Apr 2021 13:09:08 +0200 (CEST)
To:     "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, it+linux-bpf@molgen.mpg.de
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: sysctl: setting key "net.core.bpf_jit_enable": Invalid argument
Message-ID: <412d88b2-fa9a-149e-6f6e-3cfbce9edef0@molgen.mpg.de>
Date:   Sun, 11 Apr 2021 13:09:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux folks,


Related to * [CVE-2021-29154] Linux kernel incorrect computation of 
branch displacements in BPF JIT compiler can be abused to execute 
arbitrary code in Kernel mode* [1], on the POWER8 system IBM S822LC with 
self-built Linux 5.12.0-rc5+, I am unable to disable `bpf_jit_enable`.

     $ /sbin/sysctl net.core.bpf_jit_enable
     net.core.bpf_jit_enable = 1
     $ sudo /sbin/sysctl -w net.core.bpf_jit_enable=0
     sysctl: setting key "net.core.bpf_jit_enable": Invalid argument

It works on an x86 with Debian sid/unstable and Linux 5.10.26-1.


Kind regards,

Paul


[1]: https://seclists.org/oss-sec/2021/q2/12
