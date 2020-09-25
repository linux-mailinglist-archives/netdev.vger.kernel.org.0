Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAA527905E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgIYSbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbgIYSbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:31:18 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA66DC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:31:17 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id c18so2768638qtw.5
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=ZyUQHXSEqGwdP2qzH0eKHz2Jwk3AaJDeWZF3RsqElwA=;
        b=MdI2z0ziZE4SQecY+iDY0oUBl3GP3XOrOQaucLJ3YZqw1HFCqkWw47IG5fXmWkqHR7
         yQ6SJCgTQYYrmZmH4haG36SjYrD8SALvGfxq5zJOfNSAmLwKNXaborAmmm3/N8GBk00X
         KdjeNoyWT8bLc/aPfxyBM6kyXFsD7+dKjH4HSkHODs6BHD1bpvWBW5Z39YTCpicUWgG5
         b1RgStV4IyoMUDW8zgQVQ9WNDJij1+MndA/DYyATE32nMCmnJYz6IcMkdYH+aHxsLAET
         gEgI1iokjD/3hJpnqzlK6bmWrgZEND2cyl+omofEVbcONmOhmQRRTG8IjQS+BlV+ZaiC
         xbvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=ZyUQHXSEqGwdP2qzH0eKHz2Jwk3AaJDeWZF3RsqElwA=;
        b=MHyc99ehHdYJoLnlRg5lW+7aSdy611236AARalJU7iaRTBqeAE/OsyanL3Ory78UxT
         c59W3t2IdH42b6d6EoVXCP83X0de+VUgmgR3lnC3ZcYwbEcYz5KFXbmOM5glESjpLIHB
         qnXNgHptrxZ8fZWtxf4a8xw4j+EMkA53ycv+otnT/YkzmRsQsUlDSkKsvBy8yQUtFENc
         SDcm9V11G0la+7NrJsgoHu58uYmxV12yBdIh2yNwaV8nkaYSC3QvpZowVgRrcfIvQCeE
         1nXBciUsAn8gDJW91yz+4e9oTmD0PiUAuUzUCVOdmoJ7R8g7WGkwsPj6kPlnDWVri18f
         ku6A==
X-Gm-Message-State: AOAM530FJUYlH9cITkVMvpY1EAghHoEoqIc2Ken9vvXqKXM4Ucyj3Dyi
        Jz5aPR3lToh10QwJxQI1QwE=
X-Google-Smtp-Source: ABdhPJzpQ5V3x4jCLWKA6z6yz0hW7RTQhpb/GpKIRmfFVTMNzXG4NlPfDgMiYkrUs+zMqvFIUb6vjA==
X-Received: by 2002:ac8:1763:: with SMTP id u32mr1017260qtk.14.1601058677157;
        Fri, 25 Sep 2020 11:31:17 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z29sm2552252qtj.79.2020.09.25.11.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 11:31:16 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:31:15 -0400
Message-ID: <20200925143115.GB12824@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] MAINTAINERS: Add Vladimir as a maintainer for DSA
In-Reply-To: <20200925152616.20963-1-f.fainelli@gmail.com>
References: <20200925152616.20963-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 08:26:16 -0700 Florian Fainelli <f.fainelli@gmail.com> wrote:
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9350506a1127..6dc9ebf5bf76 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12077,6 +12077,7 @@ NETWORKING [DSA]
>  M:	Andrew Lunn <andrew@lunn.ch>
>  M:	Vivien Didelot <vivien.didelot@gmail.com>
>  M:	Florian Fainelli <f.fainelli@gmail.com>
> +M:	Vladimir Oltean <olteanv@gmail.com>
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/dsa/
>  F:	drivers/net/dsa/

Unfortunately I cannot be as active as I would like to be lately, sorry for
the inconvenience. Vladimir is definitely a perfect fit for DSA, welcome!


Best,

	Vivien
