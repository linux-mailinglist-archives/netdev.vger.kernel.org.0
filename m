Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5442937BEFB
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 15:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhELN5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 09:57:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:33806 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhELN5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 09:57:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620827765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cQa3n9TFzuvP31kbKmw7UvEUqGGt3ON7QhD32UT4nCc=;
        b=kpt7Vw1uKfI2STlhe+TtkrixKAyPKUAJUcvBxqz3+rF5yoMNy2NzVVTMldVhKGut514EBP
        lyLrn06dikPecRoeaUhdKwru6AvhUJsH3Ipusta3OH0lhj6ukfA2HiY5yEMgMzgkRxfJ9/
        ZyUJUriHZsciJQ3Kdab0EEvi51Aj1hk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 26F20AE27;
        Wed, 12 May 2021 13:56:05 +0000 (UTC)
Message-ID: <a5eda19c63b1aef7141f2814109eb969020ca650.camel@suse.com>
Subject: Re: [linux-nfc] [PATCH] NFC: cooperation with runtime PM
From:   Oliver Neukum <oneukum@suse.com>
To:     clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        linux-nfc@lists.01.org, netdev@vger.kernel.org
Date:   Wed, 12 May 2021 15:56:04 +0200
In-Reply-To: <20210512134413.31808-1-oneukum@suse.com>
References: <20210512134413.31808-1-oneukum@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, den 12.05.2021, 15:44 +0200 schrieb Oliver Neukum:
> We cannot rely on the underlying hardware to do correct
> runtime PM. NFC core needs to get PM reference while
> a device is operational, lest it be suspended when
> it is supposed to be waiting for a target to come
> into range.
> 

Sorry for sending this out with an uncompleted change log.
It went out unintentionally early.

	Regards
		Oliver


