Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D63F57CF
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389684AbfKHTlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:41:22 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38858 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388041AbfKHTlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:41:21 -0500
Received: by mail-wm1-f66.google.com with SMTP id z19so7387642wmk.3
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 11:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+9uGOxKFFBUrhoWMRi3B1c9hleXqKEW5ns1xGB5QCLw=;
        b=RdC7juWMDszU+G4FO/0JoRP2XeWH9lY+LtmBqOPdgJ8XC6bkf0NsFqVVwGK8yLCxqv
         EO1HfAv7ZfSzhBEdN7BCxRUx2gp9YwTma+QA8ajkcTZBaihCYJXVob5lq+x8ipiHdpVI
         oIYas0WhlvacPGwe3mR2Tj1Rh4ctWx4sccW69DAyyDVJp4A9NxYnHuLH8B7g81U+4la6
         XawfSyVx+FZWkBsB7A4E77QWKj2/nBCn3YgXz5dkQ3EVzWDM36yIAnaStgWWRVP7edng
         taQxO9wEL2tfCct60bus98ZHmzHtiOmjtDYwCzMSUtEZ7h0QWEctjaQ6O4PXQKx7l8Wx
         QM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+9uGOxKFFBUrhoWMRi3B1c9hleXqKEW5ns1xGB5QCLw=;
        b=ZhmtIHxNxFuWTfvOKImApZbqvt/YpW/6HIki69eJwAGiPflBjvsIvXtW8v8Ucm6C/o
         4V1lDJFp2uK4ZWb4w7ayffrqkEMLhtujSQ3zaczROG5hC4Qh4DX9fIHSV0elS/pAkDV3
         f3UaHroD7466CgRq2asQCtnym6rDotlroYHyE0qp2yfIBOGTXfDoUHT88zkxHQWgU2My
         22OYq+2JtdP8HdlGo8vVtGPBzhaE8HXuAC9iNWRcHGj7d7U6aV7Op6hHDPST+DJWzo+g
         8Q6EjgDrRVH+a7o3hlVPEU7q1cZAy/pqmmQB1823l2e7+3KOmG8hCV2WT15Dbf/67+IB
         C0BA==
X-Gm-Message-State: APjAAAVdchroBIDUFNzb9mV5lgqqw1Aj9Rtf5t3M0r/fyX5IlcmTf4NH
        xzJZvXmQCEZV47INhlXFJbgLJg==
X-Google-Smtp-Source: APXvYqyBo+um2KBRP3w/o5IKRdasbCg/n+9n9Fm8EBf8ZOSK8hHVpV/DZgPvcvWDfNWOBncYfBP5Pw==
X-Received: by 2002:a1c:2e8f:: with SMTP id u137mr9951666wmu.105.1573242079736;
        Fri, 08 Nov 2019 11:41:19 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id o81sm7427640wmb.38.2019.11.08.11.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 11:41:19 -0800 (PST)
Date:   Fri, 8 Nov 2019 20:41:18 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Parav Pandit <parav@mellanox.com>, alex.williamson@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org, netdev@vger.kernel.org,
        saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108194118.GY6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108110640.225b2724@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108110640.225b2724@cakuba>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 08, 2019 at 08:06:40PM CET, jakub.kicinski@netronome.com wrote:
>On Fri, 8 Nov 2019 13:12:33 +0100, Jiri Pirko wrote:
>> Thu, Nov 07, 2019 at 09:32:34PM CET, jakub.kicinski@netronome.com wrote:
>> >On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:  
>> >> Mellanox sub function capability allows users to create several hundreds
>> >> of networking and/or rdma devices without depending on PCI SR-IOV support.  
>> >
>> >You call the new port type "sub function" but the devlink port flavour
>> >is mdev.
>> >
>> >As I'm sure you remember you nacked my patches exposing NFP's PCI 
>> >sub functions which are just regions of the BAR without any mdev
>> >capability. Am I in the clear to repost those now? Jiri?  
>> 
>> Well question is, if it makes sense to have SFs without having them as
>> mdev? I mean, we discussed the modelling thoroughtly and eventually we
>> realized that in order to model this correctly, we need SFs on "a bus".
>> Originally we were thinking about custom bus, but mdev is already there
>> to handle this.
>
>But the "main/real" port is not a mdev in your case. NFP is like mlx4. 
>It has one PCI PF for multiple ports.

I don't see how relevant the number of PFs-vs-uplink_ports is.


>
>> Our SFs are also just regions of the BAR, same thing as you have.
>> 
>> Can't you do the same for nfp SFs?
>> Then the "mdev" flavour is enough for all.
>
>Absolutely not. 
>
>Why not make the main device of mlx5 a mdev, too, if that's acceptable.
>There's (a) long precedence for multiple ports on one PCI PF in
>networking devices, (b) plenty deployed software 
>which depend on the main devices hanging off the PCI PF directly.
>
>The point of mdevs is being able to sign them to VFs or run DPDK on
>them (map to user space).
>
>For normal devices existing sysfs hierarchy were one device has
>multiple children of a certain class, without a bus and a separate
>driver is perfectly fine. Do you think we should also slice all serial
>chips into mdevs if they have multiple lines.
>
>Exactly as I predicted much confusion about what's being achieved here,
>heh :)

Please let me understand how your device is different.
Originally Parav didn't want to have mlx5 subfunctions as mdev. He
wanted to have them tight to the same pci device as the pf. No
difference from what you describe you want. However while we thought
about how to fit things in, how to handle na phys_port_name, how to see
things in sysfs we came up with an idea of a dedicated bus. We took it
upstream and people suggested to use mdev bus for this.

Parav, please correct me if I'm wrong but I don't think where is a plan
to push SFs into VM or to userspace as Jakub expects, right?
