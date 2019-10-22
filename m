Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3EFDF9EC
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 02:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbfJVAsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 20:48:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40728 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbfJVAsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 20:48:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id 15so3499262pgt.7
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 17:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=9ZxBVNQ9Bd3ja+GyYsGolEdFXPVAh5PHrwO5UMmiKd0=;
        b=Ax5udvJ6yIw/qGB4F3BAhXGmaN8F2sVHDpUS8haKtrzzK5yJOgI3GtcC/lbYjuaosH
         /qGDiiiBpxurUX7vnWLZ78Ds48BgOiRgiBQqA2Uri0kx8wTnkQX/Sl6cjpl/i8AXWvJy
         5Do0YGaQUKogPeKHD3mlCqId25gBU7hNyBc+F3mNEGmIpisGA2NbXI41J1kKSSbdyvb5
         xaH/TITDFZlsfvj7pLG9UiE6Z+5POwJojnlxIH038ae/zfGvf/LSb3VFVyTkm8Wc0qo6
         MAc5F1AZrX1JYrjchag9BH+WIeyDUMzZmNHrCt0myZ3XMhGBRZw4/8WMGf1r0GPGCmTk
         5Z9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9ZxBVNQ9Bd3ja+GyYsGolEdFXPVAh5PHrwO5UMmiKd0=;
        b=HkitvpT4TE6wOe4TOqWbzE4hgl7vRv6Q1j13oF0dZNX8gaCbgLQz3tekgdAV4N0FrJ
         xwA70H1jYg7qjxscTBFVfIjd3rb6oNCPOhxJd/EpFRGbn30AV/JEEnXEYvD2tSTXTHbr
         txm3h0Ta9MfwsClOLcHT2pImz1j/dYnPVB+2Naw/yhmG9DURD/VO3/MKayOd7tWJ1pgV
         zWddc/mNpL3qQ4PbIWiNnVNPv7nluMowzln8KXcc1wH0MO5nFGJhtE+c2CXxAeQLn8ib
         4yPv4OhoHw2WdqQHXe6kUWSdgKKuYlz/vNHpjWzNJyYT+ZzmbuoXtbsdSw6ljHWWiVcZ
         Oc4A==
X-Gm-Message-State: APjAAAUITIWDC5WjbKRBvHdeSy/yAacU3ysVd7Q194QSUSkt3jzdPtVj
        hJ0u3kIl8CGA3NHq+oabgYWrnw==
X-Google-Smtp-Source: APXvYqzUKvN4pMr7EjbyQ0XEf5BpiD4cqXqoEGm8lH9gaJyAV8dXnXgnL/6RoC0cgoVivE7zZZY17g==
X-Received: by 2002:a62:5fc3:: with SMTP id t186mr228439pfb.238.1571705313197;
        Mon, 21 Oct 2019 17:48:33 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id f17sm25360301pgd.8.2019.10.21.17.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 17:48:32 -0700 (PDT)
Date:   Mon, 21 Oct 2019 17:48:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Arnd Bergmann <arnd@arndb.de>, Jason Baron <jbaron@akamai.com>
Cc:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dynamic_debug: provide dynamic_hex_dump stub
Message-ID: <20191021174829.065f9b66@cakuba.netronome.com>
In-Reply-To: <20190918195607.2080036-1-arnd@arndb.de>
References: <20190918195607.2080036-1-arnd@arndb.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Sep 2019 21:55:11 +0200, Arnd Bergmann wrote:
> The ionic driver started using dymamic_hex_dump(), but
> that is not always defined:
> 
> drivers/net/ethernet/pensando/ionic/ionic_main.c:229:2: error: implicit declaration of function 'dynamic_hex_dump' [-Werror,-Wimplicit-function-declaration]
> 
> Add a dummy implementation to use when CONFIG_DYNAMIC_DEBUG
> is disabled, printing nothing.
> 
> Fixes: 938962d55229 ("ionic: Add adminq action")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks like this still doesn't appear in any tree, after a month
(judging by linux-next).

Can we take this into the networking tree? Please scream at me if I'm
missing something or this would not be appropriate.
