Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAEC50C42E
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiDVWqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbiDVWqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:46:03 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF362DB5ED
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:36:24 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d15so13565528pll.10
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=g1lhuaRo3OOBQYJGPWFnF2A4YTaYfbs5BOZ6154kPPo=;
        b=aSJsfyvDPzJr+t3yGXwXl5WobCcJE53xF3XcRSEi62fWSPYhIIBg4bmwnqlzui09V/
         OKm/Z0EqqyNVfUJBltjQAPUJDxOZ5morYlyeE9eDo2p8YwxN3zTWgrbvSGJv9GDti6Qd
         EXy0NOe962hzUjWyUZQ8jfPyGLLbItte7B51JP12b7btpvHeae5cj2lkKh6JTj+xj31T
         FgB/UJKM9RhJmx1TuPysdode4zeUz1bKjlyQoq2IAEpP1rS3xRdLnsgGEavsHHyDLO8l
         UEr73I86PaU/o2LBdf5z63BQ4o1kfgPPbYAU8dUVqgwsqAz7B3R2optcjKStc4QLi4cn
         lqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g1lhuaRo3OOBQYJGPWFnF2A4YTaYfbs5BOZ6154kPPo=;
        b=Bg5orYM1Fzh8LcE390xsoasEhflbC8x/e3/Izx7HaiSVkddAkWdJ00FZvCNwIOSZ1I
         WALR9v9km3v2NbSS+3Gwr1ymrC49uYGkfz29nCKPWg6r2YY41PEQ2NWURsvtngqNB9cu
         crSto8Xx0ewx7vB8mL6UIVnOdY9UNwR11+1Sd5M/FaTeX3pS9yYMjKSweUnonoGRtleH
         mLUjEy5I/xsZwEeY537w1JPoAmJ/oLtwKy+n8j7+3GnpU8PmI0QERWXv9k6UHtr9Ylr4
         eBpUCKkGMm0JPB5rlnbPyDOAwpNyD4htXKidhKoHPeuhmJldWVgR5e6fDQ09UTW3LTnC
         Yj8g==
X-Gm-Message-State: AOAM530nhc/GZkwwQ6bjR7S6NQ0DXd/MpG8IqAEAu87onTGeICl3m8jU
        qIr0RzMU77SXd+XdnSfCLDhjtPqv7o+6oA==
X-Google-Smtp-Source: ABdhPJzgSQ/Cf6lM+gnTgpnhse3RwCp7ZLyIsGXi2t1mol23P/8+4gIHGhkUz1f9HnXxUGK3rV6OSg==
X-Received: by 2002:a17:90b:124c:b0:1bc:369b:7db5 with SMTP id gx12-20020a17090b124c00b001bc369b7db5mr18309010pjb.179.1650663383575;
        Fri, 22 Apr 2022 14:36:23 -0700 (PDT)
Received: from [192.168.0.5] ([50.53.169.105])
        by smtp.gmail.com with ESMTPSA id i1-20020a17090a650100b001cd8e9ea22asm6884895pjj.52.2022.04.22.14.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 14:36:23 -0700 (PDT)
Message-ID: <56b4d3e4-0274-10d8-0746-954750eac085@pensando.io>
Date:   Fri, 22 Apr 2022 14:36:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [patch iproute2-next] devlink: introduce -h[ex] cmdline option to
 allow dumping numbers in hex format
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com
References: <20220419171637.1147925-1-jiri@resnulli.us>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20220419171637.1147925-1-jiri@resnulli.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/22 10:16 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> For health reporter dumps it is quite convenient to have the numbers in
> hexadecimal format. Introduce a command line option to allow user to
> achieve that output.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>   devlink/devlink.c  | 19 +++++++++++++------
>   man/man8/devlink.8 |  4 ++++
>   2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index aab739f7f437..bc681737ec8a 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -367,6 +367,7 @@ struct dl {
>   	bool pretty_output;
>   	bool verbose;
>   	bool stats;
> +	bool hex;
>   	struct {
>   		bool present;
>   		char *bus_name;
> @@ -8044,6 +8045,8 @@ static int cmd_health_dump_clear(struct dl *dl)
>   
>   static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
>   {
> +	const char *num_fmt = dl->hex ? "%x" : "%u";
> +	const char *num64_fmt = dl->hex ? "%"PRIx64 : "%"PRIu64;

Can we get a leading "0x" on these to help identify that they are hex 
digits?

>   	uint8_t *data;
>   	uint32_t len;
>   
> @@ -8053,16 +8056,16 @@ static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
>   		print_bool(PRINT_ANY, NULL, "%s", mnl_attr_get_u8(nl_data));
>   		break;
>   	case MNL_TYPE_U8:
> -		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u8(nl_data));
> +		print_uint(PRINT_ANY, NULL, num_fmt, mnl_attr_get_u8(nl_data));
>   		break;
>   	case MNL_TYPE_U16:
> -		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u16(nl_data));
> +		print_uint(PRINT_ANY, NULL, num_fmt, mnl_attr_get_u16(nl_data));
>   		break;
>   	case MNL_TYPE_U32:
> -		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u32(nl_data));
> +		print_uint(PRINT_ANY, NULL, num_fmt, mnl_attr_get_u32(nl_data));
>   		break;
>   	case MNL_TYPE_U64:
> -		print_u64(PRINT_ANY, NULL, "%"PRIu64, mnl_attr_get_u64(nl_data));
> +		print_u64(PRINT_ANY, NULL, num64_fmt, mnl_attr_get_u64(nl_data));
>   		break;
>   	case MNL_TYPE_NUL_STRING:
>   		print_string(PRINT_ANY, NULL, "%s", mnl_attr_get_str(nl_data));
> @@ -8939,7 +8942,7 @@ static void help(void)
>   	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
>   	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
>   	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health | trap }\n"
> -	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] }\n");
> +	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] -h[ex] }\n");
>   }
>   
>   static int dl_cmd(struct dl *dl, int argc, char **argv)
> @@ -9053,6 +9056,7 @@ int main(int argc, char **argv)
>   		{ "statistics",		no_argument,		NULL, 's' },
>   		{ "Netns",		required_argument,	NULL, 'N' },
>   		{ "iec",		no_argument,		NULL, 'i' },
> +		{ "hex",		no_argument,		NULL, 'h' },

Can we use 'x' instead of 'h' here?  Most times '-h' means 'help', and 
might surprise unsuspecting users when it isn't a help flag.

Thanks,
sln

>   		{ NULL, 0, NULL, 0 }
>   	};
>   	const char *batch_file = NULL;
> @@ -9068,7 +9072,7 @@ int main(int argc, char **argv)
>   		return EXIT_FAILURE;
>   	}
>   
> -	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:i",
> +	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:ih",
>   				  long_options, NULL)) >= 0) {
>   
>   		switch (opt) {
> @@ -9106,6 +9110,9 @@ int main(int argc, char **argv)
>   		case 'i':
>   			use_iec = true;
>   			break;
> +		case 'h':
> +			dl->hex = true;
> +			break;
>   		default:
>   			pr_err("Unknown option.\n");
>   			help();
> diff --git a/man/man8/devlink.8 b/man/man8/devlink.8
> index 840cf44cf97b..3797a27cefc5 100644
> --- a/man/man8/devlink.8
> +++ b/man/man8/devlink.8
> @@ -63,6 +63,10 @@ Switches to the specified network namespace.
>   .BR "\-i", " --iec"
>   Print human readable rates in IEC units (e.g. 1Ki = 1024).
>   
> +.TP
> +.BR "\-h", " --hex"
> +Print dump numbers in hexadecimal format.
> +
>   .SS
>   .I OBJECT
>   
