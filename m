Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B27837D1
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732949AbfHFRYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:24:42 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45510 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729161AbfHFRYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:24:41 -0400
Received: by mail-qt1-f193.google.com with SMTP id x22so11943013qtp.12
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=Gp7qhd0Lwx9zgPg8B7djBkz1jo5UqTOVdjIgUJsZDyg=;
        b=MmIJ9OFbHfoENJu7DT5rm/VgxfuQn5Ley65j/5/fKWZzmDDe5j8jn50kuMkyej7Jj1
         dBNcQZzYmSzuX4KIAnwJ0psf1z8CnFMqXFVZR6AA+LIQQ9njePvcgw+xuuWgNY6TYTHM
         uL7UEvR835OU1Xa/MZ7yAff2LHqpbwsVo/QvV/HcKIcyWwbcmHCMaHYQZCFDpURg+9jA
         s+hC+9yvT7pra3HJ429iRICmJlTF3+o5sbVI/4vzWxhiY1xrY+A0Ct57ErwG3aY7/7z6
         jpnIbNdI3u/yLl455EAA0GWsDUjp4XAGkdoJjBnrwugEktDP/g4/lXtHfeMbGUxjvYFO
         7aeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Gp7qhd0Lwx9zgPg8B7djBkz1jo5UqTOVdjIgUJsZDyg=;
        b=De6kdaVGxaM4Wq93kv6Q22OdPQGrBQLRCN10pwFFh/vCrerCAXPEihH94HJzOEtJFS
         Xhsb/wGM4dB/WUxKoCrPTCG440jGieev9s9LWIoARgyUdsQI/1ju40SJsyEDltVgLBTd
         H9DZlFXe1AAby/Hx6Kedh0qpK0ih6i5QeSg6rG239Q2J8fDA400VQr8jt7PtWEQq8CfL
         +i4JRJc53RbII9Ot3gtc3XdV4x961lO5lJCCX7qnXVfhu1OTk0it4tHQkXcCqmceD3j6
         EXc4BRAR8JvU4WpeKwAxGmKicMhTYDj7hCNQMM9guXy8vd8/EHK5W/kK81YYSgMd7MWh
         TUdQ==
X-Gm-Message-State: APjAAAW2pIP/qCbF3EsDiLSgaw2wkXoJTz9l8IE1V9+gmQrV9wEUKUbQ
        5wmgHO3C9+fJU20sb6NtiTg=
X-Google-Smtp-Source: APXvYqx/xb+q+Nr6Bk5w5UlvTp06SrAbenIUU2rOEHWRzulJQMVR+kfJtswAtTUFils4FPFTDOthZQ==
X-Received: by 2002:a0c:c382:: with SMTP id o2mr4087572qvi.75.1565112280535;
        Tue, 06 Aug 2019 10:24:40 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id d71sm718103qkg.70.2019.08.06.10.24.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 10:24:39 -0700 (PDT)
Date:   Tue, 6 Aug 2019 13:24:38 -0400
Message-ID: <20190806132438.GD2822@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, linville@redhat.com, cphealy@gmail.com
Subject: Re: [PATCH ethtool] ethtool: dump nested registers
In-Reply-To: <20190806052002.GD31971@unicorn.suse.cz>
References: <20190802193455.17126-1-vivien.didelot@gmail.com>
 <20190805080448.GA31971@unicorn.suse.cz>
 <20190805105216.GB31482@t480s.localdomain>
 <20190806052002.GD31971@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On Tue, 6 Aug 2019 07:20:02 +0200, Michal Kubecek <mkubecek@suse.cz> wrote:
> On Mon, Aug 05, 2019 at 10:52:16AM -0400, Vivien Didelot wrote:
> > Hi Michal!
> > 
> > On Mon, 5 Aug 2019 10:04:48 +0200, Michal Kubecek <mkubecek@suse.cz> wrote:
> > > On Fri, Aug 02, 2019 at 03:34:54PM -0400, Vivien Didelot wrote:
> > > > Usually kernel drivers set the regs->len value to the same length as
> > > > info->regdump_len, which was used for the allocation. In case where
> > > > regs->len is smaller than the allocated info->regdump_len length,
> > > > we may assume that the dump contains a nested set of registers.
> > > > 
> > > > This becomes handy for kernel drivers to expose registers of an
> > > > underlying network conduit unfortunately not exposed to userspace,
> > > > as found in network switching equipment for example.
> > > > 
> > > > This patch adds support for recursing into the dump operation if there
> > > > is enough room for a nested ethtool_drvinfo structure containing a
> > > > valid driver name, followed by a ethtool_regs structure like this:
> > > > 
> > > >     0      regs->len                        info->regdump_len
> > > >     v              v                                        v
> > > >     +--------------+-----------------+--------------+-- - --+
> > > >     | ethtool_regs | ethtool_drvinfo | ethtool_regs |       |
> > > >     +--------------+-----------------+--------------+-- - --+
> > > > 
> > > > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> > > > ---
> > > 
> > > I'm not sure about this approach. If these additional objects with their
> > > own registers are represented by a network device, we can query their
> > > registers directly. If they are not (which, IIUC, is the case in your
> > > use case), we should use an appropriate interface. AFAIK the CPU ports
> > > are already represented in devlink, shouldn't devlink be also used to
> > > query their registers?
> > 
> > Yet another interface wasn't that much appropriate for DSA, making the
> > stack unnecessarily complex.
> 
> AFAICS, there is already devlink support in dsa and CPU ports are
> presented as devlink ports. So it wouldn't be a completely new
> interface.
> 
> > In fact we are already glueing the statistics of the CPU port into the
> > master's ethtool ops (both physical ports are wired together).
> 
> The ethtool statistics (in general) are one big mess, I don't think it's
> an example worth following; rather one showing us what to avoid.
> 
> > Adding support for nested registers dump in ethtool makes it simple to
> > (pretty) dump CPU port's registers without too much userspace
> > addition.
> 
> It is indeed convenient for pretty print - but very hard to use for any
> automated processing. My point is that CPU port is not represented by
> a network device but it is already represented by a devlink port so that
> it makes much more sense to tie its register dump to that object than to
> add add it to register dump of port's master.

How would that be presented to userspace? The pretty printing for some
DSA switch ports (e.g. mv88e6xxx) are already added in ethtool. Is there
a devlink-ethtool glue of some kind, or should the pretty printing be
duplicated in yet another tool? I'd prefer to avoid the latter...

> In the future, I would like to transform the ethtool register dump from
> current opaque block of data to an actual dump of registers. It is
> unfortunate that drivers are already mixing information specific to
> a network device with information common for the whole physical device.
> Adding more data which is actually related to a different object would
> only make things worse.

I totally understand and I'm interested to follow this work.


Thanks,

	Vivien
