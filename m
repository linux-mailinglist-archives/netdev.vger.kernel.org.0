Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485172B3C22
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 05:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgKPEd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 23:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKPEd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 23:33:28 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7B4C0613CF;
        Sun, 15 Nov 2020 20:33:28 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id j23so37675iog.6;
        Sun, 15 Nov 2020 20:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/27BslBqc5GZo7q1EJdT3t6c0WkFn4/uMgY9xh+IEH0=;
        b=cypHqYSZlfipIz3a6yFFj8CSFwD04VtKxsp8CHmEfC+Bg1XuNcULx4M4ZG5dq5cKD/
         RZEb8lacge/gYWWf4tGisnVbceWQOPgtLaMsF4Wh+vkRwSrFDOHDSh7hUij1pWqncGKy
         qmvo0HYVOXxAu+vYawBH3KfURTVfBMUcGmfPmNvcDo8HV6osqRHnPjeQNJHsSvBdPU8+
         JSKxnHhItGVXxdPWP/TWr3vKPTvvdsKz1fadWnuR8xORQSr/4hJzyAWECn+WfTn6aU3L
         sGEB5a3QOmPz3+q1GlU03vHtJBO/nJAZr+lRdhXBRDDVwzKiqJ/SO7SQDJ12GziAiMqD
         bX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/27BslBqc5GZo7q1EJdT3t6c0WkFn4/uMgY9xh+IEH0=;
        b=jQHoGrRGwesm8aQYipHQk8CQH+YTSgOdn/b6Xj68e/1uzQiVPQorSaHHkWyKcVP+10
         DSC0rYJDReEuBq32jqbaym8XJiEvnSsU9lSdxPV7epr+wTF7TWf8MhVZ20mqpzNhuWMv
         5ZALmjXgODcd0yP2HFfSw7lBck4AxiNqZkMYnEw4AxIFymIjBILnknZ5uuRwugfWBYKy
         3wljgPMU00GFnr80FkDbDGLh7ypLpGoenFfCcJAIW/vHF+/5D5JJBNp2fpdT/JZbZ1TT
         8TthcrpSah+6bnzzSbs2EUf7nrUVOO3SFF5qqauN6dEaSSBEqM2glYDiVRiiUFli2FFF
         /oJw==
X-Gm-Message-State: AOAM533hJK+FY8gVx0SMEU+5z36aZZSG/J08G0zGwsjxCuC8u/gmFy/L
        ozUaIdZ5xUjN6tpvSjWdgDg=
X-Google-Smtp-Source: ABdhPJwQnfMaQR02cUwFjrXwu0WPwmdsDdA3BxzXPNMJmDUmx9W5qsjfwe/i+B+vxXY8YUg6zXq+Aw==
X-Received: by 2002:a6b:5809:: with SMTP id m9mr6780983iob.186.1605501207540;
        Sun, 15 Nov 2020 20:33:27 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:1971:93b4:1291:ee0d])
        by smtp.googlemail.com with ESMTPSA id v85sm10639297ilk.50.2020.11.15.20.33.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2020 20:33:26 -0800 (PST)
Subject: Re: [PATCHv4 iproute2-next 1/5] configure: add check_libbpf() for
 later libbpf support
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201029151146.3810859-1-haliu@redhat.com>
 <20201109070802.3638167-1-haliu@redhat.com>
 <20201109070802.3638167-2-haliu@redhat.com>
 <8443c959-2ab5-0963-120e-b278e8bac360@gmail.com>
 <20201116043001.GG2408@dhcp-12-153.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9ee39336-aff3-22ed-7ca4-996f0233ab86@gmail.com>
Date:   Sun, 15 Nov 2020 21:33:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201116043001.GG2408@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/20 9:30 PM, Hangbin Liu wrote:
> diff --git a/configure b/configure
> index 3081a2ac..5ca10337 100755
> --- a/configure
> +++ b/configure
> @@ -5,7 +5,7 @@
>  # Influential LIBBPF environment variables:
>  #   LIBBPF_FORCE={on,off}   on: require link against libbpf;
>  #                           off: disable libbpf probing
> -#   LIBBPF_LIBDIR           Path to libbpf to use
> +#   LIBBPF_DESTDIR          Path to libbpf dest dir to use

DESTDIR as a name applies to an install script. I think LIBBPF_DIR
 is fine. You can enhance the description to make it clear.
