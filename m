Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D2618AFE
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 15:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfEINwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 09:52:35 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46934 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfEINwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 09:52:35 -0400
Received: by mail-pf1-f196.google.com with SMTP id y11so1351628pfm.13
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 06:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8qLMzW5sdCiXr0+VC/BzOUU+cRpa3JTBYUSsmfFfV+A=;
        b=WYmoO0PZf7Mw9FC4uBg9msl8Dff2BS4ow/w1tSr8+5OS41ns14QveTUnZoW88PcNyq
         efSrEk4vQIPnP0ivUY/6cBaX/mQ2lzb3ArfXFZ7iXkmwzmxzvPSaWx9FT4f+VtT5iZs1
         lw6LUlhRXChhqnqFFLbXCJz5QBtGZMecCbqSco6MlKaMuQxnMsKkX/98i01UQJ6peYZk
         GJT309Rp+WfBupZ3cM1+XDg0ADdmVmttJRpNPjNuxVp+lTwHDHyQfd0VVB5t0uWfQw1s
         BhTSh1/0xu13R1h3tuVPgXIGHxoS9CN4MhVsUiGiBvOQrDiWgcHTMskwCi2D2nKW8q6J
         RNUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8qLMzW5sdCiXr0+VC/BzOUU+cRpa3JTBYUSsmfFfV+A=;
        b=qvkJsjsWx92sF8dUITkhB6TViONneTZSZF0JnII363T+WVpDjc2RhhvI9jN/UhBfDa
         84awTYDdKV97oxRhwWNErAm0cY+L9QjQpGWvzrW6Yv3Fppu/hLDcmwDKv3fTJpqw1XH5
         TsTDju9GG1nbe9XALO8M/u1KVZAwma/XRrx9VJ9GcrO+bLIYoveHz4XvUYh7SAl8awla
         BNvJ99rO/BUkNa7pU6/e62j/k9rAE1zAkI7sGr2T33o39BhH+A0sosqpD4T224+erd2K
         pY5M9gKJe6KsJAlX2KVi3PJioUA7ECPGhGpAn0Mrf9D+UaiEYkqt/NJd4TxBf4ODwHKm
         wbrw==
X-Gm-Message-State: APjAAAWsxQihG1lzrNAVEPmUOWbZCq6wtxFeETBe3EgsnQXAANxMA0cF
        NiC/7OuzQL0BASa3POoDbao=
X-Google-Smtp-Source: APXvYqxM+qnT1qm7fo4B78wUjqOZShxyjPiVptC7yNqokc9DqtVrZK7avNTWUNXTjyTD8bNOMFVg3A==
X-Received: by 2002:a65:6116:: with SMTP id z22mr5752716pgu.50.1557409954577;
        Thu, 09 May 2019 06:52:34 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id c19sm2565587pgi.42.2019.05.09.06.52.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 May 2019 06:52:33 -0700 (PDT)
Date:   Thu, 9 May 2019 06:52:31 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Miroslav Lichvar <mlichvar@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>,
        stefan.sorensen@spectralink.com
Subject: Re: [PATCH net] vlan: disable SIOCSHWTSTAMP in container
Message-ID: <20190509135231.ivchey4lwpk6emte@localhost>
References: <20190509065507.23991-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509065507.23991-1-liuhangbin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 02:55:07PM +0800, Hangbin Liu wrote:
> With NET_ADMIN enabled in container, a normal user could be mapped to
> root and is able to change the real device's rx filter via ioctl on
> vlan, which would affect the other ptp process on host. Fix it by
> disabling SIOCSHWTSTAMP in container.
> 
> Fixes: a6111d3c93d0 ("vlan: Pass SIOC[SG]HWTSTAMP ioctls to real device")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
