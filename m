Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B44A3CFFC6
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 18:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhGTQNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:13:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:22084 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhGTQNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 12:13:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="190861456"
X-IronPort-AV: E=Sophos;i="5.84,255,1620716400"; 
   d="scan'208";a="190861456"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 09:53:16 -0700
X-IronPort-AV: E=Sophos;i="5.84,255,1620716400"; 
   d="scan'208";a="469822709"
Received: from kvadariv-mobl1.amr.corp.intel.com (HELO [10.212.155.118]) ([10.212.155.118])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 09:53:15 -0700
Subject: Re: [PATCH v3 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Peter H Anvin <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210720045552.2124688-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210720045552.2124688-6-sathyanarayanan.kuppuswamy@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <eddc318e-e9c9-546d-6cff-b3c40062aecd@intel.com>
Date:   Tue, 20 Jul 2021 09:53:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210720045552.2124688-6-sathyanarayanan.kuppuswamy@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Used in Quote memory allocation */
> +#define QUOTE_SIZE			(2 * PAGE_SIZE)
> +/* Get Quote timeout in msec */
> +#define GET_QUOTE_TIMEOUT		(5000)

The comment is good, but even better would be to call this:

	GET_QUOTE_TIMEOUT_MS

> +/* Mutex to synchronize attestation requests */
> +static DEFINE_MUTEX(attestation_lock);
> +/* Completion object to track attestation status */
> +static DECLARE_COMPLETION(attestation_done);
> +/* Buffer used to copy report data in attestation handler */
> +static u8 report_data[TDX_REPORT_DATA_LEN];
> +/* Data pointer used to get TD Quote data in attestation handler */
> +static void *tdquote_data;
> +/* Data pointer used to get TDREPORT data in attestation handler */
> +static void *tdreport_data;

Are these *really* totally unknown, opaque blobs?  Why not give them an
actual data type?

> +/* DMA handle used to allocate and free tdquote DMA buffer */
> +dma_addr_t tdquote_dma_handle;

That's an unreadable jumble.  Please add some line breaks and try to
logically group those.

> +static void attestation_callback_handler(void)
> +{
> +	complete(&attestation_done);
> +}
> +
> +static long tdg_attest_ioctl(struct file *file, unsigned int cmd,
> +			     unsigned long arg)
> +{
> +	void __user *argp = (void __user *)arg;
> +	long ret = 0;
> +
> +	mutex_lock(&attestation_lock);
> +
> +	switch (cmd) {
> +	case TDX_CMD_GET_TDREPORT:
> +		if (copy_from_user(report_data, argp, TDX_REPORT_DATA_LEN)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		/* Generate TDREPORT_STRUCT */
> +		if (tdx_mcall_tdreport(virt_to_phys(tdreport_data),
> +				       virt_to_phys(report_data))) {

Having that take a physical address seems like a mistake.  Why not just
do the virt_to_phys() inside the helper?

Also, this isn't very clear that there is an input and an output.  Can
you rename these to make that more clear?

> +			ret = -EIO;
> +			break;
> +		}
> +
> +		if (copy_to_user(argp, tdreport_data, TDX_TDREPORT_LEN))
> +			ret = -EFAULT;
> +		break;
> +	case TDX_CMD_GEN_QUOTE:
> +		/* Copy TDREPORT data from user buffer */
> +		if (copy_from_user(tdquote_data, argp, TDX_TDREPORT_LEN)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		/* Submit GetQuote Request */
> +		if (tdx_hcall_get_quote(virt_to_phys(tdquote_data))) {
> +			ret = -EIO;
> +			break;
> +		}
> +
> +		/* Wait for attestation completion */
> +		ret = wait_for_completion_interruptible_timeout(
> +				&attestation_done,
> +				msecs_to_jiffies(GET_QUOTE_TIMEOUT));
> +		if (ret <= 0) {
> +			ret = -EIO;
> +			break;
> +		}
> +
> +		if (copy_to_user(argp, tdquote_data, QUOTE_SIZE))
> +			ret = -EFAULT;
> +
> +		break;
> +	case TDX_CMD_GET_QUOTE_SIZE:
> +		ret = put_user(QUOTE_SIZE, (u64 __user *)argp);
> +		break;
> +	default:
> +		pr_err("cmd %d not supported\n", cmd);
> +		break;

First of all, drivers shouldn't pollute the kernel log on bad input.
Second, won't this inherit the ret=0 value and return success?

> +	}
> +
> +	mutex_unlock(&attestation_lock);
> +
> +	return ret;
> +}
> +
> +static const struct file_operations tdg_attest_fops = {
> +	.owner		= THIS_MODULE,
> +	.unlocked_ioctl	= tdg_attest_ioctl,
> +	.llseek		= no_llseek,
> +};
> +
> +static struct miscdevice tdg_attest_device = {
> +	.minor          = MISC_DYNAMIC_MINOR,
> +	.name           = "tdx-attest",
> +	.fops           = &tdg_attest_fops,
> +};
> +
> +static int __init tdg_attest_init(void)
> +{
> +	dma_addr_t handle;
> +	long ret = 0;

The function returns 'int', yet 'ret' is a long.  Why?

> +	ret = misc_register(&tdg_attest_device);
> +	if (ret) {
> +		pr_err("misc device registration failed\n");
> +		return ret;
> +	}
> +
> +	tdreport_data = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 0);
> +	if (!tdreport_data) {
> +		ret = -ENOMEM;
> +		goto failed;
> +	}

Why does this need to use the page allocator directly?  Why does it need
to zero the memory?  Why does it need to get a whole page?  If it really
only needs a single page, why not use __get_free_page()?

> +
> +	ret = dma_set_coherent_mask(tdg_attest_device.this_device,
> +				    DMA_BIT_MASK(64));
> +	if (ret) {
> +		pr_err("dma set coherent mask failed\n");
> +		goto failed;
> +	}
> +
> +	/* Allocate DMA buffer to get TDQUOTE data from the VMM */
> +	tdquote_data = dma_alloc_coherent(tdg_attest_device.this_device,
> +					  QUOTE_SIZE, &handle,
> +					  GFP_KERNEL | __GFP_ZERO);
> +	if (!tdquote_data) {
> +		ret = -ENOMEM;
> +		goto failed;
> +	}
> +
> +	tdquote_dma_handle =  handle;
> +
> +	/*
> +	 * Currently tdg_event_notify_handler is only used in attestation
> +	 * driver. But, WRITE_ONCE is used as benign data race notice.
> +	 */
> +	WRITE_ONCE(tdg_event_notify_handler, attestation_callback_handler);
> +
> +	pr_debug("module initialization success\n");
> +
> +	return 0;
> +
> +failed:
> +	if (tdreport_data)
> +		free_pages((unsigned long)tdreport_data, 0);
> +
> +	misc_deregister(&tdg_attest_device);
> +
> +	pr_debug("module initialization failed\n");
> +
> +	return ret;
> +}
...
