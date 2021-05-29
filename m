Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1953B394D8D
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 19:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhE2RuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 13:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhE2RuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 13:50:23 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978FEC061574
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 10:48:45 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id i14-20020a9d624e0000b029033683c71999so6762501otk.5
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 10:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ve+azerB5ofCLIT6bPXG6qRcMengA4dRZMjJP8lZyJI=;
        b=gprx8oafCWRWWtIKvQCx+7Y1olm/E2Pd4MzBZ7VpQwTuQuoBF80PuBgAyc02MpUAIz
         jcWCuFt0PADAP1f/HlFs8qrV/G6uCEFaU4V+PyQnjbhPjP0GOvCfs6XQ1pgFYmS7ywDN
         +WkXhfP6OWsJA77rHP9ZxD/b3NC8872n/qWtb8kTPHnbbjGPDH4gg2UeQvi64r4igd3b
         63f1B/d1UlO5B6FXCIpJteSUs7KmRbZWD0GODte8yyGHk61oQnNUAuJRsOMapoAWiFJw
         7CfdeRcZQPIOomGLI9d8zI8ojC3VBmWms0jqYaNIhGHWLixt/p0zvwJeGuDofFd/oUiP
         S2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ve+azerB5ofCLIT6bPXG6qRcMengA4dRZMjJP8lZyJI=;
        b=ooI9gaK24xZepLIvolnyprukbNFfNOzgpcPbjSVd/capEoTdWU208GYnkehIhrJSK/
         ga/Lj6IVqtBXqGFDAeGsceMAe/vM+Li2jYSyCbmfTcp9seuk67xwldVGa8uwhWjSa7qF
         uqt+i1ypiGLTE2CSxxQUOTH3TC+AL+6YcB0cugl3Q8meRd9XXWuqcLRNXdq3niP0RybM
         ARk75x0v+C291kammnv04xeTNk3Gqo51po+eEaQeT3lh3LdAkVQLV6ICoCbIAqINtx+X
         Tgkg5x7oJbGIl28MXYcgTRDE6aNwYbj+YVA7LhWK+KMA5/wdatyfAHld4pppjqiM3aLa
         P1fQ==
X-Gm-Message-State: AOAM531TChfUJp5r9JRVS9HvhbqOlWch1/jObujB9sqpNzzzxnuPCBwe
        Mwgco3spSavvssaZR12fEOQ=
X-Google-Smtp-Source: ABdhPJzYDgJYpjkyDB2hos9KHW8VQTUyTh+R6xFoUoSLPIfZfaXE+QvcW6tlfxBxom/pSNMXkiYwoA==
X-Received: by 2002:a05:6830:1bd4:: with SMTP id v20mr12074183ota.101.1622310525072;
        Sat, 29 May 2021 10:48:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id v22sm1779826oic.37.2021.05.29.10.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 May 2021 10:48:44 -0700 (PDT)
Subject: Re: [Draft iproute2-next PATCH] configure: add options ability
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>
References: <20210528123543.3836-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <014bc2cc-f47c-d269-dad9-f04e8e3d30ef@gmail.com>
Date:   Sat, 29 May 2021 11:48:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210528123543.3836-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 6:35 AM, Hangbin Liu wrote:
> From: Hangbin Liu <haliu@redhat.com>
> 
> Hi David,
> 
> As we talked in my previous libbpf support patchset. You'd like to make
> configure with option settings. Here is a draft patch. Not sure if this
> is what you want.
> 
> There are also a lot variables that I not sure if we should add options
> for them. e.g. PKG_CONFIG, CC, IPTC, IPT_LIB_DIR, etc. Do you have any
> suggestions?

I think it is better to have command line options vs environment
variables. Command line options can be used with a usage / help function
to make it easier for users to learn or remember the config options.

That said, the environment variable approach should continue to work for
existing build scripts.

Your RFC looks fine to me. It would be easier to review if options are
converted with separate patches vs one big one.



> +while true; do
> +	case "$1" in
> +		--libbpf_force)
> +			if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
> +				usage 1
> +			fi
> +			LIBBPF_FORCE=$2
> +			shift 2 ;;
> +                --libbpf_dir)
> +			LIBBPF_DIR="$2"
> +                        shift 2 ;;
> +                --include_dir)
> +			# How to deal with the old INCLUDE usage?

if number of input arguments is just 1 and it does not start with '-',
then guess that it is old style INCLUDE.

Thanks for working on this.
