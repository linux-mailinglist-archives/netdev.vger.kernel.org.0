Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F424137F2
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 08:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfEDGyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 02:54:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39973 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDGyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 02:54:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id d31so3809291pgl.7
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 23:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gqyA9w6RcMTkaC1wlrGYiIZtj1uy6ZoYFIu5t9JyriA=;
        b=jPezRXAEY669SQbZu/6bAvGUuYDGTH/MEjwYqbzwbVaAG/LALvOho6XqI9/tKuCg5k
         97jvuYYHpxQPkb70kyY6+qdqEtzAjEuQYcTOC42IK2C9x4WepVk4XosPjIO7ltRo8XOM
         b6RZ5LuXsuLItHlqWK29Nk8bzZB+86OgAj+kE04Sk+XqwobHNUYQwdlOTPIRDNuSpEYc
         W9aIzubh2IsmMqbAC+toy0jGJ6XUgDUJnajqX4s6lGljxFDmvGm/PltFnkQJNeHj/d+v
         hTlrMbcn1l49qeJrjY0P2/urLIJ99auo+MI8B0BWmgqUu7Eb3EbvfXpf18tYYMwWDXqT
         kU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gqyA9w6RcMTkaC1wlrGYiIZtj1uy6ZoYFIu5t9JyriA=;
        b=ISCNr6SdKiN/gZ5zt3jT0BbKXruGLpJt5F7hRI9dYNt2tnZrtgxmg/ghqodZ8Yekqa
         6za1nQOP5g6YP1bt7/tzhRp0yoIwPPHdTvqWBApd/dYtB0NHOGHO3FSZmruNBvZN1pz3
         lvq+c91WPIOh9vKsB/aP+qTzluCslruA/xE/EcNsNnX9T7Feh8WjleGzqDR8OJuVVEAI
         WDaebfbI1zhyHUUfjYYSHxDj4+wWNctJqMXj7iWXdrViL7f/QOAS5f0Ou+Nf+fX6JwS0
         vTxvpu+NTMSeetkrXRSnJsu/HDX/iy/35LpMqnujuuDNJhncRMicjzXwol8sdLT1gpQy
         WbPQ==
X-Gm-Message-State: APjAAAU+Vj9yXelm1L7oN8Q9Vs/Z74UZroSgShW+kxAflWska7hcJy1q
        DIKU7YOa6LLw7GdxE+xV1aYWxA==
X-Google-Smtp-Source: APXvYqwE1Fot3eHa0e9hWyuSTftja1FGOlZ271uN0ygTu5BNBapRvhKLGijzB4soIdw2kWbKZ+M+0A==
X-Received: by 2002:a62:3501:: with SMTP id c1mr17569232pfa.184.1556952849325;
        Fri, 03 May 2019 23:54:09 -0700 (PDT)
Received: from cakuba.netronome.com (ip-184-212-224-194.bympra.spcsdns.net. [184.212.224.194])
        by smtp.gmail.com with ESMTPSA id s20sm5434573pgs.39.2019.05.03.23.54.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 03 May 2019 23:54:09 -0700 (PDT)
Date:   Sat, 4 May 2019 02:53:53 -0400
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 0/4] net: mvpp2: cls: Add classification
Message-ID: <20190504025353.74acbb6d@cakuba.netronome.com>
In-Reply-To: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
References: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Apr 2019 15:14:25 +0200, Maxime Chevallier wrote:
> Compared to the first submissions, the NETIF_F_NTUPLE flag was also
> removed, following Saeed's comment.

You should probably add it back, even though the stack only uses
NETIF_F_NTUPLE for aRFS the ethtool APIs historically depend on the
drivers doing a lot of the validation.

The flag was added by:

15682bc488d4 ("ethtool: Introduce n-tuple filter programming support")

your initial use of the flag was correct.
