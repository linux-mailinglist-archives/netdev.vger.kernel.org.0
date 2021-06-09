Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471763A107E
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbhFIJqY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Jun 2021 05:46:24 -0400
Received: from mga07.intel.com ([134.134.136.100]:11502 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238295AbhFIJqX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 05:46:23 -0400
IronPort-SDR: 0dBO/PmNBia3IdTlVmN1MVbdnpmKFzvTBnmgYo8a3CHccvpPkIimsiAA3Yw/gpq56tlxVQuA+v
 Ehxne7hgIkkQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="268894585"
X-IronPort-AV: E=Sophos;i="5.83,260,1616482800"; 
   d="scan'208";a="268894585"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 02:44:27 -0700
IronPort-SDR: Qy/NT3vTzSfHTbfyoUjPsGD6gW2+TaBEyrMMAXG8cyjl2Z4z7ObV80eKNaqmKjqaBBYEMR3EXu
 ilgvnRE5n2MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,260,1616482800"; 
   d="scan'208";a="476905522"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Jun 2021 02:44:26 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 9 Jun 2021 02:44:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 9 Jun 2021 02:44:25 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2242.008;
 Wed, 9 Jun 2021 02:44:25 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Baron <jbaron@akamai.com>,
        Stefani Seibold <stefani@seibold.net>,
        Thomas Graf <tgraf@suug.ch>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        Jens Axboe <axboe@kernel.dk>, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] lib: Fix spelling mistakes
Thread-Topic: [PATCH 1/1] lib: Fix spelling mistakes
Thread-Index: AQHXW25mQUZ/3mReXUOUVl0pKz3Wa6sLcQ/A
Date:   Wed, 9 Jun 2021 09:44:25 +0000
Message-ID: <384f6bc573564b2fbc29c33fcc78f934@intel.com>
References: <20210607072555.12416-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210607072555.12416-1-thunder.leizhen@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Zhen Lei <thunder.leizhen@huawei.com>
> Sent: Monday, June 07, 2021 12:26 AM
> To: Jason Baron <jbaron@akamai.com>; Stefani Seibold <stefani@seibold.net>;
> Keller, Jacob E <jacob.e.keller@intel.com>; Thomas Graf <tgraf@suug.ch>;
> Herbert Xu <herbert@gondor.apana.org.au>; Jens Axboe <axboe@kernel.dk>;
> Petr Mladek <pmladek@suse.com>; Steven Rostedt <rostedt@goodmis.org>;
> Sergey Senozhatsky <senozhatsky@chromium.org>; Andy Shevchenko
> <andriy.shevchenko@linux.intel.com>; Rasmus Villemoes
> <linux@rasmusvillemoes.dk>; Andrew Morton <akpm@linux-foundation.org>;
> netdev <netdev@vger.kernel.org>; linux-block <linux-block@vger.kernel.org>;
> linux-kernel <linux-kernel@vger.kernel.org>
> Cc: Zhen Lei <thunder.leizhen@huawei.com>
> Subject: [PATCH 1/1] lib: Fix spelling mistakes
> 
> Fix some spelling mistakes in comments:
> permanentely ==> permanently
> wont ==> won't
> remaning ==> remaining
> succed ==> succeed
> shouldnt ==> shouldn't
> alpha-numeric ==> alphanumeric
> storeing ==> storing
> funtion ==> function
> documenation ==> documentation
> Determin ==> Determine
> intepreted ==> interpreted
> ammount ==> amount
> obious ==> obvious
> interupts ==> interrupts
> occured ==> occurred
> asssociated ==> associated
> taking into acount ==> taking into account
> squence ==> sequence
> stil ==> still
> contiguos ==> contiguous
> matchs ==> matches
> 

Looks correct to me.

Certainly for the PLDMFW changes, but also for the rest of the fixes:

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  lib/Kconfig.debug             | 6 +++---
>  lib/asn1_encoder.c            | 2 +-
>  lib/devres.c                  | 2 +-
>  lib/dynamic_debug.c           | 2 +-
>  lib/fonts/font_pearl_8x8.c    | 2 +-
>  lib/kfifo.c                   | 2 +-
>  lib/list_sort.c               | 2 +-
>  lib/nlattr.c                  | 4 ++--
>  lib/oid_registry.c            | 2 +-
>  lib/pldmfw/pldmfw.c           | 2 +-
>  lib/reed_solomon/test_rslib.c | 2 +-
>  lib/refcount.c                | 2 +-
>  lib/rhashtable.c              | 2 +-
>  lib/sbitmap.c                 | 2 +-
>  lib/scatterlist.c             | 4 ++--
>  lib/seq_buf.c                 | 2 +-
>  lib/sort.c                    | 2 +-
>  lib/stackdepot.c              | 2 +-
>  lib/vsprintf.c                | 2 +-
>  19 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 150f13baa6cc..3cf48998a374 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1293,7 +1293,7 @@ config PROVE_RAW_LOCK_NESTING
>  	 option expect lockdep splats until these problems have been fully
>  	 addressed which is work in progress. This config switch allows to
>  	 identify and analyze these problems. It will be removed and the
> -	 check permanentely enabled once the main issues have been fixed.
> +	 check permanently enabled once the main issues have been fixed.
> 
>  	 If unsure, select N.
> 
> @@ -1459,7 +1459,7 @@ config DEBUG_LOCKING_API_SELFTESTS
>  	  Say Y here if you want the kernel to run a short self-test during
>  	  bootup. The self-test checks whether common types of locking bugs
>  	  are detected by debugging mechanisms or not. (if you disable
> -	  lock debugging then those bugs wont be detected of course.)
> +	  lock debugging then those bugs won't be detected of course.)
>  	  The following locking APIs are covered: spinlocks, rwlocks,
>  	  mutexes and rwsems.
> 
> @@ -1945,7 +1945,7 @@ config FAIL_IO_TIMEOUT
>  	  thus exercising the error handling.
> 
>  	  Only works with drivers that use the generic timeout handling,
> -	  for others it wont do anything.
> +	  for others it won't do anything.
> 
>  config FAIL_FUTEX
>  	bool "Fault-injection capability for futexes"
> diff --git a/lib/asn1_encoder.c b/lib/asn1_encoder.c
> index 41e71aae3ef6..27bbe891714f 100644
> --- a/lib/asn1_encoder.c
> +++ b/lib/asn1_encoder.c
> @@ -181,7 +181,7 @@ EXPORT_SYMBOL_GPL(asn1_encode_oid);
>  /**
>   * asn1_encode_length() - encode a length to follow an ASN.1 tag
>   * @data: pointer to encode at
> - * @data_len: pointer to remaning length (adjusted by routine)
> + * @data_len: pointer to remaining length (adjusted by routine)
>   * @len: length to encode
>   *
>   * This routine can encode lengths up to 65535 using the ASN.1 rules.
> diff --git a/lib/devres.c b/lib/devres.c
> index bdb06898a977..b0e1c6702c71 100644
> --- a/lib/devres.c
> +++ b/lib/devres.c
> @@ -355,7 +355,7 @@ static void pcim_iomap_release(struct device *gendev,
> void *res)
>   * detach.
>   *
>   * This function might sleep when the table is first allocated but can
> - * be safely called without context and guaranteed to succed once
> + * be safely called without context and guaranteed to succeed once
>   * allocated.
>   */
>  void __iomem * const *pcim_iomap_table(struct pci_dev *pdev)
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index d3ce78298832..cb5abb42c16a 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -991,7 +991,7 @@ static int ddebug_dyndbg_param_cb(char *param, char
> *val,
> 
>  	ddebug_exec_queries((val ? val : "+p"), modname);
> 
> -	return 0; /* query failure shouldnt stop module load */
> +	return 0; /* query failure shouldn't stop module load */
>  }
> 
>  /* handle both dyndbg and $module.dyndbg params at boot */
> diff --git a/lib/fonts/font_pearl_8x8.c b/lib/fonts/font_pearl_8x8.c
> index b1678ed0017c..ae98ca17982e 100644
> --- a/lib/fonts/font_pearl_8x8.c
> +++ b/lib/fonts/font_pearl_8x8.c
> @@ -3,7 +3,7 @@
>  /*                                            */
>  /*       Font file generated by cpi2fnt       */
>  /*       ------------------------------       */
> -/*       Combined with the alpha-numeric      */
> +/*       Combined with the alphanumeric       */
>  /*       portion of Greg Harp's old PEARL     */
>  /*       font (from earlier versions of       */
>  /*       linux-m86k) by John Shifflett        */
> diff --git a/lib/kfifo.c b/lib/kfifo.c
> index 70dab9ac7827..12f5a347aa13 100644
> --- a/lib/kfifo.c
> +++ b/lib/kfifo.c
> @@ -415,7 +415,7 @@ static unsigned int __kfifo_peek_n(struct __kfifo *fifo,
> size_t recsize)
>  	)
> 
>  /*
> - * __kfifo_poke_n internal helper function for storeing the length of
> + * __kfifo_poke_n internal helper function for storing the length of
>   * the record into the fifo
>   */
>  static void __kfifo_poke_n(struct __kfifo *fifo, unsigned int n, size_t recsize)
> diff --git a/lib/list_sort.c b/lib/list_sort.c
> index 1e1e37762799..0fb59e92ca2d 100644
> --- a/lib/list_sort.c
> +++ b/lib/list_sort.c
> @@ -104,7 +104,7 @@ static void merge_final(void *priv, list_cmp_func_t cmp,
> struct list_head *head,
>   * @head: the list to sort
>   * @cmp: the elements comparison function
>   *
> - * The comparison funtion @cmp must return > 0 if @a should sort after
> + * The comparison function @cmp must return > 0 if @a should sort after
>   * @b ("@a > @b" if you want an ascending sort), and <= 0 if @a should
>   * sort before @b *or* their original order should be preserved.  It is
>   * always called with the element that came first in the input in @a,
> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index 1d051ef66afe..86029ad5ead4 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -619,7 +619,7 @@ static int __nla_validate_parse(const struct nlattr *head,
> int len, int maxtype,
>   * Validates all attributes in the specified attribute stream against the
>   * specified policy. Validation depends on the validate flags passed, see
>   * &enum netlink_validation for more details on that.
> - * See documenation of struct nla_policy for more details.
> + * See documentation of struct nla_policy for more details.
>   *
>   * Returns 0 on success or a negative error code.
>   */
> @@ -633,7 +633,7 @@ int __nla_validate(const struct nlattr *head, int len, int
> maxtype,
>  EXPORT_SYMBOL(__nla_validate);
> 
>  /**
> - * nla_policy_len - Determin the max. length of a policy
> + * nla_policy_len - Determine the max. length of a policy
>   * @policy: policy to use
>   * @n: number of policies
>   *
> diff --git a/lib/oid_registry.c b/lib/oid_registry.c
> index 3dfaa836e7c5..e592d48b1974 100644
> --- a/lib/oid_registry.c
> +++ b/lib/oid_registry.c
> @@ -124,7 +124,7 @@ EXPORT_SYMBOL_GPL(parse_OID);
>   * @bufsize: The size of the buffer
>   *
>   * The OID is rendered into the buffer in "a.b.c.d" format and the number of
> - * bytes is returned.  -EBADMSG is returned if the data could not be intepreted
> + * bytes is returned.  -EBADMSG is returned if the data could not be interpreted
>   * and -ENOBUFS if the buffer was too small.
>   */
>  int sprint_oid(const void *data, size_t datasize, char *buffer, size_t bufsize)
> diff --git a/lib/pldmfw/pldmfw.c b/lib/pldmfw/pldmfw.c
> index e5d4b3b2af81..6e77eb6d8e72 100644
> --- a/lib/pldmfw/pldmfw.c
> +++ b/lib/pldmfw/pldmfw.c
> @@ -82,7 +82,7 @@ pldm_check_fw_space(struct pldmfw_priv *data, size_t
> offset, size_t length)
>   * @bytes_to_move: number of bytes to move the offset forward by
>   *
>   * Check that there is enough space past the current offset, and then move the
> - * offset forward by this ammount.
> + * offset forward by this amount.
>   *
>   * Returns: zero on success, or -EFAULT if the image is too small to fit the
>   * expected length.
> diff --git a/lib/reed_solomon/test_rslib.c b/lib/reed_solomon/test_rslib.c
> index 4eb29f365ece..d9d1c33aebda 100644
> --- a/lib/reed_solomon/test_rslib.c
> +++ b/lib/reed_solomon/test_rslib.c
> @@ -385,7 +385,7 @@ static void test_bc(struct rs_control *rs, int len, int errs,
> 
>  			/*
>  			 * We check that the returned word is actually a
> -			 * codeword. The obious way to do this would be to
> +			 * codeword. The obvious way to do this would be to
>  			 * compute the syndrome, but we don't want to replicate
>  			 * that code here. However, all the codes are in
>  			 * systematic form, and therefore we can encode the
> diff --git a/lib/refcount.c b/lib/refcount.c
> index ebac8b7d15a7..a207a8f22b3c 100644
> --- a/lib/refcount.c
> +++ b/lib/refcount.c
> @@ -164,7 +164,7 @@ EXPORT_SYMBOL(refcount_dec_and_lock);
>   * @flags: saved IRQ-flags if the is acquired
>   *
>   * Same as refcount_dec_and_lock() above except that the spinlock is acquired
> - * with disabled interupts.
> + * with disabled interrupts.
>   *
>   * Return: true and hold spinlock if able to decrement refcount to 0, false
>   *         otherwise
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index c949c1e3b87c..e12bbfb240b8 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -703,7 +703,7 @@ EXPORT_SYMBOL_GPL(rhashtable_walk_exit);
>   *
>   * Returns zero if successful.
>   *
> - * Returns -EAGAIN if resize event occured.  Note that the iterator
> + * Returns -EAGAIN if resize event occurred.  Note that the iterator
>   * will rewind back to the beginning and you may use it immediately
>   * by calling rhashtable_walk_next.
>   *
> diff --git a/lib/sbitmap.c b/lib/sbitmap.c
> index 47b3691058eb..b25db9be938a 100644
> --- a/lib/sbitmap.c
> +++ b/lib/sbitmap.c
> @@ -583,7 +583,7 @@ void sbitmap_queue_clear(struct sbitmap_queue *sbq,
> unsigned int nr,
>  	/*
>  	 * Once the clear bit is set, the bit may be allocated out.
>  	 *
> -	 * Orders READ/WRITE on the asssociated instance(such as request
> +	 * Orders READ/WRITE on the associated instance(such as request
>  	 * of blk_mq) by this bit for avoiding race with re-allocation,
>  	 * and its pair is the memory barrier implied in __sbitmap_get_word.
>  	 *
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index a59778946404..27efa6178153 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -38,7 +38,7 @@ EXPORT_SYMBOL(sg_next);
>   * @sg:		The scatterlist
>   *
>   * Description:
> - * Allows to know how many entries are in sg, taking into acount
> + * Allows to know how many entries are in sg, taking into account
>   * chaining as well
>   *
>   **/
> @@ -59,7 +59,7 @@ EXPORT_SYMBOL(sg_nents);
>   *
>   * Description:
>   * Determines the number of entries in sg that are required to meet
> - * the supplied length, taking into acount chaining as well
> + * the supplied length, taking into account chaining as well
>   *
>   * Returns:
>   *   the number of sg entries needed, negative error on failure
> diff --git a/lib/seq_buf.c b/lib/seq_buf.c
> index 707453f5d58e..b81e87ab34f6 100644
> --- a/lib/seq_buf.c
> +++ b/lib/seq_buf.c
> @@ -285,7 +285,7 @@ int seq_buf_path(struct seq_buf *s, const struct path
> *path, const char *esc)
>  }
> 
>  /**
> - * seq_buf_to_user - copy the squence buffer to user space
> + * seq_buf_to_user - copy the sequence buffer to user space
>   * @s: seq_buf descriptor
>   * @ubuf: The userspace memory location to copy to
>   * @cnt: The amount to copy
> diff --git a/lib/sort.c b/lib/sort.c
> index 3ad454411997..aa18153864d2 100644
> --- a/lib/sort.c
> +++ b/lib/sort.c
> @@ -51,7 +51,7 @@ static bool is_aligned(const void *base, size_t size, unsigned
> char align)
>   * which basically all CPUs have, to minimize loop overhead computations.
>   *
>   * For some reason, on x86 gcc 7.3.0 adds a redundant test of n at the
> - * bottom of the loop, even though the zero flag is stil valid from the
> + * bottom of the loop, even though the zero flag is still valid from the
>   * subtract (since the intervening mov instructions don't alter the flags).
>   * Gcc 8.1.0 doesn't have that problem.
>   */
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index df9179f4f441..0a2e417f83cb 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -11,7 +11,7 @@
>   * Instead, stack depot maintains a hashtable of unique stacktraces. Since alloc
>   * and free stacks repeat a lot, we save about 100x space.
>   * Stacks are never removed from depot, so we store them contiguously one
> after
> - * another in a contiguos memory allocation.
> + * another in a contiguous memory allocation.
>   *
>   * Author: Alexander Potapenko <glider@google.com>
>   * Copyright (C) 2016 Google, Inc.
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 1d6bca047690..87acf66f0e4c 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -3422,7 +3422,7 @@ int vsscanf(const char *buf, const char *fmt, va_list
> args)
> 
>  	while (*fmt) {
>  		/* skip any white space in format */
> -		/* white space in format matchs any amount of
> +		/* white space in format matches any amount of
>  		 * white space, including none, in the input.
>  		 */
>  		if (isspace(*fmt)) {
> --
> 2.25.1
> 

