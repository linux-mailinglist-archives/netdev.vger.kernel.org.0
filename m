Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E96C4229E7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbhJEOEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbhJEOD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 10:03:57 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE921C094240
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 06:54:46 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id n63so986014oif.7
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 06:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fyPxe37KhXTaJxJSIJzbMxwWQqktsKbPgHfCJEzmU6Q=;
        b=SP7icXlYwYBnriyZSt181p1XjA8ARZfJp+ThCre04GgnWRHTaN25aWlMWwpctbWc63
         1DP0BhiWxzmK/pyMRIgcfhEN3t714IFI58QlUmX59EqTpJcLthqV+bEdmOgz3Oc5h1pi
         WVqUFiKPtFxQqTFhnU7OPGdaQuzWXC1DY33M9NOq1q1QIhsNdoLO3gj2TYmE/XLvyzSX
         FLWOcbexK4F8ObR7lKJNIlw/fDl8rnM3/Csqw0MXwC3vmhlWpaNkjpWS3Tpm6yKYbx0o
         qk8njpfUlWSetJWwWzRpH9m/4z28Ovh7A5i7Ghx1Y0dsRoHfg8Q7XyuWbfuvDURSPajE
         n4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fyPxe37KhXTaJxJSIJzbMxwWQqktsKbPgHfCJEzmU6Q=;
        b=mC8pbMLb6uqFzKwGz6jnhlzk0zfj7L+TWk6UQfi4UrgoT2cML0rlW2POJdrfiLFTq/
         NOT8A01NZe6Csz+YemG6Pxn5XxyHHpB0jvaKQlY8fS4Qv+kYRiEPE9vtnkH5z+YIItoy
         BhkzohKrDrvT844CritkQyWGzkpRDGkrEF5rzLNqBcaLGG1706+uDkwv5hQ+Nbb1EcSu
         myjmGtSeBtMu0qX8fipOn5T5v3h9YL+NusUN/NFqJQkAtdmLXg6MnnfH+Wd2LU1P+cQe
         gTFiDr2j0jRdknn4kZpwBYUUoBqWtvp9Q7MBVQptUM/f8Q5g/VyNjxIw87B387jZHmjO
         O6+w==
X-Gm-Message-State: AOAM533LFAMo9OlQW76GvqJTdZfioappzBDHpm4Px6xjwEoJSPCj0zZt
        ilY4VJVdP2oh+cF54TO9bHM=
X-Google-Smtp-Source: ABdhPJy1yyp8jiMuYMha7IlgJghZFsq1N2cvZIwcioi1c9yPfoxcePVHJaQeG5vYg4v3hXDMtG/fjw==
X-Received: by 2002:a54:4393:: with SMTP id u19mr2546410oiv.77.1633442086304;
        Tue, 05 Oct 2021 06:54:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id e2sm3648452otk.46.2021.10.05.06.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 06:54:45 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2 1/3] configure: support --param=value style
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, bluca@debian.org
References: <cover.1633369677.git.aclaudi@redhat.com>
 <189942255eec5688c214c6ff48815836b7d7e1c6.1633369677.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <43c24b47-3e75-6197-31c3-ba430932b815@gmail.com>
Date:   Tue, 5 Oct 2021 07:54:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <189942255eec5688c214c6ff48815836b7d7e1c6.1633369677.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/21 1:50 PM, Andrea Claudi wrote:
> diff --git a/configure b/configure
> index 7f4f3bd9..cebfda6e 100755
> --- a/configure
> +++ b/configure
> @@ -501,18 +501,30 @@ if [ $# -eq 1 ] && [ "$(echo $1 | cut -c 1)" != '-' ]; then
>  else
>  	while true; do
>  		case "$1" in
> -			--include_dir)
> -				INCLUDE=$2
> -				shift 2 ;;
> -			--libbpf_dir)
> -				LIBBPF_DIR="$2"
> -				shift 2 ;;
> -			--libbpf_force)
> -				if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
> +			--include_dir*)

this is going to match a lot more than just --include_dir and --include_dir=


