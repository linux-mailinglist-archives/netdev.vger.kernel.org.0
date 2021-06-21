Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27D83AF8B0
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhFUWnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbhFUWnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:43:20 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A463AC061574;
        Mon, 21 Jun 2021 15:41:04 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id he7so31275725ejc.13;
        Mon, 21 Jun 2021 15:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9ZblUxqMAeqDml7/8yTajpBO17oO8lzUGH1Oft0tu0E=;
        b=CTmPR9KijJJ/ee7Ljc4W8fGbo3n+kzufOxofUEEgd9OvGSExqTLpzR8cdxlsyKsIkT
         b+3XUx6/gzqeJU+PNKtUVwZEX7fEGnNtX6z0cb4OQgEaqVj0cqfgScp1PZiQE6PlU2qZ
         wx4jkVJeyljSlyMM3dpacfGtSX4HOo8FFfFN2FCPCHCRGTlOb7SeqZAznuzdHd6scHPJ
         Josn7+ZhrNiWL6FznO8Qu/aL/+IxP6xuYG2E4I9eXseyTizycp826CZSFTaJSamNeHTu
         Kpj/NoSF7+ax58qzPMY0xNxTwztt3779pHCEBE4Z5iuOwXKNwGdpyO9FhXlT5HYWY9ek
         18/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9ZblUxqMAeqDml7/8yTajpBO17oO8lzUGH1Oft0tu0E=;
        b=CXI5RgkdiF2IERs4z0VeNctkp9KmkQelEi099stfrEkuB4DOppcghxsBow0tQK31Lp
         jQY6J7y0EpCQht/C1s0o3/bdHcfXssTN5hKSP+xqgSTHnD0x0s0mym/CDCjQD9FES5cv
         3255mrK8d8wiJNWPIyZWuNnIYBMlrU3aHtE00NA0c5L25LGwv+U5nogA3xrvrRk+6GRo
         /+qU7Kzd7lZW0JjNb2+dHFz4565AZ5cJhJR0/f7rC4MS3sb8759KWnL0XOtB1IpprpdH
         b0yxLlHVoOQnoE8PiZBrqCx6Cypve1f7JFWyK7N3Yf5DnIN7s56VM+im80jhsLJEnhUq
         60Gw==
X-Gm-Message-State: AOAM531D7u9QWAa0AW5kUXrXuP4k8/kdU6UtiK88r7Ed4cSS9nL4Mrgh
        HpBtIAeoMX1ctCMTd9FgUto=
X-Google-Smtp-Source: ABdhPJwxUSkHowvOE+xh3pSsB7Z940uDN23DZV/jF4gJPs8QI7P11veLpYU0qDLFP9dMuTJ8dTRTzQ==
X-Received: by 2002:a17:906:ce4f:: with SMTP id se15mr468703ejb.232.1624315263325;
        Mon, 21 Jun 2021 15:41:03 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id r17sm11082792edt.33.2021.06.21.15.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:41:03 -0700 (PDT)
Date:   Tue, 22 Jun 2021 01:41:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: dsa: b53: Create default VLAN entry
 explicitly
Message-ID: <20210621224102.gokr46wyz6zu3cy4@skbuf>
References: <20210621221055.958628-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621221055.958628-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 03:10:55PM -0700, Florian Fainelli wrote:
> In case CONFIG_VLAN_8021Q is not set, there will be no call down to the
> b53 driver to ensure that the default PVID VLAN entry will be configured
> with the appropriate untagged attribute towards the CPU port. We were
> implicitly relying on dsa_slave_vlan_rx_add_vid() to do that for us,
> instead make it explicit.
> 
> Reported-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
