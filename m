Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2B0D9BBC
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437123AbfJPUZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:25:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42379 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388251AbfJPUZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 16:25:03 -0400
Received: by mail-pg1-f193.google.com with SMTP id f14so9837694pgi.9
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 13:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Apfk1pKEHxx3CG4JkPwppjLiXLQBFDiQwmfVhilG3pA=;
        b=VWXgrS3bry1pjHqA4B7y4ZGqfG2pcO+w/Lb9EBM0bQypaisBl5RF0kWXWi9XBIpWta
         hKTlNBOY3Ikteb/uZX1p2ezdYINvKpKUmYJb3r9V6xnUTdfTXAU3y2wt1rVliPyueJTq
         1qflWctL3WvaZgOGd8PXEaRJ/hTeN5wD+H5zOSpe+nZzIXTvWZu9DOpLuS8HqVoASH7u
         hLxeiAge0w1uLqCMe4k8XCVOaI1v838KiVDvvvpQvEhA6FNmni2FhghkMvhugxm39xYb
         sA7/LWdbaFcAwMN+Fx90bzO9QwcWX1SVplwjDQTUW7JYR6AE3O5Pml6xzKnO+fMU60Bd
         ITlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Apfk1pKEHxx3CG4JkPwppjLiXLQBFDiQwmfVhilG3pA=;
        b=IdBkz+JyagIak83ZTWONt3x5V77o4DOby9AUC4GCxSv5d+KDjP21wz8YkkDxDILYwg
         G0qPWHd/MGV3x84USDtaXqZ1bxJp2R4pG0We4/Yuvyyqq4NT+xx0kyaHduJzpHIoiLa3
         ai9k1BIu/S1RZUaRk5sPzRNIrzn3Q4V2peeFaKtZouOCp2cMI+1I6DDX/iQ6Ya5wC7D2
         o4vkkui9tWe2X+mctDHg3BGkGFS0SJnINdYabi00/UOxEJi/x4lHflbBTpsjTJiZKuRG
         KrAp/l7Y+5vV5sMfqNy84X6laURS4gPf1g6IR+J6p2k9lHEOC4rmNAvaxWx4taOhv4RD
         Bx2A==
X-Gm-Message-State: APjAAAU9uEVSDZIF+74WTJwkULPfh/x/+Z0YRtgWWLtCjavXzW+fasZv
        b0ufaMdVTmKTpwZ9tLiCdoxhRg==
X-Google-Smtp-Source: APXvYqx6jOVgLo/avUgtWT76lKPBc35ucuSi5MnrltggB3NSqz1eS4ko6KTFBU7s2kNGcxiUNUX4Rg==
X-Received: by 2002:a62:ed01:: with SMTP id u1mr32471248pfh.122.1571257501112;
        Wed, 16 Oct 2019 13:25:01 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f17sm23326497pgd.8.2019.10.16.13.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 13:25:01 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:24:50 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, Romain Bellan <romain.bellan@wifirst.fr>
Subject: Re: [PATCH iproute2] man: remove "defaut group" sentence on ip link
Message-ID: <20191016132450.268729d1@hermes.lan>
In-Reply-To: <20191015153550.29010-1-florent.fourcot@wifirst.fr>
References: <20191015153550.29010-1-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 17:35:50 +0200
Florent Fourcot <florent.fourcot@wifirst.fr> wrote:

> By default, all devices are listed, not only the default group.
> 
> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
> Signed-off-by: Romain Bellan <romain.bellan@wifirst.fr>

Thanks for catching this.
Applied
