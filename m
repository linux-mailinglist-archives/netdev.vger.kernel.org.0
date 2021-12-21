Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2791B47C37A
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 17:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbhLUQGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 11:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239444AbhLUQGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 11:06:54 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66439C06173F
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 08:06:54 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id 69so479741qkd.6
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 08:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=egauge.net; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=CA0vEmK4VuD0G874S6BcBlFV/fcXlZJ0vIg3qiYKRtE=;
        b=qOIVe/Ulrw9M0ql12nQM/iQjHwp0KJnIxM9TgARluh2svI6qk9dSBSboo9pua1hOoR
         jUsxmOzEVEFx4EzAcyVWC0ZA+ndcS6+sBpbGJ5VyTH7DRyDXo3Q7VT3HtXy4bxi3s+MV
         yWeof3dsaDfLiZydW3qhODT6lz3X7RKu1FkvfPnvUDtvUQo7y+D49vSVxSeuQnp5nOvz
         HCTVFaspA9npKQ2+SvimAumqTYCp4V8UJ1l/dE3/QD1nPB2IK2ENRrfoo/DcHVx9w5j3
         UubJs6ATzXZFi00dP8k0ZOVE+n4E3EzdUhPEif/Po+dM45o+7GvVulrBFO/uMV1Xk5su
         9BvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=CA0vEmK4VuD0G874S6BcBlFV/fcXlZJ0vIg3qiYKRtE=;
        b=3fIqRbwHAgCrjqd3t4ksNUHugebXENCnkVmPKINC0Bfft4m0oo81kIvXAR3n4Va7Da
         iF2H/IHsCBMXMNPHBdPnvt/7k0FWc20Q8dKe8SzkTiHAcUzhRoAejuBnDl9M4IqjMCw5
         kmm3RKQVZWulfoX9slEQCUo5T0i0gKWfMUyRF9eUxf5SfQDFCIvXe4cDUD4SH0YBL2PT
         bd6/gYwJ6OLwNSdb8xmjwdcZvc4jm22Y6Q9ZMK3yZUitzq1xKcbSFIbq1CWOqbFnNX0k
         XrqiYrN01OEzuPzj9D9xyUCj3MJX/B+shPvBc3lmEDGvM/pjx0I2oj+U9Iskxxw++Zqp
         LZ/g==
X-Gm-Message-State: AOAM531Pn69udjItMdNr4XxzKXq43kl4mv+KS3CJUqXqTEhHQbSNBhsM
        ww2Bxb8ZxRY1zySp8pUJDlQO
X-Google-Smtp-Source: ABdhPJwY/i2y/TBE4bud79JOMazs61JlNK44ovTedNtrgQW3IL7WCnnDmTktbDvmJaqxOyESEh8t3Q==
X-Received: by 2002:a05:620a:4301:: with SMTP id u1mr2533209qko.134.1640102813467;
        Tue, 21 Dec 2021 08:06:53 -0800 (PST)
Received: from sloth ([2607:fb90:ac99:dad1:b58:661c:23ad:781e])
        by smtp.gmail.com with ESMTPSA id 196sm13506624qkd.61.2021.12.21.08.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 08:06:52 -0800 (PST)
Message-ID: <5f4ab50b4773effafd0a43c8c541d49621f78980.camel@egauge.net>
Subject: Re: [PATCH v6 2/2] wilc1000: Document enable-gpios and reset-gpios
 properties
From:   David Mosberger-Tang <davidm@egauge.net>
To:     Rob Herring <robh@kernel.org>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adham Abozaeid <adham.abozaeid@microchip.com>
Date:   Tue, 21 Dec 2021 09:06:48 -0700
In-Reply-To: <YcHu8qkzguAPZcKx@robh.at.kernel.org>
References: <20211220180334.3990693-1-davidm@egauge.net>
         <20211220180334.3990693-3-davidm@egauge.net>
         <YcHu8qkzguAPZcKx@robh.at.kernel.org>
Organization: eGauge Systems LLC
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-21 at 11:12 -0400, Rob Herring wrote:
> On Mon, 20 Dec 2021 18:03:38 +0000, David Mosberger-Tang wrote:
> > Add documentation for the ENABLE and RESET GPIOs that may be needed
> > by
> > wilc1000-spi.
> > 
> > Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
> > ---
> >  .../net/wireless/microchip,wilc1000.yaml      | 19
> > +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> > 
> 
> Please add Acked-by/Reviewed-by tags when posting new versions. 

Ah, sorry about that.

> However,
> there's no need to repost patches *only* to add the tags. The
> upstream
> maintainer will do that for acks received on the version they apply.
> 
> If a tag was not added on purpose, please state why and what changed.

Not on purpose.  I just didn't know how this is handled.

Thanks and best regards,

  --david

