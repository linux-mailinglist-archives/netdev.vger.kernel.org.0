Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41667E671
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 01:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388477AbfHAXg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 19:36:56 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40580 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388202AbfHAXg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 19:36:56 -0400
Received: by mail-qk1-f196.google.com with SMTP id s145so53457218qke.7
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 16:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EbMWKEZssRd2TOARZ546wCAxGOEmLc2VGjMVp1/NmCU=;
        b=HiOkjNBkzRA+QbE87vKtOFoLkBtE4yXy1syWinAVM0jM04JEeqpu3PNeLVLvqwJL+c
         y6IuGp76qEMlW87N0tg6ppotV7y3HPhOewrV/HDh7CPDBTwLUBqRA0JSY/mycGTLqbfB
         9SHfYlOpWbvTOuFj5lfI9Fx/nYST9BeMpG7IMyvxYge7kfLqSFk57sEKxXJzQV3LaWqY
         11aWCQDQZVlesjoBPVTzAmTXWe7EKClpUdTTYojLHrRBp+k4AJ8mNj81omSzwlUKsheF
         rahKV2ZHnuFVCAhIco6FmSk/KQvv+CW7F/4Pqn2C3uEE6SbwN0RBanie5/xSSUkYKStO
         KR8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EbMWKEZssRd2TOARZ546wCAxGOEmLc2VGjMVp1/NmCU=;
        b=qVCny+WF4eK+QXAI5pixZDG3U1f4IbV6pxFZTEAV+HApoYuLR0tYPi9Hh09rUnD6iw
         p0XUUt1OwAyMpwf61KUFccozr9ulJEpFkbpkCoTe4Nps5kcavWHY+70lzjtcJSSaEZR8
         +w/LoQ7erQUVFxi8w/icErrs7eq2weL4J8sKM7mNfZ3q9myfp9lzzD7z8W+skYOG3EUA
         xcCiamaQ8yd0VoddhiohoVz1MZDH1+q9VQZmmbbLAhkKSziVEachoFZ5da5hlWyKHTWc
         O7U9y3MfnsvynyEPrtYtto97/Fc/FilGsmQcZzRTeXED6EybhB+i95CLFy6T6pwKficu
         c1Vw==
X-Gm-Message-State: APjAAAXE34SFAaWWuLhScSb2F76rpH476kY+tzTZp0ES5YxLz0RzLAj5
        qs4ylQcNAq7kRHaUyID/EzHa/A==
X-Google-Smtp-Source: APXvYqxyt6TiNzfH6pSyLhCLBJufH4Ka0vjiF2VlvWycgVP5VCGoaev6K/Jf/aNNL12ZCBK62HSgfA==
X-Received: by 2002:ae9:f809:: with SMTP id x9mr89119298qkh.86.1564702615102;
        Thu, 01 Aug 2019 16:36:55 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w62sm29081689qkd.30.2019.08.01.16.36.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 16:36:55 -0700 (PDT)
Date:   Thu, 1 Aug 2019 16:36:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [v2,1/2] tools: bpftool: add net attach command to attach XDP
 on interface
Message-ID: <20190801163638.71700f6d@cakuba.netronome.com>
In-Reply-To: <20190801081133.13200-2-danieltimlee@gmail.com>
References: <20190801081133.13200-1-danieltimlee@gmail.com>
        <20190801081133.13200-2-danieltimlee@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Aug 2019 17:11:32 +0900, Daniel T. Lee wrote:
> By this commit, using `bpftool net attach`, user can attach XDP prog on
> interface. New type of enum 'net_attach_type' has been made, as stated at
> cover-letter, the meaning of 'attach' is, prog will be attached on interface.
> 
> BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
> Changes in v2:
>   - command 'load' changed to 'attach' for the consistency
>   - 'NET_ATTACH_TYPE_XDP_DRIVE' changed to 'NET_ATTACH_TYPE_XDP_DRIVER'
> 
>  tools/bpf/bpftool/net.c | 107 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 106 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index 67e99c56bc88..f3b57660b303 100644
> --- a/tools/bpf/bpftool/net.c
> +++ b/tools/bpf/bpftool/net.c
> @@ -55,6 +55,35 @@ struct bpf_attach_info {
>  	__u32 flow_dissector_id;
>  };
>  
> +enum net_attach_type {
> +	NET_ATTACH_TYPE_XDP,
> +	NET_ATTACH_TYPE_XDP_GENERIC,
> +	NET_ATTACH_TYPE_XDP_DRIVER,
> +	NET_ATTACH_TYPE_XDP_OFFLOAD,
> +	__MAX_NET_ATTACH_TYPE
> +};
> +
> +static const char * const attach_type_strings[] = {
> +	[NET_ATTACH_TYPE_XDP] = "xdp",
> +	[NET_ATTACH_TYPE_XDP_GENERIC] = "xdpgeneric",
> +	[NET_ATTACH_TYPE_XDP_DRIVER] = "xdpdrv",
> +	[NET_ATTACH_TYPE_XDP_OFFLOAD] = "xdpoffload",
> +	[__MAX_NET_ATTACH_TYPE] = NULL,

Not sure if the terminator is necessary,
ARRAY_SIZE(attach_type_strings) should suffice?

> +};
> +
> +static enum net_attach_type parse_attach_type(const char *str)
> +{
> +	enum net_attach_type type;
> +
> +	for (type = 0; type < __MAX_NET_ATTACH_TYPE; type++) {
> +		if (attach_type_strings[type] &&
> +		   is_prefix(str, attach_type_strings[type]))
> +			return type;
> +	}
> +
> +	return __MAX_NET_ATTACH_TYPE;
> +}
> +
>  static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
>  {
>  	struct bpf_netdev_t *netinfo = cookie;
> @@ -223,6 +252,77 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
>  	return 0;
>  }
>  
> +static int parse_attach_args(int argc, char **argv, int *progfd,
> +			     enum net_attach_type *attach_type, int *ifindex)
> +{
> +	if (!REQ_ARGS(3))
> +		return -EINVAL;
> +
> +	*progfd = prog_parse_fd(&argc, &argv);
> +	if (*progfd < 0)
> +		return *progfd;
> +
> +	*attach_type = parse_attach_type(*argv);
> +	if (*attach_type == __MAX_NET_ATTACH_TYPE) {
> +		p_err("invalid net attach/detach type");
> +		return -EINVAL;

You should close the progfd on error paths.

> +	}

Hm. I'm not too sure about the ordering of arguments, type should
probably be right after attach.

If we ever add tc attach support or some other hook, that's more
fundamental part of the command than the program. So I think:

bpftool net attach xdp id xyz dev ethN

> +	NEXT_ARG();
> +	if (!REQ_ARGS(1))
> +		return -EINVAL;

Error message needed here.

> +	*ifindex = if_nametoindex(*argv);
> +	if (!*ifindex) {
> +		p_err("Invalid ifname");

"ifname" is not mentioned in help, it'd be best to keep this error
message consistent with bpftool prog load.

> +		return -EINVAL;
> +	}

Please require the dev keyword before the interface name.
That'll make it feel closer to prog load syntax.

> +	return 0;
> +}
> +
> +static int do_attach_detach_xdp(int *progfd, enum net_attach_type *attach_type,
> +				int *ifindex)
> +{
> +	__u32 flags;
> +	int err;
> +
> +	flags = XDP_FLAGS_UPDATE_IF_NOEXIST;

Please add this as an option so that user can decide whether overwrite
is allowed or not.

> +	if (*attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
> +		flags |= XDP_FLAGS_SKB_MODE;
> +	if (*attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
> +		flags |= XDP_FLAGS_DRV_MODE;
> +	if (*attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
> +		flags |= XDP_FLAGS_HW_MODE;
> +
> +	err = bpf_set_link_xdp_fd(*ifindex, *progfd, flags);
> +
> +	return err;

no need for the err variable here.

> +}
> +
> +static int do_attach(int argc, char **argv)
> +{
> +	enum net_attach_type attach_type;
> +	int err, progfd, ifindex;
> +
> +	err = parse_attach_args(argc, argv, &progfd, &attach_type, &ifindex);
> +	if (err)
> +		return err;

Probably not the best idea to move this out into a helper.

> +	if (is_prefix("xdp", attach_type_strings[attach_type]))
> +		err = do_attach_detach_xdp(&progfd, &attach_type, &ifindex);

Hm. We either need an error to be reported if it's not xdp or since we
only accept XDP now perhaps the if() is superfluous?

> +	if (err < 0) {
> +		p_err("link set %s failed", attach_type_strings[attach_type]);

"link set"?  So you are familiar with iproute2 syntax! :)

> +		return -1;
> +	}
> +
> +	if (json_output)
> +		jsonw_null(json_wtr);
> +
> +	return 0;
> +}
> +
>  static int do_show(int argc, char **argv)
>  {
>  	struct bpf_attach_info attach_info = {};
> @@ -305,13 +405,17 @@ static int do_help(int argc, char **argv)
>  
>  	fprintf(stderr,
>  		"Usage: %s %s { show | list } [dev <devname>]\n"
> +		"       %s %s attach PROG LOAD_TYPE <devname>\n"
>  		"       %s %s help\n"
> +		"\n"
> +		"       " HELP_SPEC_PROGRAM "\n"
> +		"       LOAD_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"

ATTACH_TYPE now?

Perhaps a new line before the "Note"?

>  		"Note: Only xdp and tc attachments are supported now.\n"
>  		"      For progs attached to cgroups, use \"bpftool cgroup\"\n"
>  		"      to dump program attachments. For program types\n"
>  		"      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
>  		"      consult iproute2.\n",
> -		bin_name, argv[-2], bin_name, argv[-2]);
> +		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
>  
>  	return 0;
>  }
> @@ -319,6 +423,7 @@ static int do_help(int argc, char **argv)
>  static const struct cmd cmds[] = {
>  	{ "show",	do_show },
>  	{ "list",	do_show },
> +	{ "attach",	do_attach },
>  	{ "help",	do_help },
>  	{ 0 }
>  };

