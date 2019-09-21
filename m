Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B9EB9BCC
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 03:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfIUBLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 21:11:48 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36594 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfIUBLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 21:11:48 -0400
Received: by mail-qk1-f193.google.com with SMTP id y189so9200106qkc.3
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 18:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=wScDWZ1k3aPENhb3eEVkRi/0sjaCyiUXHzXtGguOYj4=;
        b=C9fUgKAKLuFZ5eYdFogOcuLYgGoPE6fBHeCy3fhnBwQuOjFIAgb7Q/8mjeTNpaSRPa
         3YGZO6X8hSRN/TZYDJd+85WwGdD1wEVrdDSe1ChdSI/sHLhfzhDU/K9bjWhaYUxX1MiU
         E7qRRNuqEhPr2B6qK/WqqDQCSCgZkHiKhs0QTMqjNFpCPvtS3l4gzZB0hRxE0EIqqmzY
         /5BkuJGyMNjibVreiqGXg7vMCF91V4mgy+YMv6Fz6C2giLOBrBt2lon0x3bSwDKN4YI4
         asbEbHkCwFcJfGu/+9alnZ8ssyY4Qa4gjn0b4PTf4d0STZSxw+HVC7sY+HfkBi8Fb+hj
         BMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wScDWZ1k3aPENhb3eEVkRi/0sjaCyiUXHzXtGguOYj4=;
        b=sG/4yjC4ePp5YqVNLzgL2muxVzwOXwAnCRgZ469Y+xB9CE8flww6Y6x9sJHBjqhVTE
         D1ulKnt8ESL4pwAYn5j4EnpaIAIGMbXbdYrR6ml36lrL7yc1vCym/heI3XObk53OMm/x
         m0HW3u73+tw2pCt+wZw0Hye9xPSeIK8zW53OdZypl9qPbd847JJmQ2s0hKRWbhs5I0zN
         Xq4+JUnHk7aJOJjENbVpKi4hUy+/tUMIy447u+pgHQoUIn/RvHmnaabQZPyHob96iEk1
         IaZtPaUmUoIWr6T3wbh2UjQCVeyQgvNyekcmoInJB+7dWby2vnLq8/sUJoS3gS8PEEfS
         r5mw==
X-Gm-Message-State: APjAAAUtQqYPkVpdUlAKBZBnZN64iJ4nNoyOI4fGKJ2xvm6U65Q0PPWA
        3lz197rMc5n/hqywgC9SKAp1Gg==
X-Google-Smtp-Source: APXvYqzPzAoyhVSr2yw7qD8UFqINaJlHLTqpF4q2nC0TaLGgX2csgV8CNN97qn6WuIocY/suiVN8CA==
X-Received: by 2002:a37:4a0c:: with SMTP id x12mr6315388qka.23.1569028306086;
        Fri, 20 Sep 2019 18:11:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c26sm2233930qtk.93.2019.09.20.18.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 18:11:45 -0700 (PDT)
Date:   Fri, 20 Sep 2019 18:11:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dwmac: fix 'mac-mode' type
Message-ID: <20190920181141.52cfee67@cakuba.netronome.com>
In-Reply-To: <20190917103052.13456-1-alexandru.ardelean@analog.com>
References: <20190917103052.13456-1-alexandru.ardelean@analog.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Sep 2019 13:30:52 +0300, Alexandru Ardelean wrote:
> The 'mac-mode' property is similar to 'phy-mode' and 'phy-connection-type',
> which are enums of mode strings.
> 
> The 'dwmac' driver supports almost all modes declared in the 'phy-mode'
> enum (except for 1 or 2). But in general, there may be a case where
> 'mac-mode' becomes more generic and is moved as part of phylib or netdev.
> 
> In any case, the 'mac-mode' field should be made an enum, and it also makes
> sense to just reference the 'phy-connection-type' from
> 'ethernet-controller.yaml'. That will also make it more future-proof for new
> modes.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Applied, thank you!

FWIW I had to add the Fixes tag by hand, either ozlabs patchwork or my
git-pw doesn't have the automagic handling there, yet.
