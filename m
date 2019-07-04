Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA2E5F407
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfGDHox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:44:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39943 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfGDHox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:44:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so4943479wmj.5
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 00:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W65VeVUNIkHBy0pg3+jT/JsP/IOvzyC7CKYCmaZQDuU=;
        b=iewLVq506SCTVdBm6/R6k70+NWzysUyjduq/ely+fOAqRHRsfmr33s9t9cRUT4yT0U
         TMoLPig+a5I5klGLKoKtsxnVgRTvda7qQkwqXdVddEUf0gI9K2sQqwlbLTUn19xU7sID
         h8sY4QF+3RQc7GIOtcd8A2o7GfjLiIXZSoiyIw8iuo0E/fpsOkDowEAeUb0YxUG1zNpj
         oudLngvRj9HFP3t/5uFxtGGXaz4CoyTz9eSmR6bBZmV5PWTCS+Jv97osG9tsg+JIVZYV
         Gr95slAJrCY63EnTlX3iT9bwcMACr2o02NBxl883FCVuTDpAeEDRV/J5rig5/BDhT7CA
         QZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W65VeVUNIkHBy0pg3+jT/JsP/IOvzyC7CKYCmaZQDuU=;
        b=XF7Tat3zRzkPNPvWmfDu7tO5nAbV+S311zjjp6Cjq5KmaBMAw8M+g+ycHrzFHC1IIo
         wp685BuLDAnfue6vOaBWEx6aRnUatn57h+9KywC+pE0TBDHrz/Muy+a/ovJEqXY2x0Ww
         /aK1+Nu7VuB/mISbEsRHvx/93B/OJSk+9fKEvurgYUQunfTI/ZHHkvROdCa/lcdTjH2d
         YkN6x3rJeDH0y22paeB6EZRtshbpq4Lu9hdQLl2hCyXbwZxAZBPIelLsl4C0KiEcNjz7
         y3HcR/F1DRJlnF+Al7fDNIYh2RdV29yfLXQi9hkZoHiYjxSIfee8/A1sXrRczr2oFgE4
         ieUA==
X-Gm-Message-State: APjAAAVaUb2SCDvJqU862mioGQ9zohZySMuFXMBfX27FwZXFlS7M3KKF
        Ow5fFu1uGWFl2ac0HOWfEdCSHQ==
X-Google-Smtp-Source: APXvYqwHFzxB79Ppgx6yUSJ/GmGP0nPqGR95RUYepw41gy4KlxIZVEk/SYna6jryANPp0QqmXwXO8w==
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr11533764wma.46.1562226291354;
        Thu, 04 Jul 2019 00:44:51 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id l1sm3559271wmg.13.2019.07.04.00.44.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 00:44:50 -0700 (PDT)
Date:   Thu, 4 Jul 2019 09:44:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Message-ID: <20190704074450.GE2250@nanopsycho>
References: <20190702104711.77618f6a@cakuba.netronome.com>
 <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702164252.6d4fe5e3@cakuba.netronome.com>
 <AM0PR05MB4866F1AF0CF5914B372F0BCCD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702191536.4de1ac68@cakuba.netronome.com>
 <AM0PR05MB486624D2D9BAD293CD5FB33CD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190703103720.GU2250@nanopsycho>
 <20190703140958.GB18473@lunn.ch>
 <20190703143431.GC2250@nanopsycho>
 <AM0PR05MB48665F6CA614A3770D6ABCF4D1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB48665F6CA614A3770D6ABCF4D1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 03, 2019 at 06:13:17PM CEST, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Wednesday, July 3, 2019 8:05 PM
>> To: Andrew Lunn <andrew@lunn.ch>
>> Cc: Parav Pandit <parav@mellanox.com>; Jakub Kicinski
>> <jakub.kicinski@netronome.com>; Jiri Pirko <jiri@mellanox.com>;
>> netdev@vger.kernel.org; Saeed Mahameed <saeedm@mellanox.com>;
>> vivien.didelot@gmail.com; f.fainelli@gmail.com
>> Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
>> port attribute
>> 
>> Wed, Jul 03, 2019 at 04:09:58PM CEST, andrew@lunn.ch wrote:
>> >> However, we expose it for DEVLINK_PORT_FLAVOUR_CPU and
>> >> DEVLINK_PORT_FLAVOUR_DSA. Not sure if it makes sense there either.
>> >> Ccing Florian, Andrew and Vivien.
>> >> What do you guys think?
>> >
>> >Hi Jiri
>> >
>> >DSA and CPU ports are physical ports of the switch. And there can be
>> >multiple DSA ports, and maybe sometime real soon now, multiple CPU
>> >ports. So having a number associated with them is useful.
>> 
>> Okay. Makes sense.
>> 
>Ok. I should probably update the comment section for port_number as its scope is expanded.
>Should I revise the series with updated comment?

Please do. Also put a check to not fillup port_number attribute in case
of pf/vf flavour. Thanks!

>
>> >
>> >       Andrew
