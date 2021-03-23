Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F37345767
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 06:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCWFkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 01:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhCWFkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 01:40:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7871AC061574;
        Mon, 22 Mar 2021 22:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=icJplTGGxz2G/Khqfbp5NSjgVDQ3QMHoDvs8dUu35/g=; b=fzQXiMuSOQgfzL4PpG40ZAiYUh
        zuPqXC4LOZPPPhb/A3eC+mM1ElYgrDZxxSHAmdLm1nrK4WUAw06hbj4hqdpeFAlU0haOdvCQ/GQ5J
        +8pNeqc8K5/ToeZspfzrb4+REnirY5IuXSl4XS/C2icNm8hSe5dhCQQ/ZgkrdqRgkv0FeVyPANKuB
        pWfUfqcK9podU0vfb2I22NmTUULj3xTKjxtt23dAyZyWqA+GJIsZVelcxuUr/9EN4z8Dl3kIHW6mT
        OWlrPGiC3wlrsc9J/HLLKux6S7byIPZ3/PTBLJZZ7Ybk5ZkPPu5lAFVZQV+qu01fHUkfZT8wLGAkq
        mmQgO6ag==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOZlX-009bhI-9F; Tue, 23 Mar 2021 05:39:50 +0000
Subject: Re: [PATCH] perf tools: Trivial spelling fixes
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, irogers@google.com,
        kan.liang@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20210323044605.1788192-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <dc1cde42-f0a6-8f1a-1353-9e767ae3cd31@infradead.org>
Date:   Mon, 22 Mar 2021 22:39:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210323044605.1788192-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 9:46 PM, Bhaskar Chowdhury wrote:
> 
> s/succeded/succeeded/ ........five different places
> s/revsions/revisions/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  tools/perf/util/header.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 20effdff76ce..97a0eeb6d2ab 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -127,7 +127,7 @@ static int __do_write_buf(struct feat_fd *ff,  const void *buf, size_t size)
>  	return 0;
>  }
> 
> -/* Return: 0 if succeded, -ERR if failed. */
> +/* Return: 0 if succeeded, -ERR if failed. */
>  int do_write(struct feat_fd *ff, const void *buf, size_t size)
>  {
>  	if (!ff->buf)
> @@ -135,7 +135,7 @@ int do_write(struct feat_fd *ff, const void *buf, size_t size)
>  	return __do_write_buf(ff, buf, size);
>  }
> 
> -/* Return: 0 if succeded, -ERR if failed. */
> +/* Return: 0 if succeeded, -ERR if failed. */
>  static int do_write_bitmap(struct feat_fd *ff, unsigned long *set, u64 size)
>  {
>  	u64 *p = (u64 *) set;
> @@ -154,7 +154,7 @@ static int do_write_bitmap(struct feat_fd *ff, unsigned long *set, u64 size)
>  	return 0;
>  }
> 
> -/* Return: 0 if succeded, -ERR if failed. */
> +/* Return: 0 if succeeded, -ERR if failed. */
>  int write_padded(struct feat_fd *ff, const void *bf,
>  		 size_t count, size_t count_aligned)
>  {
> @@ -170,7 +170,7 @@ int write_padded(struct feat_fd *ff, const void *bf,
>  #define string_size(str)						\
>  	(PERF_ALIGN((strlen(str) + 1), NAME_ALIGN) + sizeof(u32))
> 
> -/* Return: 0 if succeded, -ERR if failed. */
> +/* Return: 0 if succeeded, -ERR if failed. */
>  static int do_write_string(struct feat_fd *ff, const char *str)
>  {
>  	u32 len, olen;
> @@ -266,7 +266,7 @@ static char *do_read_string(struct feat_fd *ff)
>  	return NULL;
>  }
> 
> -/* Return: 0 if succeded, -ERR if failed. */
> +/* Return: 0 if succeeded, -ERR if failed. */
>  static int do_read_bitmap(struct feat_fd *ff, unsigned long **pset, u64 *psize)
>  {
>  	unsigned long *set;
> @@ -3485,7 +3485,7 @@ static const size_t attr_pipe_abi_sizes[] = {
>   * between host recording the samples, and host parsing the samples is the
>   * same. This is not always the case given that the pipe output may always be
>   * redirected into a file and analyzed on a different machine with possibly a
> - * different endianness and perf_event ABI revsions in the perf tool itself.
> + * different endianness and perf_event ABI revisions in the perf tool itself.
>   */
>  static int try_all_pipe_abis(uint64_t hdr_sz, struct perf_header *ph)
>  {
> --


-- 
~Randy

