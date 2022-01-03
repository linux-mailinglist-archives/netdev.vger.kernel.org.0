Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D64483681
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiACR7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbiACR7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:59:30 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97293C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 09:59:29 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id q14so130975149edi.3
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 09:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=twLHbbl1FAVK6UDtrOSps/tDUvaMDVkvxe+o/IEcYXQ=;
        b=SjWDq2C9ScIKYVG2EG32ilQtHc0e30mXxS0XIJsdWx7WqBQ0zKgGeLUxSfkO+TIGmw
         YcZ1DSxBKCjsivawrtnKeNN/aCwsbv7+AXxiGmFtGebX9G8oBTd935EJP9uB9stHo805
         26mrEeDObElLpzQ2rYYApwdJZvfhekUUZD3YtJ04hW6XuWWr2rDNyHsLlw2aboQtJTiK
         vRu4tM1ACBcbpjETyUP9CObuYyVQ4IcpzWKPincEGSYF+dNggstzYMPs3aZMuL961ekA
         orAe+jHMZSwT3oJsjcjy0vfSE1cVJSEt4yfBYdKyVWiRjvFJTezvhjkBKM4nJecMSwtv
         Al7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=twLHbbl1FAVK6UDtrOSps/tDUvaMDVkvxe+o/IEcYXQ=;
        b=UWlnYMQae9kP4zwuSEDD+MFp+0xPcEY4KncynRVnVq0Nl4Lu0bc12LBEAL6EDxTvyz
         2r5VFZY04+ygOJGVOkB/95e4Ogzm2iae16PnN8kJRYnSVUYExXTm8sl0WwizKaZmC1eV
         3t9OvwqkT8h64GKdT79KK1uA8PjZVhQbdMmj+Cp0OYb6mAlPS4cgxWs9XcGsKBl4KDFW
         PpUXWeTx2P4u0JJdL+WZz7eWUc2xGX14R12tWD+wHRhVZpc+pnBZynmJRkWrQ3eMio6B
         jzArRGGYq0dp8pRr41AtinDdi/VWcqWuyFXEbx7+F8SStp3O+DtUEybiG1Pc1m9PcBaf
         vxWA==
X-Gm-Message-State: AOAM533GlWZfX/YT+VkrZS7c4q3gVwGnb3cqRGF8/lYbJmoL45I6pvSb
        lx+UZJnjl6jgendOjBCCZRI=
X-Google-Smtp-Source: ABdhPJz9NqjcXqMyqepq3NoNyjshAvEinkJ/8rZRQ27Hx79G9qccsnnhsg8/cOp20VtRMnYDgdj5XQ==
X-Received: by 2002:a17:907:7285:: with SMTP id dt5mr24422004ejc.376.1641232768190;
        Mon, 03 Jan 2022 09:59:28 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id u14sm13708866edv.92.2022.01.03.09.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 09:59:27 -0800 (PST)
Date:   Mon, 3 Jan 2022 19:59:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next v3 01/11] net: dsa: realtek-smi: move to
 subdirectory
Message-ID: <20220103175926.3yfddkrrt577iuvw@skbuf>
References: <20211231043306.12322-1-luizluca@gmail.com>
 <20211231043306.12322-2-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211231043306.12322-2-luizluca@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 01:32:56AM -0300, Luiz Angelo Daros de Luca wrote:
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
