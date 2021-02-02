Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBE530B5C5
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 04:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhBBDUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 22:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbhBBDUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 22:20:50 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB31FC06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 19:20:10 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id f6so18483041ots.9
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 19:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qnVo4gynOx1Kz0nwhyIoVdeS41bHGw9/XhPKalG9nQg=;
        b=es5ojrxvQKPZf9Q2Vqnl5lvFctHsIPdwIF6TqGo19qiHZtAXjdNdje3brCmUjQg12W
         4vrcGuTbsAge4nHv/EIZK5RMdqYtJWzfPSUd1Wi63UUS9nNswOhNTvu0TgZOi8i0Uflg
         Xom4hERe5jOkAumgRIzEx7qDEg8ik+ASZLkkfU3t+n9dQLu5KeUFd5L8BW24iyZ4qpWU
         VxIZI04SUJlaW8MRV93qG8XW966qMBRg42EoiAXhL0nUpl+qS9t2hTSF+YtdopYpW29E
         EmgabqgrcbzYjuAzdG6Bna+4CqNfqhao4hw7iokHO+r1hznqc4yLdmeorlfYdY2IHfd/
         2jUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qnVo4gynOx1Kz0nwhyIoVdeS41bHGw9/XhPKalG9nQg=;
        b=dxKP6V1SfWcbzwsHnGnpEbjz6TKpeBnJlOnbuSW3M8d3K+l2sC2uAS6eATTf14GanO
         lg+RJGqniWgAjWjdDjlcUsjrnZwXG1asAzkg+aG/+Q9ORmMXsUIlOkWdeblvxwoZfpuG
         xBmrn1ZiiUAJDw/3v1vh/jjPqlvUeFKUva3RvH+bnvYcI2swuryq8YI0Sn6VIHdhVrZM
         rq3ughYk00tQQrxZ+JcjozZ4/bC0g29EJQ0xBhtBJUlEAPJqHDsiw5soeK1S7qR8vbuy
         i2B54JvjYqGrHIg8mJhLZDFJeOjXUfXJQHlbb1k03F1x6RHdA6XMTjzprKLxzUVi5mEh
         QPZQ==
X-Gm-Message-State: AOAM5301rS2khi0izi8Ow9zRIOUTVQz1WrYbug2FwAcr6u/bUyb5Rs/B
        PCGo2l9uYPrLyvRyYHuoDrsjGzlLA7U=
X-Google-Smtp-Source: ABdhPJw9A14miodRGJojkXVSIg0dz3ro4KIrjdMIatap8PvrTaiAC8N1mHajacfQRhUYCsYhZJiAnQ==
X-Received: by 2002:a05:6830:1041:: with SMTP id b1mr13643044otp.335.1612236009970;
        Mon, 01 Feb 2021 19:20:09 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id p23sm4423473otk.51.2021.02.01.19.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 19:20:09 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2 0/6] Support devlink port add delete
To:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
References: <20210129165608.134965-1-parav@nvidia.com>
 <20210201213551.8503-1-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2cfa07ec-9997-6286-5352-f723b6ad03c8@gmail.com>
Date:   Mon, 1 Feb 2021 20:20:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210201213551.8503-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/21 2:35 PM, Parav Pandit wrote:
> This patchset implements devlink port add, delete and function state
> management commands.
> 
> An example sequence for a PCI SF:
> 
> Set the device in switchdev mode:
> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
> 
> View ports in switchdev mode:
> $ devlink port show
> pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 splittable false
> 
> Add a subfunction port for PCI PF 0 with sfnumber 88:
> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
> pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 splittable false
>   function:
>     hw_addr 00:00:00:00:00:00 state inactive opstate detached
> 
> Show a newly added port:
> $ devlink port show pci/0000:06:00.0/32768
> pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf controller 0 pfnum 0 sfnum 88 splittable false
>   function:
>     hw_addr 00:00:00:00:00:00 state inactive opstate detached
> 
> Set the function state to active:
> $ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:88 state active
> 
> Show the port in JSON format:
> $ devlink port show pci/0000:06:00.0/32768 -jp
> {
>     "port": {
>         "pci/0000:06:00.0/32768": {
>             "type": "eth",
>             "netdev": "ens2f0npf0sf88",
>             "flavour": "pcisf",
>             "controller": 0,
>             "pfnum": 0,
>             "sfnum": 88,
>             "splittable": false,
>             "function": {
>                 "hw_addr": "00:00:00:00:88:88",
>                 "state": "active",
>                 "opstate": "attached"
>             }
>         }
>     }
> }
> 
> Set the function state to active:
> $ devlink port function set pci/0000:06:00.0/32768 state inactive
> 
> Delete the port after use:
> $ devlink port del pci/0000:06:00.0/32768
> 

applied to iproute2-next.

In the future, please split additions and changes to utility functions
into a separate standalone patch.
