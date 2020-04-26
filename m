Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366BA1B9213
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 19:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgDZR0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 13:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgDZR0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 13:26:10 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4C0C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 10:26:10 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id i16so14490469ils.12
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 10:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kxiV8Pry+O550WXGviFieXpjatQaJdMHLa3QGv9ddhI=;
        b=tKMmwnBXIlYxWQmn03i155JQi/FM2RnYmyFe/+QWyCg4XBCjE5ySTZlQhmlzfa0qjZ
         l/CKrKGzbpugukEUAtq6LCyYZVTD5+gYT7gN/2XvuSBn3q4fA7TK0rVVJoQvAG2+F4hZ
         6WjfjAA4GtmwLyLMVLw14BftVUV7qpBmgcmcxOapb/cujPZW6PKg9eXQ/xjsi8O+74mV
         79X+Vucw0EQ8xOve5/+zJY66QMFT1sQ1iiiOdalLAzfIoxlKdvnu3mldm9QK4CqXXqtH
         omePeKvdawDidfF/+PmvgnZFcNmEda489QzVjrjwsoKRkvkKdA2GYFHVEwSdPWTDAFih
         sdAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kxiV8Pry+O550WXGviFieXpjatQaJdMHLa3QGv9ddhI=;
        b=Q89Xtwdlh5Czj+7g3Pd4ut5qPzYv9ifMzLeOTfCFfXXvhhZtkXNVOd6bx5101OgLhF
         zOiidmZxY1afAGowmkPwa/7Btf3vx70vk3voVHynXNKnaYMjyDiMfKYN0MzCG80bZYtQ
         fLMJsFYrFB35cgP9cOLa6nL9BGHAwUuDNiKBF1EC4961lxVAqCphNNRGlNupUPnhvHAZ
         N4cz230K617LLYKhWVWwzn9kNaXl9QnCf1WA5VMjmiTwj8vOuuG77K9hnbCptmuGcqB3
         rV3jwJz6EqpR7KgJ5ncrnQXuxr7EfiAAp9w/DKN/pXTPlSyCgKgSYfa68/t5zjIQ/SVX
         Ixdg==
X-Gm-Message-State: AGi0PuZGKPT8gDHsQHpv2ypDVVOfPhSUK7JbvUdgSqpSK4FW9F3AB5Ct
        11louX00lbkQmXgJPQ/nizfmBwW/
X-Google-Smtp-Source: APiQypJOvvt7L5gNA5eT0Hvqdh3/T3guRphb2Qrs84rijSUFew7aKs7SDD4FbxpuJ2jly3LvEYOd+g==
X-Received: by 2002:a92:414d:: with SMTP id o74mr18318282ila.266.1587921970042;
        Sun, 26 Apr 2020 10:26:10 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id k11sm4148614iom.43.2020.04.26.10.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 10:26:09 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/3] ipv4: add sysctl for nexthop api
 compatibility mode
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        bpoirier@cumulusnetworks.com
References: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
 <1587862128-24319-3-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <537bdf7c-a5cf-aae6-cf34-c917ab4fcbde@gmail.com>
Date:   Sun, 26 Apr 2020 11:26:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587862128-24319-3-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/20 6:48 PM, Roopa Prabhu wrote:
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 81b267e..a613ecf 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -711,6 +711,13 @@ static struct ctl_table ipv4_net_table[] = {
>  		.proc_handler   = proc_tcp_early_demux
>  	},
>  	{
> +		.procname       = "nexthop_compat_mode",
> +		.data           = &init_net.ipv4.sysctl_nexthop_compat_mode,
> +		.maxlen         = sizeof(int),
> +		.mode           = 0644,
> +		.proc_handler   = proc_dointvec
> +	},

I think you can make this a bool.

	.proc_handler   = proc_dointvec_minmax,
        .extra1         = SYSCTL_ZERO,
        .extra2         = SYSCTL_ONE,

rest looks good to me.
