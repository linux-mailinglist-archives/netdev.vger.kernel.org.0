Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9F731510E
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbhBIN5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:57:54 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:53814 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhBIN4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 08:56:22 -0500
Received: by mail-wm1-f46.google.com with SMTP id j11so3214412wmi.3;
        Tue, 09 Feb 2021 05:56:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XSnpm7/HVnmzb1rRaH6rhaurZgUv42UULqOJi/Beqao=;
        b=D4Ek4cgqJooPeb583beOBFvfUnJTxcJf3MQsdxMteT8tpoACHNo29Cxy938QoCbsiz
         buP9hyW7Ii8wh4ugURO34/APzExrrAVsLJQAF8/BIgXlvpeIBDp6jpRJt7QS0RnivrcN
         n8xj6QMptIenethorH2XlOyzxfSvBFBJEmV+klsETyvZAM9Ez35UVOodpltGb2dzFKrX
         sdyxg3/BK/GTxEdPhZjDhqKbmcGpgK52xjzgtN3cBSTr8ddUAR70trnh2fEHaHtKKkYV
         lqhNVAuoFhn9+tB7B+xIv1B6UofXlG0PDPc52pDvHW1jzcIM0IVvIg/jo1cwfJfZhMvT
         Sp+w==
X-Gm-Message-State: AOAM532lYPltvysWL+YYFyw1ix1d/zjC4TQPpC5r7SbRX5QA8psZ+Qfd
        +XdXCYQk3kiS2OxvoF3z08w=
X-Google-Smtp-Source: ABdhPJwNB2giv7+CoyjHR4gxPw378n2meWhV1w/yKa2jvI06fXrZd3Z4dr3WdpEwpM4n3qwOnwgCXQ==
X-Received: by 2002:a1c:ab57:: with SMTP id u84mr3640970wme.115.1612878940148;
        Tue, 09 Feb 2021 05:55:40 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id 2sm20140855wre.24.2021.02.09.05.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 05:55:39 -0800 (PST)
Date:   Tue, 9 Feb 2021 13:55:38 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Subject: Re: [PATCH 4/7] xen/events: link interdomain events to associated
 xenbus device
Message-ID: <20210209135538.ysr5pzxihvwxn22p@liuwe-devbox-debian-v2>
References: <20210206104932.29064-1-jgross@suse.com>
 <20210206104932.29064-5-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210206104932.29064-5-jgross@suse.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 06, 2021 at 11:49:29AM +0100, Juergen Gross wrote:
> In order to support the possibility of per-device event channel
> settings (e.g. lateeoi spurious event thresholds) add a xenbus device
> pointer to struct irq_info() and modify the related event channel
> binding interfaces to take the pointer to the xenbus device as a
> parameter instead of the domain id of the other side.
> 
> While at it remove the stale prototype of bind_evtchn_to_irq_lateeoi().
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
