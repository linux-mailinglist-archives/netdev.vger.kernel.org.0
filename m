Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2962563CC7
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbfGIUgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:36:37 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44399 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729179AbfGIUgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 16:36:37 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so46037766iob.11
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 13:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6m7K62uIkNdn9JzBs9gvpn8zso5q4eFW2shRH6A/EWk=;
        b=XgyJHtmnh8xT3uxM453EwoHyGyyl/430CnJfU1twLQt+DCfY6Jom3M6tTraGwILW8C
         oqmKhDwz3xjgsD/3ZJYvOc951HF2N56lr9Mwo8amir4P+wAdXswHHyQbayPcnXgy2sIg
         oPEciUlvHqmxeVWZ1vwzwPjEYw5LyALBfab6I82wdM2lx7eCvZNnmU/ezOhnO4MNh9Jl
         zlXF49LAPA+A27t6+uJSblhltWzX4VpydgygnEL7OAYGcd3POylTYbVbGWLjyxjFTEPQ
         xx0Np+vsJXcHbP8RIYQ0vnAl0BbrhsDvelyqXK0psNfN0sNyAgARBm9UtEx1m5r6pasG
         ZP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6m7K62uIkNdn9JzBs9gvpn8zso5q4eFW2shRH6A/EWk=;
        b=ZGG8hsKUFGPoJnOYEgXbf+btk0nEngWHuXHrp3KllhPRy093S5QRKchdJdj8UVppJe
         fqcAifjNRJ5XYvDXst+GOgtPxTazTnbw3MBST3TfZ5RiKdATRCO4FtgOHoXJ8yYKIg4w
         xea7djfsGgQAuitZXWkJuPHadlTRkwGR4m41esaEJ+0UniYnmVzhblrQA8+hS+Hyc5TR
         MBFVT9l7qLZQ2kcXdlZaepn5nQSvPDqCwZ0TifH4j+Q9aQvZZ8iafs4oOXIFcpxrbx2X
         RI7xNbhifXN8dR7pqhpR3yczMPt+wv5XJ//EItmtNIOJzaWREKRwLR7rJQJ/H+qL6Qyu
         FlRg==
X-Gm-Message-State: APjAAAW1GOe9gXI/RR2vh711UDVxdrpQqK4Y5Vn9Q16A4zp3DNRvzIsb
        2sjs/0n4aKXN3kgJRqR3tqY=
X-Google-Smtp-Source: APXvYqx1tHR0/2y3kES9wXX6DCbBYY3LVsXKtpkJljYL7p+IIMlixEky1yt3F/HmBLmF9me0fbridQ==
X-Received: by 2002:a02:b78a:: with SMTP id f10mr31298823jam.5.1562704596271;
        Tue, 09 Jul 2019 13:36:36 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:c0e1:11bc:b0c5:7f? ([2601:282:800:fd80:c0e1:11bc:b0c5:7f])
        by smtp.googlemail.com with ESMTPSA id m4sm35229735iok.68.2019.07.09.13.36.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 13:36:35 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 2/3] tc: add mpls actions
To:     Stephen Hemminger <stephen@networkplumber.org>,
        John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        xiyou.wangcong@gmail.com, willemdebruijn.kernel@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com
References: <1562687972-23549-1-git-send-email-john.hurley@netronome.com>
 <1562687972-23549-3-git-send-email-john.hurley@netronome.com>
 <20190709100051.65bd159d@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f202a7ef-909b-1c0c-2a75-10d989b4923f@gmail.com>
Date:   Tue, 9 Jul 2019 14:36:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190709100051.65bd159d@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/19 11:00 AM, Stephen Hemminger wrote:
> On Tue,  9 Jul 2019 16:59:31 +0100
> John Hurley <john.hurley@netronome.com> wrote:
> 
>> 	if (!tb[TCA_MPLS_PARMS]) {
>> +		print_string(PRINT_FP, NULL, "%s", "[NULL mpls parameters]");
> 
> This is an error message please just use fprintf(stderr instead
> 

skbedit, nat as 2 examples (and the only 2 I checked) do the print_string.
