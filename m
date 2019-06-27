Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6771958957
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfF0R4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:56:17 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33786 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfF0R4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:56:17 -0400
Received: by mail-pf1-f195.google.com with SMTP id x15so1616475pfq.0
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 10:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LxEztFoHTzDBArSkM2DATNWZeIKb+2HqFQQZReY8AZE=;
        b=ltFFdm3SsKlHYczuhmU4RxSM7JnOUiQ3I1cSvZUOiPzNdEA8swMQ3O7lAmuLJH+wdx
         9SwmDnGDN4cP0AHaG7alNCE3NbzJDDWA7aJwk3zSwRih7XW2/9b4w/c2zhEF4tX17OTm
         PB/mw5hk7Hmv7QbL+PCa6ZUuW5sbatSZ6MBn8Pckc8aVFYAkGTnvDr+NdgZ/i2xSEK+e
         +IsTCBcY+HweGckh3FzCiuDAMp/QX+ZJ0BJR0z+ivFhtejFEzRPzAB1rmVtb6B9nmmB1
         ogcVue/B/Cffl24MWJ4gAOlncXT1H21JDT27Q+gwUrrgdanzxfq7SvJ8eJdA3UMsnKYy
         +ZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LxEztFoHTzDBArSkM2DATNWZeIKb+2HqFQQZReY8AZE=;
        b=mTJFzUYfs6/Rz1Ym/jCC673Ps0ze3tzRkTmN6eEqwExwN+U+Rbt8rv3aOC6ZU6Es6V
         z11OFWPygglF+/L/5iSoiBHi52fAm2y0fH4cn0oKdzaQXm1rRrkaQQW6jqPqZEaSlCfO
         crZzflFxqFcHNQk1SJ1cYoXlNnExyBPhkthV6H5fa3iPxLOi+mczpPa/jfvufnvyuDw0
         xLc//FLnlCsg6zAkioCzE1DOEXY7FZefj0uw3HEWDdwuvpDZ5BRk0g4YcCRyEVNHEByw
         wuTImsE8dSgQem7u8KNpXnV43xgReSheGKpUAxbBVXKCDlST1LV/NylgHDVlnTHxJ0gw
         sJtA==
X-Gm-Message-State: APjAAAVdNuqO7CPsHWRjdDo/0fZsbL08h/XO2m3Z4EIzaIrd76wQulf2
        C5HZpQTQ5SePEfeSTa+7Rx0oZ2VTlnE=
X-Google-Smtp-Source: APXvYqyn3b3G8kd3kHLHMkHjDkOOEIQvTmpgdPHVAEIwvAQclCzYGkuZimpjqsMKq192YYMqYF3QDA==
X-Received: by 2002:a63:221f:: with SMTP id i31mr1554092pgi.251.1561658176071;
        Thu, 27 Jun 2019 10:56:16 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m6sm10002375pjl.18.2019.06.27.10.56.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 10:56:15 -0700 (PDT)
Date:   Thu, 27 Jun 2019 10:56:09 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, sthemmin@microsoft.com, dsahern@gmail.com,
        mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190627105609.521f632a@hermes.lan>
In-Reply-To: <20190627104808.1404049a@cakuba.netronome.com>
References: <20190627094327.GF2424@nanopsycho>
        <20190627104808.1404049a@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 10:48:08 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Thu, 27 Jun 2019 11:43:27 +0200, Jiri Pirko wrote:
> > Hi all.
> > 
> > In the past, there was repeatedly discussed the IFNAMSIZ (16) limit for
> > netdevice name length. Now when we have PF and VF representors
> > with port names like "pfXvfY", it became quite common to hit this limit:
> > 0123456789012345
> > enp131s0f1npf0vf6
> > enp131s0f1npf0vf22
> > 
> > Since IFLA_NAME is just a string, I though it might be possible to use
> > it to carry longer names as it is. However, the userspace tools, like
> > iproute2, are doing checks before print out. So for example in output of
> > "ip addr" when IFLA_NAME is longer than IFNAMSIZE, the netdevice is
> > completely avoided.
> > 
> > So here is a proposal that might work:
> > 1) Add a new attribute IFLA_NAME_EXT that could carry names longer than
> >    IFNAMSIZE, say 64 bytes. The max size should be only defined in kernel,
> >    user should be prepared for any string size.
> > 2) Add a file in sysfs that would indicate that NAME_EXT is supported by
> >    the kernel.
> > 3) Udev is going to look for the sysfs indication file. In case when
> >    kernel supports long names, it will do rename to longer name, setting
> >    IFLA_NAME_EXT. If not, it does what it does now - fail.
> > 4) There are two cases that can happen during rename:
> >    A) The name is shorter than IFNAMSIZ  
> >       -> both IFLA_NAME and IFLA_NAME_EXT would contain the same string:    
> >          original IFLA_NAME     = eth0
> >          original IFLA_NAME_EXT = eth0
> >          renamed  IFLA_NAME     = enp5s0f1npf0vf1
> >          renamed  IFLA_NAME_EXT = enp5s0f1npf0vf1
> >    B) The name is longer tha IFNAMSIZ  
> >       -> IFLA_NAME would contain the original one, IFLA_NAME_EXT would     
> >          contain the new one:
> >          original IFLA_NAME     = eth0
> >          original IFLA_NAME_EXT = eth0
> >          renamed  IFLA_NAME     = eth0
> >          renamed  IFLA_NAME_EXT = enp131s0f1npf0vf22  
> 
> I think B is the only way, A risks duplicate IFLA_NAMEs over ioctl,
> right?  And maybe there is some crazy application out there which 
> mixes netlink and ioctl.
> 
> I guess it's not worse than status quo, given that today renames 
> will fail and we will either get truncated names or eth0s..
> 
> > This would allow the old tools to work with "eth0" and the new
> > tools would work with "enp131s0f1npf0vf22". In sysfs, there would
> > be symlink from one name to another.
> >       
> > Also, there might be a warning added to kernel if someone works
> > with IFLA_NAME that the userspace tool should be upgraded.
> > 
> > Eventually, only IFLA_NAME_EXT is going to be used by everyone.
> > 
> > I'm aware there are other places where similar new attribute
> > would have to be introduced too (ip rule for example).
> > I'm not saying this is a simple work.
> > 
> > Question is what to do with the ioctl api (get ifindex etc). I would
> > probably leave it as is and push tools to use rtnetlink instead.
> > 
> > Any ideas why this would not work? Any ideas how to solve this
> > differently?  
> 
> Since we'd have to update all user space to make use of the new names
> I'd be tempted to move to a more structured device identification.
> 
> 5: enp131s0f1npf0vf6: <BROADCAST,MULTICAST> ...
> 
> vs:
> 
> 5: eth5 (parent enp131s0f1 pf 0 vf 6 peer X*): <BROADCAST,MULTICAST> ...
> 
> * ;)
> 
> And allow filtering/selection of device based on more attributes than
> just name and ifindex.  In practice in container workloads, for example,
> the names are already very much insufficient to identify the device.
> Refocusing on attributes is probably a big effort and not that practical
> for traditional CLI users?  IDK
> 
> Anyway, IMHO your scheme is strictly better than status quo.

Or Cisco style naming ;-) Ethernet0/0 

There is a better solution for human use already.
the field ifalias allows arbitrary values and hooked into SNMP.

Why not have userspace fill in this field with something by default?
