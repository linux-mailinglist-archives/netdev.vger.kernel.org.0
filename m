Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607532283A3
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 17:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgGUPXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 11:23:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36278 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgGUPXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 11:23:11 -0400
Received: by mail-wm1-f68.google.com with SMTP id 17so3290850wmo.1;
        Tue, 21 Jul 2020 08:23:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p7EhiTheSPT8YoryckcdBWxVTJmOmoe7ehYp9Iw7gw8=;
        b=UqkSXF5N+1/sz1Hj7XufEOJ+w4s2U8XETUaGdksrr7H/2TGMTtbLZyztshkVfI9mnr
         I6Z1H38DKAQcNHa0X3JUSRjBJMuTTsrSIeckFbTqRrN+I99YNNkTGyplw/xb0LzoSxfE
         wkAMpn/upYfhUfzztgIUxFx1yRx4lMB2TSESXGW46/G2JQ1Um9hgRpqiQj4ari6npt6C
         Hsky0hOHN2pca2InT8sm4aKvM3Hln3DXDyK5suTkZpxcc/bC/B55W/Q5bcbyWvWkhAlF
         7Am8oY9cg3uZ1Yfxutfphn3Lbt9Bt2reTbheVwz2GeogMV5QqbpnTdZ6gX7+XkHE9xvq
         dPXQ==
X-Gm-Message-State: AOAM531bDodHJdadZMwPyrZhqZurEwsEUvCGV0RGNtJzYh3VJczHOwuv
        UN4BykCY+LUHBVXuFyj29UM=
X-Google-Smtp-Source: ABdhPJwWVBw3s/flYuwbNz80xtxewRBzFgP2+qrzIC5pqCiEUkA61+GqhztC/p9e/hTodVJH1xTvtQ==
X-Received: by 2002:a7b:cf16:: with SMTP id l22mr4957939wmg.68.1595344989506;
        Tue, 21 Jul 2020 08:23:09 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id d13sm37693674wrq.89.2020.07.21.08.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 08:23:08 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:23:07 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [RFC 02/11] Drivers: hv: vmbus: Move __vmbus_open()
Message-ID: <20200721152307.5y66fvm2muyf3xqq@liuwe-devbox-debian-v2>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-3-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721014135.84140-3-boqun.feng@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 09:41:26AM +0800, Boqun Feng wrote:
> Pure function movement, no functional changes. The move is made, because
> in a later change, __vmbus_open() will rely on some static functions
> afterwards, so we sperate the move and the modification of
> __vmbus_open() in two patches to make it easy to review.
> 
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
