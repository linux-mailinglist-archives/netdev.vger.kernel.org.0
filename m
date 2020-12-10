Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D428C2D6400
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 18:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392648AbgLJROq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 12:14:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392532AbgLJROm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 12:14:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607620394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9+sZiQTpBj4sPkMgcRd8EiX+JKrqzXgdUV0LvARz7zM=;
        b=PWMKLUcC8fSmXOWeZZYydexiG3ZGxUlhs7m3cNSPV8Lan42Iuo/QgMfdktzxwhcWj6Bktm
        xGvef106i6aAUpbC/t05WW696S6LcYizdfVEVX059W3DzIl0feHlTv0gnCyYew4K/peVST
        DZ5mskhn6L9lTG2+lmkDvSDm7Va2iN0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-atGdpOIyOQ2Efujr8XJCOA-1; Thu, 10 Dec 2020 12:13:13 -0500
X-MC-Unique: atGdpOIyOQ2Efujr8XJCOA-1
Received: by mail-wr1-f69.google.com with SMTP id q18so2166304wrc.20
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:13:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9+sZiQTpBj4sPkMgcRd8EiX+JKrqzXgdUV0LvARz7zM=;
        b=IUiJEtEtsfki2OPUOvTGFqJVC5ZV/MMFCxdb/p7QblSLAcx4Gl+Q42WZ4oHhf8Y2th
         nWaw0xq3b08jq+b4RcBO8PaQgwADcV2GLxPd1w/3tval13lzTMBBQLiG/T3AgNgsREjH
         aK/BPi5gxNERnOV89zPjUU9FtQoPG0Up35+yRdyp0w4IvqqB8MD0t0d0QNVt4soi4n5U
         f8Dh8yv+MCBULWxroJBNpE2m3N28mm7+1mEpJA7N436A5c39A8siWhXZjnnLJPDH9nHD
         hgwzqoED9MrcPaVmC6uyjGBJ9lJUaPhXtOXEgs2Uw3ZIOgUD4hFEm31SPwhfhtPFUVVv
         BreQ==
X-Gm-Message-State: AOAM533XpnSsUVw5VflYYCBcaRi0ya9obLOLqhDCgPadhA4/ebA9DPfQ
        y5kAO20PmkIjWy/6QYsLB68UjKzCy6463FeD7MsV+5jgreG1xDNG6BxEW4DuuIvDKn2f7RrjVUZ
        K7g9D5vLNUx5mmZvQ
X-Received: by 2002:a5d:61ca:: with SMTP id q10mr9458830wrv.124.1607620391761;
        Thu, 10 Dec 2020 09:13:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLWTHybCg00kwrPskYIm5jMSTpmjA849HgyPt3UN6gRy65IemdOcWm2Xr6ko/LjluS+Jvr8g==
X-Received: by 2002:a5d:61ca:: with SMTP id q10mr9458817wrv.124.1607620391577;
        Thu, 10 Dec 2020 09:13:11 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z140sm10517171wmc.30.2020.12.10.09.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 09:13:10 -0800 (PST)
Date:   Thu, 10 Dec 2020 18:13:09 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH v4 net-next 0/2] add ppp_generic ioctl(s) to bridge
 channels
Message-ID: <20201210171309.GC15778@linux.home>
References: <20201210155058.14518-1-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210155058.14518-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 03:50:56PM +0000, Tom Parkin wrote:
> Following on from my previous RFC[1], this series adds two ioctl calls
> to the ppp code to implement "channel bridging".
> 
> When two ppp channels are bridged, frames presented to ppp_input() on
> one channel are passed to the other channel's ->start_xmit function for
> transmission.
> 
> The primary use-case for this functionality is in an L2TP Access
> Concentrator where PPP frames are typically presented in a PPPoE session
> (e.g. from a home broadband user) and are forwarded to the ISP network in
> a PPPoL2TP session.

Looks good to me now. Thanks Tom!

Reviewed-by: Guillaume Nault <gnault@redhat.com>

