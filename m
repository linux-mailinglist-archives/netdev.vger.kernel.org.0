Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B51DDE25C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfJUCst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:48:49 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33106 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfJUCst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:48:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so7466415pfl.0;
        Sun, 20 Oct 2019 19:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NI2Xsv37vOUaBUcaG6wCqKoYrGVf8BqjdA3KlM+wbbE=;
        b=HfBEFd+KoCv7cBN56dfksSEEtNzLuuuY9JAeMEn7vbxZ0bDS7T2Jlg/2GRplwgzNZw
         rbnFu9iunv59cw6eA1IRhBp/h+TVsoxOF1x+DkloM+Ycd4QvgQFwf0aYn4v61kqKQCp4
         +fCGg+q/dwOKcqo6vWf+s0pNkR9UIOmrJ/6drasKzM8PXjM095OzFOB5uEfg0EFrmekC
         qFm6DEM894hhYIYCwRZPvhi+STT4rShW3uPek0lh40HPVivyZSDZ+Yel1UnoA4FjLOi0
         gyFMS6N+ptDTHUUJ7OXszdFnrD+fca/Lu0rPYAvHKiLIdLA6kp+lxwjJcI7UXHdC4VJI
         WRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NI2Xsv37vOUaBUcaG6wCqKoYrGVf8BqjdA3KlM+wbbE=;
        b=jU0nhkJr+FEge0EUFTyW1y399hmp+BFlDnf3nGWeUuK54ugc0VJyL+/PVrpRuvMai1
         UUm3GZwmZhUHUtmYbJTE/9Q20oLnTqPkYn3rrteuoDYRPjS+HWqNSBUsM3d75b0adPvG
         4JlCLX0F3tWrJnzpT7tlwg79iWQGMUIeeeS6l2HU58fPpLo1vaLTS1MjUWdtKVPyEUVm
         mjruaD0w+ewp7AmMPdME/2CnaBOvtxSwSAUmMG74anKN8SOohDuEjEE+tBLasGK0PAYA
         uutbx4AIF1ygd6gh21e6RICzwawwfcrnAzPBau5sXUAkfjhHOZyKgLxAP3AYto+AEk0t
         6mZQ==
X-Gm-Message-State: APjAAAUGFsVTbrQ4sYoiKz1+jqMGptZcVg3JJ7EYxqVx6fPru4mmv2rk
        Azgb8M8pF2vZ3zrKlvprbcAL+tBH
X-Google-Smtp-Source: APXvYqwtLA6yRGpo+zjXr/SUvBZiIygxtNLjyI0m6o7+qELfMMfW76THKDSzP0dRVbIQYHYAJmNp7Q==
X-Received: by 2002:a65:67c8:: with SMTP id b8mr23074092pgs.121.1571626128410;
        Sun, 20 Oct 2019 19:48:48 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id bb15sm12479648pjb.2.2019.10.20.19.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:48:47 -0700 (PDT)
Subject: Re: [PATCH net-next 11/16] net: dsa: mv88e6xxx: silently skip PVT ops
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-12-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6305a191-0314-f37a-baf3-13e9fae63c88@gmail.com>
Date:   Sun, 20 Oct 2019 19:48:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-12-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Since mv88e6xxx_pvt_map is a static helper, no need to return
> -EOPNOTSUPP if the chip has no PVT, simply silently skip the operation.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
