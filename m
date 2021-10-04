Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01CD4204BA
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 03:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhJDBaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 21:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhJDBaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 21:30:20 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E2BC0613EC
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 18:28:31 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id e144so18429711iof.3
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 18:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8iIkyj6sICJx5EPMr1RSEpQLopFmtfLFHCaKgg9JBZI=;
        b=e3Tajoi5JxqtT5k65usATWZELy8hgOMtcz4rwHiiCQNHzV0zIUveU1vcBrgwa9JdSd
         4lnY89iw39kPZNoTA+c1C2xTXtWJG7Au9gnxdanRgR1+kxcjIrbKGllG4cONdyn8PRHZ
         GcuLnLNG8drMmSh49UfESXvv5hRjzUnsTwV90bOOthhWw/DM5wTsTc34oAfvT4uL2qAe
         jqeEmipXyRb9UGHoURz1jTdQ7KAYJsShPed4QINjfj1eqPRWXgRieWHUBqvDwweA9RNs
         q8dn1m2mlH5TA79kCfucascWHwD8G6QUhcTWduuRw11ImOEmyTwxkhsA3R115qboV/MV
         FCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8iIkyj6sICJx5EPMr1RSEpQLopFmtfLFHCaKgg9JBZI=;
        b=fuKoxgs2SwTFF0dXJ2qV67VQIQhDB8BYe4pU+b6vO4g58xa5a/EAtNbJ371kemfv1q
         KOEr3mgste89uKWY+zw29AJIFx53UlvFaDur1vVv48J1USILouLssewl1svBnnjg2dXi
         GstHTFhy/aonhhpO+WmF5hhHZvPW821wsUPlrRbk7gwWJP48B6SEx6qlqheWqJPsOzWe
         Owv6u2az5OZ4qKaxURe9Ha+HPCIwQSA0dohsjrKvahhc4bGCfoPpdiYBt3Ld6chjDib8
         IGKdOYw8R10AFMwG/xt6Od5m+qmOyMQ9IJkqIO0wqn+L2bVDPsepq0kFoX3Jm4/4bcP2
         Cl3A==
X-Gm-Message-State: AOAM532eKQ5EuDQq33dfDhx+Jz3TcQ5DydaC9D3r4fPUUAitO89qAmya
        /+3DDJLcm6O6y1s+00JFtrz/dFhT+pE8PQ==
X-Google-Smtp-Source: ABdhPJx7R2Q96+Ya9Q5m3yaXq4UAwlwYXb6GLPYLAV6Po5HbRtTf8xPAh+a3pYJ1PZPO6Gj1hh4ChQ==
X-Received: by 2002:a05:6602:3311:: with SMTP id b17mr7497483ioz.47.1633310911425;
        Sun, 03 Oct 2021 18:28:31 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id z6sm8514073iox.28.2021.10.03.18.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 18:28:30 -0700 (PDT)
Subject: Re: [PATCH 1/2 iproute2] configure: support --param=value style
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, bluca@debian.org
References: <cover.1633191885.git.aclaudi@redhat.com>
 <754f3aaeae85cdc9aec0a7b609803a0281e1fabb.1633191885.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <42421564-cc08-3b76-d245-164d9c039ad2@gmail.com>
Date:   Sun, 3 Oct 2021 19:28:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <754f3aaeae85cdc9aec0a7b609803a0281e1fabb.1633191885.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/21 10:41 AM, Andrea Claudi wrote:
> diff --git a/configure b/configure
> index 7f4f3bd9..f0c81ee1 100755
> --- a/configure
> +++ b/configure
> @@ -504,15 +504,28 @@ else
>  			--include_dir)
>  				INCLUDE=$2
>  				shift 2 ;;
> +			--include_dir=*)
> +				INCLUDE="${1#*=}"
> +				shift ;;
>  			--libbpf_dir)
>  				LIBBPF_DIR="$2"
>  				shift 2 ;;
> +			--libbpf_dir=*)
> +				LIBBPF_DIR="${1#*=}"
> +				shift ;;

We should be able to consolidate these into 1 case like:

			--libbpf_dir|--libbpf_dir=)

and then handle the difference in argument style. e.g.,

			LIBBPF_FORCE="${1#*=}"
			if [ -z "${LIBBPF_FORCE}" ]; then
				LIBBPF_FORCE=$2
				shift
			fi

			....


>  			--libbpf_force)
>  				if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
>  					usage 1
>  				fi
>  				LIBBPF_FORCE=$2
>  				shift 2 ;;
> +			--libbpf_force=*)
> +				libbpf_f="${1#*=}"
> +				if [ "$libbpf_f" != 'on' ] && [ "$libbpf_f" != 'off' ]; then
> +					usage 1
> +				fi
> +				LIBBPF_FORCE="$libbpf_f"
> +				shift ;;
>  			-h | --help)
>  				usage 0 ;;
>  			"")
> 

