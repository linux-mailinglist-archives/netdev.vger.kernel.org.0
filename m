Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE66A0E3E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfH1Xes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:34:48 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37862 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbfH1Xes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:34:48 -0400
Received: by mail-ed1-f66.google.com with SMTP id f22so1899507edt.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 16:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=eIeNg8O1Kr2JbFnOvJkYF804LUP44tbHFocoveh1tdI=;
        b=tRXRjXpyp2r+Mxn7yBLQVOLFlnEbZmYxYSEi4nKZyWISqStlY7Y3ElEB0LGqrVDQ+A
         rjJBvZFJUR8gJiFi2HFZyGtsJLIkRFVRpwpPu8Hz/KH/hfTA+34KUtQpOnEBeH2Ae+Yb
         RFopfRjng/kUdOmRT/cUIamxnOxgRubKKnbwiJ/XzubL804LYdULub/gHifUW8tnMsE3
         +gMyhtWe/BOV8j+kBavkCtlyH54NH0cVJessMBelTqc6xgfJdfNJ8r7Iq1DbSFQ1AcqI
         AlOSOfwsMs0O6iRPqO77qHxEu1yPX0mEPh/aCaONoclkh5WrMjrffBuBNbMXlbJHYA9E
         ALOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=eIeNg8O1Kr2JbFnOvJkYF804LUP44tbHFocoveh1tdI=;
        b=JLRCrmxc0VXkfu4xhFXdxQQAljMyAo8Ej0FSfjYnLReGIqvsUepsxNlK3bnq7I6aVB
         SeZS+dNzENcnjD4K0e9AZLZsKTjlWTpwDFR0OvhFeHBb30y268HI2fYWJMpVqodH/IeL
         8rL2T1NTzPLo3G1gneEz6svr+IvfY07uIqOGhMbtBVe9wQrz5kxaUucW2FFxfXIFlpbv
         FCVtMotytyqYENlQJx4qar25pwoxTvhOOnH9JmI2joBDWGw6yahKBtQkGHqXqHIWCPsq
         biyDQ+507nfnNKtgGLR5CSwrasVuhG1RQGfLsd/EvnTjN6fC7p9qvjVdPWkpS44Bfqbo
         eunQ==
X-Gm-Message-State: APjAAAWW8wGnQzOYIdjs2rZhBU9yspMvan2C1ZUDuSu9hg8rgxLoSIGB
        Nz+j+7zQH9U9wXhO0bdMNeUmVw==
X-Google-Smtp-Source: APXvYqyBq8z57Box602KqPuUpmv/XnECTiTF60pV2XL8VHhi7RcDA0rxei2q+K96GJdHR8ggF/jUZA==
X-Received: by 2002:a17:906:c744:: with SMTP id fk4mr5644892ejb.189.1567035285948;
        Wed, 28 Aug 2019 16:34:45 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j12sm107695edt.66.2019.08.28.16.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 16:34:45 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:34:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Julia Kartseva <hex@fb.com>, <ast@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     <rdna@fb.com>, <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 04/10] tools/bpf: add
 libbpf_prog_type_(from|to)_str helpers
Message-ID: <20190828163422.3d167c4b@cakuba.netronome.com>
In-Reply-To: <467620c966825173dbd65b37a3f9bd7dd4fb8184.1567024943.git.hex@fb.com>
References: <cover.1567024943.git.hex@fb.com>
        <467620c966825173dbd65b37a3f9bd7dd4fb8184.1567024943.git.hex@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 14:03:07 -0700, Julia Kartseva wrote:
> Standardize string representation of prog types by putting commonly used
> names to libbpf.
> The prog_type to string mapping is taken from bpftool:
> tools/bpf/bpftool/main.h
> 
> Signed-off-by: Julia Kartseva <hex@fb.com>

This "libbpf patches have to be completely separate" just went to
another level :/ Now we are splitting code moves into add and remove
parts which are 5 patches apart? How are we supposed to review this?


Greg, Thomas, libbpf is extracted from the kernel sources and
maintained in a clone repo on GitHub for ease of packaging.

IIUC Alexei's concern is that since we are moving the commits from
the kernel repo to the GitHub one we have to preserve the commits
exactly as they are, otherwise SOB lines lose their power.

Can you provide some guidance on whether that's a valid concern, 
or whether it's perfectly fine to apply a partial patch?

(HW vendors also back port tree-wide cleanups into their drivers,
 so if SOB lines are voided by git format-patch -- driver/path/
 that'd be quite an issue..)

> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 72e6e5eb397f..946a4d41f223 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -296,6 +296,35 @@ struct bpf_object {
>  };
>  #define obj_elf_valid(o)	((o)->efile.elf)
>  
> +static const char *const prog_type_strs[] = {
> +	[BPF_PROG_TYPE_UNSPEC] = "unspec",
> +	[BPF_PROG_TYPE_SOCKET_FILTER] = "socket_filter",
> +	[BPF_PROG_TYPE_KPROBE] = "kprobe",
> +	[BPF_PROG_TYPE_SCHED_CLS] = "sched_cls",
> +	[BPF_PROG_TYPE_SCHED_ACT] = "sched_act",
> +	[BPF_PROG_TYPE_TRACEPOINT] = "tracepoint",
> +	[BPF_PROG_TYPE_XDP] = "xdp",
> +	[BPF_PROG_TYPE_PERF_EVENT] = "perf_event",
> +	[BPF_PROG_TYPE_CGROUP_SKB] = "cgroup_skb",
> +	[BPF_PROG_TYPE_CGROUP_SOCK] = "cgroup_sock",
> +	[BPF_PROG_TYPE_LWT_IN] = "lwt_in",
> +	[BPF_PROG_TYPE_LWT_OUT] = "lwt_out",
> +	[BPF_PROG_TYPE_LWT_XMIT] = "lwt_xmit",
> +	[BPF_PROG_TYPE_SOCK_OPS] = "sock_ops",
> +	[BPF_PROG_TYPE_SK_SKB] = "sk_skb",
> +	[BPF_PROG_TYPE_CGROUP_DEVICE] = "cgroup_device",
> +	[BPF_PROG_TYPE_SK_MSG] = "sk_msg",
> +	[BPF_PROG_TYPE_RAW_TRACEPOINT] = "raw_tracepoint",
> +	[BPF_PROG_TYPE_CGROUP_SOCK_ADDR] = "cgroup_sock_addr",
> +	[BPF_PROG_TYPE_LWT_SEG6LOCAL] = "lwt_seg6local",
> +	[BPF_PROG_TYPE_LIRC_MODE2] = "lirc_mode2",
> +	[BPF_PROG_TYPE_SK_REUSEPORT] = "sk_reuseport",
> +	[BPF_PROG_TYPE_FLOW_DISSECTOR] = "flow_dissector",
> +	[BPF_PROG_TYPE_CGROUP_SYSCTL] = "cgroup_sysctl",
> +	[BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE] = "raw_tracepoint_writable",
> +	[BPF_PROG_TYPE_CGROUP_SOCKOPT] = "cgroup_sockopt",
> +};
> +
>  void bpf_program__unload(struct bpf_program *prog)
>  {
>  	int i;
> @@ -4632,6 +4661,28 @@ int libbpf_attach_type_by_name(const char *name,
>  	return -EINVAL;
>  }
>  
> +int libbpf_prog_type_from_str(const char *str, enum bpf_prog_type *type)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(prog_type_strs); i++)
> +		if (prog_type_strs[i] && strcmp(prog_type_strs[i], str) == 0) {
> +			*type = i;
> +			return 0;
> +		}
> +
> +	return -EINVAL;
> +}
> +
> +int libbpf_prog_type_to_str(enum bpf_prog_type type, const char **str)
> +{
> +	if (type < BPF_PROG_TYPE_UNSPEC || type >= ARRAY_SIZE(prog_type_strs))
> +		return -EINVAL;
> +
> +	*str = prog_type_strs[type];
> +	return 0;
> +}
> +
>  static int
>  bpf_program__identify_section(struct bpf_program *prog,
>  			      enum bpf_prog_type *prog_type,
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index e8f70977d137..6846c488d8a2 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -122,12 +122,20 @@ LIBBPF_API int bpf_object__set_priv(struct bpf_object *obj, void *priv,
>  				    bpf_object_clear_priv_t clear_priv);
>  LIBBPF_API void *bpf_object__priv(const struct bpf_object *prog);
>  
> +/* Program and expected attach types by section name */
>  LIBBPF_API int
>  libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
>  			 enum bpf_attach_type *expected_attach_type);
> +/* Attach type by section name */
>  LIBBPF_API int libbpf_attach_type_by_name(const char *name,
>  					  enum bpf_attach_type *attach_type);
>  
> +/* String representation of program type */
> +LIBBPF_API int libbpf_prog_type_from_str(const char *str,
> +					 enum bpf_prog_type *type);
> +LIBBPF_API int libbpf_prog_type_to_str(enum bpf_prog_type type,
> +				       const char **str);
> +
>  /* Accessors of bpf_program */
>  struct bpf_program;
>  LIBBPF_API struct bpf_program *bpf_program__next(struct bpf_program *prog,
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 664ce8e7a60e..2ea7c99f1579 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -188,4 +188,6 @@ LIBBPF_0.0.4 {
>  LIBBPF_0.0.5 {
>  	global:
>  		bpf_btf_get_next_id;
> +		libbpf_prog_type_from_str;
> +		libbpf_prog_type_to_str;
>  } LIBBPF_0.0.4;

