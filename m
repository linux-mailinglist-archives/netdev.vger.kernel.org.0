Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110E01F509A
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 10:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgFJIwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 04:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgFJIwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 04:52:33 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99299C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 01:52:32 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h5so1303281wrc.7
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 01:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/zRYJS8XEuw6y9ec/aRSpqY42eHpF1fJ6G35FlMvRN4=;
        b=OF6zFyVLsbjfL3PesSKi84VpYHJ6j1Qvt2eTVJBkCe1PqikOGpE3Vvj8YpK90UtJ5k
         cGbh7kkLYYGWvtMYfPThkKJ9trZLW6bv7M5dnc9Xz0jzWHxPZTr4tOE0dxQJqFPWh6Gj
         wr7fsBWgrrTJKNHkGA5RZbAHR3TAR8qN4BsWv20/qaOY51XU/6aphV7r6AoHJRxTVkWj
         JJgNlPr94UJhhSC3nM6/WTBNojJAIsfV7pkfZa43idmZhjTKCp8axiy0o1CUIZkuUQBq
         kt6JuevBX46zk2ZXoHdu2FUAvKSwkPPlwqJ0VpC9bi9DKQuiWFLC2MtQS2/cjRhoWxnP
         omMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/zRYJS8XEuw6y9ec/aRSpqY42eHpF1fJ6G35FlMvRN4=;
        b=RxAxZR1sDZ4bfON5qtWJKUWPm8O0J85Mzq19o7xhCPI5AEiuI4qAVKYmT/CKDw4Upe
         hGLhR0MYeVytLZIAuhvlnIm7B8rpPvNXO7eYh/xYut0gRVejQKk/3f+yV4MJCMUrlD/y
         +lXTNmU6qmtqtER58AkgKsqdQEm87Q9Rc9Bs5rpdAsg8mb7ORIp73fVZsYspdB+2VF1T
         23Vg3+VoVuVmeouam6wFFfwfSsSdEESbZvEC2yvOBaqPEbr/1ofkCtTRVCBAgdoZtrky
         rz8GLwrqzdapDe/HFqN5mtvf/vd9UOyXQGA5CosYQbhR9b2nGzBCmzBnW96nMntlWe65
         9eZw==
X-Gm-Message-State: AOAM5328yvlScSdzu3KHbhcZR9UqugeJubt7DjrYH0fk9wcSOxggZV51
        IBTPo/xyyIdVKuWImfXs6BY/XMl3
X-Google-Smtp-Source: ABdhPJyxSuawHLoW8pnMLQt2/c7BUTK8KqvuUZ9pvLQzW3kCA5r25jCFOC6rfd6GSOkgMnSjOlda/w==
X-Received: by 2002:adf:f389:: with SMTP id m9mr2298800wro.195.1591779150992;
        Wed, 10 Jun 2020 01:52:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8de0:f6e2:666:9123? (p200300ea8f2357008de0f6e206669123.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8de0:f6e2:666:9123])
        by smtp.googlemail.com with ESMTPSA id u74sm6218911wmu.31.2020.06.10.01.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 01:52:30 -0700 (PDT)
Subject: Re: ethtool 5.7: netlink ENOENT error when setting WOL
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
Message-ID: <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
Date:   Wed, 10 Jun 2020 10:52:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.06.2020 10:26, Heiner Kallweit wrote:
> Since ethtool 5.7 following happens (kernel is latest linux-next):
> 
> ethtool -s enp3s0 wol g
> netlink error: No such file or directory
> 
> With ethtool 5.6 this doesn't happen. I also checked the latest ethtool
> git version (5.7 + some fixes), error still occurs.
> 
> Heiner
> 
Bisecting points to:
netlink: show netlink error even without extack
