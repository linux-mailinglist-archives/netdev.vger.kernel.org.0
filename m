Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7237A3A4956
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhFKTQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:16:17 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:45920 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbhFKTQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:16:13 -0400
Received: by mail-ed1-f43.google.com with SMTP id r7so23904881edv.12;
        Fri, 11 Jun 2021 12:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eavniMUi4aDBLcYKfkFwimbzVmV+4ZEH1FNF9KlkOGg=;
        b=CIcnUTc/rNevBuvZuJzrkNj0VDlCwidtH/2NdfrWgiR8F/z1tvmqo7ICes2pT3lply
         p6uM+ZhgeGvs5AyQfawkdTzrr350uWvNouPUAGqHDbDM8VoaFvaaYY+/xFEpNGJjaC0h
         RqegmzidAXKI0DRvFLXLSq7L5h6KUAfDLTfEJT5cXsKyKiYYXVgXx3gW3OGaEETr3/El
         883vbKoZ/aAsg9SrNHssBqku9nw1gBKfzyTYKhKFuAjwJaeUoP1eq5gyIlyP/vAbBIFQ
         RmhctOUV97KKL9wVyonoVGegsyvHX8K45riuEbroiNtfSrdmmy+M8uCJyBbgu11npeCs
         whdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eavniMUi4aDBLcYKfkFwimbzVmV+4ZEH1FNF9KlkOGg=;
        b=M4TyOLgYGxJGLSUBQzTHDdteYULc84QDbeYD2bijBqYUAMmIxh/B+jSEyPce3fJubi
         f7LyF4KY237YZ5VSkFm6/bXebFBa2Gi68gT9vcQx1ZqFcmd4OEhxGE41IpuiZZP5VBwK
         9cNgJscy4hrvp8CJoPF4K3f3abmWzQD+Feu0bqvxLNQCEHwzw2X3vN9j+EhCaos2haB2
         ZNgr3tLqwVhXhn8DqwJBPGGt6n8OHY85wXBKL6iO5N7hZE1/o9jMgGWM9m7qBkx5R8PI
         HG3F71kEa8bP1HwrUQgWignnzcIM40eXf3fWujTf1+/zn4ACgbHAr9Nu3fAj9xotjrsU
         IHTA==
X-Gm-Message-State: AOAM531Y6koQ9wPnKxyOz3IZaQqU/G6rTK5w6JkmABKNTkZ8v1RrbLdb
        0iAfa5vGdCsFiR3qpcssmEA=
X-Google-Smtp-Source: ABdhPJzu+Wky5ICg0BgYMh5Cpp/ziw+MhfoeqiRNfvB/N2Dff1CGK7wD/sWQSv2f9wYEQoJcmvLQEg==
X-Received: by 2002:aa7:d817:: with SMTP id v23mr5000377edq.300.1623438780132;
        Fri, 11 Jun 2021 12:13:00 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r29sm3041806edc.52.2021.06.11.12.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:12:59 -0700 (PDT)
Date:   Fri, 11 Jun 2021 22:12:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v4 3/9] net: phy: micrel: use consistent
 alignments
Message-ID: <20210611191257.vaoebxx3v6pdqhly@skbuf>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611071527.9333-4-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 09:15:21AM +0200, Oleksij Rempel wrote:
> This patch changes the alignments to one space between "#define" and the
> macro.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
