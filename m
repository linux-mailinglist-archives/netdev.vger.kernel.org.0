Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EA26A97B
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 15:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387524AbfGPNTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 09:19:41 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45776 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbfGPNTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 09:19:41 -0400
Received: by mail-ot1-f68.google.com with SMTP id x21so20978617otq.12;
        Tue, 16 Jul 2019 06:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ft5bVu4GiOzMOquID2tug9HMlwO64i/k54DzeQayFVQ=;
        b=nHLDI7quoPcaMtrmsotzJJ0RhZI4lMAAKzNdjVA1dW0tRsKNbS9jZMpaNr/R4QO9fM
         QeNs5dxk8ed6yV+0A9NeusIEZCTmEugmItmX/KJ9ysUhwubCoFc1Yp0HfZTnSbk7QDLt
         M+qQdkKjxNt9AjOydda2zTshLmnFr2j4KUGnd1G8iTiSl973P21KAhU6zEPB1yEwW897
         GtvP3zMFVELpPYakN6p2NH++nwMyoZeldSTwZGTe5BNdEhZmnRaSPeUto0qlG3P6DbRQ
         lYqAkNDcT43appzuNFPM5WNTbA+wPyumQebOKeIWrVqWaQXt62ynSx/lOgxNdxAca6Gm
         BfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ft5bVu4GiOzMOquID2tug9HMlwO64i/k54DzeQayFVQ=;
        b=E/4Qn8Xtx3fvUs/otgZwNGa3ruLTi0cdXX7KT8jYotIiHzfEjHHZarktu0e4P++7V3
         CcdZLrGS8kQfcDCX1wrAUPyETRUHo6VO4Fgi2+bO+ZcKcTVJvK8opwL73hiBuEdi1MMf
         5BYMa1QIWCRAzX80z2fg9iZDx6iMDO53ZUseRgFTB30itX8Z44v3Tz7EVfQygxl9Xgkf
         ESg1/mremBnIAPC9tt01AFb+MQcOtuSsL0NWIr9FgGopl/W1MJh1hZYU91KIr5TR4ILu
         4FIa/ARQi98lEBGTuoxqijcAjncxZZ6vVn/SaqRGj+TdLrMASPGni0ecpVV4/4NITw9l
         CQVA==
X-Gm-Message-State: APjAAAVGQ8FlFv1tRA0cEpcR/4iy4FQu4PrJrKdnZW6Z1/Pc85qA2OM1
        QKVp4OgjwPjZipzs+id4awsk3a1u4omDrv6+VAdgvw==
X-Google-Smtp-Source: APXvYqzA6XiP/kuy0DMZBzETMQWyESn5f0PKeKhfmMMib8v9R3xOk+yf0LOZdoUZA+PDnLIAU/yLYAhJo1JSp2dBxAE=
X-Received: by 2002:a05:6830:1319:: with SMTP id p25mr25455046otq.224.1563283180146;
 Tue, 16 Jul 2019 06:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190715210512.15823-1-TheSven73@gmail.com> <VI1PR0402MB36009E99D7361583702B84DDFFCE0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB36009E99D7361583702B84DDFFCE0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 16 Jul 2019 09:19:29 -0400
Message-ID: <CAGngYiUb5==QSM1-oa4bSeqhGyoaTw_dWjygLo=0X60eX=wQhQ@mail.gmail.com>
Subject: Re: [EXT] [PATCH v1] net: fec: optionally reset PHY via a reset-controller
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Mon, Jul 15, 2019 at 10:02 PM Andy Duan <fugang.duan@nxp.com> wrote:
>
> the phylib already can handle mii bus reset and phy device reset

That's a great suggestion, thank you !! I completely overlooked that code.
What will happen to the legacy phy reset code in fec? Are there many users left?
