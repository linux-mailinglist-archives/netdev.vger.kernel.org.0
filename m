Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CF684481
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfHGGeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:34:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39815 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfHGGeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 02:34:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so9412wra.6
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 23:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=goKfiwOlS/neEO6ispU57Y0aKevTbWjRl6bRi9lmWQE=;
        b=17fM0yw0J3aR84UBRna4PIj6JoUxEMtGtA8L/iB2YA3X7KynpSnJQE0uAMJU2twOca
         WEfAUvTuAqD2UGQ46YeBixD6rBSwT420W8Qkbycr3RIfG63y1r5Vo47zG1uJqg6pwm5Q
         3+w5XoXqS+zyjN870k1FzUf378iX/ZH2jVFDg8lrdj55q+XvqtvbOMyWdk/UAkodr7xV
         1nuYuu35W0YtG5tqKxcRppJ3eEVGWBcH9R5AWuQZlZqUzXR0I0scZGA8oMaB67q9J8V/
         zG0zumDH/5ZxmB8qZh2X7mnU03O+rGxwXx2CJjeEr0L9N07wgN/hH1kVB2z0DeRZ7o7g
         mXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=goKfiwOlS/neEO6ispU57Y0aKevTbWjRl6bRi9lmWQE=;
        b=IGsN7Jrkdzwq5tdmCUTz2twYEFisaxbcTZju7c1Qnw63H7S7qinhZeJhrDYOPqd+/s
         isQCXO5tyMqxpQ/E64XVjb8EFuaYerCvPo7IbM9PaIsrHr1wlmCMsfZQLc1XuDfMIvWB
         sccMBVXgpY8F9seMG19Xl1XDaAaQMmw+Z6HcZfSZlEJKaUo0B4Bay1359yIorBzFZPUu
         OxQ4ePJz46+FOLH9cZEHAI+c1bKl1oVKsyG0yMt1OPrlxoMY4PZ/DnIPKoQghMfAB3zp
         cQwcm4V66sBmskUVwvZ4uKJ22tjMo8rCRzjav+5J2hxJi1zqE0aVisyG8gfj7KSF85+l
         c+3w==
X-Gm-Message-State: APjAAAXYZ+yTUWMySwkc+T35cHWHY9lG3WKTAG8r07xKJXL6BS0lH7Ec
        o2TnlnUa9vccPizi3XWdRPiFLA==
X-Google-Smtp-Source: APXvYqwEq3tDtIhalyjNtd/kTq02DvUfmriI1wmmrtHzC9qBlxodslW64axeVQRrh3xAvc5f8YSxhQ==
X-Received: by 2002:a5d:5647:: with SMTP id j7mr8592198wrw.191.1565159651220;
        Tue, 06 Aug 2019 23:34:11 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 25sm482685wmi.40.2019.08.06.23.34.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 23:34:10 -0700 (PDT)
Date:   Wed, 7 Aug 2019 08:34:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        linville@redhat.com, cphealy@gmail.com
Subject: Re: [PATCH ethtool] ethtool: dump nested registers
Message-ID: <20190807063410.GF2332@nanopsycho.orion>
References: <20190802193455.17126-1-vivien.didelot@gmail.com>
 <20190805080448.GA31971@unicorn.suse.cz>
 <20190805105216.GB31482@t480s.localdomain>
 <20190806052002.GD31971@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806052002.GD31971@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 06, 2019 at 07:20:02AM CEST, mkubecek@suse.cz wrote:
>On Mon, Aug 05, 2019 at 10:52:16AM -0400, Vivien Didelot wrote:
>> Hi Michal!
>> 
>> On Mon, 5 Aug 2019 10:04:48 +0200, Michal Kubecek <mkubecek@suse.cz> wrote:
>> > On Fri, Aug 02, 2019 at 03:34:54PM -0400, Vivien Didelot wrote:
>> > > Usually kernel drivers set the regs->len value to the same length as
>> > > info->regdump_len, which was used for the allocation. In case where
>> > > regs->len is smaller than the allocated info->regdump_len length,
>> > > we may assume that the dump contains a nested set of registers.
>> > > 
>> > > This becomes handy for kernel drivers to expose registers of an
>> > > underlying network conduit unfortunately not exposed to userspace,
>> > > as found in network switching equipment for example.
>> > > 
>> > > This patch adds support for recursing into the dump operation if there
>> > > is enough room for a nested ethtool_drvinfo structure containing a
>> > > valid driver name, followed by a ethtool_regs structure like this:
>> > > 
>> > >     0      regs->len                        info->regdump_len
>> > >     v              v                                        v
>> > >     +--------------+-----------------+--------------+-- - --+
>> > >     | ethtool_regs | ethtool_drvinfo | ethtool_regs |       |
>> > >     +--------------+-----------------+--------------+-- - --+
>> > > 
>> > > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
>> > > ---
>> > 
>> > I'm not sure about this approach. If these additional objects with their
>> > own registers are represented by a network device, we can query their
>> > registers directly. If they are not (which, IIUC, is the case in your
>> > use case), we should use an appropriate interface. AFAIK the CPU ports
>> > are already represented in devlink, shouldn't devlink be also used to
>> > query their registers?
>> 
>> Yet another interface wasn't that much appropriate for DSA, making the
>> stack unnecessarily complex.
>
>AFAICS, there is already devlink support in dsa and CPU ports are
>presented as devlink ports. So it wouldn't be a completely new
>interface.

I agree that since we have cpu devlink-port object, we should use this
object to carry info of it. Not to "abuse" netdevice of front panel
ports. We already have devlink regions for the purpose of binary dumps.
Currently they are per-devlink, but it should be easy to extend them
per-devlink-port.

Similar to the statistics. I think that they should go to devlink-port
object too.


>
>> In fact we are already glueing the statistics of the CPU port into the
>> master's ethtool ops (both physical ports are wired together).
>
>The ethtool statistics (in general) are one big mess, I don't think it's
>an example worth following; rather one showing us what to avoid.
>
>> Adding support for nested registers dump in ethtool makes it simple to
>> (pretty) dump CPU port's registers without too much userspace
>> addition.
>
>It is indeed convenient for pretty print - but very hard to use for any
>automated processing. My point is that CPU port is not represented by
>a network device but it is already represented by a devlink port so that
>it makes much more sense to tie its register dump to that object than to
>add add it to register dump of port's master.
>
>In the future, I would like to transform the ethtool register dump from
>current opaque block of data to an actual dump of registers. It is
>unfortunate that drivers are already mixing information specific to
>a network device with information common for the whole physical device.
>Adding more data which is actually related to a different object would
>only make things worse.
>
>Michal Kubecek
