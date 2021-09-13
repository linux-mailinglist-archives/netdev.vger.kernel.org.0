Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BEF409A32
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241419AbhIMQ73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:59:29 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58659 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241294AbhIMQ7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 12:59:16 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 7158D5C016A;
        Mon, 13 Sep 2021 12:58:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 13 Sep 2021 12:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=animalcreek.com;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=/YX5Udt6vbjGSgSU1tjpoD4Md1W
        98inn3an5jk9WL1U=; b=u1c7uP9SPx6sFGOlB/+nkW/0sGKfMLaHiTpv/V7LELi
        ens5F1SgPWJqHS8Md41mkuxMGaEmSkHWt0yf+9TSkZE0IgQWYwVKvJreuDPrvZH/
        c4p/QFwCxkJbwW2qjikySgBThAw8gpIX60U6mBhhucLeXkdIccDkW68fBLBz6G/1
        RYB/SBQ/WsGBfyyyV8NuBCQcwWnJoH6p138BRjjHgzB0C2qfAGtMn4axmCSsAVd/
        yXsF/3CYrjvG5FPmvTcwWik56FA/FRbIWkDS/Myale83xcQAzQEWbBNZIDeMYXQp
        HRpo9U+xRoK875YhR0F3jVJa3MBMhEJ/lxE8LIgRwJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/YX5Ud
        t6vbjGSgSU1tjpoD4Md1W98inn3an5jk9WL1U=; b=V7ry8qo/HLWyAagg+DF6QW
        XrqsxPfmZHPhyAWQ8LdxrwK73BnRSTodSvAQet0mbUrfRecGzl1BWwN2hzPEE/rA
        cvBoumIccmSUMWzcPwqXC3fZXPHIHPPg1zNMPwOGiTR5aN+lZNz6Yw6evUxFcx6R
        oRWd1HSZtfQ+2LZGWTuy9GMG0w6GzWWjBO5zHOK31fuUQzCBR44ExIXIryUrOpu9
        /tC5f6ARSMjvQaH74zCXP/kmh0nSGotj6okjlYdMAM9LD/ruf7n6oAB/AjsTehc7
        8DTaLQaOrM3Tq5ruO5WFRzhs3o2+I/4iCALVG4lI7u1xvNkdlCuoqEKVWpXO9I6Q
        ==
X-ME-Sender: <xms:FoM_YZWcwZT3Tfltlz7UmYcbmEMk2Mvm7VVwBbgIYZnSp9l2i-DYvw>
    <xme:FoM_YZmlbyDSufF9TGroWQxa_i0y40lQtvu0DQTQ2ZQLRQOoHRRBdqf4tx-ZSNj90
    HpSGGIw1cnLuQVgxQ>
X-ME-Received: <xmr:FoM_YVZQvWysZfXDBhV_MQGByhwWmuTmKWzZRWet_SaPrN5fOYqSxFXHdufCVz1R7hQvF8qgSaAQdqPm_TeGQTSiiSktFYjBaAtet-I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegjedguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujghosehttdertddttddvnecuhfhrohhmpeforghr
    khcuifhrvggvrhcuoehmghhrvggvrhesrghnihhmrghltghrvggvkhdrtghomheqnecugg
    ftrfgrthhtvghrnhepieeugfdutdefiedtvdfftedufedvjeehgfevveefudfgjeffgeei
    teetjedufffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepmhhgrhgvvghrsegrnhhimhgrlhgtrhgvvghkrdgtohhm
X-ME-Proxy: <xmx:FoM_YcXk80oBL9lH3Wrx2Rx_zIs0eTxhtaJTGGwPz9GyRUd-TNpr2g>
    <xmx:FoM_YTkqQQGWf06rahVdEFa6kkDqoj0QKV4yNRJn_ioERDbaRYZOWw>
    <xmx:FoM_YZfMIPADBfBPhJ_HOXz0WsULCVEyoUnwcrrRuUn2huCOdnGlrA>
    <xmx:GIM_YRXIYXcEckZQibekN4gcwbGUiB8P9Pe9HV-fFpOvuQV77VOevA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Sep 2021 12:57:58 -0400 (EDT)
Received: by blue.animalcreek.com (Postfix, from userid 1000)
        id EB1C2136014F; Mon, 13 Sep 2021 09:57:57 -0700 (MST)
Date:   Mon, 13 Sep 2021 09:57:57 -0700
From:   Mark Greer <mgreer@animalcreek.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 12/15] nfc: trf7970a: drop unneeded debug prints
Message-ID: <20210913165757.GA1309751@animalcreek.com>
References: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
 <20210913132035.242870-13-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913132035.242870-13-krzysztof.kozlowski@canonical.com>
Organization: Animal Creek Technologies, Inc.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 03:20:32PM +0200, Krzysztof Kozlowski wrote:
> ftrace is a preferred and standard way to debug entering and exiting
> functions so drop useless debug prints.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/nfc/trf7970a.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
> index 8890fcd59c39..29ca9c328df2 100644
> --- a/drivers/nfc/trf7970a.c
> +++ b/drivers/nfc/trf7970a.c
> @@ -2170,8 +2170,6 @@ static int trf7970a_suspend(struct device *dev)
>  	struct spi_device *spi = to_spi_device(dev);
>  	struct trf7970a *trf = spi_get_drvdata(spi);
>  
> -	dev_dbg(dev, "Suspend\n");
> -
>  	mutex_lock(&trf->lock);
>  
>  	trf7970a_shutdown(trf);
> @@ -2187,8 +2185,6 @@ static int trf7970a_resume(struct device *dev)
>  	struct trf7970a *trf = spi_get_drvdata(spi);
>  	int ret;
>  
> -	dev_dbg(dev, "Resume\n");
> -
>  	mutex_lock(&trf->lock);
>  
>  	ret = trf7970a_startup(trf);
> @@ -2206,8 +2202,6 @@ static int trf7970a_pm_runtime_suspend(struct device *dev)
>  	struct trf7970a *trf = spi_get_drvdata(spi);
>  	int ret;
>  
> -	dev_dbg(dev, "Runtime suspend\n");
> -
>  	mutex_lock(&trf->lock);
>  
>  	ret = trf7970a_power_down(trf);
> @@ -2223,8 +2217,6 @@ static int trf7970a_pm_runtime_resume(struct device *dev)
>  	struct trf7970a *trf = spi_get_drvdata(spi);
>  	int ret;
>  
> -	dev_dbg(dev, "Runtime resume\n");
> -
>  	ret = trf7970a_power_up(trf);
>  	if (!ret)
>  		pm_runtime_mark_last_busy(dev);
> -- 
> 2.30.2

Acked-by: Mark Greer <mgreer@animalcreek.com>
