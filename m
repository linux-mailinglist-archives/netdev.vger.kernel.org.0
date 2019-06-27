Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9DD58596
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfF0P3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:29:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43425 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0P3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:29:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so1400355pfg.10
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 08:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8fuHdHdiEjIUTcichDGMVPHPCDjsVoWx+4OQONVTd7s=;
        b=KU/d5ypGfSyplSI981Ib1YoHQEXoC5vTAXwS/8No/eps/K7NVnsmQP4x1qAY2DzEJd
         /dhyQ9LIZ/utyiKsL8/Yq75HH7BlQrrj+uHNWl5tSvA4FCCT7WC3tl5QQtns2l9WDygp
         4mbEXo+SZqJk8GB4E9w7ZBsjYSYc8M1S3FfkvssRlL+yuG5GNDkKo6EGAz2s3rsC1iip
         Hj/NeBj/tCo35jujljAU8TV/908IRclCrQnIdPNkC1jYOLcXaTNsFnuZTkJPVXlZNQcE
         bRKHomxipn/pbVjLpuFBnuJoW3TYpLLCphIGsJ2WUX6QcdKAmj15QTLXl8p0gj/N3ynn
         zU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8fuHdHdiEjIUTcichDGMVPHPCDjsVoWx+4OQONVTd7s=;
        b=E4fUnfvA6SXF0FOARBybT6spKTN9UMzm0iCVIarvBfrAIbYd/0P4giOdW1AeNWnUV9
         gKC7gJxgpmXAc+gXduJmP/V6o3BhnP/o586qx+Kb0Z95kmydK1jthl6s0327tSaHf8DW
         YjTs9H/gsNLFZlfzdAqic4PgpGXiu52LQelI0AwBlzITDW5dJ8wqqVDhYSX7AEksh0rW
         vPvefH1IwpQKEkLomjCaVSahqC0AXhnNmM1/3UbThZw9ty0/s6nG/eSnHAsf21+rmK+B
         MBF+4mQTK8I2XD8xBbA/31mUMbfK4Bl3r5pCelt7QqKvZ8QXkjMD9ztu3n+zB93t6YBa
         +C1Q==
X-Gm-Message-State: APjAAAU4u/PmzbXHrj8x2+3B5Cc8EcAs9B3afTpUPzr1GKZrxEUnZHoS
        UmIhmtkvv7oKO0wVvmTHO4tl0Q==
X-Google-Smtp-Source: APXvYqwRuvY+WetJSJ9ORbtJWZoxmPjLH0RY9sEWqzgeGWXRehnhX1qBPK96HOIB87F3oz5w4rKBJA==
X-Received: by 2002:a63:4c14:: with SMTP id z20mr4307052pga.360.1561649369170;
        Thu, 27 Jun 2019 08:29:29 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z4sm2978904pfa.142.2019.06.27.08.29.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 08:29:29 -0700 (PDT)
Date:   Thu, 27 Jun 2019 08:29:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190627082922.289225f7@hermes.lan>
In-Reply-To: <20190627094327.GF2424@nanopsycho>
References: <20190627094327.GF2424@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 11:43:27 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Hi all.
> 
> In the past, there was repeatedly discussed the IFNAMSIZ (16) limit for
> netdevice name length. Now when we have PF and VF representors
> with port names like "pfXvfY", it became quite common to hit this limit:
> 0123456789012345
> enp131s0f1npf0vf6
> enp131s0f1npf0vf22
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
> 
> This would allow the old tools to work with "eth0" and the new
> tools would work with "enp131s0f1npf0vf22". In sysfs, there would
> be symlink from one name to another.
>       
> Also, there might be a warning added to kernel if someone works
> with IFLA_NAME that the userspace tool should be upgraded.
> 
> Eventually, only IFLA_NAME_EXT is going to be used by everyone.
> 
> I'm aware there are other places where similar new attribute
> would have to be introduced too (ip rule for example).
> I'm not saying this is a simple work.
> 
> Question is what to do with the ioctl api (get ifindex etc). I would
> probably leave it as is and push tools to use rtnetlink instead.
> 
> Any ideas why this would not work? Any ideas how to solve this
> differently?
> 
> Thanks!
> 
> Jiri
>      

I looked into this in the past, but then rejected it because
there are so many tools that use names, not just iproute2.
Plus long names are very user unfriendly.
