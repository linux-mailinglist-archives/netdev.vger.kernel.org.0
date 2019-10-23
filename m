Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D5FE2347
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390811AbfJWTZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:25:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52825 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733199AbfJWTZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 15:25:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id r19so166618wmh.2
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 12:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=vFxCI/KbpNduZQklP4zVuiStyldLk1fsAtxcovgm4aE=;
        b=0BJ6XXvfEcZHvH0XEfe4KHrA7AHs47A4fYPbWyTftJ6JVV+iidQif0P1Q4GrYRoGej
         W3v0hMROiD/TL89bU3KvHc+ZlrsaCovlKc/YB7UfWTDsYeNix8usCl88MoMvLxzthKJA
         Sn43KTuw30dIiTpVhv36Q0rOH9FevNzChHTgVEqDOOzwnUXK7n/7KkbLOY+r18oZbWJg
         T6eSSmuwIbSoKxerSiNPZQpaIpBqhglSD2uwya94xUJ5RWH0RA+S/ZMexN0UlI3pa+1n
         reLiNpg4tZ4aExhFZ6Jjs0bvJD1wwOdrmzS2Xt8JddwlbtM4YjtT+vc5bvDMCDUJszxW
         5f+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=vFxCI/KbpNduZQklP4zVuiStyldLk1fsAtxcovgm4aE=;
        b=cnA1R1G+eaGCGvdbTCPwoUfDLM5d2zy2eVyYr4wPyABd0V/8HkerE40OqB+mNPFyMD
         dBufVsaIhSeUhgN+6zglUFNS+k0DL9vTqXBmwx48vpeuZq2PqlFsXvp+Wq4vL2RR6L6R
         Xa0jdThp1NSGFrEG9WqW4+JUOalGen5CPfCKKhABbtFVGjR6AWMCyoAn1l71Pd4gcTL7
         wD8qMQ+kfGPnNniw8U2Ca97t3QsVC3gGEioXcsDWQ+Bd1ANJ6wJUME7gfFuN8QqyUk2n
         p5LzWMirXWr30XcinmzJ5IEOC9sEiVEr/kXpByzewHs864BC54kRnejCd7ufZflGSJj3
         YtOg==
X-Gm-Message-State: APjAAAUpel9FYWbcbRw/FdI+Q6WZxq2OrzRolgJdOuKSJvLMVTrRatWl
        q+KsoLOqs8yMED2XIiOi9G0wcQ==
X-Google-Smtp-Source: APXvYqyqeiU29Ku6YnbBMAXtliwiQtTMgv2VMMBcR4AevByGzdsqSDF2KUssxYRTyCf3jUwXW0xWyA==
X-Received: by 2002:a7b:cd19:: with SMTP id f25mr1444787wmj.154.1571858714291;
        Wed, 23 Oct 2019 12:25:14 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c144sm163275wmd.1.2019.10.23.12.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 12:25:13 -0700 (PDT)
Date:   Wed, 23 Oct 2019 21:25:12 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Yuval Avnery <yuvalav@mellanox.com>, netdev@vger.kernel.org,
        jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, shuah@kernel.org
Subject: Re: [PATCH net-next 0/9] devlink vdev
Message-ID: <20191023192512.GA2414@nanopsycho>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
 <20191023120046.0f53b744@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191023120046.0f53b744@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 23, 2019 at 09:00:46PM CEST, jakub.kicinski@netronome.com wrote:
>On Tue, 22 Oct 2019 20:43:01 +0300, Yuval Avnery wrote:
>> This patchset introduces devlink vdev.
>> 
>> Currently, legacy tools do not provide a comprehensive solution that can
>> be used in both SmartNic and non-SmartNic mode.
>> Vdev represents a device that exists on the ASIC but is not necessarily
>> visible to the kernel.
>> 
>> Using devlink ports is not suitable because:
>> 
>> 1. Those devices aren't necessarily network devices (such as NVMe devices)
>>    and doesn’t have E-switch representation. Therefore, there is need for
>>    more generic representation of PCI VF.
>> 2. Some attributes are not necessarily pure port attributes
>>    (number of MSIX vectors)
>> 3. It creates a confusing devlink topology, with multiple port flavours
>>    and indices.
>> 
>> Vdev will be created along with flavour and attributes.
>> Some network vdevs may be linked with a devlink port.
>> 
>> This is also aimed to replace "ip link vf" commands as they are strongly
>> linked to the PCI topology and allow access only to enabled VFs.
>> Even though current patchset and example is limited to MAC address
>> of the VF, this interface will allow to manage PF, VF, mdev in
>> SmartNic and non SmartNic modes, in unified way for networking and
>> non-networking devices via devlink instance.
>> 
>> Example:
>> 
>> A privileged user wants to configure a VF's hw_addr, before the VF is
>> enabled.
>> 
>> $ devlink vdev set pci/0000:03:00.0/1 hw_addr 10:22:33:44:55:66
>> 
>> $ devlink vdev show pci/0000:03:00.0/1
>> pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr 10:22:33:44:55:66
>> 
>> $ devlink vdev show pci/0000:03:00.0/1 -jp
>> {
>>     "vdev": {
>>         "pci/0000:03:00.0/1": {
>>             "flavour": "pcivf",
>>             "pf": 0,
>>             "vf": 0,
>>             "port_index": 1,
>>             "hw_addr": "10:22:33:44:55:66"
>>         }
>>     }
>> }
>
>I don't trust this is a good design. 
>
>We need some proper ontology and decisions what goes where. We have
>half of port attributes duplicated here, and hw_addr which honestly
>makes more sense in a port (since port is more of a networking
>construct, why would ep storage have a hw_addr?). Then you say you're
>going to dump more PCI stuff in here :(

Well basically what this "vdev" is is the "port peer" we discussed
couple of months ago. It provides possibility for the user on bare metal
to cofigure things for the VF - for example.

Regarding hw_addr vs. port - it is not correct to make that a devlink
port attribute. It is not port's hw_addr, but the port's peer hw_addr.


>
>"vdev" sounds entirely meaningless, and has a high chance of becoming 
>a dumping ground for attributes.

Sure, it is a madeup name. If you have a better name, please share.
Basically it is something that represents VF/mdev - the other side of
devlink port. But in some cases, like NVMe, there is no associated
devlink port - that is why "devlink port peer" would not work here.


>
>I'm kind of sour about the debug interfaces that were added to devlink.
>Seems like the health API superseded the region stuff to a certain
>extent and the two don't interact with each other.

Yeah, I admit that the regions were probably step into wrong direction.
But only one driver (mlx4) implements and will be hopefully soon
coverted into health.


>
>I'm slightly worried there is too much "learning by doing" going on
>with these new devlink uABIs.

I'm worried about this too.


>
>I'm sure you guys thought this all through in detail and have more
>documentation and design docs internally. Could you provide more of
>this information here? How things fit together? Bigger picture?
>
>The 20 lines of cover letters and no Documentation/ is definitely not
>going to cut it this time.

You are right, Documentation/ file is definitelly a good idea here.


