Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C0E363FAD
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 12:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238639AbhDSKg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 06:36:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:45000 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhDSKgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 06:36:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618828555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQdR5G6WwPVds0HtT/sm8oEfzziivzyBjpRO9qCc/lI=;
        b=JRRZSVcpsDVQ43zjqaaeu7C7s0rAclV8Vm0aENCVFfipW612yCbBUQIswbLDIENjU9idFg
        a/JiYiG/V+uMupPvThv1m0Yhu1967vEdD7S7kQczOVr40MhAYCE82RaWlk2UIzmHlr8Ntd
        w92oE3EmlgA4Lod+6uXLOtVALRVCaM8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ED923B2F0;
        Mon, 19 Apr 2021 10:35:54 +0000 (UTC)
Message-ID: <9fd3ff38935e4c9c1d631606adf241d63171cfde.camel@suse.com>
Subject: Re: rtl8152 / power management kernel hang
From:   Oliver Neukum <oneukum@suse.com>
To:     Thiago Macieira <thiago.macieira@intel.com>,
        netdev@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>
Cc:     linux-usb@vger.kernel.org
Date:   Mon, 19 Apr 2021 12:35:43 +0200
In-Reply-To: <2853970.3CDyD5GulP@tjmaciei-mobl1>
References: <7261663.lHksN3My1W@tjmaciei-mobl1>
         <2223fc29fdbd5a37494454d95952c1b9f8373f3e.camel@suse.com>
         <2853970.3CDyD5GulP@tjmaciei-mobl1>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Donnerstag, den 15.04.2021, 08:11 -0700 schrieb Thiago Macieira:
> On Thursday, 15 April 2021 03:10:58 PDT Oliver Neukum wrote:
> > Hi,
> > 
> > is this device part of a docking station?
> 
> Yes, it is. It's a USB-C dock station by Dell, whose product number I can't 
> remember (I think "WD40" but that's not an easy Google search). It's one they 
> used to offer for sale 4 years ago or so and has an HDMI, a mini-DP, VGA, 
> three USB and one network port in the back.

One of them at least has a systemic issue with power management.
Please check the upcoming kernel for whether it is your model.

	Regards
		Oliver


