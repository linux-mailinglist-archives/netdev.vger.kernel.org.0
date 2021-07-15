Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B19C3CA15C
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 17:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbhGOPWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:22:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:37631 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238380AbhGOPWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 11:22:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="232393404"
X-IronPort-AV: E=Sophos;i="5.84,242,1620716400"; 
   d="scan'208";a="232393404"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 08:19:12 -0700
X-IronPort-AV: E=Sophos;i="5.84,242,1620716400"; 
   d="scan'208";a="495513685"
Received: from bmookkia-mobl1.amr.corp.intel.com (HELO skuppusw-mobl5.amr.corp.intel.com) ([10.212.123.85])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 08:19:11 -0700
Subject: Re: [PATCH v2 6/6] tools/tdx: Add a sample attestation user app
To:     Mian Yousaf Kaukab <ykaukab@suse.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter H Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-7-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210715083635.GA112769@suse.de>
From:   "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Message-ID: <a7757efc-cb62-013f-8976-427b354ff0f1@linux.intel.com>
Date:   Thu, 15 Jul 2021 08:19:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210715083635.GA112769@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/15/21 1:36 AM, Mian Yousaf Kaukab wrote:
> In tdg_attest_ioctl() TDX_CMD_GEN_QUOTE case is calling
> tdx_mcall_tdreport() same as TDX_CMD_GET_TDREPORT case. Then what is
> the point of calling get_tdreport() here? Do you mean to call
> gen_report_data()?

Yes, I also noticed this issue and fixed the attestation driver to
to get TDREPORT data as input to get TDQUOTE.

I will be posting the fixed version of attestation driver today.


-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
