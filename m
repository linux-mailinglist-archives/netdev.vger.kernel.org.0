Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F77F5A44
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732707AbfKHVj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:39:57 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37124 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732435AbfKHVj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:39:57 -0500
Received: by mail-wm1-f67.google.com with SMTP id q130so7661878wme.2
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tze57b2bsR/GwYQoTzplFmam8+QXL62VeoNRfOZV8yY=;
        b=Q/WAHYGD+DBuN7thKm8RS7Ein9f+4V87oGeQN/HOn9okMHHz64ciF2qgw/Oj03eu7D
         NremqJ+36eDt4ZOHhtguXLs2WXYHSxd7wy3+e1QX6j9QLvh8u5qD1EVUF/MwL7lBCuJD
         S7RFUPmZCr712D0cFsS3CKSFq/ufjmFntSylQw8wRlRptVrtrUi6showrm5AiqMZ5Eg3
         9nzX+46AqvFiz8XiQhs0eHdP3OLwqrPnnyNfqKk83KvP/sg73iT8GDE6/3x/hXcSYVCb
         6+MxC6/NhztMfvVjNIMzLq61+B5T3ZQIMoqKlK+xW8uWIczih20tAjHyT3zb9dR86ccH
         wkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tze57b2bsR/GwYQoTzplFmam8+QXL62VeoNRfOZV8yY=;
        b=Dcf0s0dqSpzgvT18Mz0uvHF12Cz3IQOr8yiLpB8BQrBBKFHrwKuqQylCByAuYWIoL/
         hRZzpm3liwHYCzO4TekfdKRDSkWYVXwUAZoOFEoTIBwUe/mueVnmfg+8ZCMJgZ5pFi1z
         wBO4gEjk431LLHNEHnA6yf+XaFzhdvoWBBrl3CzcohobTkTK1CAlZgmes5NJKYSilUJp
         o1eKF8A65KUjONr1MFyfsYwLaMz6nFDX0dv8Al/tW81TOBTunmkpq1bTbIA8dcO8LaBq
         IgsFCAXYSo+OPcPPSffcFlzN0599N+jo51GXVP71qQfBGpnaIjBUuzvEr6ruszlGrBx2
         b/JQ==
X-Gm-Message-State: APjAAAXTCeRZR5mmk/v9SJ7OmVz3gOkpqF6wvRovVVHy+Ojz4M/rAYs2
        s+EComtke1XqvovmrxvFEoU0VQ==
X-Google-Smtp-Source: APXvYqz2ULh0wC+3gaPbsNu6divAq6scvendvnNAXeY517/H3G/vlQZUzHHQgrMTj6oeXNKdcEqL2g==
X-Received: by 2002:a1c:1f03:: with SMTP id f3mr10042764wmf.131.1573249193950;
        Fri, 08 Nov 2019 13:39:53 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id x205sm11132284wmb.5.2019.11.08.13.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:39:53 -0800 (PST)
Date:   Fri, 8 Nov 2019 22:39:52 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Parav Pandit <parav@mellanox.com>, alex.williamson@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org, netdev@vger.kernel.org,
        saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108213952.GZ6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108110640.225b2724@cakuba>
 <20191108194118.GY6990@nanopsycho>
 <20191108132120.510d8b87@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108132120.510d8b87@cakuba>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 08, 2019 at 10:21:20PM CET, jakub.kicinski@netronome.com wrote:
>On Fri, 8 Nov 2019 20:41:18 +0100, Jiri Pirko wrote:
>> Fri, Nov 08, 2019 at 08:06:40PM CET, jakub.kicinski@netronome.com wrote:
>> >On Fri, 8 Nov 2019 13:12:33 +0100, Jiri Pirko wrote:  
>> >> Thu, Nov 07, 2019 at 09:32:34PM CET, jakub.kicinski@netronome.com wrote:  
>> >> >On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:    
>> >> >> Mellanox sub function capability allows users to create several hundreds
>> >> >> of networking and/or rdma devices without depending on PCI SR-IOV support.    
>> >> >
>> >> >You call the new port type "sub function" but the devlink port flavour
>> >> >is mdev.
>> >> >
>> >> >As I'm sure you remember you nacked my patches exposing NFP's PCI 
>> >> >sub functions which are just regions of the BAR without any mdev
>> >> >capability. Am I in the clear to repost those now? Jiri?    
>> >> 
>> >> Well question is, if it makes sense to have SFs without having them as
>> >> mdev? I mean, we discussed the modelling thoroughtly and eventually we
>> >> realized that in order to model this correctly, we need SFs on "a bus".
>> >> Originally we were thinking about custom bus, but mdev is already there
>> >> to handle this.  
>> >
>> >But the "main/real" port is not a mdev in your case. NFP is like mlx4. 
>> >It has one PCI PF for multiple ports.  
>> 
>> I don't see how relevant the number of PFs-vs-uplink_ports is.
>
>Well. We have a slice per external port, the association between the
>port and the slice becomes irrelevant once switchdev mode is enabled,
>but the queues are assigned statically so it'd be a waste of resources
>to not show all slices as netdevs.
>
>> >> Our SFs are also just regions of the BAR, same thing as you have.
>> >> 
>> >> Can't you do the same for nfp SFs?
>> >> Then the "mdev" flavour is enough for all.  
>> >
>> >Absolutely not. 
>> >
>> >Why not make the main device of mlx5 a mdev, too, if that's acceptable.
>> >There's (a) long precedence for multiple ports on one PCI PF in
>> >networking devices, (b) plenty deployed software 
>> >which depend on the main devices hanging off the PCI PF directly.
>> >
>> >The point of mdevs is being able to sign them to VFs or run DPDK on
>> >them (map to user space).
>> >
>> >For normal devices existing sysfs hierarchy were one device has
>> >multiple children of a certain class, without a bus and a separate
>> >driver is perfectly fine. Do you think we should also slice all serial
>> >chips into mdevs if they have multiple lines.
>> >
>> >Exactly as I predicted much confusion about what's being achieved here,
>> >heh :)  
>> 
>> Please let me understand how your device is different.
>> Originally Parav didn't want to have mlx5 subfunctions as mdev. He
>> wanted to have them tight to the same pci device as the pf. No
>> difference from what you describe you want. However while we thought
>> about how to fit things in, how to handle na phys_port_name, how to see
>> things in sysfs we came up with an idea of a dedicated bus.
>
>The difference is that there is naturally a main device and subslices
>with this new mlx5 code. In mlx4 or nfp all ports are equal and
>statically allocated when FW initializes based on port breakout.

Ah, I see. I was missing the static part in nfp. Now I understand. It is
just an another "pf", but not real pf in the pci terminology, right?


>
>Maybe it's the fact I spent last night at an airport but I'm feeling
>like I'm arguing about this stronger than I actually care :)
>
>> We took it upstream and people suggested to use mdev bus for this.
>> 
>> Parav, please correct me if I'm wrong but I don't think where is a plan
>> to push SFs into VM or to userspace as Jakub expects, right?
>
>There's definitely a plan to push them to VFs, I believe that was part
>of the original requirements, otherwise there'd be absolutely no need
>for a bus to begin with.
