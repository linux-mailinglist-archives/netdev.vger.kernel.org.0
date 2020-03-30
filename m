Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF718197D06
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgC3Nfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:35:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50749 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgC3Nff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 09:35:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id t128so1551568wma.0
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 06:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uDEQEDW6poGS9KlZwA7C1Aw+uiQ73m0ZwbQHiy6fHMU=;
        b=oNoTq/0jEs/F/y47lF3GQZUvzjqzY3g/r7ZsEVGLzJvFW7LGdvpSTn0nKXnpciwISX
         tHesiAdmVleOJmVKSR7q52sjoccnbDOn1apJ4Kac9Cuwn/2MOy0nYXxYRTqRwImZlgtM
         hEqfOccmax/R7aO7jtbSu5TJ016xPMWmbY9ChPA8Lu3rFuBsEv/yFJ5eDneDFgKbuiE9
         sKJjtRrrjqnRdZI6juL/zSydc1S5mWYH0WPu4zqp/CmK5XXYAkPozs+QaBWBOHJiLhzK
         VU4uE1lo1iBErYakJC8HZNkLHJXUTfOjSrYzkS3/9CyAKoVYR83uCCeYKCoKwebHnhsI
         U97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uDEQEDW6poGS9KlZwA7C1Aw+uiQ73m0ZwbQHiy6fHMU=;
        b=ktrn0YZoEl79iRpmmYUQnhL3DZB0buQUMIi1lqC8v2phhxJiBq3TITT8AdS0Z6NMg4
         40UShHbpEfIy6PHiUfRSEBAqlIDMyzxnUglUN/fLs5dmj98DHogKBj+U0uOvUdkONs1j
         MvLXSD1VPaGM9Gtfiqxsl9nYo6N8CPJII0bkcHBkt9ipe1Z22+yK15KrVFhUqQSFLvTA
         PG5qKRFiLeOe1ztw0RqNDvCzv6a+60csvd9FZUtqJgBRTapy/iNnvq99jAae1w5/wDpp
         gJv2GJNe+VsObD+ovhDArCMGoNEiBx60sB8MeOVMyBgrD/hb/+XqTF7U94Y6B+EShyL3
         FTnQ==
X-Gm-Message-State: ANhLgQ11c8shG2vuBIo1wxQEfn8PcUWL3EuZKpc2zbp9wk9x1hgrW2Ak
        VRRQdlrHTILs7sxbPpreK6bJwQ==
X-Google-Smtp-Source: ADFU+vs6/OixDOzqDc7i8XFshzPHP6HAEBX3aPgRo3exeLbxiS6aLgRVqOGZ5hwpYhLRCjVgiy8jEw==
X-Received: by 2002:a1c:2506:: with SMTP id l6mr12757052wml.44.1585575332469;
        Mon, 30 Mar 2020 06:35:32 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 5sm19761892wrs.20.2020.03.30.06.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 06:35:31 -0700 (PDT)
Date:   Mon, 30 Mar 2020 15:35:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eran Ben Elisha <eranbe@mellanox.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next v2 1/3] netdevsim: Change dummy reporter auto
 recover default
Message-ID: <20200330133530.GA2199@nanopsycho.orion>
References: <1585479955-29828-1-git-send-email-eranbe@mellanox.com>
 <1585479955-29828-2-git-send-email-eranbe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585479955-29828-2-git-send-email-eranbe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 29, 2020 at 01:05:53PM CEST, eranbe@mellanox.com wrote:
>Health reporters should be registered with auto recover set to true.
>Align dummy reporter behaviour with that, as in later patch the option to
>set auto recover behaviour will be removed.
>
>In addition, align netdevsim selftest to the new default value.
>
>Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
