Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBFB5E220
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 12:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGCKhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 06:37:23 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40613 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfGCKhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 06:37:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so2179442wre.7
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 03:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PRVBBer/tcjnndubI7SKAMwPa4hnhzK7MM2y6KvZ3m0=;
        b=a3oclML/oX27sTD9MZ2uw9kcJJoKMVLKy5MbwVJXcxhgrQ1Uv9CjYzUdyULlVBpRq9
         NQ0p8lTfWqnaPhxVs4Fys1xO8Y7MxzhwEpMcsxzJ7ywys5OCZ/ty87xKOskqOX/cRXZh
         HrhC38ziOg5xnP5u/oFOrxwQt3UpqoglXlKU0UerWUcAAYP3bxhPQus2WqsDfjl/hMHe
         hYoJ4VAcGKrLQsNXmOrutmZbuMGlc2ai2SVbsUJ3H+S90AEtyJeIY1kgSr4p+GWpQr/M
         frso+RCyzJQzCbh1vaPsyA9mVHhTNF8qd3hDZM/ZtjoIlCSQ7skNZx8Vf0Aq21iRGgJu
         WgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PRVBBer/tcjnndubI7SKAMwPa4hnhzK7MM2y6KvZ3m0=;
        b=RZ5JNCAj55uoVt0GatWSO/2Qhsm0K9XSZtnmjgNRhi5bDmE/mrbRR3tlRBYzt6J5ka
         egQkhHx5373gaxwInLU52ax2aSOttwegEZtf32/PDY0yPrrNuBtNExzqvvdaX1Q9DllO
         GsA6moPNWpntytCOZpLj/jCsbHt0jpZqqmcHjufqw9iPlVjKsELNfQw4K80uCSQHXnFN
         Ng9pP39d71S8eV+iQedQ/zqmpZf1aO0DGNL947pnrbFmOd/On28pTvuCMoPdg+hLQNrZ
         va+sZ4MpWt+QL9Lg5GCRjQMGLw/DcHfYiaQidBzCkAL7B3MDI8gVqucz/+1Kdi9DM3m+
         jC8A==
X-Gm-Message-State: APjAAAVFZWOpxlJx0zavvNXKa7BnV4542CgFdTE4p8JeLYi3qe71OYS4
        wWOlOUmfNSTJ5e3ZdmajVzTPxQ==
X-Google-Smtp-Source: APXvYqz1qaUuHB3oo1S7z9HL/OjznUtNRMke+fTd1mtnOWF9Md8oAhPYibWZBMsciPW4srMKcvWLag==
X-Received: by 2002:adf:979a:: with SMTP id s26mr13651782wrb.13.1562150241282;
        Wed, 03 Jul 2019 03:37:21 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id a3sm1935827wmb.35.2019.07.03.03.37.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 03:37:20 -0700 (PDT)
Date:   Wed, 3 Jul 2019 12:37:20 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Message-ID: <20190703103720.GU2250@nanopsycho>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190701122734.18770-2-parav@mellanox.com>
 <20190701162650.17854185@cakuba.netronome.com>
 <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702104711.77618f6a@cakuba.netronome.com>
 <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702164252.6d4fe5e3@cakuba.netronome.com>
 <AM0PR05MB4866F1AF0CF5914B372F0BCCD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702191536.4de1ac68@cakuba.netronome.com>
 <AM0PR05MB486624D2D9BAD293CD5FB33CD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB486624D2D9BAD293CD5FB33CD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 03, 2019 at 06:46:13AM CEST, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Sent: Wednesday, July 3, 2019 7:46 AM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: Jiri Pirko <jiri@mellanox.com>; netdev@vger.kernel.org; Saeed
>> Mahameed <saeedm@mellanox.com>
>> Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
>> port attribute
>> 
>> On Wed, 3 Jul 2019 02:08:39 +0000, Parav Pandit wrote:
>> > > If you want to expose some device specific eswitch port ID please
>> > > add a new attribute for that.
>> > > The fact that that ID may match port_number for your device today is
>> > > coincidental.  port_number, and split attributes should not be
>> > > exposed for PCI ports.
>> >
>> > So your concern is non mellanox hw has eswitch but there may not be a
>> > unique handle to identify a eswitch port?
>> 
>> That's not a concern, no.  Like any debug attribute it should be optional.
>> 
>> > Or that handle may be wider than 32-bit?
>> 
>> 64 bit would probably be better, yes, although that wasn't my initial
>> concern.
>> 
>Why 32-bit is not enough?
>
>> > And instead of treating port_number as handle, there should be
>> > different attribute, is that the ask?
>> 
>> Yes, the ask, as always, is to not abuse existing attributes to carry
>> tangentially related information.
>
>Why it is tangential?
>Devlink_port has got a port_number. Depending on flavour this port_number represents a port.
>If it is floavour=PHYSICAL, its physical port number.
>If it is eswitch pf/vf ports, it represents eswitch port.
>
>Why you see it only as physical_port_number?

The original intention was like that. See the desc of
devlink_port_attrs_set():

 *      @port_number: number of the port that is facing user, for example
 *                    the front panel port number

For vf/pf representors, this is not applicable and should be indeed
avoided.

However, we expose it for DEVLINK_PORT_FLAVOUR_CPU and
DEVLINK_PORT_FLAVOUR_DSA. Not sure if it makes sense there either.
Ccing Florian, Andrew and Vivien.
What do you guys think?

Perhaps we should have:
	if (attrs->flavour == DEVLINK_PORT_FLAVOUR_PHYSICAL &&
	    nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs->port_number))
                return -EMSGSIZE;
in devlink_nl_port_attrs_put()

