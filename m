Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0022A30A575
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhBAKg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:36:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:42482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233056AbhBAKgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 05:36:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612175769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eb3ZzqKoffBFNIR7/9wefuenRV7PBjYsODgL8rAL/eQ=;
        b=bmS9GuMBbCEogEIymC85+zEqQvle3HmwAC94UrK0twKu0L8kxLVZTBGnVXVmNO/KdOD34Q
        0M6+9W/DxjvaxTonxGGzAMBuHoLKnZZ1Ht8JPlD/eS0yjCoag3/eKkk8rORik3DTMCWziV
        UiwP9Ar9Gt7HCNl1RAm22Uvri3xXiDI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0426EAD4E;
        Mon,  1 Feb 2021 10:36:09 +0000 (UTC)
Message-ID: <ffc9f232be80a9e1bcacac63871fc66130f40356.camel@suse.com>
Subject: Re: [PATCH 1/2] net: usbnet: initialize tasklet using tasklet_init
From:   Oliver Neukum <oneukum@suse.com>
To:     Emil Renner Berthing <esmil@mailme.dk>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Date:   Mon, 01 Feb 2021 11:36:01 +0100
In-Reply-To: <20210123173221.5855-2-esmil@mailme.dk>
References: <20210123173221.5855-1-esmil@mailme.dk>
         <20210123173221.5855-2-esmil@mailme.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Samstag, den 23.01.2021, 18:32 +0100 schrieb Emil Renner Berthing:
> From: Emil Renner Berthing <kernel@esmil.dk>
> 
> Initialize tasklet using tasklet_init() rather than open-coding it.
> 
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Acked-by: Oliver Neukum <oneukum@suse.com>

