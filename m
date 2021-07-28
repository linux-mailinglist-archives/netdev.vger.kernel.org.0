Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7A33D971D
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 22:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhG1UwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 16:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhG1UwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 16:52:22 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7800C061757;
        Wed, 28 Jul 2021 13:52:18 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id b9so4073667wrx.12;
        Wed, 28 Jul 2021 13:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PUAw6z5Mv2Gc2MTPDaFS8HQXeD9s7MU+i2BPK1JVR3k=;
        b=ERum8YtVoz22rlJfSAMNFjru7xCCFlIncst5ebw/3Vx1lWzxJFdMcestrTlYY5SRjY
         rVwimvYmeUZnAplwOnCEglFuXMya/6TZo8szaiTVj7T6MeaGE6Jlw62KInGdKAi2DN3K
         ZK7EKOu27l5XFz/FrjbgxZMAu2cUzPmH7xqaw6mz8AZKPK+v6CGf0uqXVY+RcBCZ61j0
         6o/3/7YL4PtRXJ5lyOd9mCy4iacjnIQe+cqyIDpo6/m5AUr17ubXq+XMgf3ItKEq2swT
         ylIafEEmaYs/8hevwWCNUsMimSkbDPUoWNf+r7LKYD37o7Ze1XC+NNPXabRuA2VTTlZP
         tyuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PUAw6z5Mv2Gc2MTPDaFS8HQXeD9s7MU+i2BPK1JVR3k=;
        b=uUCHL7C52H7/AF/JMwWIs9ezxrzFPRNZiSYCGODl35rthsXKWaHFBurM2O0QOULWh7
         l40ghFYa0ElBzM8mV9AhsbhtpkImXl0CjjT9sZl3/5ytezbNfiy+rkUmP31JWXpjSyCB
         i5BbS7brS3CR2o0H4PIrg6EJ0wE47U5vNsobrkANakyBFM1ZipLKFotkMGCySphwXL3j
         cUjssNygek2IbK3lqw9hjf2jIKk/x0XqDOT05zw4K5Bg1oUZMloRF6rp8EYvXotG/aBt
         3pdOG59tk3vfJsIkGw+pwMjgFL00QOZH6x5C5g5sXAAHGQyA66Ov99/ItOYpdrDWRCt/
         r3Lg==
X-Gm-Message-State: AOAM530u8b5m5GXZTL5IkKy/kzuV1b2EQhsjEGwXVG9KzZkbHhziSuek
        AH1Mi0ecHQeV6+dzjfErFA3MQfzODyQ=
X-Google-Smtp-Source: ABdhPJyvd7DAw8cIvkEcBYZ7k2TywI17Nq42UxTn/6MyUe1NtfuPiFOdAwMLcSCXJyt5x/qUuolCWQ==
X-Received: by 2002:a05:6000:1d0:: with SMTP id t16mr178657wrx.213.1627505537556;
        Wed, 28 Jul 2021 13:52:17 -0700 (PDT)
Received: from [10.8.0.150] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id c15sm640429wrw.93.2021.07.28.13.52.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 13:52:17 -0700 (PDT)
Subject: Re: [PATCH] packet.7: Describe SOCK_PACKET netif name length issues
 and workarounds.
To:     Ralf Baechle <ralf@linux-mips.org>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        Thomas Osterried <thomas@osterried.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org
References: <YP/Jcc4AFIcvgXls@linux-mips.org>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <a050e248-af45-0678-b25c-27e249fb5565@gmail.com>
Date:   Wed, 28 Jul 2021 22:52:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YP/Jcc4AFIcvgXls@linux-mips.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ralf,

On 7/27/21 10:53 AM, Ralf Baechle wrote:
> Describe the issues with SOCK_PACKET possibly truncating network interface
> names in results, solutions and possible workarounds.
> 
> While the issue is know for a long time it appears to have never been
> documented properly and is has started to bite software antiques badly since
> the introduction of Predictable Network Interface Names.  So let's document
> it.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Thanks for the patch!
Please see a few comments below.

Thanks,

Alex

> ---
>   man7/packet.7 | 31 ++++++++++++++++++++++++++++++-
>   1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/man7/packet.7 b/man7/packet.7
> index 706efbb54..7697bbdeb 100644
> --- a/man7/packet.7
> +++ b/man7/packet.7
> @@ -627,6 +627,34 @@ extension is an ugly hack and should be replaced by a control message.
>   There is currently no way to get the original destination address of
>   packets via
>   .BR SOCK_DGRAM .

Since the bug spreads across multiple paragraphs, maybe consider adding 
a subsection of BUGS to keep it organized?

> +.PP
> +The
> +.I spkt_device
> +field of
> +.I sockaddr_pkt
> +has a size of 14 bytes which is less than the constant
> +.B IFNAMSIZ
> +defined in
> +.I <net/if.h>
> +which is 16 bytes and describes the system limit for a network interface


See the following extract from man-pages(7):

$ man 7 man-pages | sed -n '/Use semantic newlines/,/^$/p';
    Use semantic newlines
        In the source of a manual page,  new  sentences  should  be
        started  on new lines, and long sentences should split into
        lines at clause breaks (commas, semicolons, colons, and  so
        on).   This  convention,  sometimes known as "semantic new‐
        lines", makes it easier to see the effect of patches, which
        often  operate at the level of individual sentences or sen‐
        tence clauses.


> +name.  This means the names of network devices longer than 14 bytes will be
> +truncated to fit into
> +.I spkt_device .
> +All these lengths include the terminating null byte (\(aq\e0\(aq)).
> +.PP
> +Issues from this with old code typically show up with very long interface
> +names used by the
> +.B Predictable Network Interface Names
> +feature enabled by default in many modern Linux distributions.
> +.PP
> +The preferred solution is to rewrite code to avoid
> +.BR SOCK_PACKET .
> +Possible user solutions are to disable
> +.B Predictable Network Interface Names
> +or to rename the interface to a name of at most 13 bytes, for example using
> +the
> +.BR IP (8)

You probably meant s/IP/ip/

> +tool.
>   .\" .SH CREDITS
>   .\" This man page was written by Andi Kleen with help from Matthew Wilcox.
>   .\" AF_PACKET in Linux 2.2 was implemented
> @@ -637,7 +665,8 @@ packets via
>   .BR capabilities (7),
>   .BR ip (7),
>   .BR raw (7),
> -.BR socket (7)
> +.BR socket (7),
> +.BR ip (8),
>   .PP
>   RFC\ 894 for the standard IP Ethernet encapsulation.
>   RFC\ 1700 for the IEEE 802.3 IP encapsulation.
> 


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
