Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E247BDC416
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 13:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404729AbfJRLlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 07:41:21 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45625 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729803AbfJRLlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 07:41:20 -0400
Received: by mail-pg1-f196.google.com with SMTP id r1so3220217pgj.12;
        Fri, 18 Oct 2019 04:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vvNqJKeQ4VHN2Q+KmJAu1hW/F4EtjFyqZ69sSgSZUx0=;
        b=JIy6ZkfZ18shf9qHLkOSgMk8Ska8cQ0h8hpJtdRx3EzswYa/CcgGd+PssSKQLqbyEg
         J8OtwlYmkHtt/egPuMQFyNaM/8PUCVaQVu0WwYgrMsBdEyGifvPZiOmAvoM+oRX1dRq8
         5c1bkC0V1WPpflvB/naXi0CfhbDnVBLERgs7x7Ppn2gSkYUgsbNUaFom7oX7MO6d5NQ2
         szY5swXVI9wD31XHNvoCugEaLbjiuNKXO2sQTaP9RWq8bDk/R6S0l4/LN14ImSHdkefq
         mOd605aBXmmjZOGDHTTDi9Ko29mo3BeGA8R/V5csQDR/gdGFUIxQ9bRlE5iGOZYviIOs
         DYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vvNqJKeQ4VHN2Q+KmJAu1hW/F4EtjFyqZ69sSgSZUx0=;
        b=sRdBLFZZyDCEOF9GTzIIvZX964h9RDAvB3EW63RvA1zM5AfxTrlsbcnyX302vxzD5i
         Qp0Ln1rzQMoU06fAXbwiKUx6OtIpS27WOMPlJbcUb7WX4TMz5Hb+Za0+1tcAz/EpK02p
         2syVFH7XYb7CpqPBFY1huc8om/A5GmKf6vUGFY8agI9j9PMEvZQPU/SZy4uuenXE0Qga
         moBWJ5LBnbaH6npRCg4/g6HsvJJSVMFOFZRrkCnX9OVdiL0FgSaWaLwLcdTvAJC5g2QY
         2DX/ZJIxfS/vqShrvfSi9Fq0g0BNS+rC6TkbnJM4TBq9dZs0I/LWQKDXkYP4+w/ASaNy
         yLEg==
X-Gm-Message-State: APjAAAUOQQtJxZ4gGCcrmSnkBp6SfwX3uWeRTir39Jvnr3bmnwuwJN8h
        JuCVx1MbGjTbC4zyiC8NyvCEMhil
X-Google-Smtp-Source: APXvYqzIdbx+dFeJg+wrIEI91yG1IOMZXLd3DxUCqkiGIX2b08CJGHT5aZyV7WVaY8utlTjj8t4e3w==
X-Received: by 2002:a63:e1f:: with SMTP id d31mr9595650pgl.379.1571398879949;
        Fri, 18 Oct 2019 04:41:19 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id p66sm7078592pfg.127.2019.10.18.04.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 04:41:19 -0700 (PDT)
Date:   Fri, 18 Oct 2019 04:41:16 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     linux-kernel@lists.codethink.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp_pch: include ethernet driver for external functions
Message-ID: <20191018114116.GA1348@localhost>
References: <20191018105128.4382-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018105128.4382-1-ben.dooks@codethink.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 11:51:28AM +0100, Ben Dooks (Codethink) wrote:
> The driver uses a number of functions from the ethernet driver
> so include the header to remove the following warnings from
> sparse about undeclared functions:
> 
> drivers/ptp/ptp_pch.c:182:5: warning: symbol 'pch_ch_control_read' was not declared. Should it be static?

That one is never used and should be removed.

> drivers/ptp/ptp_pch.c:193:6: warning: symbol 'pch_ch_control_write' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:201:5: warning: symbol 'pch_ch_event_read' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:212:6: warning: symbol 'pch_ch_event_write' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:220:5: warning: symbol 'pch_src_uuid_lo_read' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:231:5: warning: symbol 'pch_src_uuid_hi_read' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:242:5: warning: symbol 'pch_rx_snap_read' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:259:5: warning: symbol 'pch_tx_snap_read' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:300:5: warning: symbol 'pch_set_station_address' was not declared. Should it be static?

> +#include <../net/ethernet/oki-semi/pch_gbe/pch_gbe.h>

Instead of that long relative path, just move ptp_pch.c out of
drivers/ptp and into drivers/net/ethernet/oki-semi/pch_gbe.

Then move the shared declarations out of pch_gbe.h and into a new
header file, included by both users with:

#include "ptp_pch.h"

Thanks,

Richard
