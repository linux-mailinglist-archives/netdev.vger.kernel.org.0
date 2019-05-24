Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E309C2A0F1
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfEXWE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:04:58 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46104 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729552AbfEXWE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:04:58 -0400
Received: by mail-pl1-f196.google.com with SMTP id r18so4661222pls.13;
        Fri, 24 May 2019 15:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YnnyVNqUxh2k/cxJmn0sG9tavfiNdKrpTqEXdJVnlro=;
        b=Upz4APO1cM07lMLyjajBRGcUaIxxWc2xSIZPv0yCdbKk3bgt8lhoMg/RBm5woTdxPr
         nACGQHxt104QMt3YOOh2M23sdsn8KzWP43N33VaglrLr0tP4Uc0GjOGD2Enlhex9VIQJ
         /yNsLnXqaY7H7SRuzusM6LohshAGdco0DOPG58aQuYHlVn+khi52A4xolC0Syz96GUlg
         AONdEtSU9gMyoKyKxxlCZ+f2GCXI1k7BJOOgckQPYpu5r3jPA7qyv80idWO6GzETPGKv
         Wo6lFlJbmAFy8PTdZ+uLnfhPiv7bcyUp6FDJfa9Qo2vVvj1pDoHAB6fMuQ+tsu1ZewBH
         2bYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YnnyVNqUxh2k/cxJmn0sG9tavfiNdKrpTqEXdJVnlro=;
        b=pfxKN3zAPReirnVmToZpIV4v+7tV/Ak2+nxzafvlHKZjwTsdo2/Jr8u7eAipS+lyEM
         +8t8jxxZ4GbpYv11Rgg0jBr5Ll+tb/Go5P5Xwe+Pf5GrFUJXjfByb15KSI6KzqWohd61
         8iHAu2LQ84+EkL4/t1LbUMfiSeGwjB5krwygMIusvdnOihD6t/QM/GIFzn16qZ5Mn7fh
         J//+zFU9WGQzxLGevA9gqDQe6w7l1iuWTdjUixuK/9en6b+WLtgFw1F0qSC5NIAyBap5
         37ElRdUiS5pT/c2EWKHkbiXgWozbnT6UjW5webZcPNq8oS6LGG7J45r1jUWcew+dYdbE
         dKTA==
X-Gm-Message-State: APjAAAX3IrWp9sRilSWvxgD/N2s3Q1mY/wQvVMTHoi/JlWd97N4az+KA
        odJdgYycAeh2oVAv4nwv+mXOZ5tz
X-Google-Smtp-Source: APXvYqypmiDhXsU+qDxVxiydwYZ6k6hTxblUTrBF2RHXWA3cgKgAk9DsWjvYxZl+U+7+y7nr6JubvQ==
X-Received: by 2002:a17:902:a70f:: with SMTP id w15mr39764422plq.222.1558735497195;
        Fri, 24 May 2019 15:04:57 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:59ee:6a57:8906:e2a1? ([2601:282:800:fd80:59ee:6a57:8906:e2a1])
        by smtp.googlemail.com with ESMTPSA id o7sm4736191pfp.168.2019.05.24.15.04.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 15:04:56 -0700 (PDT)
Subject: Re: [PATCH][next] ipv4: remove redundant assignment to n
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190524215658.25432-1-colin.king@canonical.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fece118c-22ca-30c5-51b7-b6e9dc56ae59@gmail.com>
Date:   Fri, 24 May 2019 16:04:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190524215658.25432-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/19 3:56 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer n is being assigned a value however this value is
> never read in the code block and the end of the code block
> continues to the next loop iteration. Clean up the code by
> removing the redundant assignment.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/ipv4/fib_trie.c | 1 -
>  1 file changed, 1 deletion(-)
> 

This looks right to me -- n should have been dropped. It is used in
fib_trie_free from which I created  __fib_info_notify_update but
__fib_info_notify_update does do the put_child_root or node_free, it
only walks the tree looking for relevant entries that need to send the
NEWROUTE notifications.

Fixes: 1bff1a0c9bbda ("ipv4: Add function to send route updates")
Reviewed-by: David Ahern <dsahern@gmail.com>

