Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED1E1074EE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 16:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfKVPck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 10:32:40 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46150 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfKVPcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 10:32:39 -0500
Received: by mail-qt1-f193.google.com with SMTP id r20so8189614qtp.13;
        Fri, 22 Nov 2019 07:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=3dYqDBTtgP5XtAXKi8VqGBK1T+2eM5ua2xkGVDRu3sU=;
        b=Wko8uZW+HZHX101h/glfPk2TwQpX8eA3RoRJBlvcPjKO1YFB1gAZNm/aJKbEeWM2mC
         WoLhmD4VPMBtvS724RLDe7TmnR9C2GjaykNl6ZO1A5l3gqQ/aYDLVCAIzyho/j5jW5tM
         B1rZjzj+OpHMmHNyz8V25I1+PEwBD/01txRDavVizPaFck1cRiLwIxIbMOwbV8FE13oy
         HPfw2WK0ktZbufdrr35VjTjsi26eWHz+N4cfFynalx0qoX25B8r7BWjCYanXuYI60lY5
         /ZveS/yy8OKJQKS4CvmE4p6zvLrqrRcRxOuhDnK09lgIRspFCyM6HKpJGJwgeQYtRHOg
         OQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=3dYqDBTtgP5XtAXKi8VqGBK1T+2eM5ua2xkGVDRu3sU=;
        b=CD7rWBQcn67sgAR4FYU0Wr0MSy0tzKxScSCG342hq8JKMgV4/iIVLCWQDLQebMsbpD
         JRONRqIVJsj2RhRZGmeHGN9Pj762NmOHkIF1dRFNN+3MwfOgsW9FAVX/fmJwWv1WLSLT
         2Y7MgF2Z7rpOclCgsFEfT4vRsH+ZRbSiZBIt2IY7uEMwgK3hCxUkER6Pgra2Z0jUEjlX
         iK07j9sXmOCNcMdPHDT4MBBVZ3bDa1qkrHXfU0LbOaGc8g/A45XI7UaAjqlMq1E+Ldm/
         77uWed8GJPaeZSFOzLOJV7Gow1DkN7qd1mLkhWbsYXuPWJTW3+2FHxX20VjOd7b+HODc
         4NDg==
X-Gm-Message-State: APjAAAVXLz/QA5WhVsxxva5Py1riHeYppLjTiR9QqMryGYjIUXy/qtqx
        IxLGfJ82GribpNsmMKRVw8w=
X-Google-Smtp-Source: APXvYqxpWhu362qs5B2IRWYx9RpSlMLPqgpS0sjhL2aS+shabDbMr8Vc1kJtregaLu4VwhXrb0Nxtw==
X-Received: by 2002:ac8:661a:: with SMTP id c26mr14774515qtp.317.1574436758716;
        Fri, 22 Nov 2019 07:32:38 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id v189sm3149907qkc.37.2019.11.22.07.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 07:32:37 -0800 (PST)
Date:   Fri, 22 Nov 2019 10:32:36 -0500
Message-ID: <20191122103236.GB1112895@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Chen Wandun <chenwandun@huawei.com>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chenwandun@huawei.com
Subject: Re: [PATCH] net: dsa: ocelot: fix "should it be static?" warnings
In-Reply-To: <1574425965-97890-1-git-send-email-chenwandun@huawei.com>
References: <1574425965-97890-1-git-send-email-chenwandun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 20:32:45 +0800, Chen Wandun <chenwandun@huawei.com> wrote:
> Fix following sparse warnings:
> drivers/net/dsa/ocelot/felix.c:351:6: warning: symbol 'felix_txtstamp' was not declared. Should it be static?
> 
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
