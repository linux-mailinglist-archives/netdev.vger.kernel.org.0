Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CCA3B0948
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhFVPlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbhFVPlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:41:50 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77E1C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:39:33 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso21606203otu.10
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M0Vnj9oBSGzjvOOOG5ikIodSMcDdLbkeDiR9v8FvHWw=;
        b=Grd54ACcg22Zwknp3GTGhXiaga5lVfJeOfy+Ifbe+lgxZUS0Jv96fAIlZ5Fj1JNYO/
         Ztl8aM7AuPwEPSU4RCvg3D+jQ4vZ6dWDy7eBxpcV2NpcCkouy8AgX6YBZha1rVL0BHRo
         5S1qs1+btBOLUO111Qczhu72TFDKRaWWrLPiyXLDtax77LiaIa3tK3PrzhYhlC9+o2/5
         WHIRlJYOn9pI3jXFc+oUqQMdYWeIYIEnox6T0V7k4+DHEWWtTRZswAj/80mDm+/AhlJw
         NEC2ipv/090RJr0/56QS05rJfmgi+k9HNhA5N8lBZc01AJrzu022wNYNewR9JaRg+lDK
         SfQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M0Vnj9oBSGzjvOOOG5ikIodSMcDdLbkeDiR9v8FvHWw=;
        b=iO1H2HxwZiGsfe9eo1bJbycYvj250WF8SndEq7w88VGwYUTwSTxm5rGwUs19wJl0KQ
         6TavBn+l4wYsewFM7WlUcETJvdg98VW4lVcf6XIbOagIfw28LvmlFwz7zr6g8R+4JkIR
         4VFY4smvgD/UvZcxxjOB3aoPHHwdSNC/fsHLtVWSE/Rs3gV7FtyFSNTnKbG7nbM+gIeE
         FXGLQznUE2mvGH4IpLQh6a9tpWN1/mZNtpCwIJbWZsdVLt6Y2BL+c3DHZMxLY5l7jGYQ
         DxMQbDJTGnNaGWUGzlsAVVml+VTAfczTGK9IqbcIvOLtIoHvJHF0gZyzURoDAUunsqEn
         XcJA==
X-Gm-Message-State: AOAM533v4VZ81qr0tmn8TTZf3B3b3OoeLtyM5ysZM0NMoQe855oqJ7KR
        TNPEmiHnz9U8+2HWg+aAxmo=
X-Google-Smtp-Source: ABdhPJyDk56Arn76lksJQx+WZNKoecJBpifVXrNrPCU+ehKzN74G6dThi1nVWN/RZNo8SR/Pi0rppw==
X-Received: by 2002:a05:6830:104d:: with SMTP id b13mr3572239otp.308.1624376373288;
        Tue, 22 Jun 2021 08:39:33 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id g1sm568404ooi.34.2021.06.22.08.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 08:39:32 -0700 (PDT)
Subject: Re: [PATCH iproute2 v3 2/2] tc: pedit: add decrement operation
To:     =?UTF-8?Q?Asbj=c3=b8rn_Sloth_T=c3=b8nnesen?= <asbjorn@asbjorn.st>,
        netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@nvidia.com>
References: <20210618160635.703845-1-asbjorn@asbjorn.st>
 <20210618160635.703845-2-asbjorn@asbjorn.st>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7b5d610b-0fd6-d466-cd6d-bb2725397cdd@gmail.com>
Date:   Tue, 22 Jun 2021 09:39:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618160635.703845-2-asbjorn@asbjorn.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ looks fine to me; adding tc folks to make sure they see it ]

On 6/18/21 10:06 AM, Asbjørn Sloth Tønnesen wrote:
> Implement a decrement operation for ttl and hoplimit.
> 
> Since this is just syntactic sugar, it goes that:
> 
>   tc filter add ... action pedit ex munge ip ttl dec ...
>   tc filter add ... action pedit ex munge ip6 hoplimit dec ...
> 
> is just a more readable version of this:
> 
>   tc filter add ... action pedit ex munge ip ttl add 0xff ...
>   tc filter add ... action pedit ex munge ip6 hoplimit add 0xff ...
> 
> This feature was suggested by some pseudo tc examples in Mellanox's
> documentation[1], but wasn't present in neither their mlnx-iproute2
> nor iproute2.
> 
> Tested with skip_sw on Mellanox ConnectX-6 Dx.
> 
> [1] https://docs.mellanox.com/pages/viewpage.action?pageId=47033989
> 
> v3:
>    - Use dedicated flags argument in parse_cmd() (David Ahern)
>    - Minor rewording of the man page
> 
> v2:
>    - Fix whitespace issue (Stephen Hemminger)
>    - Add to usage info in explain()
> 
> Signed-off-by: Asbjørn Sloth Tønnesen <asbjorn@asbjorn.st>
> ---
>  man/man8/tc-pedit.8 |  8 +++++++-
>  tc/m_pedit.c        | 25 +++++++++++++++++++------
>  tc/m_pedit.h        |  4 ++++
>  tc/p_ip.c           |  2 +-
>  tc/p_ip6.c          |  2 +-
>  5 files changed, 32 insertions(+), 9 deletions(-)
> 
> diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
> index 376ad4a8..15159ddd 100644
> --- a/man/man8/tc-pedit.8
> +++ b/man/man8/tc-pedit.8
> @@ -77,6 +77,7 @@ pedit - generic packet editor action
>  .IR VAL " | "
>  .BR add
>  .IR VAL " | "
> +.BR decrement " | "
>  .BR preserve " } [ " retain
>  .IR RVAL " ]"
>  
> @@ -96,7 +97,7 @@ chosen automatically based on the header field size.
>  .B ex
>  Use extended pedit.
>  .I EXTENDED_LAYERED_OP
> -and the add
> +and the add/decrement
>  .I CMD_SPEC
>  are allowed only in this mode.
>  .TP
> @@ -288,6 +289,11 @@ is defined by the size of the addressed header field in
>  .IR EXTENDED_LAYERED_OP .
>  This operation is supported only for extended layered op.
>  .TP
> +.BI decrement
> +Decrease the addressed data by one.
> +This operation is supported only for
> +.BR ip " " ttl " and " ip6 " " hoplimit "."
> +.TP
>  .B preserve
>  Keep the addressed data as is.
>  .TP
> diff --git a/tc/m_pedit.c b/tc/m_pedit.c
> index b745c379..54949e43 100644
> --- a/tc/m_pedit.c
> +++ b/tc/m_pedit.c
> @@ -41,7 +41,7 @@ static void explain(void)
>  		"\t\tATC:= at <atval> offmask <maskval> shift <shiftval>\n"
>  		"\t\tNOTE: offval is byte offset, must be multiple of 4\n"
>  		"\t\tNOTE: maskval is a 32 bit hex number\n \t\tNOTE: shiftval is a shift value\n"
> -		"\t\tCMD:= clear | invert | set <setval>| add <addval> | retain\n"
> +		"\t\tCMD:= clear | invert | set <setval> | add <addval> | decrement | retain\n"
>  		"\t<LAYERED>:= ip <ipdata> | ip6 <ip6data>\n"
>  		" \t\t| udp <udpdata> | tcp <tcpdata> | icmp <icmpdata>\n"
>  		"\tCONTROL:= reclassify | pipe | drop | continue | pass |\n"
> @@ -360,15 +360,24 @@ int parse_cmd(int *argc_p, char ***argv_p, __u32 len, int type, __u32 retain,
>  		if (matches(*argv, "add") == 0)
>  			tkey->cmd = TCA_PEDIT_KEY_EX_CMD_ADD;
>  
> -		if (!sel->extended && tkey->cmd) {
> -			fprintf(stderr,
> -				"Non extended mode. only 'set' command is supported\n");
> -			return -1;
> -		}
> +		if (!sel->extended && tkey->cmd)
> +			goto non_ext_only_set_cmd;
>  
>  		NEXT_ARG();
>  		if (parse_val(&argc, &argv, val, type))
>  			return -1;
> +	} else if (matches(*argv, "decrement") == 0) {
> +		if ((flags & PEDIT_ALLOW_DEC) == 0) {
> +			fprintf(stderr,
> +				"decrement command is not supported for this field\n");
> +			return -1;
> +		}
> +
> +		if (!sel->extended)
> +			goto non_ext_only_set_cmd;
> +
> +		tkey->cmd = TCA_PEDIT_KEY_EX_CMD_ADD;
> +		*v = retain; /* decrement by overflow */
>  	} else if (matches(*argv, "preserve") == 0) {
>  		retain = 0;
>  	} else {
> @@ -431,6 +440,10 @@ done:
>  	*argv_p = argv;
>  	return res;
>  
> +non_ext_only_set_cmd:
> +	fprintf(stderr,
> +		"Non extended mode. only 'set' command is supported\n");
> +	return -1;
>  }
>  
>  static int parse_offset(int *argc_p, char ***argv_p, struct m_pedit_sel *sel,
> diff --git a/tc/m_pedit.h b/tc/m_pedit.h
> index 7398f66d..549bcf86 100644
> --- a/tc/m_pedit.h
> +++ b/tc/m_pedit.h
> @@ -39,6 +39,10 @@
>  
>  #define PEDITKINDSIZ 16
>  
> +enum m_pedit_flags {
> +	PEDIT_ALLOW_DEC = 1<<0,
> +};
> +
>  struct m_pedit_key {
>  	__u32           mask;  /* AND */
>  	__u32           val;   /*XOR */
> diff --git a/tc/p_ip.c b/tc/p_ip.c
> index 2d1643d0..8eed9e8d 100644
> --- a/tc/p_ip.c
> +++ b/tc/p_ip.c
> @@ -68,7 +68,7 @@ parse_ip(int *argc_p, char ***argv_p,
>  	if (strcmp(*argv, "ttl") == 0) {
>  		NEXT_ARG();
>  		tkey->off = 8;
> -		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
> +		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, PEDIT_ALLOW_DEC);
>  		goto done;
>  	}
>  	if (strcmp(*argv, "protocol") == 0) {
> diff --git a/tc/p_ip6.c b/tc/p_ip6.c
> index f9d5d3b0..f855c59e 100644
> --- a/tc/p_ip6.c
> +++ b/tc/p_ip6.c
> @@ -71,7 +71,7 @@ parse_ip6(int *argc_p, char ***argv_p,
>  	if (strcmp(*argv, "hoplimit") == 0) {
>  		NEXT_ARG();
>  		tkey->off = 7;
> -		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, 0);
> +		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey, PEDIT_ALLOW_DEC);
>  		goto done;
>  	}
>  	if (strcmp(*argv, "traffic_class") == 0) {
> 

