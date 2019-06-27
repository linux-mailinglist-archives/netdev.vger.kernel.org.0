Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95231589D9
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfF0SXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:23:13 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35901 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfF0SXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 14:23:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so1648958pfl.3
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rqcej5Xl5puymZy5XapN80ALN1dsa+uras37ig2Ug+c=;
        b=se5yB5tQsun4+WkLds2t9dybRysNTei8HpMBKsE2oCcyIXNRcmor3fev6KXTrBmudM
         noqIM/2nag4FtL4LxJrtCFDzlfxjZzRj6e7PMf9GyJu9mW90hn+1TA5LCWnD7kYZEr6V
         zUkdSEplZcIVSimSW4hWLnUoT61UDyY0TP95jdKHvmWw5VI7x7XNJRumAbSQ9eZ7K6TX
         Uc4xtA31qMe6LvKis1A7k37ShlkpfsgqIYktSttpPhZkQvDJivIvkoc9YJ82euaDpSKk
         OKlydtZmIufGpp4fGToGDNKbU5HDKeRvFOTZGo4XFopAm0sytmDr74Rfo4MJh69llyt2
         /BiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rqcej5Xl5puymZy5XapN80ALN1dsa+uras37ig2Ug+c=;
        b=VXREwFUz8G5qpe5S+6lQ6qLKANzyx766TwHuoj6jvxuZmOzR65VREv7KY87Esg+8/E
         ymHv4Z1FvRTt4yXEZ2ewowTaaCnDBojlS5XHMPYenCtg6iGn31NCnVIJYdqaW1VNPK5J
         3ebE1p+nxQySctURAo4hV5DGtf5fq/E8Hni0QeslcEddoEmdKpHymi2yc8WFHIogLu3y
         NqRIazUMoPNZ0JXkdJIRcn+MjZxazhm4ROnbFebZaSiiNe06AYHBm5slrbr0dH8IqoiX
         wfd3f4P00x8Ejr77tcLXOSbQt/AFyANtv10TPFrHpr7uWgK1A9U+dz10H8mvo4y5wfLE
         XpWQ==
X-Gm-Message-State: APjAAAVR7VsrMiUb9X2TCD+GzJ0Y01VSrOPwToKPaaqW2BO4k03EQJxe
        hIGJgvoRRd3qc97uCoA9w1qXDQ==
X-Google-Smtp-Source: APXvYqxWETZuAn2+sZg9tAhhjLJI7qGgm6T8mWddHQzXwQrXJ6843Wi9AGxceUycmlgGxG/6Jxmz3g==
X-Received: by 2002:a17:90a:ba93:: with SMTP id t19mr7519181pjr.139.1561659792655;
        Thu, 27 Jun 2019 11:23:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y14sm5211949pjr.13.2019.06.27.11.23.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 11:23:12 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:23:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190627112305.7e05e210@hermes.lan>
In-Reply-To: <20190627180803.GJ27240@unicorn.suse.cz>
References: <20190627094327.GF2424@nanopsycho>
        <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
        <20190627180803.GJ27240@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 20:08:03 +0200
Michal Kubecek <mkubecek@suse.cz> wrote:

> It often feels as a deficiency that unlike block devices where we can
> keep one name and create multiple symlinks based on different naming
> schemes, network devices can have only one name. There are aliases but
> AFAIK they are only used (and can be only used) for SNMP. IMHO this
> limitation is part of the mess that left us with so-called "predictable
> names" which are in practice neither persistent nor predictable.
> 
> So perhaps we could introduce actual aliases (or altnames or whatever we
> would call them) for network devices that could be used to identify
> a network device whenever both kernel and userspace tool supports them.
> Old (and ancient) tools would have to use the one canonical name limited
> to current IFNAMSIZ, new tools would allow using any alias which could
> be longer.
> 
> Michal

 
That is already there in current network model.
# ip li set dev eno1 alias 'Onboard Ethernet'
# ip li show dev eno1
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether ac:1f:6b:74:38:c0 brd ff:ff:ff:ff:ff:ff
    alias Onboard Ethernet


