Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB2D3659DB
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhDTNV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:21:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:42522 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhDTNVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 09:21:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618924853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z8fMNZLHfPA+P03rcxAxW338OHehTmfQEPMao8EWaHI=;
        b=Lo0i1zry8NtuYr4tk1e0EAqBbAnQj3ZnAM4p2GaaVFYe4vo46raLDvSOyJCzKmPTHHT5lI
        iUabyFQvvFq73Z3+OgrzZqxHV6z950fRxoXqFHXOrzWbB/ONqW3ELpVWPesr2pbtA1UA5S
        wfUCF+HZvPGVkWkp3EmQFCNfQsFNg+U=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 58E08B2F1;
        Tue, 20 Apr 2021 13:20:53 +0000 (UTC)
Message-ID: <f360af558c2fbea7bd02d4f2fee2215f3589fa7e.camel@suse.com>
Subject: Re: rtl8152 / power management kernel hang
From:   Oliver Neukum <oneukum@suse.com>
To:     Thiago Macieira <thiago.macieira@intel.com>,
        netdev@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>
Cc:     linux-usb@vger.kernel.org
Date:   Tue, 20 Apr 2021 15:20:39 +0200
In-Reply-To: <4365289.qXpdF7q2Ag@tjmaciei-mobl1>
References: <7261663.lHksN3My1W@tjmaciei-mobl1>
         <2853970.3CDyD5GulP@tjmaciei-mobl1>
         <9fd3ff38935e4c9c1d631606adf241d63171cfde.camel@suse.com>
         <4365289.qXpdF7q2Ag@tjmaciei-mobl1>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, den 19.04.2021, 08:53 -0700 schrieb Thiago Macieira:
> On Monday, 19 April 2021 03:35:43 PDT Oliver Neukum wrote:
> > One of them at least has a systemic issue with power management.
> > Please check the upcoming kernel for whether it is your model.
> 
> Thanks, Oliver, will do.
> 
> For clarification, "upcoming" is 5.12 or 5.13? Tumbleweed is still on 5.11.

5.13

	HTH
		Oliver


