Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D098A297DC8
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 19:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762603AbgJXRgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 13:36:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1762592AbgJXRgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 13:36:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603561002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EdyYDxHWSuMzobNrDVLd93fuCbB3LRhd4pgq6NGCbDw=;
        b=g8hbqQQli2pdApdeQJx8Sg+tgjU3cJhxqc0Qu7fQHv+vrDBVQKoiDIfCgqfPsVlKXHSA9G
        KdJzbT054qvOxrk6dJDCC3kMh4Lz54FyL8NNVh6t5egiNhhgcKM98ndknfpjGfymvQQekQ
        R6eECB3SHDhjiLLO6IxKVeX2G6YgsNs=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-zue--7fGP2aVrhSZ6POPiA-1; Sat, 24 Oct 2020 13:36:40 -0400
X-MC-Unique: zue--7fGP2aVrhSZ6POPiA-1
Received: by mail-oo1-f72.google.com with SMTP id v18so3487768oou.10
        for <netdev@vger.kernel.org>; Sat, 24 Oct 2020 10:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=EdyYDxHWSuMzobNrDVLd93fuCbB3LRhd4pgq6NGCbDw=;
        b=WSwQ5PcS3BGOuzOEZFfMTpspDop0LS6MRRfoH9dLot0qiIcR4Bmes3t50WZX/hUfe3
         EfIaanQs0tiTf88FfmUT2P/L4pwvXQooIeiOHuWB0i0W4O5RGDKlqu+lqXcBHB3Z8V/C
         tWjFj7VN3n2NZm3H9+XSQW259R50+bgaxIN+jQTv2stTnMvdwN0T3ldIE3RxYKSJcaS4
         TmYo4UoIH2ecqhjzv16olyljez4n4J15JX5CBD1xVcVhqWU52Wa8hgX96CwPL6aBAhXq
         EJw8ARseyzCDYt+vfxjk5nE+DQQiaezL1KUIqoZ2zf7StAsN8zh21iBwlsyAhWMVm9Xh
         nf5w==
X-Gm-Message-State: AOAM532dGxLnk8/220IpWllT/SmoYupxppE1RML5Q4VDBPDSDhdf3uec
        bZeliAaO3SjlQmNMRcShzuA/28RhcrexjmRqBzfnE0c+frS6zj/SHennUmux7hCu540eAh1J6sh
        0X0VThnA2m0Rk2+TD
X-Received: by 2002:a9d:d0e:: with SMTP id 14mr7275078oti.190.1603560999879;
        Sat, 24 Oct 2020 10:36:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzA1g+hrGHqYFbNjUkSBrlVOQ0tmVxbXfEiaL9MI5bHd+wNyHUj8wLulQWz5JOLUxnRMjrw7g==
X-Received: by 2002:a9d:d0e:: with SMTP id 14mr7275059oti.190.1603560999692;
        Sat, 24 Oct 2020 10:36:39 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id r188sm1531524oia.13.2020.10.24.10.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2020 10:36:39 -0700 (PDT)
Subject: Re: [RFC PATCH 4/6] ethernet: m10-retimer: add support for retimers
 on Intel MAX 10 BMC
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Xu Yilun <yilun.xu@intel.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        mdf@kernel.org, lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        lgoncalv@redhat.com, hao.wu@intel.com
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-5-git-send-email-yilun.xu@intel.com>
 <dbc77c18-8076-bcfd-b4f7-03e62dc46a97@redhat.com>
 <20201024163950.GJ745568@lunn.ch>
From:   Tom Rix <trix@redhat.com>
Message-ID: <a4415cfa-b43b-8606-e944-edeb00de06fc@redhat.com>
Date:   Sat, 24 Oct 2020 10:36:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20201024163950.GJ745568@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/24/20 9:39 AM, Andrew Lunn wrote:
> On Sat, Oct 24, 2020 at 08:03:51AM -0700, Tom Rix wrote:
>> On 10/23/20 1:45 AM, Xu Yilun wrote:
>>> This driver supports the ethernet retimers (Parkvale) for the Intel PAC
>>> (Programmable Acceleration Card) N3000, which is a FPGA based Smart NIC.
>> Parkvale is a code name, it would be better if the public name was used.
>>
>> As this is a physical chip that could be used on other cards,
>>
>> I think the generic parts should be split out of intel-m10-bmc-retimer.c
>>
>> into a separate file, maybe retimer-c827.c
> This driver is not really a driver for the Parkvale. That driver is
> hidden away in the BMC. So we need to be a bit careful with the name,
> leaving it available for when somebody writes a real Linux driver for
> retimer.

Then the parkvale verbage should be removed.

And the doc ascii diagram be updated with a

+---------+

|  BMC    |

| retimer |

+---------+

Tom

> 	Andrew
>

