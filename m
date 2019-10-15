Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24091D80D2
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732615AbfJOUOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:14:20 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:50323 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbfJOUOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 16:14:19 -0400
Received: by mail-wm1-f50.google.com with SMTP id 5so420995wmg.0
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 13:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XI2CJCZ+iTNWCh0LwsnSqy0loih3SECuaT8wglOqaYI=;
        b=Ylx0El7e/T/SpRAtL8uqWvblmJI2x6qR2odQ+yhcRAfoiK6Dom2+GB0O5wl1JJE9go
         uDxxPGV/Uiw+Ew9do4oSV9VxODOzMdUaNmpFpZhfaeOLZa9+CvghK8Cu7pUKxapD6BhD
         Pa6C4LkqDWd9gsUUz/9ryBMh9rJtoOi7y5n+4AQrq3cDLkAZ7koEOGvlxJRFtkpdM/oM
         OhAvUqyTVNUnx/wRQMouAn/mUYawwMdLrO3Fha77i05W8vjUHGiyDjoTz4UKo/eJSWYY
         SStQOu23r9k4AoRg2iAAxCOZM1GDy8mwHNeAmEpzSBDipHR+0L/Y+IkkDt8ftevNtuTZ
         IIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XI2CJCZ+iTNWCh0LwsnSqy0loih3SECuaT8wglOqaYI=;
        b=tmpKSqsBGyr4f+WYntqfx66xuDuTdbepF1uwowDIqPOxD9f5KaZaasGF+hCq2L6uy2
         accRcUi4ufn/eYGV+WcCQmOfg3SC8xjjFajqjD2wwlcOT16RNLkh7dgvTK7AUli0ZNv3
         Ha027ZSEjhovJiCtaDVAPyeQNj+MtmmQujfRcjS2/7KoegQ//OaNMcvrysM78BKiSwyK
         Lr8U/UuYZf2DxleLN0bOD6EaW5dhDD3xWcXtNFu2EUX0vCQauCXsaWIMBw0sQxf4/AlH
         zv1rsp3DgLXH/XstbPo8L0/svc2KOQmraHUjDROcdDVsO3qAyCdt1kOdixwu3heUP3gj
         XySw==
X-Gm-Message-State: APjAAAXLaxloBkvz8cjwU6gHXPvrgJbSTpnDdCeja/HxIupadGDhc9Ze
        pS7qBfv1byAu6YT+754t39cRjQ==
X-Google-Smtp-Source: APXvYqxkoirmpWiYEtr76PLxeFV6KhPjMiBX2snGpSRgipsYufY07Ze0bm5FwOHThXTRDlzE6vk1vQ==
X-Received: by 2002:a1c:7c0a:: with SMTP id x10mr219564wmc.48.1571170457618;
        Tue, 15 Oct 2019 13:14:17 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d193sm469541wmd.0.2019.10.15.13.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 13:14:17 -0700 (PDT)
Date:   Tue, 15 Oct 2019 22:14:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 0/2] mlxsw: Add support for 400Gbps (50Gbps
 per lane) link modes
Message-ID: <20191015201416.GA2266@nanopsycho>
References: <20191012162758.32473-1-jiri@resnulli.us>
 <20191015120757.12c9c95b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015120757.12c9c95b@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Oct 15, 2019 at 09:07:57PM CEST, jakub.kicinski@netronome.com wrote:
>On Sat, 12 Oct 2019 18:27:56 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Add 400Gbps bits to ethtool and introduce support in mlxsw. These modes
>> are supported by the Spectrum-2 switch ASIC.
>
>Thanks for the update, looks good to me!
>
>Out of curiosity - why did we start bunching up LR, ER and FR?

No clue. But it's been done like that for other speeds too.
