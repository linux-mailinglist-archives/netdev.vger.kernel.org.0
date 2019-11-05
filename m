Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70CB1EF780
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbfKEIrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:47:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55053 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKEIrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:47:09 -0500
Received: by mail-wm1-f67.google.com with SMTP id z26so6661227wmi.4
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 00:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VeJfr81HWB2luNDMkYvhTx/QeEA6gXL5xogmrTmKQKI=;
        b=nmDM4lWBWM0ChGt+XN+OPfjU18NWX3Fq9Y0hK4d/9H1z1262sMY1OKuOI8Q88/I26W
         LP0+F1DZFTZqpRGm9uwyFcQifkn+60Acr7z+9eWcv4vz5PAW1OCybgSk/9CnzfVWl3ep
         8gKsJVToojHU1kN+OPNf50UnJwgUFNgPsQ+M2m6LMz5RUWs4qYzx5KKK0oVyQLWqd1Fn
         nu85YFwsDpVpwh/menKHXS4XvoWac4RSPgLFA5TVpm3ZO44pD/XbP5aGehAgwr9WWRRz
         /sVk2eUg78q6ChvKHh5d0BrHZr5bbn+aY+IoCck8XOM71BO+otnGWELYGkw88jI5t/a2
         bdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VeJfr81HWB2luNDMkYvhTx/QeEA6gXL5xogmrTmKQKI=;
        b=HHAjuPMGMaCP3jJMmkyQMWXb7Vokps2UvfkzgPoLN4H32fhvoZvG1ULyIbVf9stw8y
         gPNLKK6MM6N4wtrAAr3TrhpTSynFnGV5ip7lLi1EJyd9NhVIPChoOpKgeUwilXeXeTrL
         9fS4YZyK1pJ+vxM603N3rsC3iKvBaC6ekUovNPgWplHMhhwJGrb5Xl9urkO/5PXmISJw
         lrEYyPVrmTPwv0oLbw4Tw9GJ/SZmSwIEJuc9M9Bb62THO97MvU3j/8cumIIUiNIkFg9d
         xmU4hANGTEpdJV+M1eUtTqyi6ZJwFkYst4puAkc3h4zr1m4oTNpyTTbCOzv6Cf1VivaX
         307g==
X-Gm-Message-State: APjAAAX9rGbQmpNSbWS+6c0c1QklyflshLWynmpSJGwynRz4JVuPke27
        swCFwHRDoRIYPnXCANX7Ej+j9Q==
X-Google-Smtp-Source: APXvYqzaI3yzD0AB1qFNTeNePh8r1X4VQx4Qj4Ov38F8oWh+B0G29zUioQv4FCMalfUdoVK4HaHo5Q==
X-Received: by 2002:a05:600c:22cf:: with SMTP id 15mr2770957wmg.148.1572943627231;
        Tue, 05 Nov 2019 00:47:07 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id t12sm18485521wrx.93.2019.11.05.00.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 00:47:06 -0800 (PST)
Date:   Tue, 5 Nov 2019 09:47:06 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>, jiri@mellanox.com
Subject: Re: [PATCH net-next 1/5] net: dsa: Add support for devlink resources
Message-ID: <20191105084706.GA3465@nanopsycho>
References: <20191105001301.27966-1-andrew@lunn.ch>
 <20191105001301.27966-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105001301.27966-2-andrew@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 05, 2019 at 01:12:57AM CET, andrew@lunn.ch wrote:
>Add wrappers around the devlink resource API, so that DSA drivers can
>register and unregister devlink resources.
>
>Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Acked-by: Jiri Pirko <jiri@mellanox.com>
