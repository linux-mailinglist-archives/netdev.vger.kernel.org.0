Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756B22B2C8E
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 11:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgKNKCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 05:02:24 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54725 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgKNKCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 05:02:23 -0500
Received: by mail-wm1-f65.google.com with SMTP id d142so17572157wmd.4
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 02:02:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pX4A+/lTPhLXj+i3Ma5pL9T6t8fO9ZWt3DK3dCDzqWg=;
        b=AvWMjC6QUHwFxscBx2+ASw8xczG98zNXzJl/AJbZNP9kC5vXkzNNWGcoF5k7DzI7ms
         5RNhsXxbjbcuUPpCB6i2vLZGZRd/FlBM65/eRMX8Rjfhnk7mnKHbXqozPAn3AMzEavBd
         vP9Ezyf3YnREz2J5Y/m4prvwGRiCa8dMhPklAlzkIf0f8n0ai6dIDLZ4XKOdR6qzp0GQ
         199XRfMpeRB5pbN2pKqkH1TjKzgQPxBsIveJEdan7qxkAvNod3E9viad4Il3MkuuXKlG
         +njfXmJ7JA7TG9yYqWsAZBObxQ+j9HbH3Tlu8zt/Yrl8RO/OewXz9vThdBniXMXaJkT4
         wS9A==
X-Gm-Message-State: AOAM532z/YM6LXrnA07N46ZaJsBUrRebG8/1HkWIm8YS25xR6u5XZIGe
        C+OG/R3tJhO6mEGQji5YtNCrGr8Tqt0x4g==
X-Google-Smtp-Source: ABdhPJx9F2UeXc1x0nO06Fk4AHeJr9DDJw1UFyCHcc3XIXAfRr1P2FB4kT6qs0h09SErjOa6wVN4jA==
X-Received: by 2002:a1c:660b:: with SMTP id a11mr6085878wmc.159.1605348142093;
        Sat, 14 Nov 2020 02:02:22 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id q17sm16812324wro.36.2020.11.14.02.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 02:02:21 -0800 (PST)
Date:   Sat, 14 Nov 2020 11:02:19 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] nfc: s3fwrn5: Remove the max_payload.
Message-ID: <20201114100219.GA5253@kozik-lap>
References: <CGME20201114001736epcms2p258c17155d29874c028e3cafcbcb0ee6e@epcms2p2>
 <20201114001736epcms2p258c17155d29874c028e3cafcbcb0ee6e@epcms2p2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201114001736epcms2p258c17155d29874c028e3cafcbcb0ee6e@epcms2p2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 09:17:36AM +0900, Bongsu Jeon wrote:
> 
> max_payload is unused.

Thanks for the patch.

You have an empty line at beginning of commit msg - please format the
commit description correctly.  Remove alo the trailing dot from subject.

Best regards,
Krzysztof


> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/core.c    | 3 +--
>  drivers/nfc/s3fwrn5/i2c.c     | 4 +---
>  drivers/nfc/s3fwrn5/s3fwrn5.h | 3 +--
>  3 files changed, 3 insertions(+), 7 deletions(-)
