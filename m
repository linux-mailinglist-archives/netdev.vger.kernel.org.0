Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E3A30A57D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhBAKh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:37:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:42942 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233056AbhBAKhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 05:37:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612175797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RX+3aoWedwiUmiW9UVKhbO6sRRKkujrhxKbe5LLEQKc=;
        b=OgFkL5eN1e6PzDK9LGrMe2x2udxLXrCk3bBFzGKHpmMH9VuXHb9r21NJ/WekOlsFZpPMze
        0eMBddcC74+A42Wv2Xi9nztubgli4lUq5JuCv94n7OzR9z2Vw3GfDKJC5PsJ7t0RPl/dxH
        uKz0jNWW08ivhiwiEDlIFvBLJt18iPg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1550FAE53;
        Mon,  1 Feb 2021 10:36:37 +0000 (UTC)
Message-ID: <c4cf54806f8dccce8cf030f91ba47b11164b0c7f.camel@suse.com>
Subject: Re: [PATCH 2/2] net: usbnet: use new tasklet API
From:   Oliver Neukum <oneukum@suse.com>
To:     Emil Renner Berthing <esmil@mailme.dk>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Date:   Mon, 01 Feb 2021 11:36:29 +0100
In-Reply-To: <20210123173221.5855-3-esmil@mailme.dk>
References: <20210123173221.5855-1-esmil@mailme.dk>
         <20210123173221.5855-3-esmil@mailme.dk>
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
> This converts the driver to use the new tasklet API introduced in
> commit 12cc923f1ccc ("tasklet: Introduce new initialization API")
> 
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Acked-by: Oliver Neukum <oneukum@suse.com>

