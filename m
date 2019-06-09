Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6E43A63A
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 15:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbfFINpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 09:45:08 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42903 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbfFINpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 09:45:07 -0400
Received: by mail-pl1-f195.google.com with SMTP id go2so2585873plb.9;
        Sun, 09 Jun 2019 06:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pPppdZ9uXU43eX9//ephLQ9/Gyyp4fejUMpXTf0UPp8=;
        b=pD4C2iTsd2FD+dAu7Ik+QxetzIjtU2RxoD+RQge7TycD199Y73NuEt+tGtrZ26AvIE
         VcWIGolZtkGXD6/zy0YUfAc8vrg2aahlhxbZbOxtfzosElsyWny3qicDnBwKj3mETLOo
         w8c/GTbVNiE46fns+ZrIlGclkNwPwjEreRKnL6gAY+nCqXghTrPMNcIaPhwTr0+Lv54J
         g3WQZqTYfdTX3dCyRitnR9lHySp7AfFmKF3nNn+BMWlKJLM+TQBCKAS05MKEcwWXhxGY
         iaFy9slfMRhGrLgShIaBrjY3/OQBNw8No0/KyOu//WCnNYN3+dIW0tWxCrFyB7Xdz0d/
         IhRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pPppdZ9uXU43eX9//ephLQ9/Gyyp4fejUMpXTf0UPp8=;
        b=ZDNaARhHCd2Zu5ZEke14d79mxrwGy1kg4h1OxG9GShFyCLjwV2TZ7WAF3oPpKyWXT7
         wYQv5i0+BoePZhjnpSLOLYW+8Lgu07B/DjPktuvWCqlfhNWckbIht7wBcqAJye8J2kkQ
         sQDDxEuUPgW24pQ7FPT89xoNxRHEZqqeURkJuM53iFm6IFQAfYATYgKKtqZKWWxoOaqc
         NIkD9mSUTwEvlXY2FNsQJvML/ypFJO8bbGhpZfWAgypC3/FQkrUDnX8ZTsDD/PdutOO2
         R1e7zE6gDi1yrDPAYArUQB7AcpiYr6ffcY/KT4otaVSoaaxrzZ29hqT2YAZEa1vAWyHF
         +LwA==
X-Gm-Message-State: APjAAAXXaVb/72XApuOFdLkpOB5/dFUviWVwcCuCd9arp3Q+VcQSzc8E
        Jf7YHD0GnJohGX583IyTAIA=
X-Google-Smtp-Source: APXvYqw6tjQTCRtKMGjwTOLhqdGFeonaVmhDptd0mgobhIqHIpkl8UHJrgvYtAQzwlHP/wzOeE28uQ==
X-Received: by 2002:a17:902:b603:: with SMTP id b3mr7790080pls.72.1560087907191;
        Sun, 09 Jun 2019 06:45:07 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id f5sm7315269pfn.161.2019.06.09.06.45.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 09 Jun 2019 06:45:06 -0700 (PDT)
Date:   Sun, 9 Jun 2019 06:45:04 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 23/33] docs: ptp.txt: convert to ReST and move to
 driver-api
Message-ID: <20190609134504.qigq3m2d23hrflvy@localhost>
References: <cover.1560045490.git.mchehab+samsung@kernel.org>
 <1736539355fdee1effe3b332cf3d93124394672b.1560045490.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1736539355fdee1effe3b332cf3d93124394672b.1560045490.git.mchehab+samsung@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 11:27:13PM -0300, Mauro Carvalho Chehab wrote:
> The conversion is trivial: just adjust title markups.
> 
> In order to avoid conflicts, let's add an :orphan: tag
> to it, to be removed when this file gets added to the
> driver-api book.

Acked-by: Richard Cochran <richardcochran@gmail.com>
