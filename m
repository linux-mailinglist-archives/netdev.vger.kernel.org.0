Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0691E17F8
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbgEYW6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEYW6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 18:58:33 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2996AC061A0E;
        Mon, 25 May 2020 15:58:33 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id m44so14794111qtm.8;
        Mon, 25 May 2020 15:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uzUb+ukWGDCHH4pn9DDFq+3Nj2avAM45L3+dHNrqfH0=;
        b=F4Bsj2P0jh6i7yqWhmTHpA87KK78q4s7q2TPfqNpMdd/g2RDAtPQBd+RSEvO2AWw8J
         uqPD2ak5F3q3RMzbJ0aRmA53y8Z7mYlS1jO78O3H89VePJ1e8vglinrdCf0gshy53sTJ
         OwOOfmCoS1f2hSuw3eqqqgPDWkuDsUgPm7uxECHBTSizNRym2pZhr6H1cz7aDQq3IRv6
         z2qpQp8cEZjF4DqL8XO07XEfjyEsZZ9UOZXp91oqW6rFL3rImISJG6ygsh4lbGBCmHHO
         AWYEY8qjA7oZKLJGqwO7fELVcs6qcBzf3HvtESOev7XlNgPi7o1XXVwgJ+2+KR68gZ97
         mXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uzUb+ukWGDCHH4pn9DDFq+3Nj2avAM45L3+dHNrqfH0=;
        b=imRoxVmISPzo9o7Po0dRZoJOXnDunP8Q5miyHn+XBKC/4TeoJO+FHELEyRPDPL6ONL
         DENbsiySPhItCU81+NZ0FG4eK//xA5clZa+TMCN/li4Jg1m8U7OgRqbussekhgaTTA7j
         jW88uYuR3LHi1EcPhcljK88yExmUT9UFxck4kA9DNCOaLmSN/Vxa1336ZdXObHsB1H+U
         QTGJg9PnrPaUokfcrYWF9FC/kYW1NtThQtKnr0xCcOMOgspGffO5A3Ppo6svWOprG1tk
         wdSBRfZ70l6sCM2S9emiwR0Z54RI5co1e0Vb7/x8RKGwqbL27hY1W8VQpA1uQKtwp+Rp
         Q/NQ==
X-Gm-Message-State: AOAM532BOegEw9FvJ0YRsx22m3KnA4u1wx/Y0s4hggbcT+WIyIxstU0M
        hAO9/+EMQjxuvFZLNS2D3Nif1rPWNc0xUg==
X-Google-Smtp-Source: ABdhPJxe6paNiZ1gmAUKlHUK/xCO9hx6mo9/oSgAgJ7oNN5IUYFeT09GrA7s2u+N8X6YliVF807d4Q==
X-Received: by 2002:ac8:5253:: with SMTP id y19mr7895143qtn.291.1590447512103;
        Mon, 25 May 2020 15:58:32 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:8992:a39b:b6ab:3df8:5b60])
        by smtp.gmail.com with ESMTPSA id y129sm15660104qkc.1.2020.05.25.15.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 15:58:31 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D64A2C1B76; Mon, 25 May 2020 19:58:28 -0300 (-03)
Date:   Mon, 25 May 2020 19:58:28 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: sctp: Fix spelling in Kconfig help
Message-ID: <20200525225828.GE2491@localhost.localdomain>
References: <20200525225559.13596-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525225559.13596-1-chris.packham@alliedtelesis.co.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 10:55:59AM +1200, Chris Packham wrote:
> Change 'handeled' to 'handled' in the Kconfig help for SCTP.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
