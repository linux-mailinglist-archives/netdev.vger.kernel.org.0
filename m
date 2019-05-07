Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8012A15C2C
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfEGGB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 02:01:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51719 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfEGGB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 02:01:26 -0400
Received: by mail-wm1-f68.google.com with SMTP id o189so7778464wmb.1
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 23:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KJkEcPKcyCO15sTJd1UjSAFChJ/2S6JH0Z/zgIF+zcw=;
        b=jzQIPN6DSDX9FkrnssF470q9lxu3MwbeEew8gvBADSugGJPAVaO5Pxf5dvBJOAAKyS
         4GsScUeBmM7P8RsQkZ87uZsLwM1a44cUqcTqw7TpJkXT5MlSE++mpeyjvCkTNcyCIAXr
         8Lz9UZhkH0M74dCDfgTKWmIQAAwUaNWbLnaQhfdbrHEHBnH2iHE5Z8n8yYpV17FoOkoO
         IUgS86n7HW2cdGbJIKcyu0Bi4/F15i5hFX4G/W6lBuJ7Nmzea9dF1YiyDJFlU0rJaISz
         fHNtwMIZAnLIUk6ELJZQ6UUbj7YTHUCo9IGmA0OGRRx63ZDVP0S0L+VpeGjck19XjAi1
         lYJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KJkEcPKcyCO15sTJd1UjSAFChJ/2S6JH0Z/zgIF+zcw=;
        b=pNEO+edlyrhO+74UNwouClhCN5MM/75pwsAG434LOcYRzwmo3ZtDoZoe2QHOE7ntlg
         JHJwKf86cUgAzEZJi9se/O+KsuvsDxr0wOWz066W9P2Htm6id52Sd8IlkdX446u9a7Ea
         FvT4gdXoP1/WClMaWihJrjbHW+Y62gWh6KiECf0iNhHRDCfXtBRH3s6G0ZAgxO80+K9g
         5k2IILPa2pnHl1ZksWkP6MO501W1v+H+Ir3jFHk78WN1jnAss/skS61rFqSgznQ7wgHa
         9+jJeCQ8LgXe9XA0qzTE2dA2W4EoSjeKAJ5uVNlXBMnDw50VS/DWSMGxQM1WIorxG23V
         f2GA==
X-Gm-Message-State: APjAAAXTXnX4TqbhauBtto2n7gbUlsx+k3F8XRCEpgSGaRuS6+ExNxOd
        e59nLdNew3hLwTeuDhqsj1yUww==
X-Google-Smtp-Source: APXvYqzx2yyY4LB6sPLOOWgZ3jRnhePEBt5GZU6GNf/7WUXV0xAC7C1r4UgGSbcGErrwLM9u7lRL9g==
X-Received: by 2002:a7b:c093:: with SMTP id r19mr5980509wmh.35.1557208884791;
        Mon, 06 May 2019 23:01:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q3sm6392841wrr.16.2019.05.06.23.01.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 23:01:24 -0700 (PDT)
Date:   Tue, 7 May 2019 08:01:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Message-ID: <20190507060123.GB14667@nanopsycho.orion>
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
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 06, 2019 at 09:52:18PM CEST, saeedm@mellanox.com wrote:
>On Mon, 2019-05-06 at 13:38 +0200, Jiri Pirko wrote:
>> Mon, May 06, 2019 at 12:45:44PM CEST, moshe@mellanox.com wrote:
>> > 
>> > On 5/5/2019 6:42 PM, Jiri Pirko wrote:
>> > > Sun, May 05, 2019 at 02:33:23AM CEST, saeedm@mellanox.com wrote:
>> > > > From: Moshe Shemesh <moshe@mellanox.com>
>> > > > 
>> > > > Create mlx5_devlink_health_reporter for FW reporter. The FW
>> > > > reporter
>> > > > implements devlink_health_reporter diagnose callback.
>> > > > 
>> > > > The fw reporter diagnose command can be triggered any time by
>> > > > the user
>> > > > to check current fw status.
>> > > > In healthy status, it will return clear syndrome. Otherwise it
>> > > > will dump
>> > > > the health info buffer.
>> > > > 
>> > > > Command example and output on healthy status:
>> > > > $ devlink health diagnose pci/0000:82:00.0 reporter fw
>> > > > Syndrome: 0
>> > > > 
>> > > > Command example and output on non healthy status:
>> > > > $ devlink health diagnose pci/0000:82:00.0 reporter fw
>> > > > diagnose data:
>> > > > assert_var[0] 0xfc3fc043
>> > > > assert_var[1] 0x0001b41c
>> > > > assert_var[2] 0x00000000
>> > > > assert_var[3] 0x00000000
>> > > > assert_var[4] 0x00000000
>> > > > assert_exit_ptr 0x008033b4
>> > > > assert_callra 0x0080365c
>> > > > fw_ver 16.24.1000
>> > > > hw_id 0x0000020d
>> > > > irisc_index 0
>> > > > synd 0x8: unrecoverable hardware error
>> > > > ext_synd 0x003d
>> > > > raw fw_ver 0x101803e8
>> > > > 
>> > > > Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> > > > Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
>> > > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>> > > 
>> > > 	
>> > > [...]	
>> > > 	
>> > > 	
>> > > > +static int
>> > > > +mlx5_fw_reporter_diagnose(struct devlink_health_reporter
>> > > > *reporter,
>> > > > +			  struct devlink_fmsg *fmsg)
>> > > > +{
>> > > > +	struct mlx5_core_dev *dev =
>> > > > devlink_health_reporter_priv(reporter);
>> > > > +	struct mlx5_core_health *health = &dev->priv.health;
>> > > > +	u8 synd;
>> > > > +	int err;
>> > > > +
>> > > > +	mutex_lock(&health->info_buf_lock);
>> > > > +	mlx5_get_health_info(dev, &synd);
>> > > > +
>> > > > +	if (!synd) {
>> > > > +		mutex_unlock(&health->info_buf_lock);
>> > > > +		return devlink_fmsg_u8_pair_put(fmsg,
>> > > > "Syndrome", synd);
>> > > > +	}
>> > > > +
>> > > > +	err = devlink_fmsg_string_pair_put(fmsg, "diagnose
>> > > > data",
>> > > > +					   health->info_buf);
>> > > 
>> > > No! This is wrong! You are sneaking in text blob. Please put the
>> > > info in
>> > > structured form using proper fmsg helpers.
>> > > 
>> > This is the fw output format, it is already in use, I don't want
>> > to 
>> > change it, just have it here in the diagnose output too.
>> 
>> Already in use where? in dmesg? Sorry, but that is not an argument.
>> Please format the message properly.
>> 
>
>What is wrong here ? 
>
>Unlike binary dump data, I thought diagnose data is allowed to be
>developer friendly free text format, if not then let's enforce it in
>devlink API. Jiri,  you can't audit each and every use of
>devlink_fmsg_string_pair_put, it must be done by design.

No way to enforce it. Strings need to be there in general. But drivers
have to use them wisely, only for plain values. Unlike this patch, which
is pushing structured text blob in it.

