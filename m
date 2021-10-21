Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811FC4364D2
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhJUO6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhJUO6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 10:58:05 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ACEC0613B9
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 07:55:49 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id t4so1182599oie.5
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 07:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AMFoNCzjo2neTJQLcr/2BEBCXIQ9jw04IP8o4kR5iuE=;
        b=ATTklKGbE1CbnC1iH5KtDrB0ILidV+K7UVgbgCfaE28Z9VMOsZrAOwqYOvnNTCo06v
         9EUtu2v12M6kHBLhiU0B3l7NJ1WyV8YLkO8ynAP6E148LjuZ74UChRCgo2aDFEwrvKSn
         yXzzHdb8YN09RTPkPw40nsY1DCsTAAll7lpQkuMN1dF8Dax0jJcolhDl4e9ux0jUNrNY
         4xFtUepjPQeWz8j7JSnTSi2PLCLFIYDIK3EyZlSEBGByyLluA0X1OrMUZkt+MuowR02g
         MMxkh17d7D9OZ3NkM/WTvjav6KxN3IVHXfU+PoypxUPBc/Tx6affEsAZO+//PNkfNfHY
         Ky0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AMFoNCzjo2neTJQLcr/2BEBCXIQ9jw04IP8o4kR5iuE=;
        b=eaGT3D4frLiGBPo4r3ylLurc2Fr4PH2c3SGYYhx/PeOTFhp9U/5D4Fb/qiJoicUmzP
         FXO1gqu3EqAXK4YECuscKjJUnERO0hbyXRBLad7kOizgd+AN6dIyPbXQjxpJgVIn9/lf
         n0Z9ZagXSbNnw0Eb3FSIevG3nXCJFpBpgtn61lD4/s//UnB0JtzLRrL91Xd3JrVEUieD
         2vO7x6nTPHlXDRaMN3cScvItFQAAeG42H4ga6G3S1eqY7KYfrO7kRx3h+QYS7qxspanw
         k8YiKrOkHZ2Xe/UZZqUy5G9JgVAbrlOf/q1nUosBVtTrm5x5J1mSgnmSnFo6FjSShCfy
         0w9A==
X-Gm-Message-State: AOAM532nu7LH1vyZzuTZyxuyfJBiGesiQP0wrR0uXpJvNOmZxzgMdb/1
        e9hH2Fyf/R/j8D12sItGec6MqrEkUBU=
X-Google-Smtp-Source: ABdhPJwN6LQ0olRgR6ylK+BCKv1TfDKq0pKzZIZvwMZ/4JAMycJz0A5Ag1xr3O9zLaGoTfdAwSobVA==
X-Received: by 2002:a05:6808:1921:: with SMTP id bf33mr5161155oib.71.1634828148718;
        Thu, 21 Oct 2021 07:55:48 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id j4sm1125087oia.56.2021.10.21.07.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:55:47 -0700 (PDT)
Message-ID: <1ee8e8ec-734b-eec7-1826-340c0d48f26e@gmail.com>
Date:   Thu, 21 Oct 2021 08:55:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH iproute2 v2] xfrm: enable to manage default policies
Content-Language: en-US
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, antony.antony@secunet.com,
        steffen.klassert@secunet.com
References: <20210923061342.8522-1-nicolas.dichtel@6wind.com>
 <20211018083045.27406-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211018083045.27406-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/21 2:30 AM, Nicolas Dichtel wrote:
> diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
> index ecd06396eb16..378b4092f26a 100644
> --- a/include/uapi/linux/xfrm.h
> +++ b/include/uapi/linux/xfrm.h
> @@ -213,13 +213,13 @@ enum {
>  	XFRM_MSG_GETSPDINFO,
>  #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
>  
> +	XFRM_MSG_MAPPING,
> +#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
> +
>  	XFRM_MSG_SETDEFAULT,
>  #define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
>  	XFRM_MSG_GETDEFAULT,
>  #define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
> -
> -	XFRM_MSG_MAPPING,
> -#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
>  	__XFRM_MSG_MAX
>  };
>  #define XFRM_MSG_MAX (__XFRM_MSG_MAX - 1)
> @@ -514,9 +514,12 @@ struct xfrm_user_offload {
>  #define XFRM_OFFLOAD_INBOUND	2
>  
>  struct xfrm_userpolicy_default {
> -#define XFRM_USERPOLICY_DIRMASK_MAX	(sizeof(__u8) * 8)
> -	__u8				dirmask;
> -	__u8				action;
> +#define XFRM_USERPOLICY_UNSPEC	0
> +#define XFRM_USERPOLICY_BLOCK	1
> +#define XFRM_USERPOLICY_ACCEPT	2
> +	__u8				in;
> +	__u8				fwd;
> +	__u8				out;
>  };
>  
>  /* backwards compatibility for userspace */

that is already updated in iproute2-next.


> diff --git a/ip/xfrm_policy.c b/ip/xfrm_policy.c
> index 7cc00e7c2f5b..744f331ff564 100644
> --- a/ip/xfrm_policy.c
> +++ b/ip/xfrm_policy.c
> @@ -1124,6 +1126,121 @@ static int xfrm_spd_getinfo(int argc, char **argv)
>  	return 0;
>  }
>  
> +static int xfrm_spd_setdefault(int argc, char **argv)
> +{
> +	struct rtnl_handle rth;
> +	struct {
> +		struct nlmsghdr			n;
> +		struct xfrm_userpolicy_default  up;
> +	} req = {
> +		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct xfrm_userpolicy_default)),
> +		.n.nlmsg_flags = NLM_F_REQUEST,
> +		.n.nlmsg_type = XFRM_MSG_SETDEFAULT,
> +	};
> +
> +	while (argc > 0) {
> +		if (strcmp(*argv, "in") == 0) {
> +			if (req.up.in)
> +				duparg("in", *argv);
> +
> +			NEXT_ARG();
> +			if (strcmp(*argv, "block") == 0)
> +				req.up.in = XFRM_USERPOLICY_BLOCK;
> +			else if (strcmp(*argv, "accept") == 0)
> +				req.up.in = XFRM_USERPOLICY_ACCEPT;
> +			else
> +				invarg("in policy value is invalid", *argv);
> +		} else if (strcmp(*argv, "fwd") == 0) {
> +			if (req.up.fwd)
> +				duparg("fwd", *argv);
> +
> +			NEXT_ARG();
> +			if (strcmp(*argv, "block") == 0)
> +				req.up.fwd = XFRM_USERPOLICY_BLOCK;
> +			else if (strcmp(*argv, "accept") == 0)
> +				req.up.fwd = XFRM_USERPOLICY_ACCEPT;
> +			else
> +				invarg("fwd policy value is invalid", *argv);
> +		} else if (strcmp(*argv, "out") == 0) {
> +			if (req.up.out)
> +				duparg("out", *argv);
> +
> +			NEXT_ARG();
> +			if (strcmp(*argv, "block") == 0)
> +				req.up.out = XFRM_USERPOLICY_BLOCK;
> +			else if (strcmp(*argv, "accept") == 0)
> +				req.up.out = XFRM_USERPOLICY_ACCEPT;
> +			else
> +				invarg("out policy value is invalid", *argv);
> +		} else {
> +			invarg("unknown direction", *argv);
> +		}
> +
> +		argc--; argv++;
> +	}
> +
> +	if (rtnl_open_byproto(&rth, 0, NETLINK_XFRM) < 0)
> +		exit(1);
> +
> +	if (rtnl_talk(&rth, &req.n, NULL) < 0)
> +		exit(2);
> +
> +	rtnl_close(&rth);
> +
> +	return 0;
> +}
> +
> +int xfrm_policy_default_print(struct nlmsghdr *n, FILE *fp)
> +{
> +	struct xfrm_userpolicy_default *up = NLMSG_DATA(n);
> +	int len = n->nlmsg_len - NLMSG_SPACE(sizeof(*up));
> +
> +	if (len < 0) {
> +		fprintf(stderr,
> +			"BUG: short nlmsg len %u (expect %lu) for XFRM_MSG_GETDEFAULT\n",
> +			n->nlmsg_len, NLMSG_SPACE(sizeof(*up)));
> +		return -1;
> +	}
> +
> +	fprintf(fp, "Default policies:\n");
> +	fprintf(fp, " in:  %s\n",
> +		up->in == XFRM_USERPOLICY_BLOCK ? "block" : "accept");
> +	fprintf(fp, " fwd: %s\n",
> +		up->fwd == XFRM_USERPOLICY_BLOCK ? "block" : "accept");
> +	fprintf(fp, " out: %s\n",
> +		up->out == XFRM_USERPOLICY_BLOCK ? "block" : "accept");
> +	fflush(fp);
> +
> +	return 0;
> +}
> +

create xfrm_str_to_policy and xfrm_policy_to_str helpers for the
conversions between "block" and "accept" to XFRM_USERPOLICY_BLOCK and
XFRM_USERPOLICY_ACCEPT and back.


