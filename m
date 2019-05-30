Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A4230178
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfE3SG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:06:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46839 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfE3SGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:06:19 -0400
Received: by mail-pf1-f194.google.com with SMTP id y11so4422889pfm.13
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 11:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2psPcVkxUxJ8LUEIJGin6zunEeQUtyygYhDJh2YC3k8=;
        b=GTFQEqBGqWcPajZ3vdkQUPsjnURpUIEC/zAuGuNBG7aui7Nz9i8xvht7bMDC4Its3h
         f4WCaLFSWnR78/H7el7zfnvkdYL1TbMU+oEBWeb/kr0qhRRikh10tgKr9hz4VeNcdhsu
         mQoXHzxpip8XtTFLQzDqUnsXm1ylYAOKxjvzGJ/v5uaiBofaz+DJVlFDxvCGOeorSKsM
         JnEN/4Tx6xp0Ojdt63Al4kF7V4vf50WMfBKnQrZzf+N02/GuuNzBdKrkugoJDxr6l61A
         mSx8QM5SUE3FWRCDjVNC5htJALRmV4jv+82jG5xCovEgIHxLrZrGXBSTSy4cy+qjVYBW
         qvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2psPcVkxUxJ8LUEIJGin6zunEeQUtyygYhDJh2YC3k8=;
        b=ItwMrbICxuX8RL18++ABODmUhj+ZoDfI8ReJy3Y1l5nVZnmz8hFPgu41oiyWzV1hsf
         xHWQwEe9FAOsnFSSJPiy0/8zrFUw6qQ+Z4dIpK35WAJFgy8VBGw3dJl9+uRNH3ixvY1O
         Aq9+O3+mKoQSQBYMUVRy9hijx3zeg4dGyFuDBuGYb+qGs901PiOqA9O2kh1S4Baor5yS
         8GMiX7eogkSs3FNsnJBSH9G2J6beItpSR/u+Sce8pw3P2OFMAKjlGOgGPghF+AI25GW2
         Fmdi+2mgtjFArKfTw39XBkBwHSU/r+1AJ5ZMNhqZnrPEAfxKaUdRYnSqytD9NA7dZx8O
         zR5w==
X-Gm-Message-State: APjAAAUCwro/VcBOdE/P8ZghPY7LWLWoYBLyX5Ue+Y8dO26fO0uGzRgR
        dXmkpxsRAF4a5cMiwdKrKnIcDTqA6RE=
X-Google-Smtp-Source: APXvYqzSvuzHlGiol4yelt9lN4GAYKKgcCkOSJEoAl36L8qaLo3DDk7fv5TYAMZcI3HtrawlnWJvHg==
X-Received: by 2002:a63:246:: with SMTP id 67mr4908458pgc.145.1559239578930;
        Thu, 30 May 2019 11:06:18 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i22sm3479472pfa.127.2019.05.30.11.06.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 11:06:18 -0700 (PDT)
Date:   Thu, 30 May 2019 11:06:16 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com
Subject: Re: [PATCH iproute2] bridge: mdb: restore text output format
Message-ID: <20190530110616.48097b66@hermes.lan>
In-Reply-To: <20190529175242.20919-1-nikolay@cumulusnetworks.com>
References: <20190529175242.20919-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 20:52:42 +0300
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> While I fixed the mdb json output, I did overlook the text output.
> This patch returns the original text output format:
>  dev <bridge> port <port> grp <mcast group> <temp|permanent> <flags> <timer>
> Example (old format, restored by this patch):
>  dev br0 port eth8 grp 239.1.1.11 temp
> 
> Example (changed format after the commit below):
>  23: br0  eth8  239.1.1.11  temp
> 
> We had some reports of failing scripts which were parsing the output.
> Also the old format matches the bridge mdb command syntax which makes
> it easier to build commands out of the output.
> 
> Fixes: c7c1a1ef51ae ("bridge: colorize output and use JSON print library")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Looks good, thanks for fixing.
Applied.
