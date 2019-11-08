Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1622F44E0
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 11:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbfKHKpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 05:45:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36881 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728513AbfKHKpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 05:45:08 -0500
Received: by mail-wr1-f68.google.com with SMTP id t1so6491593wrv.4
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 02:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vqaw6doOfQTHZm9xSr3ZBQ9b3NLLo/sImivEHBUzvhI=;
        b=t/7/yJMqRKZFKVnuHPbcCnjkQGS/FwsJfGdKbXBP63aYLmmPnXX5ILFYxx1qKCnidb
         X1XDndfI78ekdXB/TuRyurylpwIBylPvulelVZMB4o1gOmzouIIr1TEYZSwdWCIcxVav
         wBPVrB32jIuRr82db1Eiwwbaxj05+y+YoZNInt9jhzW05L78DSMB0Pzjg32vk8Tyoa2h
         YwUH3qkFFIFgXP7lrGoT1AGhkIE4KHQE6Mwokaf4tpv+m9og4wZPIWiuMpwPGRgOrWrN
         +kHd0sgTW/XCGYyGR+L5C6FKUgPcqGPUKOT3IkKyFsfb4MJNGFg/2glZnZ/CXVSW2YNK
         LRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vqaw6doOfQTHZm9xSr3ZBQ9b3NLLo/sImivEHBUzvhI=;
        b=X3rAfu8gN1vhia+XOedRPs+Y0hcPnqPPr5j9HIOG8TNOigbgo0czk7Ht2cu9fL6yp+
         m7HfILNdZab/GIjk45nRP7vLHKg0UxQUoE1WDfsy1DxFzxHF1fIv8fzdZ4JDhEZudNig
         bidQmDwGnCzWgiSc+YNVnQANPiPKdBDcOshai8Eigko5FbKXs4CMz5N5TKMeSHqQfMRg
         iW+VBXiiJ56m+71vt0dBpcT0nSD3KhWPsv2uydfR9RK9qxgHq/4b2Z+d+PG5EiHMoiXh
         M43c0LUElW5nDqd7ctGUnnDzNcxhfFvmz8l0auE+HvsUTU7OyBPXrTQtq14TStuhSdHr
         nN7Q==
X-Gm-Message-State: APjAAAXDeue4HZWooEgUxegCsPSlMJ2i21Hz7OXSZIXW0yxjUNoOQv6P
        wTekEaZLebm7VFrHkENSmcOAMA==
X-Google-Smtp-Source: APXvYqzWaIAfkts/duy5+ZmqOguvJpjqirZgng0zXJv0i3tpRS4htQhA5lk3+nTkMD8u8K2Cf/Kn1A==
X-Received: by 2002:adf:8527:: with SMTP id 36mr7403692wrh.144.1573209906379;
        Fri, 08 Nov 2019 02:45:06 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id 65sm9585091wrs.9.2019.11.08.02.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 02:45:06 -0800 (PST)
Date:   Fri, 8 Nov 2019 11:45:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Message-ID: <20191108104505.GF6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-19-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107160834.21087-19-parav@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Nov 07, 2019 at 05:08:34PM CET, parav@mellanox.com wrote:
>Provide a module parameter to set alias length to optionally generate
>mdev alias.
>
>Example to request mdev alias.
>$ modprobe mtty alias_length=12
>
>Make use of mtty_alias() API when alias_length module parameter is set.
>
>Signed-off-by: Parav Pandit <parav@mellanox.com>

This patch looks kind of unrelated to the rest of the set.
I think that you can either:
1) send this patch as a separate follow-up to this patchset
2) use this patch as a user and push out the mdev alias patches out of
this patchset to a separate one (I fear that this was discussed and
declined before).
