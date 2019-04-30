Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5DAFFC3
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfD3Sa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:30:26 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36584 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfD3SaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 14:30:25 -0400
Received: by mail-pf1-f195.google.com with SMTP id v80so2886732pfa.3
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 11:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SZsIi7ZjjZm8D3+PhFs6hoju1kSeRpgqe8lpVgqQ4tM=;
        b=uzQQHvvgx7SxzjbnK7MHj/H5gismsipD1NGLxccBJ0Ar7LFxfNDkfyT3oQHtbYdyPL
         LrzINPwLvPdFaapmkulywCAOxGig8XYT2P6QF3UgN8TpTVdxU+I/eeUtRiVI6CPCHrqu
         vQC+MvB/ZiCzW+6fHjbBEWuDrNmAC+YtKIZjeSA8uZbwjllCy3AtTZPJU5LLs2mGX06H
         HFG5jsp9j2+Fm/I124TwbX3d3ffJprttH+gp0tWx7SqXY5hyOZgFWbl4hmDipVvxpGKH
         wkDsSjj9NoxG2pfuMz8Sj+7Q8fjR6GghV6xQHeIx1Z1xwfHwUNkFlWrRJ6nbOYgVkmMG
         M1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SZsIi7ZjjZm8D3+PhFs6hoju1kSeRpgqe8lpVgqQ4tM=;
        b=Ftju+NZ2wxgrV6/vP042p3w6q243chINbJJ0lGJ4auiixCKT6i2nbJXL+ArLfiH6t0
         oZfMftYuQHS0ZjDFTklEq6m5pauMlRdRrO7gAlFsG1ZUgowp9IlM2PhC3vKQWWxOnuBr
         sRDfkR4AU51My+YZ95F30tbOuPUJU7I8dWb9xEP+LIIsuEY6k6pHi2qsCcgofBjs8Zkb
         lkThne85okC0ueNYCXYJBBbqtaZhM6OX07p2mTjCqm7GE6m2uhN8NdIH2JiVItLCTqcx
         1gEhhmw78lk/THxQAHQYrrOSZAcr5xxuYK33jCfLI7154Z8JDMvsMtEWpB0VB26uEY6w
         y6Xg==
X-Gm-Message-State: APjAAAVcyrGVnl0r8hj2DlOQdRdvXyZxMPTM+39QDLAJYM0yMRNhnM3b
        k+CeEzSPSzWNv/F2vQQkXcPsKym2
X-Google-Smtp-Source: APXvYqzbqzh8VD7Tcxtom6IpNeUdAQTY+g1tG8NJqe4b2EwHErdVdWWNnmdBI7QGOUPDOrSVJOi9sw==
X-Received: by 2002:a63:e10b:: with SMTP id z11mr67111818pgh.46.1556649024205;
        Tue, 30 Apr 2019 11:30:24 -0700 (PDT)
Received: from [172.27.227.169] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id s198sm30220538pfs.34.2019.04.30.11.30.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 11:30:23 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ss: add option to print socket information
 on one line
To:     Josh Hunt <johunt@akamai.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <1556227308-16057-1-git-send-email-johunt@akamai.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7f3e7f62-200c-fba3-96b1-f0682e763560@gmail.com>
Date:   Tue, 30 Apr 2019 12:30:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1556227308-16057-1-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/19 3:21 PM, Josh Hunt wrote:
> @@ -4877,6 +4903,7 @@ static void _usage(FILE *dest)
>  "\n"
>  "   -K, --kill          forcibly close sockets, display what was closed\n"
>  "   -H, --no-header     Suppress header line\n"
> +"   -O, --one-line      socket's data printed on a single line\n"
>  "\n"
>  "   -A, --query=QUERY, --socket=QUERY\n"
>  "       QUERY := {all|inet|tcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|netlink|vsock_stream|vsock_dgram|tipc}[,QUERY]\n"
> @@ -5003,6 +5030,7 @@ static const struct option long_opts[] = {
>  	{ "kill", 0, 0, 'K' },
>  	{ "no-header", 0, 0, 'H' },
>  	{ "xdp", 0, 0, OPT_XDPSOCK},
> +	{ "one-line", 0, 0, 'O' },

shame 'o' can not be used for consistency with ip, but we can have both
use 'oneline' as the long option without the '-'.

