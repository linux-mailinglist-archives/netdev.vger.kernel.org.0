Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50482B81A6
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgKRQVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgKRQVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:21:31 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323CAC0613D4;
        Wed, 18 Nov 2020 08:21:30 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id t13so2514371ilp.2;
        Wed, 18 Nov 2020 08:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AyptpwQOw4Bm0mOXRGK1bH0pgpPAZur4mQ6eyv6Xmtk=;
        b=uSSVJIOX3nPJ3bkI5EiairQDn9QlUxmGHFYg51ehT55v/G76aGPoC/veYQ/MtX66Dk
         ClzLu53T6ky6NMNxpjFNNPS7LTej/PoE80HHqTRTVun7qZQvwU4R6lk57x+a6kyk13ef
         +CqPi4erWWN3H5YM2xoGeZBfsRiQjVAD5T603BFOcuvonUb8VtPfQ6NovX9TJMoMP0Du
         6HDVOwJyLT153NAOLsblG1zZumCErHJKtcAdHO2ob0vmFDYeGUbTrjtoOLFFeQbJZrSF
         +fKT0bdIlfFppYhM1pIn6MOgpUmlEy85WBjYIfhp4OqR6rRPIHT8K8oJN5YbrM84Imh3
         ehzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AyptpwQOw4Bm0mOXRGK1bH0pgpPAZur4mQ6eyv6Xmtk=;
        b=pdn3CYZuA94m6ALS8YX9n7Fhc5WTEf4pR7pKVFYc+743wiFtcMMnxfQs1A/YL1YHA8
         FzYFYzPXEwdyqGXVKxH0lvWWoAHPatqhM9OBh7VYGx5muLQyOnbRn+DtGs2g3uF2LEAd
         XHjM9SCjYPG16rE9/uyYfdTgNvxGiit7ILXivCSOs8aMfFzjJ+pAnvLTINx9s9eHdy8E
         kn/rcTp+AWV2+tkIQdNurjb9psNG3X6YaZQaQSlNVrzLLIBiHJQ8B4YFrGjXnxdKJoiw
         m5TZx4F1FGJknsVPmJ/IRNhfl7wkMj+FY/J+M9CasT5r+S0jTczOxB4OP6novOJsdQBP
         jxWg==
X-Gm-Message-State: AOAM533ZvZdx86sH72tpfJvcZpIHAVlHQr3P1a2vMxOUgERn/mSMMES0
        fVy2p3hWkS1ridv7QfnLVMM=
X-Google-Smtp-Source: ABdhPJwZCbVB0NJgbnm8AOOKEm7sDJMjLn+rMUgu+Vubq0OQOkvz+qDkQgoBNqfh9J04Fl5tUmnRTg==
X-Received: by 2002:a92:414e:: with SMTP id o75mr16928755ila.30.1605716489615;
        Wed, 18 Nov 2020 08:21:29 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:cd3a:ec11:4d4f:e8d8])
        by smtp.googlemail.com with ESMTPSA id d5sm13297642ios.25.2020.11.18.08.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 08:21:29 -0800 (PST)
Subject: Re: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
To:     Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     jiri@nvidia.com, jgg@nvidia.com, dledford@redhat.com,
        leonro@nvidia.com, saeedm@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, Vu Pham <vuhuong@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-4-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e7b2b21f-b7d0-edd5-1af0-a52e2fc542ce@gmail.com>
Date:   Wed, 18 Nov 2020 09:21:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201112192424.2742-4-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/20 12:24 PM, Parav Pandit wrote:
> Extended devlink interface for the user to add and delete port.
> Extend devlink to connect user requests to driver to add/delete
> such port in the device.
> 
> When driver routines are invoked, devlink instance lock is not held.
> This enables driver to perform several devlink objects registration,
> unregistration such as (port, health reporter, resource etc)
> by using exising devlink APIs.
> This also helps to uniformly use the code for port unregistration
> during driver unload and during port deletion initiated by user.
> 
> Examples of add, show and delete commands:
> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
> 
> $ devlink port show
> pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 splittable false
> 
> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
> 
> $ devlink port show pci/0000:06:00.0/32768
> pci/0000:06:00.0/32768: type eth netdev eth0 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
>   function:
>     hw_addr 00:00:00:00:88:88 state inactive opstate detached
> 

There has to be limits on the number of sub functions that can be
created for a device. How does a user find that limit?

Also, seems like there are hardware constraint at play. e.g., can a user
reduce the number of queues used by the physical function to support
more sub-functions? If so how does a user programmatically learn about
this limitation? e.g., devlink could have support to show resource
sizing and configure constraints similar to what mlxsw has.

