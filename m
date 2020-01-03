Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A818C12F56E
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 09:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgACI16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 03:27:58 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52163 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgACI16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 03:27:58 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so7687756wmd.1
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 00:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FXt9Ea7eVpmqdgqD/d6S8/ecEY7tdm3e/NMg1aAm5XM=;
        b=ADLtimg6KlZkPLLdjc0r9LfFI9j/VWKfyc75TtjPZrZsZcKxBUtnJ7FxqorA705POF
         2R8hn1fXxncSxIV+ZFpawD2C/XLPZTFp0NfFAPIWZFqIk0aefbISbbHmAhmt5bBFxvAc
         fSom+uM0nvRxlhg8qQxivbRQ+Czv13RSX5yuRGOTsr+WkSmJn5hjkXdhF+nn0pmmoeLE
         oPISBgCVW8KoJeQpgf3edBC7oHH03XwoODgd0Nslb7PuAJu7uEKMBCWx1BeGSHJpmb1h
         QFknZEnWDjorohm4WJJXGt1MbxDJwmWTyC96kfJDWYiGKVr42Z8s5FQFu8uDpoD/JzRd
         3o6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FXt9Ea7eVpmqdgqD/d6S8/ecEY7tdm3e/NMg1aAm5XM=;
        b=VZ+J1lJMIlfBQXmd5qGaQEpXBM89xaGgNV4SZXzAvqrwzTz5pGdvypuu7B0l2HPtrP
         EAjJ/goysDb7XmJVCHHHwGNOuQGDE8P6pdcNtQQJ4LV1w07DiXviELg3+YDQsMNz6F48
         X3nPpIV17yAWUe1NZlnZBGQuHDUaPY/yGwd9lSJlU11OAU6K7kDZ9t8L0kc2Lvc07nHw
         yrYfwJMH5Z7Aze0XlUVAfu5J9kKSz92bbYYz34AnerXrcycqmYz7SJruddMd6QeZIL9E
         73uGaQt8ndANBh5M6xArwVhCkhlRXVQMsNKPHj+IJ1cW+hpmZ5UqJg/SjIb0ypmfO7zU
         /T2Q==
X-Gm-Message-State: APjAAAUtlJZtcDtYTPZDVdHUgtEC/3E6TprRmE03g9yW7SQ2c0wnf7Qh
        ULLffbv/sK/JeMN407VQROoFwQ==
X-Google-Smtp-Source: APXvYqw28jyBu2JzBdV9zAXZbzHl68ctcOJhBKtghcdQS8y2Um9+IjJGW6D0BW7l3bbKpZgyUcIDiA==
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr18724830wmi.128.1578040076129;
        Fri, 03 Jan 2020 00:27:56 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id v3sm60211640wru.32.2020.01.03.00.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 00:27:56 -0800 (PST)
Date:   Fri, 3 Jan 2020 09:27:55 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] ethtool: remove set but not used variable
 'lsettings'
Message-ID: <20200103082755.GG12930@netronome.com>
References: <20200103034856.177906-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103034856.177906-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 03:48:56AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> net/ethtool/linkmodes.c: In function 'ethnl_set_linkmodes':
> net/ethtool/linkmodes.c:326:32: warning:
>  variable 'lsettings' set but not used [-Wunused-but-set-variable]
>   struct ethtool_link_settings *lsettings;
>                                 ^
> It is never used, so remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

