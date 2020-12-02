Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5DA2CC684
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388131AbgLBTXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387909AbgLBTXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 14:23:11 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082CBC0617A7;
        Wed,  2 Dec 2020 11:22:31 -0800 (PST)
Received: from zn.tnic (p200300ec2f161b00329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f16:1b00:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DDD991EC04DA;
        Wed,  2 Dec 2020 20:22:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1606936948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rySJim3wBb+9W8dVG2J74HH0THuGsrX0bUYnHgpIWEU=;
        b=JuFeCHturGfuW0en93LjGZ7Qdjt76u6ure4PvfBENNP73o/sIw2rZL2huQeOG5pYwDaQq6
        0Z4j3BsdWrMQKuLTW9LBCrfVgYI2Aiw0fXFUf4WtCzhnRbjerjFmICRuUBgYqFRE0f+203
        KFHl9HuaYVFCiBO/SXfF4Qduw1tLv3c=
Date:   Wed, 2 Dec 2020 20:22:23 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dmitry.torokhov@gmail.com,
        derek.kiernan@xilinx.com, dragan.cvetic@xilinx.com,
        richardcochran@gmail.com, linux-hyperv@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: make vmware support optional
Message-ID: <20201202192223.GK2951@zn.tnic>
References: <20201117202308.7568-1-info@metux.net>
 <20201117203155.GO5719@zn.tnic>
 <0c0480af-bcf5-d7ba-9e76-d511e60f76ec@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0c0480af-bcf5-d7ba-9e76-d511e60f76ec@metux.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 08:17:23PM +0100, Enrico Weigelt, metux IT consult wrote:
> Reducing the kernel size. Think of very high density virtualization
> (w/ specially stripped-down workloads) or embedded systems.
> 
> For example, I'm running bare minimum kernels w/ only kvm and virtio
> (not even pci, etc) in such scenarios.
> 
> Of course, that's nothing for an average distro, therefore leaving
> default y.

Ok, pls put the reasoning for the change in the next revision's commit
message along with how much KB savings we're talking about.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
