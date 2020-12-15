Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2222DA9DC
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 10:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgLOJNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 04:13:48 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37464 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbgLOJNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 04:13:39 -0500
Received: by mail-ed1-f68.google.com with SMTP id cm17so20209656edb.4;
        Tue, 15 Dec 2020 01:13:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nsDxA7RpD1AJCH7CZ3WIXINau+V/HHIwvOEBUiHihzk=;
        b=qQ1rpKVkIp/WOKzSc8hfwSoDZm1uUjjrZhLS2tZwKevaxOsYlcPU3J5tbJHFssxPaj
         yir0Z4Sv5ltaeJkn5CU/6g/XB8838jKPhTr/fj1vjbYQ6P5QN+jAKfS1ZaVGlzJlkgE7
         3JNCdIYyxq0lLxMpUI/J1hFakZBa1PQTLwYHuIoxvk3YLoqSJwh4YK7yLGM/h6a8Ypqq
         /IpEytJPsOV6WmzeHCrXWh6iZfG8QBu4TcO5JVwmgzhyVT53L9tblZX4HbzNOhq2hNij
         V+0wAvLBX762WnNBIWd4SCIIuEdgkqo/Se5Yq+NNPxW/okYYYimMOXUrLhHGkB5DRHij
         TCJQ==
X-Gm-Message-State: AOAM532ouXbEef6+/Z5mGHt2wZZ/Dx5UFsPHfmL9YLiLILTs0hbESsE0
        RWhFLzYaPxrZ2GQgyK52y1E=
X-Google-Smtp-Source: ABdhPJyiRqmyU1ibJRCeaSSgJvp6sz/kG6v3LENX5LiDk3ZugznN56TYSpkPr8MPcHPQBQpq1NR3gw==
X-Received: by 2002:a05:6402:2066:: with SMTP id bd6mr28508608edb.211.1608023571913;
        Tue, 15 Dec 2020 01:12:51 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id k21sm18701931edq.26.2020.12.15.01.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 01:12:50 -0800 (PST)
Date:   Tue, 15 Dec 2020 10:12:49 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v2 net-next 1/2] nfc: s3fwrn5: Remove the delay for NFC
 sleep
Message-ID: <20201215091249.GA29321@kozik-lap>
References: <20201215065401.3220-1-bongsu.jeon@samsung.com>
 <20201215065401.3220-2-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201215065401.3220-2-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 03:54:00PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Remove the delay for NFC sleep because the delay is only needed to
> guarantee that the NFC is awake.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/phy_common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
