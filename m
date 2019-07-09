Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 521C463143
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 08:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfGIG4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 02:56:24 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55865 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfGIG4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 02:56:24 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so1816769wmj.5
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 23:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=rdOPFDMjmBEcsqwgtw6RRAGA64q55ka2JoyHfevIB/4=;
        b=B9d7wvg4cVEsAu9h5xCuoYEOaibZFCiql+BGvnSK1K5+G5CCzs9rPOynrOWTXrzJjT
         a84pKBlIG9cCRYtta+2SemZbAZnnzh2CmExpHslJ3UWnlsPeYHfPIsSaMb3hE9a9spRa
         QUs/FnVuUqzwLrYfofmf5t3V+47izHbE8EoIPROuksUUBcqdqm9sk3xt+2Syu+C7BNP2
         IPteUgb65BPpQ9/Jg/x9U1dC38f63hTjblbo3BEbwRSJHcziSrFhXIq/JUl0N0kUGIM9
         MgUX+AbQ7HAEa1l1ekmLxOpGuYU3piXg/Ahk4YNszB55K+yMmpN3qaNNwnbhCTJ8CQXV
         ZVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=rdOPFDMjmBEcsqwgtw6RRAGA64q55ka2JoyHfevIB/4=;
        b=kAE5dESJJc+6hNT+m+hpxeI6V7E7w5SV17SGyCxFdAPj4hGhOsvyZ3nktWDX/JPoxL
         ci8Dpiqu+t3MFFgyWMRoBRtqcRYpLyxRbxuB4ELmd5bUX4QkzHLH29bIMu8CYlJ18xfV
         a+wzawceeTHyOQKv+42CQGTSRA2nfmPMlHq7/eQPo4Pqr8H717wMoS+Zce/jOc6EUamk
         X5t3YiY2Wdn7Ni5KzTzTsDkk4f8iO6bknVXFq6G/hAZU4mw5rinbHSOPBi5qUBc7OhGd
         0WkN7tDPSP0fUiBsUNgUiaWayETV5bG0lVf7Bf45p/QsgkiyaDMpCGFr8EtYlQbRQGqy
         qHpw==
X-Gm-Message-State: APjAAAXV1E6u0gzZ1ri/tQgREoHu+NGVep+ul1AhP4+QeBlDBlA8I2GR
        fHWJprAKq4dNTZJCZDljwwbHz0pjnSE=
X-Google-Smtp-Source: APXvYqwDyFP8qg2EJ8MnKH4Hxmh+1AlUaZwhjfsC9u3WJK67n9tCfvJQldOdGwCSV8LR1I6UjI1wig==
X-Received: by 2002:a1c:305:: with SMTP id 5mr21170888wmd.101.1562655381220;
        Mon, 08 Jul 2019 23:56:21 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b2sm24167301wrp.72.2019.07.08.23.56.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 23:56:20 -0700 (PDT)
Date:   Tue, 9 Jul 2019 08:56:20 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 19/19] ionic: Add basic devlink interface
Message-ID: <20190709065620.GJ2282@nanopsycho.orion>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-20-snelson@pensando.io>
 <20190708193454.GF2282@nanopsycho.orion>
 <af206309-514d-9619-1455-efc93af8431e@pensando.io>
 <20190708200350.GG2282@nanopsycho.orion>
 <6f9ebbca-4f13-b046-477c-678489e6ffbf@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6f9ebbca-4f13-b046-477c-678489e6ffbf@pensando.io>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 09, 2019 at 12:58:00AM CEST, snelson@pensando.io wrote:
>On 7/8/19 1:03 PM, Jiri Pirko wrote:
>> Mon, Jul 08, 2019 at 09:58:09PM CEST, snelson@pensando.io wrote:
>> > On 7/8/19 12:34 PM, Jiri Pirko wrote:
>> > > Mon, Jul 08, 2019 at 09:25:32PM CEST, snelson@pensando.io wrote:
>> > > > 
>> > > > +
>> > > > +static const struct devlink_ops ionic_dl_ops = {
>> > > > +	.info_get	= ionic_dl_info_get,
>> > > > +};
>> > > > +
>> > > > +int ionic_devlink_register(struct ionic *ionic)
>> > > > +{
>> > > > +	struct devlink *dl;
>> > > > +	struct ionic **ip;
>> > > > +	int err;
>> > > > +
>> > > > +	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic *));
>> > > Oups. Something is wrong with your flow. The devlink alloc is allocating
>> > > the structure that holds private data (per-device data) for you. This is
>> > > misuse :/
>> > > 
>> > > You are missing one parent device struct apparently.
>> > > 
>> > > Oh, I think I see something like it. The unused "struct ionic_devlink".
>> > If I'm not mistaken, the alloc is only allocating enough for a pointer, not
>> > the whole per device struct, and a few lines down from here the pointer to
>> > the new devlink struct is assigned to ionic->dl.  This was based on what I
>> > found in the qed driver's qed_devlink_register(), and it all seems to work.
>> I'm not saying your code won't work. What I say is that you should have
>> a struct for device that would be allocated by devlink_alloc()
>
>Is there a particular reason why?  I appreciate that devlink_alloc() can give
>you this device specific space, just as alloc_etherdev_mq() can, but is there

Yes. Devlink manipulates with the whole device. However,
alloc_etherdev_mq() allocates only net_device. These are 2 different
things. devlink port relates 1:1 to net_device. However, devlink
instance can have multiple ports. What I say is do it correctly.


>a specific reason why this should be used instead of setting up simply a
>pointer to a space that has already been allocated?  There are several
>drivers that are using it the way I've setup here, which happened to be the
>first examples I followed - are they doing something different that makes
>this valid for them?

Nope. I'll look at that and fix.


>
>> 
>> The ionic struct should be associated with devlink_port. That you are
>> missing too.
>
>We don't support any of devlink_port features at this point, just the simple
>device information.

No problem, you can still register devlink_port. You don't have to do
much in order to do so.


>
>sln
>
>> 
>> 
>> > That unused struct ionic_devlink does need to go away, it was superfluous
>> > after working out a better typecast off of devlink_priv().
>> > 
>> > I'll remove the unused struct ionic_devlink, but I think the rest is okay.
>> > 
>> > sln
>> > 
>> > > 
>> > > > +	if (!dl) {
>> > > > +		dev_warn(ionic->dev, "devlink_alloc failed");
>> > > > +		return -ENOMEM;
>> > > > +	}
>> > > > +
>> > > > +	ip = (struct ionic **)devlink_priv(dl);
>> > > > +	*ip = ionic;
>> > > > +	ionic->dl = dl;
>> > > > +
>> > > > +	err = devlink_register(dl, ionic->dev);
>> > > > +	if (err) {
>> > > > +		dev_warn(ionic->dev, "devlink_register failed: %d\n", err);
>> > > > +		goto err_dl_free;
>> > > > +	}
>> > > > +
>> > > > +	return 0;
>> > > > +
>> > > > +err_dl_free:
>> > > > +	ionic->dl = NULL;
>> > > > +	devlink_free(dl);
>> > > > +	return err;
>> > > > +}
>> > > > +
>> > > > +void ionic_devlink_unregister(struct ionic *ionic)
>> > > > +{
>> > > > +	if (!ionic->dl)
>> > > > +		return;
>> > > > +
>> > > > +	devlink_unregister(ionic->dl);
>> > > > +	devlink_free(ionic->dl);
>> > > > +}
>> > > > diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
>> > > > new file mode 100644
>> > > > index 000000000000..35528884e29f
>> > > > --- /dev/null
>> > > > +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
>> > > > @@ -0,0 +1,12 @@
>> > > > +/* SPDX-License-Identifier: GPL-2.0 */
>> > > > +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>> > > > +
>> > > > +#ifndef _IONIC_DEVLINK_H_
>> > > > +#define _IONIC_DEVLINK_H_
>> > > > +
>> > > > +#include <net/devlink.h>
>> > > > +
>> > > > +int ionic_devlink_register(struct ionic *ionic);
>> > > > +void ionic_devlink_unregister(struct ionic *ionic);
>> > > > +
>> > > > +#endif /* _IONIC_DEVLINK_H_ */
>> > > > -- 
>> > > > 2.17.1
>> > > > 
>
