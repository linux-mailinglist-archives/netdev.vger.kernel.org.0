Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E2427EA0
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbfEWNsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 09:48:36 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43174 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730684AbfEWNsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 09:48:36 -0400
Received: by mail-pl1-f195.google.com with SMTP id gn7so2783965plb.10;
        Thu, 23 May 2019 06:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+gf6TK/DBZkbbPD59gjM5EzSFnmu0bkE4KJafULy65Y=;
        b=rnsqyg44lH8m7taWbuklaTCCz+35oJR/l6Qvu3nboiWywtVJszAN5r1JZZHNf22TlL
         EC6rzSjYQa/QR0ivyeZMdANgKAjULdQ8jZm65iQGs+q82LE2KLJ5xf+OjAK4S7BR91Es
         b5zTbN82WIaV6D95qOmUz/zqRV7tuLDrhiG4juw5hDWhRZyiifIizk4b+8z67j38wZKR
         roz6c8S7JRou1K+Hp2d8pEigq64HClfp+59fhiSKhLvwcIhL+H00WgbMyFXI9TPHSfoD
         ZXrtrGkrt/NwdtN+K0dNuzbfEX4sRH8aTyhUQJBSLp3RtWGgpvzEhwJlbNbAH95jHOjo
         K+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+gf6TK/DBZkbbPD59gjM5EzSFnmu0bkE4KJafULy65Y=;
        b=AeTmkADzHbtVlUbypbQ0DsRaKOyI5KwW387d/01TKDiAQNf3Inkq8FVyDIvI0HdtJS
         U059whISItvkzcK5wSPV1T/l8KGPXLGohlfGuF0GpcQhl/7ikV5qfEaoraWpfGAlLg3E
         +VpclBQQbHObMXT6MSFtqF9G7m1NO5dwA8aMxkdm/EsSJ6eih6+vBBax49vlKQOWjtbz
         fPdSzqkiRGEma36BDyVQMXRwOihitChga+qDVUMAlR0n8s/uF9EkaSZ2QGnRpfqWuJF2
         uq6pQHZgwbR4GDCsWy/IbAHzMOHlPaCDia5GFxmu5Ovxr0Q63YbFA1um9x53wzIAzBgT
         nFYA==
X-Gm-Message-State: APjAAAXqRDl9ZEW/hYnx5C6AcWh/tjPMEwygoD8CVAw9buYye4/v4irW
        HTl/af+Gbnb5HIaVb/SU6Cw=
X-Google-Smtp-Source: APXvYqwKUTsNLMMZr3WT+JsRYI+XStFLzKHLL4taI1RlLURXHZmDRyhRh2+PrNYZ032j2fi3xT6L8g==
X-Received: by 2002:a17:902:728f:: with SMTP id d15mr24384602pll.167.1558619315442;
        Thu, 23 May 2019 06:48:35 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id y191sm2667986pfb.179.2019.05.23.06.48.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 06:48:34 -0700 (PDT)
Date:   Thu, 23 May 2019 06:48:32 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2, 0/4] ENETC: support hardware timestamping
Message-ID: <20190523134832.xzupnwvhhlljtoyh@localhost>
References: <20190523023451.2933-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523023451.2933-1-yangbo.lu@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 02:33:24AM +0000, Y.b. Lu wrote:
> This patch-set is to support hardware timestamping for ENETC
> and also to add ENETC 1588 timer device tree node for ls1028a.

Please, in the future, summarize the changes from the last series in
the cover letter.  It helps the reviewers to focus.

Thanks,
Richard
