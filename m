Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2089E62EF7
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfGIDcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:32:10 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40503 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727294AbfGIDcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:32:10 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so31861135iom.7
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 20:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ax4ZrIQfkIeBQdkGdZkflhmkizTqQcdSbZEPfZGqtIQ=;
        b=WVRbNBb/MdK6K4Wx4i971MB9N0iUc38vTKWNwzQxh/qbPtOKZgfDGUcTbfrN0vpXga
         ktI1VWdvd2KGEHg5Tn9sl4eglm/MBfxeYZZfT9GoG+ACO09OlIvph+4BzXQv4Dvvr3jm
         hoUnVANvdX3C8eM+jM2Q6dFdION+ZQ8yvSsm4JRv/0USQEq/PmDhpmj8dHKoFvnpnYR9
         rL0KksQYSjQgNZjWhjEh0vISo8IqDeDJ0leddN5/S6rFUJZV5zh/Ap1eJlrk4/giCyiH
         utcxqg4vGs1lxUT2nVO8WzEgv/nIfVITYu8b95V5QZOnGr5LKV3G3HBsPI/pj3V5jeDA
         nn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ax4ZrIQfkIeBQdkGdZkflhmkizTqQcdSbZEPfZGqtIQ=;
        b=PON3NZnMg4JgvIW4aKRkF7qjBdXVSLNwT5QfJoZlb31Og97yEa4b73fyck5LGVmsDb
         KsxjDzPQgs2v1QOKsxBlXs0s7+vWB6V+O8t8U1IvsBjSj5tx8a7JgpLdqaf9POuATOSG
         YIqPRyu6+PUUm5nAy1rt7UlgFicOUBzgyyw+P6ve/VW7yRVz7q5/rUeNVqBDshX77/cb
         hfTdXj+98F2dILBj9TJOif/47gyuL6uf9D8XHYqRhl2TE/m6rLBgsNP0OPqKpgbgieiG
         qeVLbfIcXeI6CSIRdt3qzqHwYoJGWARM4HtG2SER289hUjK0YwBPF0nZVTmasEqeGaW3
         +gzw==
X-Gm-Message-State: APjAAAUbCtltxbX01zzos7TFHhkADGzPjc8TWmj3MLgydu/vxtlpiCOy
        cyaDM3BxskbGqmhl/qAhZ6pXXIWfED8JmdS5CmMRH5Jg
X-Google-Smtp-Source: APXvYqyvhDHaeD77RE2fJ1D5QgyYkwELm7vFaffghGxXHDecjEBgjrw4jANIQPmAqidQm2xMUQvuDO+IdTrUDWLWKWU=
X-Received: by 2002:a6b:7a42:: with SMTP id k2mr16222628iop.214.1562643129331;
 Mon, 08 Jul 2019 20:32:09 -0700 (PDT)
MIME-Version: 1.0
References: <1562538732-20700-1-git-send-email-kwangdo.yi@gmail.com>
 <539888f4-e5be-7ad5-53ce-63dd182708b1@gmail.com> <CAFHy5LAQyL2JW1Lox67OSz2WuRnzhVgSk6-0hfHf=gG2fXYmRQ@mail.gmail.com>
 <20190709032232.GF5835@lunn.ch>
In-Reply-To: <20190709032232.GF5835@lunn.ch>
From:   kwangdo yi <kwangdo.yi@gmail.com>
Date:   Mon, 8 Jul 2019 23:31:58 -0400
Message-ID: <CAFHy5LCtuG4aB0iFgD7VaW_-vOOQSWbGuMGj2qyNs2+WGZ+J3A@mail.gmail.com>
Subject: Re: [PATCH] phy: added a PHY_BUSY state into phy_state_machine
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 11:22 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Jul 08, 2019 at 11:16:02PM -0400, kwangdo yi wrote:
> > I simply fixed this issue by increasing the polling time from 20 msec to
> > 60 msec in Xilinx EMAC driver. But the state machine would be in a
> > better shape if it is capable of handling sub system driver's fake failure.
> > PHY device driver could advertising the min/max timeouts for its subsystem,
> > but still some vendor's EMAC driver fails to meet the deadline if this value
> > is not set properly in PHY driver.
>
> Hi Kwangdo
>
> That is not how MDIO works. The PHY has two clock cycles to prepare
> its response to any request. There is no min/max. This was always an
> MDIO bus driver problem, not a PHY problem.
>
>     Andrew

Hi Andrew,

I don't think PHY driver has a problem, nor EMAC driver has, but if PHY driver
is capable of handling EMAC driver's fake failure, the PHY driver would be in
a better fit. That's the intention of this patch.

But, it seems this timeout needs to be handled in each MDIO driver properly.
Thanks.

Regards,
