Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A72D99E6F
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 20:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389685AbfHVSHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 14:07:42 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38682 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387707AbfHVSHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 14:07:42 -0400
Received: by mail-pf1-f196.google.com with SMTP id o70so4479354pfg.5
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 11:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1GH4Oo5zbga04AzGP4KACk4wdL2sGKVVxtvv6c2anC8=;
        b=ZrWBW6tSTvhKXl7GkcHRQ+7b/xlos0dvm6Qz9E3PX5ZG0TfwY1m0nAWsbikqQp0/ac
         l1qrQyqb3ocsSWWVHT/tl2FK79lx8SXRIN53xa+rU58k5QUu1/zXWEWudo14v6+v00pC
         H3zh2a5IZievqx+BdIONlgOewSm/s2PZZjOeE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1GH4Oo5zbga04AzGP4KACk4wdL2sGKVVxtvv6c2anC8=;
        b=giio0VM1YBRprKRaqNplpXZ/XgAX0MBdXTrfFrB+5wiSWjpzmOe7srHdUg5YZS+Giw
         gr7XhiRUK6RdTB4P1Ex7QSq5K9f5cZsOjMTe+0sRv2DgRhX/9TEwSQ1IHutEf+tlpYng
         X0WDG/pgVGl1X9smmHBhEAfb+V9K4MOe6p9CeWKU23xWhNqazFjxWbB+aw0ROw48Xq1c
         YjBKLt3+YUm+VPNAQlKaFx+4Q2VQ/khTB9o2+e/uH71Bvxxc7LhvOnnRfOiNhB1XJeRd
         RArZSoBaQF/nrm/IV58jGT9c6UDuC5xGBOTPGahXvVy1bVVKYUMzICtwzeoEa07cwIjs
         cUgg==
X-Gm-Message-State: APjAAAUlKymOrQePISm/tSD/TZ61RNQgdV4a5NrxK23r3PsIwrwQR4Zq
        krzj6pnw2SELYZ/Ovs+F/d5LPQ==
X-Google-Smtp-Source: APXvYqxCfN8jblSa2BriLTm1dnfur9lri1ZlfHkGdWVii84CMnyZFTYl/WmOYxyg3XoMEfnrgfW8nA==
X-Received: by 2002:aa7:9293:: with SMTP id j19mr534565pfa.90.1566497261511;
        Thu, 22 Aug 2019 11:07:41 -0700 (PDT)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id i124sm79696pfe.61.2019.08.22.11.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 11:07:40 -0700 (PDT)
Date:   Thu, 22 Aug 2019 11:07:38 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Matthew Wang <matthewmwang@chromium.org>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nl80211: add NL80211_CMD_UPDATE_FT_IES to supported
 commands
Message-ID: <20190822180737.GA177276@google.com>
References: <20190822174806.2954-1-matthewmwang@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822174806.2954-1-matthewmwang@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 10:48:06AM -0700, Matthew Wang wrote:
> Add NL80211_CMD_UPDATE_FT_IES to supported commands. In mac80211 drivers,
> this can be implemented via existing NL80211_CMD_AUTHENTICATE and
> NL80211_ATTR_IE, but non-mac80211 drivers have a separate command for
> this. A driver supports FT if it either is mac80211 or supports this
> command.
> 
> Signed-off-by: Matthew Wang <matthewmwang@chromium.org>

FWIW:

Reviewed-by: Brian Norris <briannorris@chromium.org>

> Change-Id: I93e3d09a6d949466d1aea48bff2c3ad862edccc6

Oops :)
