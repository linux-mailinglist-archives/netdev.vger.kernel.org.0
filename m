Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7E23D2291
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhGVKb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhGVKb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 06:31:27 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF33C061757;
        Thu, 22 Jul 2021 04:12:01 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ee25so6287746edb.5;
        Thu, 22 Jul 2021 04:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h5UFFN7AGeQIGOAb/RWQkv7C5lUMZ+0NOb3u66P0znA=;
        b=Mzq18VK8+pYPI/nW5DZLi+cwN4d1s1bvaVlifFT7TF1uuB4cpZdKsz9NCvZF7FaTQz
         NABwCvsmDaITomdz0I7MsLkxvbpG+f42GM0+RU18Xo0L5HTTEtkrr86Ult5k914yLQEz
         3WuQTd2OMbVHTpfxZxOvMNWcFxGqpc9inEJjVFFohE62Teb0zyMYErkOUiQtpcmhsB61
         ereDeKvWf71dmvPOaPSS583dz9Ck/zpYMgiTJEWIvB7l8kJaUHkQ5Pr44b4gaNNDjNbv
         +rLMZmEwH8aa5lqcQ+J1NCSA+b83by6kQ/+QsTAAvL32aTwQUlw+12MGGHjJmTnH1RYO
         S/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h5UFFN7AGeQIGOAb/RWQkv7C5lUMZ+0NOb3u66P0znA=;
        b=FdtV/01he5lZRyu2X1oJwgxzMpLjEViAdesD3QtzmuIdJveU4QTZ3YqAQ6GqyfbbiR
         wx+tD7zUyYtZODnImTttzFdNO5Ytfj/eLPGfgMEvC3gUrGZ5/xdIogPj2QWhLFm6y3jf
         iAQbMNh2y1byalkAC2TJjawVLvK9NFa87r5/anRE3zt409HapAz6JfA2EZyNcQDAK2Nf
         irg01a+D6Cu9juAa9ediigirFbzQpMmglMjJG/KXa/FyR4WWWihJ9l7vP3sNGe40x5hG
         rMuDfd9Z9DC5cV1TTOWaiBN3qvHN2sYpDr2GjUpgzVRFzrYAASHd27DZhUgLMz9vivmI
         9O/g==
X-Gm-Message-State: AOAM531lakmh9I4bddkJ+TSklF5wzan2lAQONZHRI/p0uHsvgmhsjcD5
        q4otXCwFH0LwbeZ/e8A+asE=
X-Google-Smtp-Source: ABdhPJyHvPMnINyRjwAFAKb7jfk/nKGIqml/CZcTf4hAsf4X1rbAjI9rz6CDDtDQ/dpAHvP4Fyh/IA==
X-Received: by 2002:a05:6402:111a:: with SMTP id u26mr52806709edv.260.1626952319776;
        Thu, 22 Jul 2021 04:11:59 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id d13sm12227380edt.31.2021.07.22.04.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 04:11:59 -0700 (PDT)
Date:   Thu, 22 Jul 2021 14:11:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 03/15] dt-bindings: net: dsa: sja1105: update
 nxp,sja1105.yaml reference
Message-ID: <20210722111157.rtuc46bld2pfh7gk@skbuf>
References: <cover.1626947923.git.mchehab+huawei@kernel.org>
 <3e5fc7ad4f47887666868d6727f88f58613ea508.1626947923.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e5fc7ad4f47887666868d6727f88f58613ea508.1626947923.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 12:00:00PM +0200, Mauro Carvalho Chehab wrote:
> Changeset 62568bdbe6f6 ("dt-bindings: net: dsa: sja1105: convert to YAML schema")
> renamed: Documentation/devicetree/bindings/net/dsa/sja1105.txt
> to: Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml.
> 
> Update its cross-reference accordingly.
> 
> Fixes: 62568bdbe6f6 ("dt-bindings: net: dsa: sja1105: convert to YAML schema")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
