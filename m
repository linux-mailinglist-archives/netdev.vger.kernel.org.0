Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED66D4C186
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 21:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbfFSTbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 15:31:06 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37827 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfFSTbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 15:31:06 -0400
Received: by mail-io1-f68.google.com with SMTP id e5so710860iok.4;
        Wed, 19 Jun 2019 12:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OTPDBkCLe+rn37yNmxopVFQQaMHUyLf8iaXUpqyblqo=;
        b=FVrjDHRQQ4aHyshoymHdpZF3cj2NPfgyuaNIqUh8qNkOFKV4P9uhN5WBLqrg1qUh74
         3QuuwAZGR2fAwDidv70zduDox+emMb3PquoOjFINxRy8l7N7DjdXTHVRP0aBOulD9H5b
         cae0pArYYEla1mdPEVSFbwP0ohRixnNzDkX82Z6U41O0OJZIO2GKqkSbycWFfHl8egzO
         a0aQYmosH5FZCcqsqvuIG9RkgAG0wNHNJHjcXN4BfqZTawAjXHPt44RQYk2vptaD6LGx
         UK6Xe+wVXnSwXqQNMeLhZ/mRdzQ/UF1u+B8d3s7HWDzSkevhY+96U3slKhxLFiIvqOtb
         +OUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OTPDBkCLe+rn37yNmxopVFQQaMHUyLf8iaXUpqyblqo=;
        b=gg/3UA3h/SUMdeYle1/A542Sr0KMHg/J0cXn7KnorMrfEjDdF4egM4MxdYvgev6amQ
         YNCrlbRL15K5dRuSZSn9M8QcQgLSgJhKfa0yWlgpd+qr3jnVEDUDdKe6RtqrEJGouFJX
         ioKamSpz9QEDApo9prZ6pTVrzGgny0v0OTEsG0ux7E3IJr69ftacNnq+WH8DBeJZ/43H
         sazreD/0HB/ABqlH07dBs3S+8ekHnNTlUCmmWjBaPQ9pgAEfoBpboMB5ZZgkhBdyJmIv
         QzvsvTbX8ClX6jgcAe66unlmpWaNi6mxoc2+t/gkNd5vM44SIujD79mlNtVW2CpYfY6j
         SU8w==
X-Gm-Message-State: APjAAAWKpT5xPQczmoZVq1Aml3f2J8ClO8PbQKdSDZSHDPm858aOPkW+
        OzX3qIYwHfpxuSfp7WQfkbY=
X-Google-Smtp-Source: APXvYqxrDN3ddKmrDiHXCdDeekdCUrbRM1k6hbu9mfrdRvSP6xD/dX/HdkHdCOa9U5GtMHujgY0ecg==
X-Received: by 2002:a02:c918:: with SMTP id t24mr100216095jao.111.1560972665754;
        Wed, 19 Jun 2019 12:31:05 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:60fa:7b0e:5ad7:3d30? ([2601:284:8200:5cfb:60fa:7b0e:5ad7:3d30])
        by smtp.googlemail.com with ESMTPSA id q1sm17447407ios.86.2019.06.19.12.31.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 12:31:04 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2 2/2] uapi: update if_link.h
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz
References: <20190619141414.4242-1-dkirjanov@suse.com>
 <20190619141414.4242-2-dkirjanov@suse.com>
 <20190619104652.4c71c33b@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f17e6784-c021-ce7a-c64b-1868e6d8b609@gmail.com>
Date:   Wed, 19 Jun 2019 13:31:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190619104652.4c71c33b@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 11:47 AM, Stephen Hemminger wrote:
> On Wed, 19 Jun 2019 16:14:14 +0200
> Denis Kirjanov <kda@linux-powerpc.org> wrote:
> 
>> update if_link.h to commit 75345f888f700c4ab2448287e35d48c760b202e6
>> ("ipoib: show VF broadcast address")
>>
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> 
> This is only on net-next so the patches should target iproute2-next.
> 
> David can update from that.
> 

Make uapi changes as a separate patch; don't worry about syncing the
entire file. That patch is my hint to resync the kernel headers to top
of tree before applying the rest of the set.
