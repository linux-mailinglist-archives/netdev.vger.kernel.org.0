Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AACE183B4
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 04:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfEICYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 22:24:17 -0400
Received: from mail-it1-f177.google.com ([209.85.166.177]:39000 "EHLO
        mail-it1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfEICYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 22:24:17 -0400
Received: by mail-it1-f177.google.com with SMTP id m186so942963itd.4
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 19:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IDPcFKA5MtCrzIVgvF9q+q9/c3hm345FkRjqDlvkYug=;
        b=vP7iz978xls0kT3fX9im9fIceAaiWBDCMZkY/BubGgfkOkC89RkP+lse6oB3EQDW6z
         UzhNRSseHhWp6PhqyNNIRs0jfkX3qpZp0SBZ3bJjprNxeSy0ubCTxFuGYmHjTcWqtLoW
         jJ5qj05jpuo2Wq0x7anUuxR8BbRvsqBUJb+2AibyS3SJVbZyYqALwtLyuA3YI0DfbDJ+
         mlneRq0XL3f4QwwEcNVEO1d3vp9vxl0oune8wwZrbml7HweH4ajWO6NVt6szg7nMo2lH
         bOXgKcgWFZ6d9NDsbT2hsACOO5uRwkIfJ7tgmUfayCyHqMw1Ahlub6oCvjw1uT9c9drD
         F5FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IDPcFKA5MtCrzIVgvF9q+q9/c3hm345FkRjqDlvkYug=;
        b=kRljPtAEW+Mhuq4Y+8uYyQYmrJH8xeasaPRJk4eWbzbcuwPZAO4u/dRWvOvhuJgvRT
         ycjoDHwWsZnMvT9PIzkB82RcOxVwvGkA8qeIw4t1sDEXMjP2swd4AuJdOXwL5ys2UExJ
         hfAHP9ocIlkoQHXGArcfaCDV6FOCYsfsuu7+Gk0pWuFkN0b5SvtqFSzsdQsCqQfFCTTQ
         rldwNi3bzhJ4OuL71uHqZ5S9x2xURVoKXSljNC+i7wYqSsH0eAqPRyu+MenUJxRmp/Pp
         HFfCXEBy147QmsLKzDSBt4hwF9Oc7IsqXzgrazWNibIFt5so6dMdxG4Qr2xOTo03mOJc
         vccg==
X-Gm-Message-State: APjAAAX/CQhg6A2se188LCUMYrL48ERuFSmXnjNJzggi6WKJh/gfIHUN
        Zev9OMk7k+5aRJcpy+UgX/E=
X-Google-Smtp-Source: APXvYqxtgRD3BZt0tkaSk7aabRwqZnLeVV41aj/5eT/uH9frcCmDjyDozrbHqtqafBpasag/KQyezQ==
X-Received: by 2002:a24:65cd:: with SMTP id u196mr941792itb.74.1557368656386;
        Wed, 08 May 2019 19:24:16 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:65b3:9adf:de14:33a7? ([2601:282:800:fd80:65b3:9adf:de14:33a7])
        by smtp.googlemail.com with ESMTPSA id s6sm359768iol.41.2019.05.08.19.24.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 19:24:14 -0700 (PDT)
Subject: Re: [BUG][iproute2][5.0] ip route show table default: "Error: ipv4:
 FIB table does not exist."
To:     emersonbernier@tutanota.com
Cc:     Michal Kubecek <mkubecek@suse.cz>, Netdev <netdev@vger.kernel.org>,
        Stephen <stephen@networkplumber.org>,
        Kuznet <kuznet@ms2.inr.ac.ru>, Jason <jason@zx2c4.com>,
        Davem <davem@davemloft.net>
References: <LaeckvP--3-1@tutanota.com>
 <f60d6632-2f3c-c371-08c1-30bcb6a25344@gmail.com> <LakduwN--3-1@tutanota.com>
 <0e008631-e6f6-3c08-f76a-8069052f19ef@gmail.com>
 <20190324182908.GA26076@unicorn.suse.cz>
 <20190324183618.GB26076@unicorn.suse.cz>
 <26689b18-e0f1-c490-7802-4256f12aa5e2@gmail.com> <LdsgQO---3-1@tutanota.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e2cde188-61da-f03c-a6ee-eecffefb7a9b@gmail.com>
Date:   Wed, 8 May 2019 20:24:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <LdsgQO---3-1@tutanota.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/19 7:17 AM, emersonbernier@tutanota.com wrote:
> Hi, 
> 
> are those changes planned then? I don't see anything in repo
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/log/
> 

I have not taken the time yet. Feel free to submit a patch.
