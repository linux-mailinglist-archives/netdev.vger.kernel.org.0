Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2652C41A33E
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 00:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237939AbhI0WqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 18:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237947AbhI0WqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 18:46:18 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D06C061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 15:44:39 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id y197so24796586iof.11
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 15:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=szbdM7qIyP+L4lDWaP3AyQnHEOn92VMfQQPtSOhzN0I=;
        b=gXHWR4Fa2eWg3c8/mooLGewolz+c8BKwvAS0+OUJxrHSFHna/vDYt9lh8H2sdCeWs2
         jugkYApj5R/mrZa4If00IOXVtdv/nxky1G5NAhnQt+IVlqEGHz6Llqfp7DPSHdlkbgqp
         0IbUnOTmKflpoOAaFD1sm2pJa/4oUXzn9Z158hFN+gEvVdQvol9N+qEvSGs3ucNOoyaD
         /U0xBWDm0AMcygGqsjJbcz9vFjgNHsW6CWrGxl5NPxVl+qrXS8SwmLIpnVpcKfnisPh1
         meKJXA+TVsDD65tlxMGYidC53tgsmhKtqejM3JovvijCJRb6Mt2ReOG/DF9FTi3uI93u
         7wbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=szbdM7qIyP+L4lDWaP3AyQnHEOn92VMfQQPtSOhzN0I=;
        b=PMhVpJ2hGitHm2sz9+SsEnxynisUEVMZddggiEhRcW8OvugD872w3sqTEdkOJoaKG8
         3aPv0Zg3rAe59FbuZS6LzsNM33iM4r7vs9W4SvRPdG+hkC3iVvhmsld72qUTmmcQr2QJ
         Grm64nZdq8t+B1KG9OFka0crSFaJs9XDDQzaR3DaydcviAvNu004DxRdArwo6U+OafPg
         EaOJmdEC1tB3z+2q2vUj9ARlgXLsuh3nuQ62wCI1Jo/vUehoeZZVKXUfXL41p8XUSG+u
         1LfAXo6NeK3PTi93kPChtsauMDedEc5E5xXld7Zsr4wweNJn7Wz9QMno+iIza5mfZqnC
         v29Q==
X-Gm-Message-State: AOAM533bTKearLsGRq5WdTctKxAvVXk9ux6SGNWc6oX+m6fkyO/xaeXD
        Qcfx4XF6z0cOMUrgML52rJxoUAqm1kD20Q==
X-Google-Smtp-Source: ABdhPJyImcnAW25vMaxOQjjCR8ccCsMj5u3bUWIPZAPXXnLPDXcMLeuFfuK7FnXlTbLgb+lFwdYFqQ==
X-Received: by 2002:a02:ccaa:: with SMTP id t10mr1914341jap.16.1632782678559;
        Mon, 27 Sep 2021 15:44:38 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id c9sm6247622iob.23.2021.09.27.15.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 15:44:38 -0700 (PDT)
Subject: Re: [PATCH v2] iplink_rmnet: Allow passing IFLA_RMNET_FLAGS
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Daniele Palmas <dnlplm@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20210924033351.2878153-1-bjorn.andersson@linaro.org>
From:   Alex Elder <elder@linaro.org>
Message-ID: <e0caa25d-5b86-4a3a-e3f6-d5429d3f242b@linaro.org>
Date:   Mon, 27 Sep 2021 17:44:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210924033351.2878153-1-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 10:33 PM, Bjorn Andersson wrote:
> Extend the rmnet option parser to allow enabling and disabling
> IFLA_RMNET_FLAGS using ip link and add the flags to the pint_op to allow
> inspecting the current settings.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

I think what you're doing looks OK to me, but I know
David had suggestions so I expect I'll get another shot
at review...

I have a couple very minor comments, and they're basically
unrelated.  So I guess take it or leave it.

					-Alex

> ---
> 
> Changes since v1:
> - Landed ABI change to allow setting/clearing individual bits
> - Changed parser to take on/off arguments
> - Added the new v5 chksum bits
> - Made print_flags fancier, with some inspiration from iplink_vlan
> 
>   ip/iplink_rmnet.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 97 insertions(+)
> 
> diff --git a/ip/iplink_rmnet.c b/ip/iplink_rmnet.c
> index 1d16440c6900..f629ca9976d9 100644
> --- a/ip/iplink_rmnet.c
> +++ b/ip/iplink_rmnet.c
> @@ -16,6 +16,12 @@ static void print_explain(FILE *f)
>   {
>   	fprintf(f,
>   		"Usage: ... rmnet mux_id MUXID\n"
> +		"                 [ingress-deaggregation { on | off } ]\n"
> +		"                 [ingress-commands { on | off } ]\n"
> +		"                 [ingress-chksumv4 { on | off } ]\n"
> +		"                 [ingress-chksumv5 { on | off } ]\n"
> +		"                 [egress-chksumv4 { on | off } ]\n"
> +		"                 [egress-chksumv5 { on | off } ]\n"

Looking at other usage messages, it appears that the dash
rather than underscore is preferable (though not universal).
I.e., I think you did this right.

>   		"\n"
>   		"MUXID := 1-254\n"
>   	);
> @@ -26,9 +32,16 @@ static void explain(void)
>   	print_explain(stderr);
>   }
>   
> +static int on_off(const char *msg, const char *arg)
> +{
> +	fprintf(stderr, "Error: argument of \"%s\" must be \"on\" or \"off\", not \"%s\"\n", msg, arg);

It would be nice if this function could be defined centrally rather
than repeated.  Maybe defined in "lib/utils.c", declared in
"include/utils.h"?  Not your problem but if you were so moved,
that could be done in a separate patch.

> +	return -1;
> +}
> +
>   static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
>   			   struct nlmsghdr *n)
>   {
> +	struct ifla_rmnet_flags flags = { };
>   	__u16 mux_id;
>   
>   	while (argc > 0) {
> @@ -37,6 +50,60 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
>   			if (get_u16(&mux_id, *argv, 0))
>   				invarg("mux_id is invalid", *argv);
>   			addattr16(n, 1024, IFLA_RMNET_MUX_ID, mux_id);
> +		} else if (matches(*argv, "ingress-deaggregation") == 0) {
> +			NEXT_ARG();

With these repeated blocks of code my instinct is to suggest
creating a common called function, but it gets a little ugly.
What I sketch below precludes using NEXT_ARG() where it's
needed.

static int matches_on_off(ifla_rmnet_flags *flags, u32 mask,
			  const char *name, char *arg)
{
	if (matches(arg, name))
		return 0;

	if (strcmp(arg, "on") == 0)
		flags->flag |= mask;
	else if (strcmp(arg, "off") == 0) {
		flags->flag &= ~mask;
	else
		return on_off(name, arg);

	flags->mask |= mask;

	return 1;
}

Then use:

	if (matches_on_off(&flags, RMNET_FLAGS_INGRESS_DEAGGREGATION,
			   "ingress-deaggregation", *argv) < 0)
		return -1;
	else if (matches_on_off(...))
		. . .

So I'm not sure I like how this looks, and once again,
it isn't really necessary for what you're doing here...

> +			flags.mask |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_INGRESS_DEAGGREGATION;
> +			else
> +				return on_off("ingress-deaggregation", *argv);
> +		} else if (matches(*argv, "ingress-commands") == 0) {
> +			NEXT_ARG();
> +			flags.mask |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_INGRESS_MAP_COMMANDS;
> +			else
> +				return on_off("ingress-commands", *argv);
> +		} else if (matches(*argv, "ingress-chksumv4") == 0) {
> +			NEXT_ARG();
> +			flags.mask |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
> +			else
> +				return on_off("ingress-chksumv4", *argv);
> +		} else if (matches(*argv, "ingress-chksumv5") == 0) {
> +			NEXT_ARG();
> +			flags.mask |= RMNET_FLAGS_INGRESS_MAP_CKSUMV5;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV5;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_INGRESS_MAP_CKSUMV5;
> +			else
> +				return on_off("ingress-chksumv5", *argv);
> +		} else if (matches(*argv, "egress-chksumv4") == 0) {
> +			NEXT_ARG();
> +			flags.mask |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
> +			else
> +				return on_off("egress-chksumv4", *argv);
> +		} else if (matches(*argv, "egress-chksumv5") == 0) {
> +			NEXT_ARG();
> +			flags.mask |= RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
> +			if (strcmp(*argv, "on") == 0)
> +				flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
> +			else if (strcmp(*argv, "off") == 0)
> +				flags.flags &= ~RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
> +			else
> +				return on_off("egress-chksumv5", *argv);
>   		} else if (matches(*argv, "help") == 0) {
>   			explain();
>   			return -1;
> @@ -48,11 +115,33 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
>   		argc--, argv++;
>   	}
>   
> +	if (flags.mask)
> +		addattr_l(n, 1024, IFLA_RMNET_FLAGS, &flags, sizeof(flags));
> +
>   	return 0;
>   }
>   
> +static void rmnet_print_flags(FILE *fp, __u32 flags)
> +{
> +	open_json_array(PRINT_ANY, is_json_context() ? "flags" : "<");
> +#define _PF(f, s) if (flags & RMNET_FLAGS_##f) {			\
> +		flags &= ~RMNET_FLAGS_##f;				\
> +		print_string(PRINT_ANY, NULL, flags ? "%s," : "%s", s); \
> +	}
> +	_PF(INGRESS_DEAGGREGATION, "ingress-deaggregation");
> +	_PF(INGRESS_MAP_COMMANDS, "ingress-commands");
> +	_PF(INGRESS_MAP_CKSUMV4, "ingress-chksumv4");
> +	_PF(INGRESS_MAP_CKSUMV5, "ingress-chksumv5");
> +	_PF(EGRESS_MAP_CKSUMV4, "egress-chksumv4");
> +	_PF(EGRESS_MAP_CKSUMV5, "egress-chksumv5");
> +#undef _PF
> +	close_json_array(PRINT_ANY, "> ");
> +}
> +
>   static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>   {
> +	struct ifla_vlan_flags *flags;
> +
>   	if (!tb)
>   		return;
>   
> @@ -64,6 +153,14 @@ static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>   		   "mux_id",
>   		   "mux_id %u ",
>   		   rta_getattr_u16(tb[IFLA_RMNET_MUX_ID]));
> +
> +	if (tb[IFLA_RMNET_FLAGS]) {
> +		if (RTA_PAYLOAD(tb[IFLA_RMNET_FLAGS]) < sizeof(*flags))
> +			return;
> +		flags = RTA_DATA(tb[IFLA_RMNET_FLAGS]);
> +
> +		rmnet_print_flags(f, flags->flags);
> +	}
>   }
>   
>   static void rmnet_print_help(struct link_util *lu, int argc, char **argv,
> 

