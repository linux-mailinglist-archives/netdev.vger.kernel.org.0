Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C88404DDFD
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfFUAEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:04:09 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34335 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFUAEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:04:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id p10so2430275pgn.1
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/0MFjhnUu1tpcGaXSypmk9ZDdGLvZjJouKh8Z2Gnc3s=;
        b=J4SdgbreTYEAjfKS5+lE+uUG3o9+e9gv10SMpDi9bHR05D+y/YeUUer04ltnMQKw8E
         4neHdoyFzuV0HjbI1s5FM8J1Z7cejJGm3wKkGISV0Kxxm3HuAEXkspyeepiucFAIbEGT
         7ggG071co7Al9DMQ4BLN14w9lkpXhlg4+XqASLQrzxd3gLpr3vsjYzVEOYKXFFk/DnTC
         DwTtMr2busl2YA4lvUpMLY4IrWmRELi+JKrvHH7m0ELHk75u/jhRKT20Kz5UHGUbILM8
         1uQ5s73X58XeEqG1g9yKsi7EVcCkoFFSjtpUvg9U95js1tNPlJpwPps1iJAc1Zb2xJkd
         enGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/0MFjhnUu1tpcGaXSypmk9ZDdGLvZjJouKh8Z2Gnc3s=;
        b=O0gLJs3EbSvF0K2Bkg/j9gjjZvPfIQu8C3ZQ1yNEWe5cHTBYEracITxyvklKT8Hsd6
         ftjH5W5aW9OhhJS5xX+qQ5xEa6QqLIGJRdGhNLuM6nzM2vLDc+0/zpn+FILfdydzt2v+
         VUGct8hbxbzLgifg68O3ahnhrWzFcFvpyTOK8IRybzksUNOxo02SHqloLGzwwwn8uWfz
         aCvcbyxic8320y2CKHN3CgoMEoqSO+eI9epbYsd/HAcqcPU5bISIVfSK0A0iNnFj9FnJ
         xzo1evYg6K+BsZLsZ5wX9Bkj2r7AMUhq+N4sIKxYT1lH46GgGH5c1taLVZRmQ2pYZ8jy
         9gyg==
X-Gm-Message-State: APjAAAXd9w8AHyv1jW3ZP47mO1eTuC95LX47qKpH+IiJHzOGWo7T1+sm
        DbQJUrQxVfKmsaH7J3dJQsx6KA==
X-Google-Smtp-Source: APXvYqz5BamtI3wGwnX0B/dCsfuRYtld7Jrh/p8Qi51+OZn7Cp0b2Fl7Pm0Q6P5z6crYvRyF+Z3DkA==
X-Received: by 2002:a17:90a:1b48:: with SMTP id q66mr2324004pjq.83.1561075448711;
        Thu, 20 Jun 2019 17:04:08 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id a12sm920543pje.3.2019.06.20.17.04.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 17:04:04 -0700 (PDT)
Date:   Thu, 20 Jun 2019 17:04:02 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/7] libbpf: add kprobe/uprobe attach API
Message-ID: <20190621000402.GB1383@mini-arch>
References: <20190620230951.3155955-1-andriin@fb.com>
 <20190620230951.3155955-4-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620230951.3155955-4-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/20, Andrii Nakryiko wrote:
> Add ability to attach to kernel and user probes and retprobes.
> Implementation depends on perf event support for kprobes/uprobes.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c   | 207 +++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |   8 ++
>  tools/lib/bpf/libbpf.map |   2 +
>  3 files changed, 217 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 2bb1fa008be3..11329e05530e 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3969,6 +3969,213 @@ int bpf_program__attach_perf_event(struct bpf_program *prog, int pfd)
>  	return 0;
>  }
>  
> +static int parse_uint(const char *buf)
> +{
> +	int ret;
> +
> +	errno = 0;
> +	ret = (int)strtol(buf, NULL, 10);
> +	if (errno) {
> +		ret = -errno;
> +		pr_debug("failed to parse '%s' as unsigned int\n", buf);
> +		return ret;
> +	}
> +	if (ret < 0) {
> +		pr_debug("failed to parse '%s' as unsigned int\n", buf);
> +		return -EINVAL;
> +	}
> +	return ret;
> +}
> +
> +static int parse_uint_from_file(const char* file)
> +{
> +	char buf[STRERR_BUFSIZE];
> +	int fd, ret;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0) {
> +		ret = -errno;
> +		pr_debug("failed to open '%s': %s\n", file,
> +			 libbpf_strerror_r(ret, buf, sizeof(buf)));
> +		return ret;
> +	}
> +	ret = read(fd, buf, sizeof(buf));
> +	close(fd);
> +	if (ret < 0) {
> +		ret = -errno;
Is -errno still valid here after a close(fd) above? Do we have any
guarantee of errno preservation when we do another syscall?

> +		pr_debug("failed to read '%s': %s\n", file,
> +			libbpf_strerror_r(ret, buf, sizeof(buf)));
> +		return ret;
> +	}
> +	if (ret == 0 || ret >= sizeof(buf)) {
> +		buf[sizeof(buf) - 1] = 0;
> +		pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> +		return -EINVAL;
> +	}
> +	return parse_uint(buf);
> +}
> +
> +static int determine_kprobe_perf_type(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/kprobe/type";
> +	return parse_uint_from_file(file);
> +}
> +
> +static int determine_uprobe_perf_type(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/uprobe/type";
> +	return parse_uint_from_file(file);
> +}
> +
> +static int parse_config_from_file(const char *file)
> +{
> +	char buf[STRERR_BUFSIZE];
> +	int fd, ret;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0) {
> +		ret = -errno;
> +		pr_debug("failed to open '%s': %s\n", file,
> +			 libbpf_strerror_r(ret, buf, sizeof(buf)));
> +		return ret;
> +	}
> +	ret = read(fd, buf, sizeof(buf));
> +	close(fd);
> +	if (ret < 0) {
> +		ret = -errno;
> +		pr_debug("failed to read '%s': %s\n", file,
> +			libbpf_strerror_r(ret, buf, sizeof(buf)));
> +		return ret;
> +	}
> +	if (ret == 0 || ret >= sizeof(buf)) {
> +		buf[sizeof(buf) - 1] = 0;
> +		pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> +		return -EINVAL;
> +	}
> +	if (strncmp(buf, "config:", 7)) {
> +		pr_debug("expected 'config:' prefix, found '%s'\n", buf);
> +		return -EINVAL;
> +	}
> +	return parse_uint(buf + 7);
> +}
> +
> +static int determine_kprobe_retprobe_bit(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/kprobe/format/retprobe";
> +	return parse_config_from_file(file);
> +}
> +
> +static int determine_uprobe_retprobe_bit(void)
> +{
> +	const char *file = "/sys/bus/event_source/devices/uprobe/format/retprobe";
> +	return parse_config_from_file(file);
> +}
> +
> +static int perf_event_open_probe(bool uprobe, bool retprobe, const char* name,
> +				 uint64_t offset, int pid)
> +{
> +	struct perf_event_attr attr = {};
> +	char errmsg[STRERR_BUFSIZE];
> +	int type, pfd, err;
> +
> +	type = uprobe ? determine_uprobe_perf_type()
> +		      : determine_kprobe_perf_type();
> +	if (type < 0) {
> +		pr_warning("failed to determine %s perf type: %s\n",
> +			   uprobe ? "uprobe" : "kprobe",
> +			   libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> +		return type;
> +	}
> +	if (retprobe) {
> +		int bit = uprobe ? determine_uprobe_retprobe_bit()
> +				 : determine_kprobe_retprobe_bit();
> +
> +		if (bit < 0) {
> +			pr_warning("failed to determine %s retprobe bit: %s\n",
> +				   uprobe ? "uprobe" : "kprobe",
> +				   libbpf_strerror_r(bit, errmsg,
> +						     sizeof(errmsg)));
> +			return bit;
> +		}
> +		attr.config |= 1 << bit;
> +	}
> +	attr.size = sizeof(attr);
> +	attr.type = type;
> +	attr.config1 = (uint64_t)(void *)name; /* kprobe_func or uprobe_path */
> +	attr.config2 = offset;		       /* kprobe_addr or probe_offset */
> +
> +	/* pid filter is meaningful only for uprobes */
> +	pfd = syscall(__NR_perf_event_open, &attr,
> +		      pid < 0 ? -1 : pid /* pid */,
> +		      pid == -1 ? 0 : -1 /* cpu */,
> +		      -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> +	if (pfd < 0) {
> +		err = -errno;
> +		pr_warning("%s perf_event_open() failed: %s\n",
> +			   uprobe ? "uprobe" : "kprobe",
> +			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		return err;
> +	}
> +	return pfd;
> +}
> +
> +int bpf_program__attach_kprobe(struct bpf_program *prog, bool retprobe,
> +			       const char *func_name)
> +{
> +	char errmsg[STRERR_BUFSIZE];
> +	int pfd, err;
> +
> +	pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
> +				    0 /* offset */, -1 /* pid */);
> +	if (pfd < 0) {
> +		pr_warning("program '%s': failed to create %s '%s' perf event: %s\n",
> +			   bpf_program__title(prog, false),
> +			   retprobe ? "kretprobe" : "kprobe", func_name,
> +			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> +		return pfd;
> +	}
> +	err = bpf_program__attach_perf_event(prog, pfd);
> +	if (err) {
> +		libbpf_perf_event_disable_and_close(pfd);
> +		pr_warning("program '%s': failed to attach to %s '%s': %s\n",
> +			   bpf_program__title(prog, false),
> +			   retprobe ? "kretprobe" : "kprobe", func_name,
> +			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		return err;
> +	}
> +	return pfd;
> +}
> +
> +int bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
> +			       pid_t pid, const char *binary_path,
> +			       size_t func_offset)
> +{
> +	char errmsg[STRERR_BUFSIZE];
> +	int pfd, err;
> +
> +	pfd = perf_event_open_probe(true /* uprobe */, retprobe,
> +				    binary_path, func_offset, pid);
> +	if (pfd < 0) {
> +		pr_warning("program '%s': failed to create %s '%s:0x%zx' perf event: %s\n",
> +			   bpf_program__title(prog, false),
> +			   retprobe ? "uretprobe" : "uprobe",
> +			   binary_path, func_offset,
> +			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> +		return pfd;
> +	}
> +	err = bpf_program__attach_perf_event(prog, pfd);
> +	if (err) {
> +		libbpf_perf_event_disable_and_close(pfd);
> +		pr_warning("program '%s': failed to attach to %s '%s:0x%zx': %s\n",
> +			   bpf_program__title(prog, false),
> +			   retprobe ? "uretprobe" : "uprobe",
> +			   binary_path, func_offset,
> +			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		return err;
> +	}
> +	return pfd;
> +}
> +
>  enum bpf_perf_event_ret
>  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
>  			   void **copy_mem, size_t *copy_size,
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 76db1bbc0dac..a7264f06aa5f 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -168,6 +168,14 @@ LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
>  LIBBPF_API int libbpf_perf_event_disable_and_close(int pfd);
>  LIBBPF_API int bpf_program__attach_perf_event(struct bpf_program *prog,
>  					      int pfd);
> +LIBBPF_API int bpf_program__attach_kprobe(struct bpf_program *prog,
> +					  bool retprobe,
> +					  const char *func_name);
> +LIBBPF_API int bpf_program__attach_uprobe(struct bpf_program *prog,
> +					  bool retprobe,
> +					  pid_t pid,
> +					  const char *binary_path,
> +					  size_t func_offset);
>  
>  struct bpf_insn;
>  
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index d27406982b5a..1a982c2e1751 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -172,7 +172,9 @@ LIBBPF_0.0.4 {
>  		btf_dump__new;
>  		btf__parse_elf;
>  		bpf_object__load_xattr;
> +		bpf_program__attach_kprobe;
>  		bpf_program__attach_perf_event;
> +		bpf_program__attach_uprobe;
>  		libbpf_num_possible_cpus;
>  		libbpf_perf_event_disable_and_close;
>  } LIBBPF_0.0.3;
> -- 
> 2.17.1
> 
