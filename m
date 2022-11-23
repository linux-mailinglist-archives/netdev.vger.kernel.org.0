Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668D5636CB5
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 23:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiKWWCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 17:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiKWWCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 17:02:06 -0500
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E1710CEB6;
        Wed, 23 Nov 2022 14:02:03 -0800 (PST)
Received: by mail-io1-f46.google.com with SMTP id p141so92244iod.6;
        Wed, 23 Nov 2022 14:02:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=STB2mpiXWoHyu3qbKXIUYJxB6xfOqYOUoTsYwbynqro=;
        b=a9r5BKgnsZhYx5DRwPiPHkZPWaPsPwI2b4dTJz7jv7hWp+TjmYWue9XLywDkcq4sId
         9DtZLtbg/Ub1NYx9q7hu9TgD8JOZmuBy1OTRI1fk433KX1HO3TEIKeVHjlBxCjXmxBv0
         VsZV7U/cz2XlOmVtfieM1FkjVzLw5Y/KAic5jUUqt7Dq811k7Ku9+xu6xQU2u3ugX5dk
         BC8cjjDusTT9nhNM/8BoiQq6ZELKLeZMRMGHsuZGi7IoMSYRVIYqoUc65zSNqZWcQCXU
         rxTwOD36QSc9F7V6nv15C2QWvOeCS9/Ob7182E+t6ACdZu+xIPCICd84z/ikFx18PG36
         lRsg==
X-Gm-Message-State: ANoB5pnjAjC6H01SWDAy0HFxxTYmykF+njUeCuf9kRgPQqvhWobQ3yB+
        jsH8Chk8xPgPM7BJeJVLcA==
X-Google-Smtp-Source: AA0mqf4oK7Q0wkwY83HR3Uk7yKxopDWV3Qaeu3P0nOmLzagVjbYiHXwZ0BOsVAw9+CBXmridrNHqEw==
X-Received: by 2002:a05:6602:d6:b0:6bc:2cc3:cbeb with SMTP id z22-20020a05660200d600b006bc2cc3cbebmr5035484ioe.110.1669240922905;
        Wed, 23 Nov 2022 14:02:02 -0800 (PST)
Received: from robh_at_kernel.org ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id x9-20020a029489000000b00388b6508ec8sm13349jah.115.2022.11.23.14.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 14:02:02 -0800 (PST)
Received: (nullmailer pid 2582827 invoked by uid 1000);
        Wed, 23 Nov 2022 22:02:03 -0000
Date:   Wed, 23 Nov 2022 16:02:03 -0600
From:   Rob Herring <robh@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Marko <robert.marko@sartura.hr>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/6] Revert "dt-bindings: marvell,prestera: Add
 description for device-tree bindings"
Message-ID: <166924092234.2582728.15149777135659209160.robh@kernel.org>
References: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
 <20221117215557.1277033-2-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117215557.1277033-2-miquel.raynal@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 17 Nov 2022 22:55:52 +0100, Miquel Raynal wrote:
> This reverts commit 40acc05271abc2852c32622edbebd75698736b9b.
> 
> marvell,prestera.txt is an old file describing the old Alleycat3
> standalone switches. The commit mentioned above actually hacked these
> bindings to add support for a device tree property for a more modern
> version of the IP connected over PCI, using only the generic compatible
> in order to retrieve the device node from the prestera driver to read
> one static property.
> 
> The problematic property discussed here is "base-mac-provider". The
> original intent was to point to a nvmem device which could produce the
> relevant nvmem-cell. This property has never been acked by DT
> maintainers and fails all the layering that has been brought with the nvmem
> bindings by pointing at a nvmem producer, bypassing the existing nvmem
> bindings, rather than a nvmem cell directly. Furthermore, the property
> cannot even be used upstream because it expected the ONIE tlv driver to
> produce a specific cell, driver which used nacked bindings and thus was
> never merged, replaced by a more integrated concept: the nvmem-layout.
> 
> So let's forget about this temporary addition, safely avoiding the need
> for any backward compatibility handling. A new (yaml) binding file will
> be brought with the prestera bindings, and there we will actually
> include a description of the modern IP over PCI, including the right way
> to point to a nvmem cell.
> 
> Cc: Vadym Kochan <vadym.kochan@plvision.eu>
> Cc: Taras Chornyi <tchornyi@marvell.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  .../bindings/net/marvell,prestera.txt         | 34 -------------------
>  1 file changed, 34 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
