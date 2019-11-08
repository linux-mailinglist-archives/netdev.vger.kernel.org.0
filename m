Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F997F5623
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391371AbfKHTGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:06:55 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38419 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391353AbfKHTGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:06:52 -0500
Received: by mail-lj1-f195.google.com with SMTP id v8so7336281ljh.5
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 11:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8FLmVV2Nn1i56ToXPb/ssVwCCAPCGG8SAnZ1P+H/kmw=;
        b=ltgYL9JDHmVrRQ7ImtLOdrrO0GhgDKUSRvdRUwKDvKqK7SWEHFUZQ9fQ0liohDkYXs
         Ja9LKNtRqy+MCgvYJn0mKx2Blay+VFrzpqPiMhqYe5vUZryDym4LN+PeEdY/r/6S3ct+
         dGOsWwb5OqYZB57PwQBPwVZTZWypVtd1FRhhsEXfiC0vAi6ubsIzWjq2EaitLTwTW76l
         YTzhiFvf5D+hROXM/GU3OBsH50TOEl02VjNQcOGDAGyO5UzLxYmY4RbeAPTRnB6upie5
         d+f4ir9k2/uYLd89q/zytaKQiooEOYwfcGjL+MSzrKKJ8W5KEj31Ecma431qqWEecwdd
         CKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8FLmVV2Nn1i56ToXPb/ssVwCCAPCGG8SAnZ1P+H/kmw=;
        b=i16rPFVeUcpTtwD4dg81wklUhOeLmj1vijl4XvXWIBV0lG4CAoVtRPSTz0uELLGleV
         /Vt0Iz8//k9hBN/OdoVYKILVS6dqYRfZo4sWgdd+qb9qSG8xl8ofxwUTcoa/739w7mfU
         OK2DjqdebwJqAGzG5E/75DSldlvvBeb7APMYuLC1YXtYXiD3Dvwta/6YO1I8nfrCYqvT
         BWFvepsduO4DYSu0frlXPhwrY/7ZuRLAXwl0G6GqXJQ0s2/+TJWj4On57bDyAIvHL8uG
         k8hmGz2Pa63usuUc51wz0NPVVwwEFTEujLncDcIahOg0scxXjnZWm0vP+EY0fqqOYGRz
         DwjA==
X-Gm-Message-State: APjAAAWyJgsBpUI7rygLQToTAIxKs6uUTWGvkCAlYNx211rfSEOgpONy
        rDF3xgBJT7ddt/N43q6jvjp6lA==
X-Google-Smtp-Source: APXvYqx/wv0yk/AJ+E1ZtDOZUsLSUi6YPh4XUZ58UPIYFssoxtB+Qv88gMeho+YLrmJwsFzO7v7/Wg==
X-Received: by 2002:a2e:b4ba:: with SMTP id q26mr7849587ljm.60.1573240010398;
        Fri, 08 Nov 2019 11:06:50 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t8sm2932484lfl.51.2019.11.08.11.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 11:06:50 -0800 (PST)
Date:   Fri, 8 Nov 2019 11:06:40 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Parav Pandit <parav@mellanox.com>, alex.williamson@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org, netdev@vger.kernel.org,
        saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108110640.225b2724@cakuba>
In-Reply-To: <20191108121233.GJ6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 13:12:33 +0100, Jiri Pirko wrote:
> Thu, Nov 07, 2019 at 09:32:34PM CET, jakub.kicinski@netronome.com wrote:
> >On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:  
> >> Mellanox sub function capability allows users to create several hundreds
> >> of networking and/or rdma devices without depending on PCI SR-IOV support.  
> >
> >You call the new port type "sub function" but the devlink port flavour
> >is mdev.
> >
> >As I'm sure you remember you nacked my patches exposing NFP's PCI 
> >sub functions which are just regions of the BAR without any mdev
> >capability. Am I in the clear to repost those now? Jiri?  
> 
> Well question is, if it makes sense to have SFs without having them as
> mdev? I mean, we discussed the modelling thoroughtly and eventually we
> realized that in order to model this correctly, we need SFs on "a bus".
> Originally we were thinking about custom bus, but mdev is already there
> to handle this.

But the "main/real" port is not a mdev in your case. NFP is like mlx4. 
It has one PCI PF for multiple ports.

> Our SFs are also just regions of the BAR, same thing as you have.
> 
> Can't you do the same for nfp SFs?
> Then the "mdev" flavour is enough for all.

Absolutely not. 

Why not make the main device of mlx5 a mdev, too, if that's acceptable.
There's (a) long precedence for multiple ports on one PCI PF in
networking devices, (b) plenty deployed software 
which depend on the main devices hanging off the PCI PF directly.

The point of mdevs is being able to sign them to VFs or run DPDK on
them (map to user space).

For normal devices existing sysfs hierarchy were one device has
multiple children of a certain class, without a bus and a separate
driver is perfectly fine. Do you think we should also slice all serial
chips into mdevs if they have multiple lines.

Exactly as I predicted much confusion about what's being achieved here,
heh :)
