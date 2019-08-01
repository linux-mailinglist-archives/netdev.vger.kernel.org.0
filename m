Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CFB7E3C0
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388860AbfHAUIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 16:08:20 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46224 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387891AbfHAUIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 16:08:20 -0400
Received: by mail-qk1-f193.google.com with SMTP id r4so52971000qkm.13;
        Thu, 01 Aug 2019 13:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=B+yDfdKT+RmatLe61Ax4/UEmkLt8JT8gE8mDRLs1ASo=;
        b=F2DtJQPVW600MwUqAoGNDBJim0olwalXuP0oaVzNa0fuigELEEjv1TPS9O2t4zW1XQ
         pXpruzdZOB/VBi3a/Ru2xZqOapjbUY0dPt4Dayk+xHSRgZZVajTvGk70Z2HIA5Y5cMwl
         ambxZXgnsb/qDkp7nYq3cJFgRehXf/PvlySs2VBmdpH+M5ZDNJxP9VCfgdVNdKV17ZGT
         ES8W4E3m+l2EhVQavzX1ZQ+2ImO1izjQsAj5HIa8nYb0s2XUwvrhRfs4a+oxfu/a5Z1X
         VDRc8KtlnltBx/XBJhhIbBM1tf19KqXDgLfg7P/EJ+wO60b9kMWEw1/tLyFLRY/BaNsl
         MQaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=B+yDfdKT+RmatLe61Ax4/UEmkLt8JT8gE8mDRLs1ASo=;
        b=tzFMZAqFY6Z+tpYUWi3cNkkiME2slEhp9tvMYtuGe6g+kSMLqXIUWAxiUjAelqEANg
         0bmgslLtaeJALEuhXWCPMBi4yHz6zu2EbA+mM0jCfEVxzQ6lXTF2mqv5SPabTTWDMtiP
         fXNQf1oFhzQzUPmlxOkYZXdr5loc28WNYLVJbc4EFcPab10EI3xZpRZ4vfSDfalIk0Lg
         3kEMJGy+9Y8eZo1wBFvKmns/A87mWuRORAp/iYA2q8Sl8ou8BABsfe5IQ+ArvuO+D6Tz
         EgOn5ZiqIocCPiKURSVErxZkquYk88rzT3DD+gRYs8ZtUce0/IvUyGy6ld49aa0NJpj1
         /MUw==
X-Gm-Message-State: APjAAAWhm6LLaZJiI5IRZZQtx6RMNKVcUK4UOwbXB2Sq5C2HpwKKy0D1
        pIpNH+iTk5eV9HBrq3++tLs=
X-Google-Smtp-Source: APXvYqxqpChOnoBfs+GBxQM4vK6z+sYjBISy2ym7G3Sq1RF3r0v+c1tE3tcbulGCOi3Xo0MFPdQASA==
X-Received: by 2002:a37:680e:: with SMTP id d14mr88871406qkc.207.1564690099390;
        Thu, 01 Aug 2019 13:08:19 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q73sm17611144qke.90.2019.08.01.13.08.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 13:08:18 -0700 (PDT)
Date:   Thu, 1 Aug 2019 16:08:17 -0400
Message-ID: <20190801160817.GB9619@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        allan.nielsen@microchip.com
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
In-Reply-To: <20190801194801.rqv5jvb5vxjo2dor@soft-dev3.microsemi.net>
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <20190801151739.GB32290@t480s.localdomain>
 <20190801194801.rqv5jvb5vxjo2dor@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Thu, 1 Aug 2019 21:48:02 +0200, Horatiu Vultur <horatiu.vultur@microchip.com> wrote:
> > I'm a bit late in the conversation. Isn't this what you want?
> > 
> >     ip address add <multicast IPv4 address> dev br0 autojoin
> > 
> 
> Not really, I was looking in a way to register the ports to link layer
> multicast address. Sorry for the confusion, my description of the patch
> was totally missleaning.
> 
> If you follow this thread you will get a better idea what we wanted to
> achive. We got some really good comments and based on these we send a
> RFC[1]. 

OK great! Keep me in the loop, I enjoy bridge and multicast very much ;-)


Thanks,

	Vivien
