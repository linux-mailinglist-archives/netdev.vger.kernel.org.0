Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099DF8173D
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 12:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfHEKlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 06:41:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55780 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbfHEKlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 06:41:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so74228696wmj.5
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 03:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bZISF1LQ8Ag2Kah9qYtWAK2UY3PvGP6C2iaEQQeS+SA=;
        b=uqpDN7MF0QfPXDjS9p0Z3QpVyaLZsVpYW0hvgsk+knd/xHscL5FAwwWLDqegE3few9
         mC249QUG75cPakWsKJgwEFZYmMMJWwx6kuiJ1xC/A8UsObob6eb7BCEJ7qx5VPyIOZTC
         sCwW1antWd6eFP31C9rJq5s/1FpyOu1dIZf04YRJtEt1ZqVK9SwyUw7B7KtVb15gdpel
         nOJ20GjHMsG7NYgf2FdDIaweSP98wJVouLKbgqC4lTRHzmNV+MNMQe9SF2VdfaEjfC8x
         7OKxKHlMj8E6JhcuirOsbaz/9r/R+CGY6xzDps7X3l4nI7KKbTHra9kad6JGERHkv15y
         TCtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bZISF1LQ8Ag2Kah9qYtWAK2UY3PvGP6C2iaEQQeS+SA=;
        b=EF2IWn1qq4/SuPQEVA+WE1JkWQnGE06LdyzXN4VxerywvGFvRf894yl/LwUzp24gzr
         7zR6/uwrFQFLxeYk19S1fwMWwJO+1tECNbIEtdbD6uEJkCjZfMuO5uZuhVfON7bVmGwn
         Wat/qwmS98Gwx0+PucFs++UOqvGWhL6QqolHJnLk9gT1dQMKK4JZzvMhKjwryRg/m1qQ
         JTJdGxJ/XwSVXN3rB1jPYi1/1KjdlxI6zdsPLzPk/dUz2dCBx0Xwny3pcGKeWuyA0GaE
         zxatk1SmZmo8J9pMzd9csD2Ojz0kyXYDbAtdKqLt4rZVbMZ1CUSuPisPw6zIRaSvRb/G
         YIqA==
X-Gm-Message-State: APjAAAUUlvceHyFZWkA43P0a4S24c9sNZdnDMOhjppbNAAjDnXJwSnjY
        ++3sEHnroMjb4DMvHK/r2SKns68XTUg=
X-Google-Smtp-Source: APXvYqy+CF3Vs56DtTFITIPR2pDAly6y5+W6JTwOeEt2AXDuhCAOGVKdLg1gGTkK4Ga2wpjiMwSgCQ==
X-Received: by 2002:a1c:305:: with SMTP id 5mr18791145wmd.101.1565001670818;
        Mon, 05 Aug 2019 03:41:10 -0700 (PDT)
Received: from [172.20.1.254] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y18sm80648938wmi.23.2019.08.05.03.41.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 03:41:10 -0700 (PDT)
To:     Peter Wu <peter@lekensteyn.nl>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20190805001541.8096-1-peter@lekensteyn.nl>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH] tools: bpftool: fix reading from /proc/config.gz
Message-ID: <503ed83d-d485-775a-5cde-63e705862fa2@netronome.com>
Date:   Mon, 5 Aug 2019 11:41:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805001541.8096-1-peter@lekensteyn.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter,

Thanks for looking into this (and for the fixes)! Some comments below.

2019-08-05 01:15 UTC+0100 ~ Peter Wu <peter@lekensteyn.nl>
> /proc/config has never existed as far as I can see, but /proc/config.gz

As far as I understood (from examining Cilium [0]), /proc/config _is_
used by some distributions, such as CoreOS. This is why we look at that
location in bpftool.

[0] https://github.com/cilium/cilium/blob/master/bpf/run_probes.sh#L42

> is present on Arch Linux. Execute an external gunzip program to avoid
> linking to zlib and rework the option scanning code since a pipe is not
> seekable. This also fixes a file handle leak on some error paths.
> 
> Fixes: 4567b983f78c ("tools: bpftool: add probes for kernel configuration options")
> Cc: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>  tools/bpf/bpftool/feature.c | 92 +++++++++++++++++++++----------------
>  1 file changed, 52 insertions(+), 40 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index d672d9086fff..e9e10f582047 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -284,34 +284,34 @@ static void probe_jit_limit(void)
>  	}
>  }
>  
> -static char *get_kernel_config_option(FILE *fd, const char *option)
> +static bool get_kernel_config_option(FILE *fd, char **buf_p, size_t *n_p,
> +				     char **value)

Maybe we could rename this function, and have "next" appear in it
somewhere? After your changes, it does not return the value for a
specific option anymore.

>  {
> -	size_t line_n = 0, optlen = strlen(option);
> -	char *res, *strval, *line = NULL;
> -	ssize_t n;
> +	char *sep;
> +	ssize_t linelen;

Please order the declarations in reverse-Christmas tree style.

>  
> -	rewind(fd);
> -	while ((n = getline(&line, &line_n, fd)) > 0) {
> -		if (strncmp(line, option, optlen))
> +	while ((linelen = getline(buf_p, n_p, fd)) > 0) {
> +		char *line = *buf_p;

Please leave a blank line after declarations.

> +		if (strncmp(line, "CONFIG_", 7))
>  			continue;
> -		/* Check we have at least '=', value, and '\n' */
> -		if (strlen(line) < optlen + 3)
> -			continue;
> -		if (*(line + optlen) != '=')
> +
> +		sep = memchr(line, '=', linelen);
> +		if (!sep)
>  			continue;
>  
>  		/* Trim ending '\n' */
> -		line[strlen(line) - 1] = '\0';
> +		line[linelen - 1] = '\0';
> +
> +		/* Split on '=' and ensure that a value is present. */
> +		*sep = '\0';
> +		if (!sep[1])
> +			continue;
>  
> -		/* Copy and return config option value */
> -		strval = line + optlen + 1;
> -		res = strdup(strval);
> -		free(line);
> -		return res;
> +		*value = sep + 1;
> +		return true;
>  	}
> -	free(line);
>  
> -	return NULL;
> +	return false;
>  }
>  
>  static void probe_kernel_image_config(void)
> @@ -386,31 +386,34 @@ static void probe_kernel_image_config(void)
>  		/* test_bpf module for BPF tests */
>  		"CONFIG_TEST_BPF",
>  	};
> +	char *values[ARRAY_SIZE(options)] = { };
>  	char *value, *buf = NULL;
>  	struct utsname utsn;
>  	char path[PATH_MAX];
>  	size_t i, n;
>  	ssize_t ret;
> -	FILE *fd;
> +	FILE *fd = NULL;
> +	bool is_pipe = false;

Reverse-Christmas-tree style please.

>  
>  	if (uname(&utsn))
> -		goto no_config;
> +		goto end_parse;

Just thinking, maybe if uname() fails we can skip /boot/config-$(uname
-r) but still attempt to parse /proc/config{,.gz} instead of printing
only NULL options?

>  
>  	snprintf(path, sizeof(path), "/boot/config-%s", utsn.release);
>  
>  	fd = fopen(path, "r");
>  	if (!fd && errno == ENOENT) {
> -		/* Some distributions put the config file at /proc/config, give
> -		 * it a try.
> -		 * Sometimes it is also at /proc/config.gz but we do not try
> -		 * this one for now, it would require linking against libz.
> +		/* Some distributions build with CONFIG_IKCONFIG=y and put the
> +		 * config file at /proc/config.gz. We try to invoke an external
> +		 * gzip program to avoid linking to libz.
> +		 * Hide stderr to avoid interference with the JSON output.

Because some distributions do use /proc/config, we should keep this. You
can probably add /proc/config.gz as another attempt below (or even
above) the current case?

>  		 */
> -		fd = fopen("/proc/config", "r");
> +		fd = popen("gunzip -c /proc/config.gz 2>/dev/null", "r");
> +		is_pipe = true;
>  	}
>  	if (!fd) {
>  		p_info("skipping kernel config, can't open file: %s",
>  		       strerror(errno));
> -		goto no_config;
> +		goto end_parse;
>  	}
>  	/* Sanity checks */
>  	ret = getline(&buf, &n, fd);
> @@ -418,27 +421,36 @@ static void probe_kernel_image_config(void)
>  	if (!buf || !ret) {
>  		p_info("skipping kernel config, can't read from file: %s",
>  		       strerror(errno));
> -		free(buf);
> -		goto no_config;
> +		goto end_parse;
>  	}
>  	if (strcmp(buf, "# Automatically generated file; DO NOT EDIT.\n")) {
>  		p_info("skipping kernel config, can't find correct file");
> -		free(buf);
> -		goto no_config;
> +		goto end_parse;
> +	}
> +
> +	while (get_kernel_config_option(fd, &buf, &n, &value))> +		for (i = 0; i < ARRAY_SIZE(options); i++) {
> +			if (values[i] || strcmp(buf, options[i]))

Can we have an option set multiple times in the config file? If so,
maybe have a p_info() if values are different to warn users that
conflicting values were found?

(Reading the file just once is a nice improvement over my version, by
the way, thanks!)

> +				continue;
> +
> +			values[i] = strdup(value);
> +		}
> +	}
> +
> +end_parse:
> +	if (fd) {
> +		if (is_pipe) {
> +			if (pclose(fd))
> +				p_info("failed to read /proc/config.gz");
> +		} else
> +			fclose(fd);

Please use braces on all branches of the conditional statement (else).

Thanks,
Quentin
