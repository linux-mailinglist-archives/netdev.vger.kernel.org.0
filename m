Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 021F0155CD
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 23:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfEFVqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 17:46:50 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46558 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfEFVqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 17:46:50 -0400
Received: by mail-pl1-f195.google.com with SMTP id bi2so7007055plb.13
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 14:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8x2XA+iIEyd9jJP+OOfGw+qycG/ae/NCLL5jLnf7cmU=;
        b=SWnGtNE8euXcJxArhaahfSk3WGKdEh13THh4m4lybfv5TGQnm6bnev9TchYXB+Dagp
         BJik1EKb3VTB7NszyL5464TC/9HTBAjgm9u3LZJufAv5Nf9eQnm+djh6eD3fU63VKkeU
         yvXC+TNS4eSxEPG3ANTdkz3dLnzBYXilGb2VzwU1ulRgp/aRZX4Hx07fxjK69/6wJoS+
         Sj1i4lQj6ppL6j+k/qg9l3ro51wk+qXzrzBBA9dewmaWSTrE3BjvnH2YjILK2fGyy6UR
         /PE9OERdnTcfmooth95h7rDB3KvVO0A8qcjRGHN+TGTcApppMfUMs+yIxIdma4o8Tj1y
         HpmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8x2XA+iIEyd9jJP+OOfGw+qycG/ae/NCLL5jLnf7cmU=;
        b=uBenacqOsufiF/F+v4OXw7LO4c6sndNqXSDIs0QuyPYUeKbu3t24QBtGMBwOukkivy
         W8C435a89oDZRvRgQVXa3SQ1cdXqkWQczC9LpydIOrU4jVFQtwMbI15wqxp/ZAbgC2bx
         ETe3U9mTLUyUhlfhgGaYJ/qvIJSen+gLgC81edVGTPvtauchyTu1CUd0eTv+KI/XwnKQ
         m/VEBcy+NWfyw3U2JTEwSdObK7DqG8g8LsL53YoxrliN2OzDMdP8KSUE7wkJ5qyN0pwW
         L1RQOBHAzmbM1XlNJLjOQ+OXrM9sQ9FcHFgIzyAaS5a+/Xo86vf1tsqJDwMxQPMLElFG
         x42g==
X-Gm-Message-State: APjAAAVJfocQ4HQvNCnhX8aGY4rG/zuEGy7TwNrOmG8eIxkPJwMphxV1
        4eVBsMTrmzdTijt9ZVDuDeQ=
X-Google-Smtp-Source: APXvYqxnajH62JedIxadndZA6SPY3i7EmLOF4WXAHOwDfw+k48V21Zthd56+mlDIPTSvgM3iO4+9pg==
X-Received: by 2002:a17:902:d88b:: with SMTP id b11mr15171487plz.186.1557179209216;
        Mon, 06 May 2019 14:46:49 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:1919])
        by smtp.gmail.com with ESMTPSA id 4sm14166838pfi.94.2019.05.06.14.46.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 14:46:48 -0700 (PDT)
Date:   Mon, 6 May 2019 14:46:43 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Message-ID: <20190506214640.jgeikwozvk55c6iy@ast-mbp>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-10-saeedm@mellanox.com>
 <20190505154212.GC31501@nanopsycho.orion>
 <da1c4267-c258-525e-70a2-9ccd2629d5c4@mellanox.com>
 <20190506113829.GB2280@nanopsycho>
 <1bd839d1adea5fe999ecdd2d31b31936789ce58e.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bd839d1adea5fe999ecdd2d31b31936789ce58e.camel@mellanox.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 07:52:18PM +0000, Saeed Mahameed wrote:
> On Mon, 2019-05-06 at 13:38 +0200, Jiri Pirko wrote:
> > Mon, May 06, 2019 at 12:45:44PM CEST, moshe@mellanox.com wrote:
> > > 
> > > On 5/5/2019 6:42 PM, Jiri Pirko wrote:
> > > > Sun, May 05, 2019 at 02:33:23AM CEST, saeedm@mellanox.com wrote:
> > > > > From: Moshe Shemesh <moshe@mellanox.com>
> > > > > 
> > > > > Create mlx5_devlink_health_reporter for FW reporter. The FW
> > > > > reporter
> > > > > implements devlink_health_reporter diagnose callback.
> > > > > 
> > > > > The fw reporter diagnose command can be triggered any time by
> > > > > the user
> > > > > to check current fw status.
> > > > > In healthy status, it will return clear syndrome. Otherwise it
> > > > > will dump
> > > > > the health info buffer.
> > > > > 
> > > > > Command example and output on healthy status:
> > > > > $ devlink health diagnose pci/0000:82:00.0 reporter fw
> > > > > Syndrome: 0
> > > > > 
> > > > > Command example and output on non healthy status:
> > > > > $ devlink health diagnose pci/0000:82:00.0 reporter fw
> > > > > diagnose data:
> > > > > assert_var[0] 0xfc3fc043
> > > > > assert_var[1] 0x0001b41c
> > > > > assert_var[2] 0x00000000
> > > > > assert_var[3] 0x00000000
> > > > > assert_var[4] 0x00000000
> > > > > assert_exit_ptr 0x008033b4
> > > > > assert_callra 0x0080365c
> > > > > fw_ver 16.24.1000
> > > > > hw_id 0x0000020d
> > > > > irisc_index 0
> > > > > synd 0x8: unrecoverable hardware error
> > > > > ext_synd 0x003d
> > > > > raw fw_ver 0x101803e8
> > > > > 
> > > > > Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> > > > > Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> > > > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > > > 
> > > > 	
> > > > [...]	
> > > > 	
> > > > 	
> > > > > +static int
> > > > > +mlx5_fw_reporter_diagnose(struct devlink_health_reporter
> > > > > *reporter,
> > > > > +			  struct devlink_fmsg *fmsg)
> > > > > +{
> > > > > +	struct mlx5_core_dev *dev =
> > > > > devlink_health_reporter_priv(reporter);
> > > > > +	struct mlx5_core_health *health = &dev->priv.health;
> > > > > +	u8 synd;
> > > > > +	int err;
> > > > > +
> > > > > +	mutex_lock(&health->info_buf_lock);
> > > > > +	mlx5_get_health_info(dev, &synd);
> > > > > +
> > > > > +	if (!synd) {
> > > > > +		mutex_unlock(&health->info_buf_lock);
> > > > > +		return devlink_fmsg_u8_pair_put(fmsg,
> > > > > "Syndrome", synd);
> > > > > +	}
> > > > > +
> > > > > +	err = devlink_fmsg_string_pair_put(fmsg, "diagnose
> > > > > data",
> > > > > +					   health->info_buf);
> > > > 
> > > > No! This is wrong! You are sneaking in text blob. Please put the
> > > > info in
> > > > structured form using proper fmsg helpers.
> > > > 
> > > This is the fw output format, it is already in use, I don't want
> > > to 
> > > change it, just have it here in the diagnose output too.
> > 
> > Already in use where? in dmesg? Sorry, but that is not an argument.
> > Please format the message properly.
> > 
> 
> What is wrong here ? 
> 
> Unlike binary dump data, I thought diagnose data is allowed to be
> developer friendly free text format, if not then let's enforce it in
> devlink API. Jiri,  you can't audit each and every use of
> devlink_fmsg_string_pair_put, it must be done by design.

I agree with the purpose that Jiri is trying to get out of this infra,
but I disagree that strings should be disallowed.

The example messages from commit log are not useful at all:
$ devlink health diagnose pci/0000:82:00.0 reporter fw
diagnose data:
assert_var[0] 0xfc3fc043
assert_var[1] 0x0001b41c
assert_var[2] 0x00000000
assert_var[3] 0x00000000
assert_var[4] 0x00000000
assert_exit_ptr 0x008033b4
assert_callra 0x0080365c
fw_ver 16.24.1000
hw_id 0x0000020d
irisc_index 0
synd 0x8: unrecoverable hardware error
ext_synd 0x003d
raw fw_ver 0x101803e8

Firmware dumps some magic numbers. How this is any better than
what we have today?
Every bit has to have meaningful message.
The point of devlink diag is not to replicate dmesg, but to give
users a clean way to understand and debug the hw.

It seems mlx is adding a new interface and immediately misusing it.
This not an example to give to other vendors.

