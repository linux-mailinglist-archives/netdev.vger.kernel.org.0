Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05FFA29CF
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 00:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfH2WeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 18:34:02 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46105 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbfH2WeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 18:34:02 -0400
Received: by mail-ed1-f67.google.com with SMTP id z51so5729717edz.13
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 15:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=d7PGusO+D6HmK71kJjffOLU7FcBlKcg8YnX2G7kU36Q=;
        b=KqHWyQbmLT8aJ5jxKf8+674iQ2oLCGjQj1ljnGNXND8exoVHftaXOsyy2sxcKs0of/
         LMBBLIsRzfL18lUqrNRvYWv7YBHfv8r+gv9FqlNYzfm3VHAWtjPVoJa7wvtg/HafRbyG
         +ueS0/KTN01dzPIDI87ibxSKkLYuyFKXrjCOy64lyNROgUtACuhTwPrDVnmFEOC4XEQe
         sT1RsotI7LdMcimw2jfJgaq4q/Yhpc1nphwIGzF9WcMrWYz+GRn3c5OdKTjRCRcJR7NT
         NF4UbyCDyV27voF8Wt+i28nQVjE2OoAHTiYhwfE6sdGr29+SmQuuogGYfEjCzZ6fOug3
         WSYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=d7PGusO+D6HmK71kJjffOLU7FcBlKcg8YnX2G7kU36Q=;
        b=ns5jzsJYlfZpBsbSh5CFlIl5eodqdYYtjNpyd0KglcAWwJ+CT3E71Cmyzgur4JJY3o
         ri0TKUtBD70yB9YvBJtkKHKjlMDz9Egd8+6dVGQrOlUyjylwG2dnOCAm1q/qkNoJn9aE
         KJfxE03+xu88mcFzm8WOz2tMVPMyghTAkcK3UsgeiyGmTHb60phlJVCDZYm/Fy0SCeS7
         kpxWJsSUz2vz0ThcqdM+LTQUEG2w9EFRzoJ4Z9Y6GpHdFaZohV/wsneTKFpu3/OhSupx
         9BY2lREgKaFiOzfA4xqtG9Qk8PM3PU3hwiJOsYXQ0AKHifuc/gtPoHEFJI8Mkf5lUl3L
         5bog==
X-Gm-Message-State: APjAAAVMjY7sHOOGoWjaFfaCKyyKGuy+evs8M3dt4/ZCLxsY+Ib6nq7m
        NSmHdEU5tlZ5rbHWdsJed51/IA==
X-Google-Smtp-Source: APXvYqzhALlAJ5N+yYR3rpbgh0K4+grSZbwO45sarBjCUp319YE/HBAdEw61uJ/B0KgDmpHgSlSwEw==
X-Received: by 2002:a17:906:244c:: with SMTP id a12mr10202524ejb.288.1567118040811;
        Thu, 29 Aug 2019 15:34:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y10sm547436ejr.67.2019.08.29.15.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 15:34:00 -0700 (PDT)
Date:   Thu, 29 Aug 2019 15:33:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v6 net-next 01/19] devlink: Add new info version tags
 for ASIC and FW
Message-ID: <20190829153337.6544944f@cakuba.netronome.com>
In-Reply-To: <20190829182720.68419-2-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-2-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:27:02 -0700, Shannon Nelson wrote:
> The current tag set is still rather small and needs a couple
> more tags to help with ASIC identification and to have a
> more generic FW version.
> 
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
