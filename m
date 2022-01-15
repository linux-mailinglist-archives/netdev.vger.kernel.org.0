Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC03648F78B
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 16:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbiAOPma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 10:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiAOPm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 10:42:28 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7506AC061574
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 07:42:28 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id a2so5042633ilr.0
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 07:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ibU+NMvVAWCRx+oAOFunDrau0lU9zya/8h8UtAgSSck=;
        b=mnqgHNIeUloHORlG1iUFRNk7c7L3I8VYHkWWaOlCQrGKix5FcOqXRcKRig5o6gnL4p
         OlXcdoZXpolR0umKUdcY1nFJyrt0S5RO3g7E7F8RP/rkHJR2RRebcb8cAALzrExUWaDQ
         7jPI/QTdPDzA2ug20tb2OboIoQVPxh3YpbGZ+faf2Ru9/dmYopmp1yMZW4PrFWJ/oLiD
         ShBPk4qp2u3A/AYGpI156x26yWsBKmaCPqx3htw6oh/LZlmvgwjmAK2mQ33+R1tiathy
         UFiywIFfswXGp35Mwpl8+MZes2i/5rgVRGf4PIc1RPWvrPfF6IzcBh9Mn33s2MeoFzb8
         ZWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ibU+NMvVAWCRx+oAOFunDrau0lU9zya/8h8UtAgSSck=;
        b=7PBKjoUAFR4wnt4AkwL1DQbs/uzK2qOEfnRoNJvsqvxdnwyyvFiVTgUo+KTv892Ev9
         HuqrtAvbv9Oqms0n0U3b37P3nuKa9e3yszXyY53G3E9XhcdBHVdMWquMox0GrfTxM1aP
         bs4ZMYnmmV1Z22/Gzn/oy7GkIyyQwDwoX2KfgtCKqbzE5PBfPggaFlIKK6tNFPb2WLRi
         EIPu454PKX1FrHBC0DonlX+OR9IYP3kwRWzkVZgxMCCXP/S1glePpTfO9A0pbjWqbhhi
         uO+Ln0ptTZ8MWZu744XvJ6Rcd9/gsNc4lWrnOymREP75y7t3LKyLJn8pBjneGqF6GAZN
         eiTQ==
X-Gm-Message-State: AOAM533EgG5t3wnrw4ppDZ33vb0A3p5x3scCpmNtVmSpPm+mBw0MCq+E
        GTnOwSoA+LGIQbyJuFpik8Y=
X-Google-Smtp-Source: ABdhPJzjWDxNSdshfncVLpsG+8Ru0XKEG1YkdiHQh5/JlfWu47jaeyOnUC7NgNpFHOtGAx8hlAS4fg==
X-Received: by 2002:a92:dd87:: with SMTP id g7mr7149415iln.174.1642261347791;
        Sat, 15 Jan 2022 07:42:27 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:b478:8c5d:5216:cfd9? ([2601:282:800:dc80:b478:8c5d:5216:cfd9])
        by smtp.googlemail.com with ESMTPSA id s9sm6552922iow.40.2022.01.15.07.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Jan 2022 07:42:26 -0800 (PST)
Message-ID: <93dd20fc-e22e-2536-85f6-5442b3f19adc@gmail.com>
Date:   Sat, 15 Jan 2022 08:42:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2-next] mptcp: add id check for deleting address
Content-Language: en-US
To:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev, David Ahern <dsahern@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
References: <0e01aafaba6df6ff7adf255999d64259d7ae8d50.1642204990.git.geliang.tang@suse.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <0e01aafaba6df6ff7adf255999d64259d7ae8d50.1642204990.git.geliang.tang@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/22 5:10 PM, Geliang Tang wrote:
> This patch added the id check for deleting address in mptcp_parse_opt().
> The ADDRESS argument is invalid for the non-zero id address, only needed
> for the id 0 address.
> 
>  # ip mptcp endpoint delete id 1
>  # ip mptcp endpoint delete id 0 10.0.1.1
> 
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/171

meaning bug fix? If so please add a Fixes tag with the commit that
should have required the id.

> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  ip/ipmptcp.c        | 11 +++++++++--
>  man/man8/ip-mptcp.8 | 16 +++++++++++++++-
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
> index e7150138..4363e753 100644
> --- a/ip/ipmptcp.c
> +++ b/ip/ipmptcp.c
> @@ -24,7 +24,7 @@ static void usage(void)
>  	fprintf(stderr,
>  		"Usage:	ip mptcp endpoint add ADDRESS [ dev NAME ] [ id ID ]\n"
>  		"				      [ port NR ] [ FLAG-LIST ]\n"
> -		"	ip mptcp endpoint delete id ID\n"
> +		"	ip mptcp endpoint delete id ID [ ADDRESS ]\n"
>  		"	ip mptcp endpoint change id ID [ backup | nobackup ]\n"
>  		"	ip mptcp endpoint show [ id ID ]\n"
>  		"	ip mptcp endpoint flush\n"
> @@ -103,6 +103,7 @@ static int get_flags(const char *arg, __u32 *flags)
>  static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n, int cmd)
>  {
>  	bool adding = cmd == MPTCP_PM_CMD_ADD_ADDR;
> +	bool deling = cmd == MPTCP_PM_CMD_DEL_ADDR;
>  	struct rtattr *attr_addr;
>  	bool addr_set = false;
>  	inet_prefix address;
> @@ -156,8 +157,14 @@ static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n, int cmd)
>  	if (!addr_set && adding)
>  		missarg("ADDRESS");
>  
> -	if (!id_set && !adding)
> +	if (!id_set && deling)
>  		missarg("ID");
> +	else if (id_set && deling) {

brackets on the 'if () { .. }' since they are needed on the else.

> +		if (id && addr_set)
> +			invarg("invalid for non-zero id address\n", "ADDRESS");
> +		else if (!id && !addr_set)
> +			invarg("address is needed for deleting id 0 address\n", "ID");
> +	}
>  
>  	if (port && !(flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
>  		invarg("flags must have signal when using port", "port");
