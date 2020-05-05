Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84D01C501A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgEEISh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725833AbgEEISg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 04:18:36 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A79C061A0F;
        Tue,  5 May 2020 01:18:36 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z8so669886wrw.3;
        Tue, 05 May 2020 01:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=EIFxKxmFxgre3FE3hg4SRgHwf8DPj6vfKEDfHM3CKiQ=;
        b=aCwFA4fBfDssQEipU83E5gLSF3r7zaHJkvIXCb1dXejB+cc5emDmQQMCF1Bi/lYHyZ
         nogOXWKOoZM/FD7DzRznqlJy+RmjRdLlqHw+ma20qkCd37GaMOEOCs5pCoa6HDlOPvwY
         aNzpdCgtSsm/36rWPoRXXtbO6adDsKSBefbLYrCdhvj/3N78si+y0B38O7uyYtRpV6UH
         6WpH5Whq1hRLNf4xHm406O/KAO4uiQLntUvF4h8ShoQ0Eu+5S9MoKKwvYRJhkwmOL+7V
         9IA3KknRRwfbgrFhe9ArlwfwZYbbrQqvNYIH2GogYwseHxxpit/74c3WD5SsoG4/9qQW
         hQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=EIFxKxmFxgre3FE3hg4SRgHwf8DPj6vfKEDfHM3CKiQ=;
        b=azwid+64/LE3kPq+g23cvHHtXI6q5fvps5DaocoT9IqvaKKN66Mvpqd+YxWH0/MHhQ
         9itDXmDNJiqiC0a3F51C0qbHGPslomK6n/YHtInPEAJ9zVy2JtXh6lgJI6RzrLfS1dOW
         YEkO5NzBZdEY8dswrygbGU9dY+depwHyP6k2NR+TKE/XEPboQZKCV56I3wC4U/em0R7s
         8rBF3S/VqR5eMCmDUMmfEAZY9ZMM6vk4qNmHCmI0lpnGYh99YJolg1HccOJ3A/xsg6TE
         b3MeQCk0guiDFA4SRSbTDuWVcCPzgGdEJ1ItXfxYeZnSPe5SYuHktF1L9di487rTVImd
         a1Ew==
X-Gm-Message-State: AGi0Pub69V+igEe1XTiXO6DyVAGBaN09NH1izu/lnVheCqrZQX88c+OE
        nIfKKtSUptvpqSzFJ68f+/E=
X-Google-Smtp-Source: APiQypKehcY7YzCDA1Wjt8XeBeLTP04ZFxaXOXH4V8yBBNrHkagzoD8d7KOQ77V0q2W6OMvwd6k8gg==
X-Received: by 2002:a5d:51c9:: with SMTP id n9mr2257856wrv.84.1588666715387;
        Tue, 05 May 2020 01:18:35 -0700 (PDT)
Received: from user-8.122.vpn.cf.ac.uk (vpn-users-dip-pool162.dip.cf.ac.uk. [131.251.253.162])
        by smtp.googlemail.com with ESMTPSA id f83sm2453308wmf.42.2020.05.05.01.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 01:18:34 -0700 (PDT)
Message-ID: <c654c9f6707a40eb32908e6cd90cca0df8a9cdd4.camel@gmail.com>
Subject: Re: [PATCH net-next] net: agere: use true,false for bool variable
From:   Mark Einon <mark.einon@gmail.com>
To:     Jason Yan <yanaijie@huawei.com>, davem@davemloft.net,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 05 May 2020 09:18:28 +0100
In-Reply-To: <20200505074556.22331-1-yanaijie@huawei.com>
References: <20200505074556.22331-1-yanaijie@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 2020-05-05 at 15:45 +0800, Jason Yan wrote:
> Fix the following coccicheck warning:
> 
> drivers/net/ethernet/agere/et131x.c:717:3-22: WARNING: Assignment of
> 0/1 to bool variable
> drivers/net/ethernet/agere/et131x.c:721:1-20: WARNING: Assignment of
> 0/1 to bool variable
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Acked-by: Mark Einon <mark.einon@gmail.com>

