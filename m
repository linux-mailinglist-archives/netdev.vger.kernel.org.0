Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51D71FD30D
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgFQRCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgFQRCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:02:22 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8892BC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:02:21 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b5so1422773pfp.9
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3GcZ8LWFRCkQRzQQNnQbWUl7R/X7TAZh5qejiZs76Mw=;
        b=YqtmrqJepFxVYYOW5/WCHShj1UQ1oqUFrUCV2sz8sH1VHzgrFZ+KT1JEFaI8XA7mqh
         BCBeMrui8bPtfIraLWY+wn51r5rt+LFbSYQLZfLpe4ixwxGJWibz3+jSpn1caBh5Q27c
         Ne5K/cG6PUq+Zxp6ecpo+H0SU9IeuQkWzxoyBYdqVhzeIBtlsXfve2XtA9SRW4MeeYua
         F/xya5JLAILzHtpRZuCevCOmKi12l+4wO7UFCw5t+9d7aFxMsGtCK94AHRupRtmjWiRJ
         t4EFcPiyvQGRaSf1kO5TPyUIAk5HIAMu4wl8fwfW4dGfz5JQhvknG4oMtDscYvA34klz
         x0qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3GcZ8LWFRCkQRzQQNnQbWUl7R/X7TAZh5qejiZs76Mw=;
        b=oGBxkuXDv0pkpXNPq8OrcciRLoWAfEZ1AtRW2glveUFY1K/vvU9ohu1w/lomPnAL1B
         3z7LPu1+ERkC4cXb1wDHHp1sDEvXLN2hU8qt3r8R0Ppb8VbSjTfRXROugSwIc5QhYrRa
         o8TzAVMZSWh8+W20ypXa9bJTLheee26C0XTACyPSKcq5xZckzOQPzeAU+tilgLg5/Jkd
         qm3vmxExffiJrZuH8IEXcZXZHhVGB/iCw3eYBKPshJbsxumxN4eD7NbSEmVZpB68qbhr
         58UoDWa63UTAV9mfFjoJK1BpOBt5PeEBhYkpsFGG8DOcVrhEc1e/YT8Iouwoo5/gm7Qj
         8VOw==
X-Gm-Message-State: AOAM530riEaciqsCRGP9tHX3V0asIlaIcuN8yxoS79rzo+1hfSG6IaFE
        mJx8lhv+p3ZsY+/eTWALHu4=
X-Google-Smtp-Source: ABdhPJxcqExRvKFqpcWEsj/VRbmE0KyauRd9LJtQj7uUquOoLt6UA+Lpmac7icoMuFd5Xkffu6bmZg==
X-Received: by 2002:a65:4487:: with SMTP id l7mr7400345pgq.221.1592413340931;
        Wed, 17 Jun 2020 10:02:20 -0700 (PDT)
Received: from martin-VirtualBox ([137.97.149.246])
        by smtp.gmail.com with ESMTPSA id o1sm135366pja.49.2020.06.17.10.02.19
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 17 Jun 2020 10:02:20 -0700 (PDT)
Date:   Wed, 17 Jun 2020 22:32:16 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Martin <martin.varghese@nokia.com>
Subject: Re: [PATCH net v2] bareudp: Fixed multiproto mode configuration
Message-ID: <20200617170216.GA9136@martin-VirtualBox>
References: <1592368299-8428-1-git-send-email-martinvarghesenokia@gmail.com>
 <20200617092137.72ef352d@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617092137.72ef352d@kicinski-fedora-PC1C0HJN>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 09:21:37AM -0700, Jakub Kicinski wrote:
> On Wed, 17 Jun 2020 10:01:39 +0530 Martin Varghese wrote:
> > From: Martin <martin.varghese@nokia.com>
> > 
> > Code to handle multiproto configuration is missing.
> > 
> > Signed-off-by: Martin <martin.varghese@nokia.com>
> 
> No Fixes tag on this one?

Missed. Updated version sent with fixes tag

Thanks
Martin
