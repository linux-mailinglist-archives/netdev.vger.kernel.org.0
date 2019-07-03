Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697655E6D3
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfGCOee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:34:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34214 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfGCOee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 10:34:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so3075462wmd.1
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 07:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nu5Sdrkzna8XEL7fPjG3/ByZ5J249fwkeNnRtjIVb+U=;
        b=ogEHyT0fajmFrSCeCo0tuMnD+O6v9X4xDHUaOdMjL7no8f/Pwa8E1OA7rVaWv8N7Rp
         ow5m/0oqwVALSTdxgy93FiFgdsufB0OjCbTzbPX2VMj5knniiwClN5pDV64vsj/X1xz3
         64MgDQQ9NZc3EZnuKQWRWe/J9CmKNtdnxSaldbGTkdZwWmEaKYsLEd4TDwzcfycEofNK
         g1S22gzyQgQhtkE3+L6L4F1p40hhANdMdBTQas/wMW/opXBdeMMs18pyDP0C3gVGF8r+
         2YhEYrgppI33nNklkHHGViZw2Jf/fQQ8KGGXLZ8nN84FMMl7yD7kww7SIxDcZidCmcmX
         lw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nu5Sdrkzna8XEL7fPjG3/ByZ5J249fwkeNnRtjIVb+U=;
        b=MOZBQY1JywTkNbLbsz20ILKbuiBexPDqZ256fcYV3i95UtpqCNiZlfB41t0J1ivBlV
         R2GM7xaf8xcO++fsZw11EJYA9cQJo8PCaXq6q8wmf8frntW5qf/8dbPcjrBqVmD1dOB1
         zqgcPYCjlK5b3w4Qe5bG8BjxcWqG6YSH0GZXHLeHhOXEYQQylrUdSZbpmjvGf6RWBGD2
         1usaqsNa5z0+lPc2y89m1ivY0fTC4g9uLe1s1E77gff5WiVNzoYgC5c8v1Qd+1a558wX
         jJvoV6Ke8U8ttKlgu6Eecapv0shqoF52gVCKHQqRUrqx4LaXQ47R+BteikbJDtt9Iqmt
         U3VQ==
X-Gm-Message-State: APjAAAXRDnqSR0xFB8wwV2BtKh89NnN6a+hEpOypqDlIdY6xtvFXejV4
        BOy3YymKpezvE7jyMSuCEJA=
X-Google-Smtp-Source: APXvYqwOA335UsNvHGS3Y0IcbEjyXczehLrpYnZCGBLyrRztrGwRsERIukwcLofUnMG1nhCUW1ttBQ==
X-Received: by 2002:a1c:630a:: with SMTP id x10mr8923155wmb.113.1562164472547;
        Wed, 03 Jul 2019 07:34:32 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id g2sm2743275wmh.0.2019.07.03.07.34.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 07:34:32 -0700 (PDT)
Date:   Wed, 3 Jul 2019 16:34:31 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Parav Pandit <parav@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>, vivien.didelot@gmail.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Message-ID: <20190703143431.GC2250@nanopsycho>
References: <20190701162650.17854185@cakuba.netronome.com>
 <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702104711.77618f6a@cakuba.netronome.com>
 <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702164252.6d4fe5e3@cakuba.netronome.com>
 <AM0PR05MB4866F1AF0CF5914B372F0BCCD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702191536.4de1ac68@cakuba.netronome.com>
 <AM0PR05MB486624D2D9BAD293CD5FB33CD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190703103720.GU2250@nanopsycho>
 <20190703140958.GB18473@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703140958.GB18473@lunn.ch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 03, 2019 at 04:09:58PM CEST, andrew@lunn.ch wrote:
>> However, we expose it for DEVLINK_PORT_FLAVOUR_CPU and
>> DEVLINK_PORT_FLAVOUR_DSA. Not sure if it makes sense there either.
>> Ccing Florian, Andrew and Vivien.
>> What do you guys think?
>
>Hi Jiri
>
>DSA and CPU ports are physical ports of the switch. And there can be
>multiple DSA ports, and maybe sometime real soon now, multiple CPU
>ports. So having a number associated with them is useful.

Okay. Makes sense.

>
>       Andrew
