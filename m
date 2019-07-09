Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177136305D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 08:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfGIGRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 02:17:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51075 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfGIGRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 02:17:14 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so1759216wml.0
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 23:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bzY+h2K2W7igfnAo/WRof7SnbgvW+eUW/SLzS9GUuio=;
        b=WyQfv0lxwQcrpSYlrRR+OD2rTF4dp8NbJiFRpP13MHqCIedYcxEY4ku4Teg4K5mLCb
         UZFgt2SVrGN3/C10DbAtx5y127bqpM9gY4QpyfUoQ7Xt/8Pvk2rx7bdVYfjgGeduVVtq
         fd288xqBPCwv+d2EYKXJ9xlCc/yvdq2Ictv/Rnn0xSlX4eCDBneqOSEI/cSedTAs9Z1b
         9E7wxuSBM3hK2by7K5BDQWb93XGGb1mU2pvWpEDRb40tmHtKz0f2p1hnVjW9mSfGzMjo
         0z3JJrfdHS1CJrI7ki+hZuJmSofrAGjXiAoey/DTq7hJPECkPwjQXdH/+6y4xtqdxwjd
         Qh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bzY+h2K2W7igfnAo/WRof7SnbgvW+eUW/SLzS9GUuio=;
        b=LA9MYlO8dCKLZae9eU3DASpTLFxm9AoQUqIIKdEGwdzNxBp55KA/rL2XMeexRtQt67
         /B5Tc5jJjnlxM76T1qyV/mAEAzhPbCPzjSi9mP0xZPR+Z/kHkFtJjswpzkHNrDJjl1kc
         weq8jcXn+7oqlwdDNdYq9pI4m2BVmTAJ2yDHzfzKtms49l4FapLzpMCdQNEsHnSawKhb
         msKmTBugZIyOD4LWyqt4GdZ85fNZY9A8OqzDBr0sNfohVajoEsaG4MUgnjVO+HBA0I4W
         hsB6miaAnYIW+J+Ug1q9ggKVPC/DQT56U5CWEcgqI5N1Nm0xghtsXlH9MRudnw28+i8E
         blQw==
X-Gm-Message-State: APjAAAV+nUNsKsqHd6CUSeG/sCUn4NigUNpmY/X/X298C5zDX3cw4Xde
        E9Eplclq32wYmKK1IZKMj+kdPw==
X-Google-Smtp-Source: APXvYqxjZgqJqNo1GLT9xmPR6i+sxndiX/s70WhO4XqjB83LjNei9c/ZIGaXOJRJ0vQ9maC7nP/Idw==
X-Received: by 2002:a7b:c7d8:: with SMTP id z24mr20523638wmk.10.1562653032452;
        Mon, 08 Jul 2019 23:17:12 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o126sm1528576wmo.1.2019.07.08.23.17.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 23:17:12 -0700 (PDT)
Date:   Tue, 9 Jul 2019 08:17:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org,
        jiri@mellanox.com, saeedm@mellanox.com
Subject: Re: [PATCH net-next v6 0/5] devlink: Introduce PCI PF, VF ports and
 attributes
Message-ID: <20190709061711.GH2282@nanopsycho.orion>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190709041739.44292-1-parav@mellanox.com>
 <20190708224012.0280846c@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708224012.0280846c@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 09, 2019 at 07:40:12AM CEST, jakub.kicinski@netronome.com wrote:
>On Mon,  8 Jul 2019 23:17:34 -0500, Parav Pandit wrote:
>> This patchset carry forwards the work initiated in [1] and discussion
>> futher concluded at [2].
>> 
>> To improve visibility of representor netdevice, its association with
>> PF or VF, physical port, two new devlink port flavours are added as
>> PCI PF and PCI VF ports.
>> 
>> A sample eswitch view can be seen below, which will be futher extended to
>> mdev subdevices of a PCI function in future.
>> 
>> Patch-1 moves physical port's attribute to new structure
>> Patch-2 enhances netlink response to consider port flavour
>> Patch-3,4 extends devlink port attributes and port flavour
>> Patch-5 extends mlx5 driver to register devlink ports for PF, VF and
>> physical link.
>
>The coding leaves something to be desired:
>
>1) flavour handling in devlink_nl_port_attrs_put() really calls for a
>   switch statement,
>2) devlink_port_attrs_.*set() can take a pointer to flavour specific
>   structure instead of attr structure for setting the parameters,
>3) the "ret" variable there is unnecessary,
>4) there is inconsistency in whether there is an empty line between
>   if (ret) return; after __devlink_port_attrs_set() and attr setting,
>5) /* Associated PCI VF for of the PCI PF for this port. */ doesn't
>   read great;
>6) mlx5 functions should preferably have an appropriate prefix - f.e.
>   register_devlink_port() or is_devlink_port_supported().
>
>But I'll leave it to Jiri and Dave to decide if its worth a respin :)
>Functionally I think this is okay.
>

I'm happy with the set as it is right now. Anyway, if you want your
concerns to be addresses, you should write them to the appropriate code.
This list is hard to follow.


>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
