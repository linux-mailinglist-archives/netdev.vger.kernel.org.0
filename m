Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3A6B2288
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 16:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388950AbfIMOuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 10:50:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35306 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388704AbfIMOuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 10:50:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id g7so32471537wrx.2
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 07:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UHoUskxisugDZKJAcdaG4bzfDXUH41yuSokAcb+fz2g=;
        b=g/YiqbAL1kz2748UrRGLKYvMpD7wRSplyF3IUx8ITVqtJpMiTkwXsOgSXpiLwo0B9f
         AIGP8co47r9Tx52+88Qbw+wdFOPIg9oFyxO9hS7HRDGsKVo39hqD4RH17rhdwYec6faO
         lDuAsVGVOxV7Z/+FZ1+M/gHZp1hg3KeZ/IZoGD+XeFuLahM6iokihRW75UrkmbfoXdKg
         /fvTvXtb2phh+DWOQuJ9yLUK8X1p8SYR455l3bxXsbJsbgemA47i+L+RhfEWVif3uJ7S
         qA4lXbRprGcoxbVjnO7ygz3VaEDpmV5TKQgDeAIkdjsGCcKDOn9K+rT3doWJ2WJ2M/DX
         r0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UHoUskxisugDZKJAcdaG4bzfDXUH41yuSokAcb+fz2g=;
        b=klqAK1+Idb/tL1On0HXSEGNTxGJX0T6iUJHEe8A7LsiuG1GT6qMz5Kl4Z4BLZdZUiC
         ytkci2a4gsDnC69RoeeXPsPkBEC+IFtX0TtJlLuf3gVcEvSN4thvyInRI5pdKg1C+v8i
         h2NktRXTbci5M5/csf0v1qdzAsnn6C2BOQIQ4njcpemj8IrCp6nrnNlqEy8InUid5yVu
         4sIrbMuJINB9ZZUKzjYrZBiFPjF2MQ13gFnAPXlpcxZ1GqKE5VkzwV/FjqM7gv+019DE
         Q6bNztrTQcp5jQNx+0IzooM71xGp0+9D7NfOXsK6lmE7nKICStv3KKQpC9Dtg4gNdNXc
         O9Og==
X-Gm-Message-State: APjAAAURfBBE3ViKN6aWKHh+hGg3doW5r29iiD7ONzUbG60gzwGdw2gW
        r8VTvHSb6gdnigKuRNJ3ITGUwnuYg4w=
X-Google-Smtp-Source: APXvYqy4qKv+PL4PBoHn5ObZk1t42F/7ddS9om/bsb/NCNUtV9C+h+heOE4KTNhztWc27aA/qQfFFA==
X-Received: by 2002:a5d:6846:: with SMTP id o6mr2177577wrw.73.1568386213528;
        Fri, 13 Sep 2019 07:50:13 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q10sm55022831wrd.39.2019.09.13.07.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 07:50:12 -0700 (PDT)
Date:   Fri, 13 Sep 2019 16:50:12 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190913145012.GB2276@nanopsycho.orion>
References: <20190827070808.GA2250@nanopsycho>
 <20190827.012242.418276717667374306.davem@davemloft.net>
 <20190827093525.GB2250@nanopsycho>
 <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
 <20190828070711.GE2312@nanopsycho>
 <CAJieiUiipZY3A+04Po=WnvgkonfXZxFX2es=1Q5dq1Km869Obw@mail.gmail.com>
 <20190829052620.GK29594@unicorn.suse.cz>
 <CAJieiUgGY4amm_z1VGgBF-3WZceah+R5OVLEi=O2RS8RGpC9dg@mail.gmail.com>
 <20190830170342.GR2312@nanopsycho>
 <20190912115942.GC7621@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912115942.GC7621@nanopsycho.orion>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 12, 2019 at 01:59:42PM CEST, jiri@resnulli.us wrote:
>Fri, Aug 30, 2019 at 07:03:42PM CEST, jiri@resnulli.us wrote:
>>Fri, Aug 30, 2019 at 04:35:23PM CEST, roopa@cumulusnetworks.com wrote:
>
>[...]
>
>>>
>>>so to summarize, i think we have discussed the following options to
>>>update a netlink list attribute so far:
>>>(a) encode an optional attribute/flag in the list attribute in
>>>RTM_SETLINK to indicate if it is a add or del
>>>(b) Use a flag in RTM_SETLINK and RTM_DELINK to indicate add/del
>>>(close to bridge vlan add/del)
>>
>>Nope, bridge vlan add/del is done according to the cmd, not any flag.
>>
>>
>>>(c) introduce a separate generic msg type to add/del to a list
>>>attribute (IIUC this does need a separate msg type per subsystem or
>>>netlink API)
>
>Getting back to this, sorry.
>
>Thinking about it for some time, a,b,c have all their issues. Why can't
>we have another separate cmd as I originally proposed in this RFC? Does
>anyone have any argument against it? Could you please describe?
>
>Because otherwise, I don't feel comfortable going to any of a,b,c :(

How about this:

We have new commands, but we have them for lists of many types. In my
examples, I'm using "altname" and "color". This is very similar to
bridge vlan example Roopa pointed out. It scales and does not pollute
existing setlink/getlink messages. Also, the cmdline is aligned:


$ ip link property add eth0 altname someverylongname altname someotherlongname

$ ip link property add eth0 altname someotherveryverylongname color blue

$ ip link property del eth0 altname someverylongname color blue

$ ip link property add eth0 color red

$ ip link property show eth0
2: eth0: altname someotherlongname altname someotherveryverylongname color red

$ ip -j -p link property show eth0
[ {
        "ifindex": 2,
        "ifname": "eth0",
        "property": [ "altname": "someotherlongname",
	              "altname": "someotherveryverylongname",
	              "color": "red"]
    } ]

I call this "property" but I'm open to any other naming.
 




