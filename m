Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D162715BFF
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfEGF7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:59:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43699 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfEGF7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 01:59:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id r4so5119420wro.10
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 22:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y9pka7YbN40f6z8bZDn6EXNl/6srZzv8+99WUC61j/0=;
        b=GwlhNLWEzA8Q4K8t7FeqTUiqNgI+NFZBu2h3/LDk4F8EhAnZaiFFxvvK6Kmodb7gnG
         EBY3GlLxkJm2OuNcD7yexTuDqhGVTZFeKf/ixiJcHijVwzYuJ0mdHa2guGYEA2Ciff2d
         nFVAhBPv9ksPMo67bY7bZTD7RTNGBY6f51p8tk5MnbXzThaFhT4ZtkLA6/DTQjfpjNe3
         zb+jd20/pb6ImWbNhD7EsHAkK/Ne9dG5fHAg4MMmCKEiWgu1Mf6gdXaaKUXxWc/iaZft
         mA9JHEOXL9847PCjKSAM7YbncbeFhSOoWWsl1QRLZjp7nEfntkyAeosGLWof30rxRB6E
         U8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y9pka7YbN40f6z8bZDn6EXNl/6srZzv8+99WUC61j/0=;
        b=SGwWMiVg3V9jytkhR1pEjvUqykTSTMli1W1c5keMZzGwW2GXv1s9E/aLz+ZsTEUMHf
         I8rL/P+YriNuYcfwDmsLyeTpSGIOQ9+cmilWXq/iVvyLKPfu39WGYIdb9hLSbm4P5fKd
         AJJVO7uvsUub8/4x1dtopfnsxOTXROs9HzijqNCiehb9T5+KRS3Qk2hdsdodPSAwc1ei
         WzRf117Dl5c6e4O6a4DAStIFk3iI5HG2A7kf+pZQkhmNOMEHZiKXW2ksziOtKR0xFp4v
         f3EkOpldVct5Da90PlnGaNQckZKrqIhXR+PWBKTrnz9l4AFWSsXWsWPF8hSOIrh25AXy
         nwzg==
X-Gm-Message-State: APjAAAUQeeD/1a1951vViUYpFZBL1S8Yn4xU/2TI5zV4UXDcZsMI1gaA
        wSFVH9Srpey/pHnbtYG/RUwfFQ==
X-Google-Smtp-Source: APXvYqyinJh6IFjwMoVw8KSGZ1nYEIjlMwTh6y++BuXS6qwvF2u8nMd8TTXJLIrSDkwexH4FiRIuTA==
X-Received: by 2002:adf:9f4e:: with SMTP id f14mr5453309wrg.42.1557208785604;
        Mon, 06 May 2019 22:59:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b8sm8544471wrr.64.2019.05.06.22.59.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 22:59:45 -0700 (PDT)
Date:   Tue, 7 May 2019 07:59:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Message-ID: <20190507055944.GA14667@nanopsycho.orion>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-10-saeedm@mellanox.com>
 <20190505154212.GC31501@nanopsycho.orion>
 <da1c4267-c258-525e-70a2-9ccd2629d5c4@mellanox.com>
 <20190506113829.GB2280@nanopsycho>
 <1bd839d1adea5fe999ecdd2d31b31936789ce58e.camel@mellanox.com>
 <20190506214640.jgeikwozvk55c6iy@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506214640.jgeikwozvk55c6iy@ast-mbp>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 06, 2019 at 11:46:43PM CEST, alexei.starovoitov@gmail.com wrote:
>On Mon, May 06, 2019 at 07:52:18PM +0000, Saeed Mahameed wrote:
>> On Mon, 2019-05-06 at 13:38 +0200, Jiri Pirko wrote:
>> > Mon, May 06, 2019 at 12:45:44PM CEST, moshe@mellanox.com wrote:
>> > > 
>> > > On 5/5/2019 6:42 PM, Jiri Pirko wrote:
>> > > > Sun, May 05, 2019 at 02:33:23AM CEST, saeedm@mellanox.com wrote:
>> > > > > From: Moshe Shemesh <moshe@mellanox.com>
>> > > > > 
>> > > > > Create mlx5_devlink_health_reporter for FW reporter. The FW
>> > > > > reporter
>> > > > > implements devlink_health_reporter diagnose callback.
>> > > > > 
>> > > > > The fw reporter diagnose command can be triggered any time by
>> > > > > the user
>> > > > > to check current fw status.
>> > > > > In healthy status, it will return clear syndrome. Otherwise it
>> > > > > will dump
>> > > > > the health info buffer.
>> > > > > 
>> > > > > Command example and output on healthy status:
>> > > > > $ devlink health diagnose pci/0000:82:00.0 reporter fw
>> > > > > Syndrome: 0
>> > > > > 
>> > > > > Command example and output on non healthy status:
>> > > > > $ devlink health diagnose pci/0000:82:00.0 reporter fw
>> > > > > diagnose data:
>> > > > > assert_var[0] 0xfc3fc043
>> > > > > assert_var[1] 0x0001b41c
>> > > > > assert_var[2] 0x00000000
>> > > > > assert_var[3] 0x00000000
>> > > > > assert_var[4] 0x00000000
>> > > > > assert_exit_ptr 0x008033b4
>> > > > > assert_callra 0x0080365c
>> > > > > fw_ver 16.24.1000
>> > > > > hw_id 0x0000020d
>> > > > > irisc_index 0
>> > > > > synd 0x8: unrecoverable hardware error
>> > > > > ext_synd 0x003d
>> > > > > raw fw_ver 0x101803e8
>> > > > > 
>> > > > > Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> > > > > Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
>> > > > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>> > > > 
>> > > > 	
>> > > > [...]	
>> > > > 	
>> > > > 	
>> > > > > +static int
>> > > > > +mlx5_fw_reporter_diagnose(struct devlink_health_reporter
>> > > > > *reporter,
>> > > > > +			  struct devlink_fmsg *fmsg)
>> > > > > +{
>> > > > > +	struct mlx5_core_dev *dev =
>> > > > > devlink_health_reporter_priv(reporter);
>> > > > > +	struct mlx5_core_health *health = &dev->priv.health;
>> > > > > +	u8 synd;
>> > > > > +	int err;
>> > > > > +
>> > > > > +	mutex_lock(&health->info_buf_lock);
>> > > > > +	mlx5_get_health_info(dev, &synd);
>> > > > > +
>> > > > > +	if (!synd) {
>> > > > > +		mutex_unlock(&health->info_buf_lock);
>> > > > > +		return devlink_fmsg_u8_pair_put(fmsg,
>> > > > > "Syndrome", synd);
>> > > > > +	}
>> > > > > +
>> > > > > +	err = devlink_fmsg_string_pair_put(fmsg, "diagnose
>> > > > > data",
>> > > > > +					   health->info_buf);
>> > > > 
>> > > > No! This is wrong! You are sneaking in text blob. Please put the
>> > > > info in
>> > > > structured form using proper fmsg helpers.
>> > > > 
>> > > This is the fw output format, it is already in use, I don't want
>> > > to 
>> > > change it, just have it here in the diagnose output too.
>> > 
>> > Already in use where? in dmesg? Sorry, but that is not an argument.
>> > Please format the message properly.
>> > 
>> 
>> What is wrong here ? 
>> 
>> Unlike binary dump data, I thought diagnose data is allowed to be
>> developer friendly free text format, if not then let's enforce it in
>> devlink API. Jiri,  you can't audit each and every use of
>> devlink_fmsg_string_pair_put, it must be done by design.
>
>I agree with the purpose that Jiri is trying to get out of this infra,
>but I disagree that strings should be disallowed.

Not strings in general, I have nothing against them. If they are plain.
But when you push structured data into strings, for example using
sprintf for ints etc, that is a problem I'm pointing at.
Instead of that, the structured data should be formatted using
proper fmsg helpers. We already have them in kernel, it is just about
using them and not taking shortcuts.


>
>The example messages from commit log are not useful at all:
>$ devlink health diagnose pci/0000:82:00.0 reporter fw
>diagnose data:
>assert_var[0] 0xfc3fc043
>assert_var[1] 0x0001b41c
>assert_var[2] 0x00000000
>assert_var[3] 0x00000000
>assert_var[4] 0x00000000
>assert_exit_ptr 0x008033b4
>assert_callra 0x0080365c
>fw_ver 16.24.1000
>hw_id 0x0000020d
>irisc_index 0
>synd 0x8: unrecoverable hardware error
>ext_synd 0x003d
>raw fw_ver 0x101803e8
>
>Firmware dumps some magic numbers. How this is any better than
>what we have today?
>Every bit has to have meaningful message.
>The point of devlink diag is not to replicate dmesg, but to give
>users a clean way to understand and debug the hw.
>
>It seems mlx is adding a new interface and immediately misusing it.
>This not an example to give to other vendors.

I agree.
