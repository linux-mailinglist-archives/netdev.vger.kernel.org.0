Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B6430AEC8
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhBASLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:11:52 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:55028 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhBASLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:11:49 -0500
Received: by mail-wm1-f46.google.com with SMTP id u14so115579wml.4;
        Mon, 01 Feb 2021 10:11:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5mE6GwQL4E/dm2XJFp8NZbVHLfMxsLlSHpFR2Bi18gM=;
        b=H7ah4I3p8v3szOwBpi4sFY7AOSj+v00BY2w59KBjmflQuQG8ZKpkRmUItZw6yppapm
         BU4zii7OSV5EvRceAFIBcHTLzvBwDlLFZbgnJivCGVPHMnTFRLNnDuisrMsM3apTQjbs
         u28xQP2wELRpKVO0kDyYt6otLciehYpMw10ckancvrjrPbjuYIIW8Nz3xa+nENRX/iE5
         J4Fya4qu6XpJavc4tLq/mtktQ2pDcgM9oHDRgu6rUjG83p14Vr76HPQtaCA8ME1oOTxR
         Gs3+PdAXz8MjUEZ65+Ffk7tW74eEdyBiyopfgbMb1FvNyVONV3GC8Kqv/fT9x7rC2YOG
         i5Ig==
X-Gm-Message-State: AOAM532RMAwo1CvPNk4wAaeL7Vz111qlttkFpBldWq43b5zdOnfF5WX8
        h9bcTl5DXTAM2TuVmn74/lY=
X-Google-Smtp-Source: ABdhPJxYXAANkuGsB57jlD/WYbyHorJJbKVMVZ3rUyXw3DZ785MPCY0AApi0PXnrmN442/n+naBZGg==
X-Received: by 2002:a05:600c:2f81:: with SMTP id t1mr110329wmn.186.1612203066899;
        Mon, 01 Feb 2021 10:11:06 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id o124sm119597wmb.5.2021.02.01.10.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 10:11:06 -0800 (PST)
Date:   Mon, 1 Feb 2021 18:11:05 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, x86@kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 hyperv-next 0/4] Drivers: hv: vmbus: Restrict devices
 and configurations on 'isolated' guests
Message-ID: <20210201181105.g7tqnniin5cem5x2@liuwe-devbox-debian-v2>
References: <20210201144814.2701-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201144814.2701-1-parri.andrea@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 03:48:10PM +0100, Andrea Parri (Microsoft) wrote:
> Andrea Parri (Microsoft) (4):
>   x86/hyperv: Load/save the Isolation Configuration leaf
>   Drivers: hv: vmbus: Restrict vmbus_devices on isolated guests
>   Drivers: hv: vmbus: Enforce 'VMBus version >= 5.2' on isolated guests
>   hv_netvsc: Restrict configurations on isolated guests

Applied to hyperv-next. Thanks.

Wei.
