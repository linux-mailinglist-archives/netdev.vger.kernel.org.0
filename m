Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED542F5B88
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbhANHsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbhANHsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:48:53 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185B6C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:48:07 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id d17so6770797ejy.9
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g5DhD0iXL9wX78Jyyv3QZgJTZhXipS/fNP6Zc6I5NGo=;
        b=PHuxCXCXNdfcF+wm3t5Ky/KrpwTn5n28a7w0x0o5BNl3EJoFtSXFTXJDNzOsPMOnIT
         Xupcc8j0Q15YfZ4L0ZNJJknBNpwhMJpTbJ8d+gyfTYGrM50422yLXu4lqwH+zQoxuORO
         r7Ozh0IjQ60ooI/M8TJ0aWBH6CiQOTM0JKZCupaXR8svXRel4Pz8lck1vXfLn2gzJBzk
         3tPZke0j0IucnJAWU1IKrjMFox0C1q+JPorofEB/7o5JqtX53Rq1cIxXOrYqjgpmEwqB
         1QFsIlz2MqGsIZX563umM3V3BdlaN3ZicX0JMEPkNcYgrvj9jfZWb3blWSBmZPwwf688
         FkUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g5DhD0iXL9wX78Jyyv3QZgJTZhXipS/fNP6Zc6I5NGo=;
        b=bcnZNbshxDNin9YFfdqqG8/qIa6AWyiN5lJmdlKQUjlaARcgPOg2F5+rMctq21Scto
         eyDV4mu1vikfW68LO/YiwYsrqQOO6dLIR+idxu+sHyfhrooN+xxB0aEiDWAihSr2qvcX
         XVyUnGYrUwgWFCxrLpa/nBaAhFOrkAKdUeg3lz2YtXhmRgPbnW6+enWEI+w5qNzbQpVv
         nW5YCTSYiOBayxeGwoXq3pplPz7yrFZTCFvb1Y5tEWDvkc7NRGa+7+yjvwd+pU1r60KQ
         0+CgRpigk5GYtf3XY7G6Utlsyjy94u3KEhCcs5DFc2lSUayhfdEu5cJQOF6yIKm8ssRn
         B1cw==
X-Gm-Message-State: AOAM531tbQanA5sZ8lwqS2ObZVOhwv0zXblKr//MxYrht6rNRbwg1NKA
        XuIkFQNQwqFDMVIX4opN3/fX6w==
X-Google-Smtp-Source: ABdhPJzKsnp/HFFuS64OIWpInOki5rSUdR9tNuflmDISfIKmlEzXtv0bClZ0QTIM822fFxOwgw86rA==
X-Received: by 2002:a17:906:144e:: with SMTP id q14mr4262558ejc.150.1610610485727;
        Wed, 13 Jan 2021 23:48:05 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id on19sm41515ejb.19.2021.01.13.23.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 23:48:05 -0800 (PST)
Date:   Thu, 14 Jan 2021 08:48:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210114074804.GK3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 14, 2021 at 03:27:16AM CET, kuba@kernel.org wrote:
>On Wed, 13 Jan 2021 13:12:12 +0100 Jiri Pirko wrote:
>> This patchset introduces support for modular switch systems.
>> NVIDIA Mellanox SN4800 is an example of such. It contains 8 slots
>> to accomodate line cards. Available line cards include:
>> 16X 100GbE (QSFP28)
>> 8X 200GbE (QSFP56)
>> 4X 400GbE (QSFP-DD)
>> 
>> Similar to split cabels, it is essencial for the correctness of
>> configuration and funcionality to treat the line card entities
>> in the same way, no matter the line card is inserted or not.
>> Meaning, the netdevice of a line card port cannot just disappear
>> when line card is removed. Also, system admin needs to be able
>> to apply configuration on netdevices belonging to line card port
>> even before the linecard gets inserted.
>
>I don't understand why that would be. Please provide reasoning, 
>e.g. what the FW/HW limitation is.

Well, for split cable, you need to be able to say:
port 2, split into 4. And you will have 4 netdevices. These netdevices
you can use to put into bridge, configure mtu, speeds, routes, etc.
These will exist no matter if the splitter cable is actually inserted or
not.

With linecards, this is very similar. By provisioning, you also create
certain number of ports, according to the linecard that you plan to
insert. And similarly to the splitter, the netdevices are created.

You may combine the linecard/splitter config when splitter cable is
connected to a linecard port. Then you provision a linecard,
port is going to appear and you will split this port.


>
>> To resolve this, a concept of "provisioning" is introduced.
>> The user may "provision" certain slot with a line card type.
>> Driver then creates all instances (devlink ports, netdevices, etc)
>> related to this line card type. The carrier of netdevices stays down.
>> Once the line card is inserted and activated, the carrier of the
>> related netdevices goes up.
>
>Dunno what "line card" means for Mellovidia but I don't think 
>the analogy of port splitting works. To my knowledge traditional
>line cards often carry processors w/ full MACs etc. so I'd say 
>plugging in a line card is much more like plugging in a new NIC.

No. It is basically a phy gearbox. The mac is not there. The interface
between asic and linecard are lanes. The linecards is basically an
attachable phy.


>
>There is no way to tell a breakout cable from normal one, so the
>system has no chance to magically configure itself. Besides SFP
>is just plugging a cable, not a module of the system.. 
