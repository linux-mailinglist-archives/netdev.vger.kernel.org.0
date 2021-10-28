Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED73A43E907
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 21:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhJ1TjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 15:39:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:54081 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhJ1TjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 15:39:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="230450764"
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="230450764"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 12:36:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="636321990"
Received: from gupta-dev2.jf.intel.com (HELO gupta-dev2.localdomain) ([10.54.74.119])
  by fmsmga001.fm.intel.com with ESMTP; 28 Oct 2021 12:36:38 -0700
Date:   Thu, 28 Oct 2021 12:38:56 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@intel.com, tony.luck@intel.com,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH ebpf v2 2/2] bpf: Make unprivileged bpf depend on
 CONFIG_CPU_SPECTRE
Message-ID: <20211028193856.q6nuy6ugunkn42ui@gupta-dev2.localdomain>
References: <cover.1635383031.git.pawan.kumar.gupta@linux.intel.com>
 <882f5c31f48bac75ebaede2a0ec321ec67128229.1635383031.git.pawan.kumar.gupta@linux.intel.com>
 <YXo2SpgjcsDzsD9O@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <YXo2SpgjcsDzsD9O@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.10.2021 07:34, Greg KH wrote:
>On Wed, Oct 27, 2021 at 06:35:44PM -0700, Pawan Gupta wrote:
>> Disabling unprivileged BPF would help prevent unprivileged users from
>> creating the conditions required for potential speculative execution
>> side-channel attacks on affected hardware. A deep dive on such attacks
>> and mitigation is available here [1].
>>
>> If an architecture selects CONFIG_CPU_SPECTRE, disable unprivileged BPF
>> by default. An admin can enable this at runtime, if necessary.
>>
>> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>>
>> [1] https://ebpf.io/summit-2021-slides/eBPF_Summit_2021-Keynote-Daniel_Borkmann-BPF_and_Spectre.pdf
>
>This should go above the signed-off-by line, in the changelog text, not
>below it, otherwise our tools get confused when trying to apply it.

Thanks, I will fix it.
