Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A526025EC8
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 09:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbfEVHpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 03:45:08 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45750 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfEVHpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 03:45:08 -0400
Received: by mail-lf1-f67.google.com with SMTP id n22so894680lfe.12
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 00:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=15aURh5b05zdmtYRIIBYT5TwHdQmTOmGD+VB861zuSQ=;
        b=n/Q1xW2UkGhX8oSqIV7zGnFCzm0Rjz9tfXhXf1d0MCU5rhqZ5mT6BN1G8U0YUsF9h1
         v5cbaRM3c6OR72luo08wv/PVy7EfOPY/IKRGugEst3PQzjEGCQafeGRh/A9CkWlO9XU6
         RNXmdmnHW52J9G2aPX4g2gsuM7Kc8k2SA51ok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=15aURh5b05zdmtYRIIBYT5TwHdQmTOmGD+VB861zuSQ=;
        b=QpG/ADEJ4adYvqASyTb/xrmHZxLDsC3RyUDpGvp3Qjxc6UJjHzwLpI83ok5Emw+6mT
         Q4zGiPs4oyWWD6MlOjZcaOtq5PN/xkJfaFlEUPzuc9WhUpiiGaRz5Ld1N/IHrGdoLOmf
         DdMNJy78fD5MpxGZNbhr/7Jsq9/sNiOU8Zt7n+DZLPyKOUAbjV2l1woVc4WCNYcGQ6pS
         B4cPq0OAx9tkmYTP2EUcaJKQYydb3NifslwwxqUsmvqVO6SUk78KAzofzXaQQphHc4mE
         L3/jl/XaIXU+6dIfZ1/a97PffvqHZ/N8h4DwRpJQDogOzUI7XeYoX+nsxkYcidhoMCpy
         8DXg==
X-Gm-Message-State: APjAAAVczImNi6zGkeo+WBVeZu8/HPFI5k0bb4U2vkQvYB/uG3TfuYup
        GBljbnGylopqsvYjlN6MCDQ4mQ==
X-Google-Smtp-Source: APXvYqyIYn30nswvm8u0sbDWQELTLK2uoUfB/fe3LCeN8/wMiamYUsmeBy+Oh1eguWObQMQd7Nt5Qg==
X-Received: by 2002:a19:700d:: with SMTP id h13mr5006682lfc.39.1558511106411;
        Wed, 22 May 2019 00:45:06 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id v4sm139960lfi.49.2019.05.22.00.45.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 00:45:05 -0700 (PDT)
References: <20190522002457.10181-1-danieltimlee@gmail.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] samples: bpf: fix style in bpf_load
In-reply-to: <20190522002457.10181-1-danieltimlee@gmail.com>
Date:   Wed, 22 May 2019 09:45:04 +0200
Message-ID: <87woijyltr.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 02:24 AM CEST, Daniel T. Lee wrote:
> This commit fixes style problem in samples/bpf/bpf_load.c
>
> Styles that have been changed are:
>  - Magic string use of 'DEBUGFS'
>  - Useless zero initialization of a global variable
>  - Minor style fix with whitespace
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/bpf_load.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
> index eae7b635343d..e71d23d2a0ff 100644
> --- a/samples/bpf/bpf_load.c
> +++ b/samples/bpf/bpf_load.c
> @@ -40,7 +40,7 @@ int prog_cnt;
>  int prog_array_fd = -1;
>
>  struct bpf_map_data map_data[MAX_MAPS];
> -int map_data_count = 0;
> +int map_data_count;
>
>  static int populate_prog_array(const char *event, int prog_fd)
>  {
> @@ -57,6 +57,7 @@ static int populate_prog_array(const char *event, int prog_fd)
>  static int write_kprobe_events(const char *val)
>  {
>  	int fd, ret, flags;
> +	char buf[256];
>
>  	if (val == NULL)
>  		return -1;
> @@ -65,7 +66,9 @@ static int write_kprobe_events(const char *val)
>  	else
>  		flags = O_WRONLY | O_APPEND;
>
> -	fd = open("/sys/kernel/debug/tracing/kprobe_events", flags);
> +	strcpy(buf, DEBUGFS);
> +	strcat(buf, "kprobe_events");
> +	fd = open(buf, flags);

No need to build the path at run-time. Compile-time string literal
concatenation will do in this case:

  fd = open(DEBUGFS "kprobe_events", flags);

-Jakub

>
>  	ret = write(fd, val, strlen(val));
>  	close(fd);
> @@ -490,8 +493,8 @@ static int load_elf_maps_section(struct bpf_map_data *maps, int maps_shndx,
>
>  		/* Verify no newer features were requested */
>  		if (validate_zero) {
> -			addr = (unsigned char*) def + map_sz_copy;
> -			end  = (unsigned char*) def + map_sz_elf;
> +			addr = (unsigned char *) def + map_sz_copy;
> +			end  = (unsigned char *) def + map_sz_elf;
>  			for (; addr < end; addr++) {
>  				if (*addr != 0) {
>  					free(sym);
