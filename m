Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49026322F05
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 17:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhBWQrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 11:47:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233591AbhBWQqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 11:46:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 462D264E60;
        Tue, 23 Feb 2021 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614098766;
        bh=H2Kr257s95SkwkeK2jGXCbv4S5NRVpkFEbZVGs/yzRw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rRKVYpLW+bJAETXYve+cH4+bvKMUQZ5pITqbKvYtTMuQ+FaiBdYCM2oHWO17LxEXD
         WY6uQ+BORt0jiLphGrziBeDIIq1ReGq2+yEW4xRfqmIAp5MtzwxtS4ufi4TSY0k4Aj
         /VGwa802usljrwVHhNgFlzw5Ky9c3e/RfZQ+rCNhyPK5Lg7CAEBjwCLNbEfVSTro3R
         3MTy5n4bJQlhQD+8CR2qWgM8RqcBUDMFhZsp4RcY+BAjoMsYHzuFb+QhexLpUmVXHQ
         D0cRA0BduY4JXYQ+BOX8gjkaZfrlAtmmt4VzZqzGNCnz2YF0oHCNoHeTGr5ZveSVCx
         Yt+Ci3PwQUCvA==
Date:   Tue, 23 Feb 2021 08:46:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V1 net-next 1/3] net: stmmac: add clocks management for
 gmac driver
Message-ID: <20210223084602.0d1aba9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210223104818.1933-2-qiangqing.zhang@nxp.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
        <20210223104818.1933-2-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 18:48:16 +0800 Joakim Zhang wrote:
> +static int stmmac_bus_clks_enable(struct stmmac_priv *priv, bool enabled)

nit: my personal preference is to not call functions .._enable() and
then make them have a parameter saying if it's enable or disable.
Call the function .._config() or .._set() or such.
