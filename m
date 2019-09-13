Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267D6B24B7
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 19:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388516AbfIMRlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 13:41:13 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:44915 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfIMRlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 13:41:12 -0400
Received: by mail-pl1-f175.google.com with SMTP id k1so13538465pls.11
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 10:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=S96mExpkV0cQaKnc1RoBMqOV4esZbo7h7Nmxq5LYVjU=;
        b=bP18oC8yDA/KV33FBC1er77P8tQk5AAU1zbfZalS1aLt5g3UKkgc1OSr5Eg0VvUSa/
         LZ4dUygt/RkBYRcmA1Phtv9dR3yAxoOQdJ1uFZeUL88E5VWUB+YW+fp+094VXYaGJ1Ka
         +PNITx+cXb/OGCiQ08Q3bJrizB3y+q0tybc9yDiexbDTW5o6txQ+8deQ1Po6fUhMuTBq
         vbX0bxi0ZARMQCXEzWOQ0TfLymyTjE8xmjBQS+QB584r4Ca8SdMlVeS+EAvrS3rt09pK
         cQbOVWuXcGsYZdXwhkX8C99cRLsv2Y2uMkP0t1VtUixxqf+83k8UrBad4wlGzGp4H+zS
         bUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S96mExpkV0cQaKnc1RoBMqOV4esZbo7h7Nmxq5LYVjU=;
        b=Q/JVZxItcTuGUZw8cuMBp8uwdyQMfRH8Xm7+Xi17llSUQL+YyLmJ8OhVikmskxtEhe
         p8Bgy4u9TCurpASmPubyEIOsPcIZxq6oOpizfWdI6OWgT4AxpoXLLWhfdAfohUs0+X+t
         9giIb6MBthFD4+AoH+bH5sX66c6p2BCj7K5grfb+fLBHO5h5nNrICUSQltUurn6UY1JO
         SQUPfE7Zu/Zw4YKI7mor8wItiUtYUmr5760MpQChSovmlpR5Hy07cldLDqF5E7KMINYb
         CDSJVAKTx6GusNXAnW+vifIMvH6jqJTnfPwXXHqZO9HhYfJIUDFTjMlYgyeEr/tdo/1s
         4dsQ==
X-Gm-Message-State: APjAAAW/gyWP9D8yzs/z7b6ft3MxRmZFEUaXWzEvYKS+kd76lMEhCq7Q
        z2KBb4Qo7XFDK3o5zdaqTozXvdDg
X-Google-Smtp-Source: APXvYqzkA8WmWqYqvkZMOcb+bdWFfEuv89/P2KPA3bin/AdVggoccXepv+EFBWJcCGmf9iXnemqyRQ==
X-Received: by 2002:a17:902:5c3:: with SMTP id f61mr47059937plf.98.1568396471756;
        Fri, 13 Sep 2019 10:41:11 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:f0f8:327c:ea9:5985])
        by smtp.googlemail.com with ESMTPSA id 6sm45365027pfa.162.2019.09.13.10.41.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 10:41:10 -0700 (PDT)
Subject: Re: VRF Issue Since kernel 5
To:     Gowen <gowen@potatocomputing.co.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <b300235a-00f8-0689-8544-9db07cbd1e21@gmail.com>
 <CWLP265MB15547011D9510DEA6475B469FDB00@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <73b535a0-1f0c-14a9-95ab-faef66ae758b@gmail.com>
Date:   Fri, 13 Sep 2019 11:41:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CWLP265MB15547011D9510DEA6475B469FDB00@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ FYI: you should not 'top post' in responses to netdev; rather comment
inline with the previous message ]

On 9/12/19 7:50 AM, Gowen wrote:
> 
> Hi David -thanks for getting back to me
> 
> 
> 
> The DNS servers are 10.24.65.203 or 10.24.64.203 which you want to go
> 
> out mgmt-vrf. correct? No - 10.24.65.203 10.25.65.203, so should hit the route leak rule as below (if I've put the 10.24.64.0/24 subnet anywhere it is a typo)
> 
> vmAdmin@NETM06:~$ ip ro get 10.24.65.203 fibmatch
> 10.24.65.0/24 via 10.24.12.1 dev eth0
> 
> 
> I've added the 127/8 route - no difference.

you mean address on mgmt-vrf right?

> 
> The reason for what you might think is an odd design is that I wanted any non-VRF aware users to be able to come in and run all commands in default context without issue, while production and mgmt traffic was separated still
> 
> DNS is now working as long as /etc/resolv.conf is populated with my DNS servers - a lot of people would be using this on Azure which uses netplan, so they'll have the same issue, is there documentation I could update or raise a bug to check the systemd-resolve servers as well?

That is going to be the fundamental system problem: handing DNS queries
off to systemd is losing the VRF context of the process doing the DNS
query.
