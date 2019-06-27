Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3198758818
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfF0ROh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:14:37 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43375 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfF0ROh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:14:37 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so6381719ios.10
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 10:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k1fMBc3D09YAn0nDfyEOaIcdkoHUYZy20evbSP5Fs1k=;
        b=igmanSKiSBBiUPsO5O4TnpytO1uPBBSUhh0BgEGWVLA5kgKl5Ic0G0eceK+ThVTXQA
         gfoHG+HEX83mtnzhViL/Bz5L9jfUuPUO+nJX25JO/1Wa8W8lc7sOu9UmIzYcv84k2k4L
         RcMsxDiCrygg8LnemnxrjFiaZAnTS3G1LLcv0nd3DRM+8IJ3lnw2Xgt2s0sQSPMdJXEm
         jh8PuIiEXX8x91e7A/pXDA0fi0zZncU8hn1v1OTb2pGqCJCdLVuhoKgao+8ec5j9QyiL
         REEVIXYAlSKPwFhYfy+h6suFw/4nel3yPbcrGAmK3AuowIj3++EPp8k4DMpxPEGnGs70
         s3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k1fMBc3D09YAn0nDfyEOaIcdkoHUYZy20evbSP5Fs1k=;
        b=jDxcmm8YV75dpRY/lRVhGfiGAq0NV5lySv4QDGP5qQAHzdjiy5waTfUfTW7PmAVje2
         VTB48qINRkVkVMJ2qcd+YpNSfreqxLoEtGEAZfoEUPdSkJ37nTNkaPUiyILguYHphJ1F
         3DF3fXBJu0JCL2/olyKe/19RwV4pJF4IwcxzVou93tCE3zK5mX52Q4dNadKhnOCT6dZq
         SDEUn0jj9GxTOC8LeRzmrkPBDW3bRaExu9WOFiwHzu1/SNbM47+IzrbAQUWUhKHUFQ9/
         NxalKXly8hBI4rw85gXaVjFEwNvFMiqn+hwvcrFDd2ycgOm4WuO4juPZLmAFnjEnKZS0
         2ZUA==
X-Gm-Message-State: APjAAAXVzxc4NK2xfrv/Nj0+Sd1WbLwyjZHSHVCJE8EdJ7jMpvtoc1ro
        QN/QDDHqBL4q75k0c7pEqwo=
X-Google-Smtp-Source: APXvYqwv+nSlD55ffXv1jxZ+eD2yfB5OX7oKMgPTSdjSrrAfm6pICqGtEhCvWsMoDuWuaGPlrTA+cQ==
X-Received: by 2002:a05:6602:22cc:: with SMTP id e12mr6086284ioe.192.1561655676703;
        Thu, 27 Jun 2019 10:14:36 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:68e3:3bc1:af81:7b2b? ([2601:282:800:fd80:68e3:3bc1:af81:7b2b])
        by smtp.googlemail.com with ESMTPSA id u26sm2700447iol.1.2019.06.27.10.14.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:14:35 -0700 (PDT)
Subject: Re: [RFC] longer netdev names proposal
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <20190627094327.GF2424@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
Date:   Thu, 27 Jun 2019 11:14:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190627094327.GF2424@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/19 3:43 AM, Jiri Pirko wrote:
> Hi all.
> 
> In the past, there was repeatedly discussed the IFNAMSIZ (16) limit for
> netdevice name length. Now when we have PF and VF representors
> with port names like "pfXvfY", it became quite common to hit this limit:
> 0123456789012345
> enp131s0f1npf0vf6
> enp131s0f1npf0vf22

QinQ (stacked vlans) is another example.

> 
> Since IFLA_NAME is just a string, I though it might be possible to use
> it to carry longer names as it is. However, the userspace tools, like
> iproute2, are doing checks before print out. So for example in output of
> "ip addr" when IFLA_NAME is longer than IFNAMSIZE, the netdevice is
> completely avoided.
> 
> So here is a proposal that might work:
> 1) Add a new attribute IFLA_NAME_EXT that could carry names longer than
>    IFNAMSIZE, say 64 bytes. The max size should be only defined in kernel,
>    user should be prepared for any string size.
> 2) Add a file in sysfs that would indicate that NAME_EXT is supported by
>    the kernel.

no sysfs files.

Johannes added infrastructure to retrieve the policy. That is a more
flexible and robust option for determining what the kernel supports.


> 3) Udev is going to look for the sysfs indication file. In case when
>    kernel supports long names, it will do rename to longer name, setting
>    IFLA_NAME_EXT. If not, it does what it does now - fail.
> 4) There are two cases that can happen during rename:
>    A) The name is shorter than IFNAMSIZ
>       -> both IFLA_NAME and IFLA_NAME_EXT would contain the same string:
>          original IFLA_NAME     = eth0
>          original IFLA_NAME_EXT = eth0
>          renamed  IFLA_NAME     = enp5s0f1npf0vf1
>          renamed  IFLA_NAME_EXT = enp5s0f1npf0vf1
>    B) The name is longer tha IFNAMSIZ
>       -> IFLA_NAME would contain the original one, IFLA_NAME_EXT would 
>          contain the new one:
>          original IFLA_NAME     = eth0
>          original IFLA_NAME_EXT = eth0
>          renamed  IFLA_NAME     = eth0
>          renamed  IFLA_NAME_EXT = enp131s0f1npf0vf22

so kernel side there will be 2 names for the same net_device?

> 
> This would allow the old tools to work with "eth0" and the new
> tools would work with "enp131s0f1npf0vf22". In sysfs, there would
> be symlink from one name to another.

I would prefer a solution that does not rely on sysfs hooks.

>       
> Also, there might be a warning added to kernel if someone works
> with IFLA_NAME that the userspace tool should be upgraded.

that seems like spam and confusion for the first few years of a new api.

> 
> Eventually, only IFLA_NAME_EXT is going to be used by everyone.
> 
> I'm aware there are other places where similar new attribute
> would have to be introduced too (ip rule for example).
> I'm not saying this is a simple work.
> 
> Question is what to do with the ioctl api (get ifindex etc). I would
> probably leave it as is and push tools to use rtnetlink instead.

The ioctl API is going to be a limiter here. ifconfig is still quite
prevalent and net-snmp still uses ioctl (as just 2 common examples).
snmp showing one set of names and rtnetlink s/w showing another is going
to be really confusing.
