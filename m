Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A362F33BB
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390176AbhALPL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:11:57 -0500
Received: from mail-yb1-f169.google.com ([209.85.219.169]:37566 "EHLO
        mail-yb1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728629AbhALPL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:11:56 -0500
Received: by mail-yb1-f169.google.com with SMTP id d37so2462162ybi.4;
        Tue, 12 Jan 2021 07:11:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o1JVphUh6csByWehomTtn4Y0pMSqrHqyK8fOkl0xS6Q=;
        b=MvSWWC6HGMsCF1+MJDz8h0HIVfvMDvUq1GVk9a9N7qYtzhW+m7G53shqkzoPpiMMnw
         InHg4uoGzjohHbzO8MZ3CWMHj7rK5obHwioZv6TNJPGEvbx4RXyTIeZY9Lg/kL064Cv7
         priKdU8NHldeOIFK/1mx8N0TQ21GfD2pbArZqTOolB6IfYLh2TdsvZ/wB/URP4x7zwjt
         ABirEnCP7U9dcC3tfYXqD0ifrUb+tBtL9ptXtoOw4Kc2WS+nVlevcAUqIoPge7kXunrP
         xQyxIHQPlt+U44ThZCNaSr6Qjuvl0Oe2u3S3ZeMFMqfONktzEOmyp5p9SV62K0fkQ1OR
         4LKw==
X-Gm-Message-State: AOAM533HTbzshCjonDiof1XA9vRA3daCXIzrPOORLypBjTmdUPue24ej
        PvaLuhSV7PpXQe9GC/D7QhUSF7RDN3w+L/V2gDY=
X-Google-Smtp-Source: ABdhPJywtHB6H35zxD2Un9WyH84bwqmNO29lX0h4gMDaEPtlKbotlPycHYa6Wye8XG5L/CaHjtllfjD9NXbVpXQv0FE=
X-Received: by 2002:a25:76c3:: with SMTP id r186mr8115147ybc.226.1610464275289;
 Tue, 12 Jan 2021 07:11:15 -0800 (PST)
MIME-Version: 1.0
References: <20210112130538.14912-1-mailhol.vincent@wanadoo.fr> <20210112130538.14912-2-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20210112130538.14912-2-mailhol.vincent@wanadoo.fr>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 13 Jan 2021 00:11:03 +0900
Message-ID: <CAMZ6Rq+vwBtUZtHTDQw_1KGFx_VSoep7ZtD3bu6cx5y8VyQFgw@mail.gmail.com>
Subject: Re: [PATCH v10 1/1] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>
Cc:     Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 12 Jan 2021 at 22:05, Vincent Mailhol
<mailhol.vincent@wanadoo.fr> wrote:
>
> This driver supports the ES581.4, ES582.1 and ES584.1 interfaces from
> ETAS GmbH (https://www.etas.com/en/products/es58x.php).
>
> Co-developed-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
> Signed-off-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>

Something strange is going on with the mailing list.  I can not
see the second patch (1/1) in the *linux-can* mailing
archive (only the cover letter is present):
https://lore.kernel.org/linux-can/20210112130538.14912-1-mailhol.vincent@wanadoo.fr/T/#

However, the full patch series is present on the *netdev* mailing
archives: https://lore.kernel.org/netdev/20210112130538.14912-2-mailhol.vincent@wanadoo.fr/

Are there any restrictions in regard to the patch size on the
linux-can mailing list? Or did I did anything wrong which
triggered some kind of spam filter?


Yours sincerely,
Vincent
