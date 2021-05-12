Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D601837BFB1
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhELORQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:17:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:49824 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231661AbhELORF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:17:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620828956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qEM9B8aavf7aizeB8uYLEEBIRas/EykFssfdfuh2sp8=;
        b=EAz5jwxUpDyUOFmomq46zlG96hPEMuqcqZ1xFuVXn65ecV/c3nCuneKUZDpD0wI+ZPcoCH
        LOsORBzXTalx28+paL4YMCUgPuXE3NFG1/cLnm899+2a/evrmgz7DQ2b6Q0djUOPGWm0MX
        XBsEpI5EgGryJ4wRXc0RyQrUmtxLtsA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C36AAADA2;
        Wed, 12 May 2021 14:15:56 +0000 (UTC)
Message-ID: <2e1bb24b989e7ee56dcec3302a80d9e8f7d2db94.camel@suse.com>
Subject: Re: [linux-nfc] [PATCH] NFC: cooperation with runtime PM
From:   Oliver Neukum <oneukum@suse.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        linux-nfc@lists.01.org, netdev@vger.kernel.org
Date:   Wed, 12 May 2021 16:15:55 +0200
In-Reply-To: <0a8ca4c7-ce55-3c92-cc29-b383e546d563@canonical.com>
References: <20210512134413.31808-1-oneukum@suse.com>
         <0a8ca4c7-ce55-3c92-cc29-b383e546d563@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, den 12.05.2021, 09:54 -0400 schrieb Krzysztof Kozlowski:
> Hi,
> 
> Thanks for the patch. Few notes:
> 

Hi,

thank you excellent suggestion. V2 is compiling and will
be tested incorporating your suggestions.

	Regards
		Oliver


