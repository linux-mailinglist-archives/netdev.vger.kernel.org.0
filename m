Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DCA33C178
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhCOQQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhCOQQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:16:19 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFB9C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 09:16:19 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id o11so34039130iob.1
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 09:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DqbsWYj9BCQV94CGF2OMbZQUFg8JicNsbpnUffAQE4M=;
        b=Vf/BtO/aLZCU5psL3iS+R7qqmtH7+aE91Rc+95vI9QiNdRqR+LzXhJiu8WM52HoPZF
         8VnRTQLHbEqS4dQgRTf8p37ChfM//u3Tf11/ktrC3Jdm2xX0POwXMnBX6SNZndksVwC1
         QWGVLjOcP7oXdOyE0yhA1NWN9STKLEyfs5noX9Lf0V0bWM7VHRA2QwpslFF3jSqEoyrC
         uqteYueclabebP6DWxP7iF8SFKw4xc2ejh5qRcDmjOEUW7p785rE+OKFKRvgk9knqzkh
         pzauAfUPYdaYv0WP9wxIPBJMA4xNFgThE2qcrQ92mTF/As7VB0cm/a3zXh7uDyqmpjPO
         xN1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DqbsWYj9BCQV94CGF2OMbZQUFg8JicNsbpnUffAQE4M=;
        b=qrDG0VKpt0AQll0lsUKncQATgEbsYBJj0aejQAEFqQJzevP/1uiUWDqw2IApT3QvtZ
         Hn4TulTaNftkIuUaYSsmZRQrRBa9d94qtGJNY+ibs/L+Vi9rOhXP+VXXlXqCd6TAxX9Q
         nFwQL6iJqQJs3x08tzaJ2J5RhEU8jbJjafo7cJwIOXNt4DWTzNrBjdzea75Q5rs6Y8hN
         jfC5iYYFhflN5EjLfDSVvgXgoAM1WqtD5L+8Mh9+TRfMcRuw05dVeSDP+v9QoR/sOhBA
         pkIjey/Dv6RcbzhKhfeCKStMwkJbwD21JoJVOJjUd2JB2TSu4wcivV7IAlsa459OaU3P
         3x+g==
X-Gm-Message-State: AOAM533gbcUpSYIurKsHu/nFUqFTYtf0DOX/RNrq+t2kXAyT66W0wab9
        VFzU96hrfv6F/e1yWjfirqCD4w==
X-Google-Smtp-Source: ABdhPJwKV64AfuwAkLfrMUQrSI9vsu0Tuu6+bq3UrV+mTvWIh+Pzve04rGFO6B3rfRj/4gX9yn+qCA==
X-Received: by 2002:a05:6638:3a8:: with SMTP id z8mr10145470jap.111.1615824978633;
        Mon, 15 Mar 2021 09:16:18 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k4sm4893023iol.18.2021.03.15.09.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 09:16:18 -0700 (PDT)
Subject: Re: [PATCH v2] iplink_rmnet: Allow passing IFLA_RMNET_FLAGS
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>
References: <20210315154629.652824-1-bjorn.andersson@linaro.org>
From:   Alex Elder <elder@linaro.org>
Message-ID: <1b6ebc71-5efd-53ea-95b5-85e17d5804d1@linaro.org>
Date:   Mon, 15 Mar 2021 11:16:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210315154629.652824-1-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/21 10:46 AM, Bjorn Andersson wrote:
> Parse and pass IFLA_RMNET_FLAGS to the kernel, to allow changing the
> flags from the default of ingress-aggregate only.

To be clear, this default is implemented in the kernel RMNet
driver, not in "iproute2".  And it is ingress deaggregation
(unpacking of aggregated packets from a buffer), not aggregation
(which would be supplying a buffer of aggregated packets to the
hardware).

> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

I have some suggestions on your help text (and flag names).
The code looks good to me otherwise.  I trust you've
confirmed the RMNet driver uses the flags exactly as
you intend when they're provided this way.

					-Alex
> ---
> 
> Changes since v1:
> - s/ifla_vlan_flags/ifla_rmnet_flags/ in print_opt
> 
>   ip/iplink_rmnet.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 42 insertions(+)
> 
> diff --git a/ip/iplink_rmnet.c b/ip/iplink_rmnet.c
> index 1d16440c6900..a847c838def2 100644
> --- a/ip/iplink_rmnet.c
> +++ b/ip/iplink_rmnet.c
> @@ -16,6 +16,10 @@ static void print_explain(FILE *f)
>   {
>   	fprintf(f,
>   		"Usage: ... rmnet mux_id MUXID\n"
> +		"                 [ingress-deaggregation]\n"
> +		"                 [ingress-commands]\n"
> +		"                 [ingress-chksumv4]\n"
> +		"                 [egress-chksumv4]\n"

Other help output (in print_explain()) put spaces after
the '[' and before the ']'; so you'd be better to stay
consistent with that.

And I know the name is based on the C symbol, but I think
you should follow the convention that seems to be used for
all others, and use "csum" to mean checksum.

Also it's not clear what the "v4" means.  I'm not sure I
like this suggestion, but...  It comes from QMAP version 4,
as opposed to QMAP version 5, so maybe use "csum-qmap4"
in place of "csumv4?"

Is there any way to disable ingress deaggregation?  Since
it's on by default, you might want to use a "[ on | off ]"
type option for that case (or all of them for that matter).
Otherwise, the deaggregation parameter doesn't really help
anything.

>   		"\n"
>   		"MUXID := 1-254\n"
>   	);
> @@ -29,6 +33,7 @@ static void explain(void)
>   static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
>   			   struct nlmsghdr *n)
>   {
> +	struct ifla_rmnet_flags flags = { };
>   	__u16 mux_id;

Do you know why this is __u16?  Is it because it's exposed
to user space?  Not a problem... just curious.

>   	while (argc > 0) {
> @@ -37,6 +42,18 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
>   			if (get_u16(&mux_id, *argv, 0))
>   				invarg("mux_id is invalid", *argv);
>   			addattr16(n, 1024, IFLA_RMNET_MUX_ID, mux_id);
> +		} else if (matches(*argv, "ingress-deaggregation") == 0) {
> +			flags.mask = ~0;
> +			flags.flags |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
> +		} else if (matches(*argv, "ingress-commands") == 0) {
> +			flags.mask = ~0;
> +			flags.flags |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
> +		} else if (matches(*argv, "ingress-chksumv4") == 0) {
> +			flags.mask = ~0;
> +			flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
> +		} else if (matches(*argv, "egress-chksumv4") == 0) {
> +			flags.mask = ~0;
> +			flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
>   		} else if (matches(*argv, "help") == 0) {
>   			explain();
>   			return -1;
> @@ -48,11 +65,28 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
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
> +	if (flags & RMNET_FLAGS_INGRESS_DEAGGREGATION)
> +		print_string(PRINT_ANY, NULL, "%s ", "ingress-deaggregation");
> +	if (flags & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
> +		print_string(PRINT_ANY, NULL, "%s ", "ingress-commands");
> +	if (flags & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
> +		print_string(PRINT_ANY, NULL, "%s ", "ingress-chksumv4");
> +	if (flags & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
> +		print_string(PRINT_ANY, NULL, "%s ", "egress-cksumv4");
> +}
> +
>   static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>   {
> +	struct ifla_rmnet_flags *flags;
> +
>   	if (!tb)
>   		return;
>   
> @@ -64,6 +98,14 @@ static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
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

