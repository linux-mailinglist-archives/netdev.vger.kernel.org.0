Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2446385491
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 22:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389330AbfHGUmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 16:42:38 -0400
Received: from mail-qt1-f175.google.com ([209.85.160.175]:34197 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388637AbfHGUmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 16:42:38 -0400
Received: by mail-qt1-f175.google.com with SMTP id k10so20665342qtq.1
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 13:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=A7bkP8kqLoW5V3VR56Rgq4aGk7AIMwdIym2ULmduyIo=;
        b=JyayH6kOb5Zp4tUOX92PiHX7+HSAErFaj+qiB7d0f+cVUtXg7bqrX1cFz6LSsE/mcw
         mZY7UjarH5RfSZ6YEnhlugtG0KMrpOdrEIXOPsHLEgolp0oiL+S48Uyi1lD3IZpWcBRV
         hlAwRMmMGMkfk+7nsaRHsSe8vOEeovacsA0urLCiR01XEeLWgGjl6PKT7UXCv+8/7ZCh
         5kJbqof3imo7nwuQJLoDCmuuwoaY4BQjZIEeDdZlyPYlBrK6ntAVDeWila61GSbEJibk
         qfHCOcyBjLG3uBOj6RwK3UmGO8g3ISTplmn2wA3lCxbymqCQN/2txvTQzn+1XT5rCR9Z
         Wkvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=A7bkP8kqLoW5V3VR56Rgq4aGk7AIMwdIym2ULmduyIo=;
        b=EYRBG5TwdUPQaFU1pjeeEM9XG1+hKnVfgdNQBvPuIzF+T2FwUDamWWtkOH/imlBu5Y
         amEVBK71R496XmFbvpLsqKR5UD5TbkjgV347qbBuERB3dmlnIvgLAuasc3+red0Y8FC+
         0grdAtUnS6Im2GekDDBvOndzRi9kA+ZCsL3EZxeQklVBXb8BaxmvPw4onLYCIKy89dW8
         0seXzvvv7z2X1Kv8+b5D6BVI/x80irnNBTQUcaFC80u1nKKrRBHIWRLlP7Ou/vrrulpB
         aikgCVODNuMt0Noh6tqr5i2KlSSU95IBcPUqUr67Y0ZhQElSb1E+x+q7dEaElGYsuyWz
         FyfQ==
X-Gm-Message-State: APjAAAW7z+GLn5veq/gbEYOSPe6sMFWynYK6HrVNBV2IzGDW0SzwnAXE
        A82KyyaRkXPWJAZ0wHoNrpFlcQ==
X-Google-Smtp-Source: APXvYqwsTDQh9h/wJ67+60sgnX1kMqwqMn1WLia1ffDKUkkWEbVJpTJGVLgegxjNsGDMjqXHxG5Baw==
X-Received: by 2002:ac8:41d7:: with SMTP id o23mr973806qtm.268.1565210556715;
        Wed, 07 Aug 2019 13:42:36 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j2sm41889204qtb.89.2019.08.07.13.42.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 13:42:36 -0700 (PDT)
Date:   Wed, 7 Aug 2019 13:42:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [v3,1/4] tools: bpftool: add net attach command to attach XDP
 on interface
Message-ID: <20190807134208.6601fad2@cakuba.netronome.com>
In-Reply-To: <20190807022509.4214-2-danieltimlee@gmail.com>
References: <20190807022509.4214-1-danieltimlee@gmail.com>
        <20190807022509.4214-2-danieltimlee@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Aug 2019 11:25:06 +0900, Daniel T. Lee wrote:
> By this commit, using `bpftool net attach`, user can attach XDP prog on
> interface. New type of enum 'net_attach_type' has been made, as stated at
> cover-letter, the meaning of 'attach' is, prog will be attached on interface.
> 
> With 'overwrite' option at argument, attached XDP program could be replaced.
> Added new helper 'net_parse_dev' to parse the network device at argument.
> 
> BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  tools/bpf/bpftool/net.c | 141 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 130 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index 67e99c56bc88..c05a3fac5cac 100644
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
> +};
> +
> +static const char * const attach_type_strings[] = {
> +	[NET_ATTACH_TYPE_XDP]		= "xdp",
> +	[NET_ATTACH_TYPE_XDP_GENERIC]	= "xdpgeneric",
> +	[NET_ATTACH_TYPE_XDP_DRIVER]	= "xdpdrv",
> +	[NET_ATTACH_TYPE_XDP_OFFLOAD]	= "xdpoffload",
> +};
> +
> +const size_t max_net_attach_type = ARRAY_SIZE(attach_type_strings);

Nit: in practice max_.._type is num_types - 1, so perhaps rename this
to num_.. or such?

> +static enum net_attach_type parse_attach_type(const char *str)
> +{
> +	enum net_attach_type type;
> +
> +	for (type = 0; type < max_net_attach_type; type++) {
> +		if (attach_type_strings[type] &&
> +		   is_prefix(str, attach_type_strings[type]))

                   ^
this is misaligned by one space

Please try checkpatch with the --strict option to catch these.

> +			return type;
> +	}
> +
> +	return max_net_attach_type;
> +}
> +
>  static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
>  {
>  	struct bpf_netdev_t *netinfo = cookie;
> @@ -223,6 +252,97 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
>  	return 0;
>  }
>  
> +static int net_parse_dev(int *argc, char ***argv)
> +{
> +	int ifindex;
> +
> +	if (is_prefix(**argv, "dev")) {
> +		NEXT_ARGP();
> +
> +		ifindex = if_nametoindex(**argv);
> +		if (!ifindex)
> +			p_err("invalid devname %s", **argv);
> +
> +		NEXT_ARGP();
> +	} else {
> +		p_err("expected 'dev', got: '%s'?", **argv);
> +		return -1;
> +	}
> +
> +	return ifindex;
> +}
> +
> +static int do_attach_detach_xdp(int progfd, enum net_attach_type attach_type,
> +				int ifindex, bool overwrite)
> +{
> +	__u32 flags = 0;
> +
> +	if (!overwrite)
> +		flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> +	if (attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
> +		flags |= XDP_FLAGS_SKB_MODE;
> +	if (attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
> +		flags |= XDP_FLAGS_DRV_MODE;
> +	if (attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
> +		flags |= XDP_FLAGS_HW_MODE;
> +
> +	return bpf_set_link_xdp_fd(ifindex, progfd, flags);
> +}
> +
> +static int do_attach(int argc, char **argv)
> +{
> +	enum net_attach_type attach_type;
> +	int progfd, ifindex, err = 0;
> +	bool overwrite = false;
> +
> +	/* parse attach args */
> +	if (!REQ_ARGS(5))
> +		return -EINVAL;
> +
> +	attach_type = parse_attach_type(*argv);
> +	if (attach_type == max_net_attach_type) {
> +		p_err("invalid net attach/detach type");

worth adding the type to the error message so that user know which part
of command line was wrong:

	p_err("invalid net attach/detach type '%s'", *argv);

> +		return -EINVAL;
> +	}
> +
> +	NEXT_ARG();

nit: the new line should be before NEXT_ARG(), IOV NEXT_ARG() belongs
to the code which consumed the argument

> +	progfd = prog_parse_fd(&argc, &argv);
> +	if (progfd < 0)
> +		return -EINVAL;
> +
> +	ifindex = net_parse_dev(&argc, &argv);
> +	if (ifindex < 1) {
> +		close(progfd);
> +		return -EINVAL;
> +	}
> +
> +	if (argc) {
> +		if (is_prefix(*argv, "overwrite")) {
> +			overwrite = true;
> +		} else {
> +			p_err("expected 'overwrite', got: '%s'?", *argv);
> +			close(progfd);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	/* attach xdp prog */
> +	if (is_prefix("xdp", attach_type_strings[attach_type]))

I'm still unclear on why this if is needed

> +		err = do_attach_detach_xdp(progfd, attach_type, ifindex,
> +					   overwrite);
> +
> +	if (err < 0) {
> +		p_err("interface %s attach failed",
> +		      attach_type_strings[attach_type]);

Please add the error string, like:

		p_err("interface %s attach failed: %s",
		      attach_type_strings[attach_type], strerror(errno));


> +		return err;
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
> @@ -231,17 +351,10 @@ static int do_show(int argc, char **argv)
>  	unsigned int nl_pid;
>  	char err_buf[256];
>  
> -	if (argc == 2) {
> -		if (strcmp(argv[0], "dev") != 0)
> -			usage();
> -		filter_idx = if_nametoindex(argv[1]);
> -		if (filter_idx == 0) {
> -			fprintf(stderr, "invalid dev name %s\n", argv[1]);
> -			return -1;
> -		}
> -	} else if (argc != 0) {
> +	if (argc == 2)
> +		filter_idx = net_parse_dev(&argc, &argv);

You should check filter_idx is not negative here, no?

> +	else if (argc != 0)
>  		usage();
> -	}
>  
>  	ret = query_flow_dissector(&attach_info);
>  	if (ret)
