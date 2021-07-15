Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993843C9C61
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 12:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241163AbhGOKH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 06:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbhGOKHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 06:07:55 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAF0C06175F;
        Thu, 15 Jul 2021 03:05:01 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k4so6965782wrc.8;
        Thu, 15 Jul 2021 03:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jxbJukyaJl2CP1RcQXxy+hbiTq406qGg8r0G19v6yDo=;
        b=K4cDQkmIdqFZ8v9qCJuh7KU47GsTec/P9QRzLZRVMMp0upPXY5tfPCf+tAruqlBscY
         zEL7XW3DyKssLQUWd+rt/wUlWYVWNa0GqjCFRFCTnfv6Nuqx+8f+qzxy4HKiF3b3r4PZ
         D6cunaocYG+kGCVW3UOpgQzJL/sTfK2YCqnpioQeSBzmgjxnd7GeWpuYWdahDXRe6iLb
         Xbc5fEMN9hcwSmECXtbV/ciA2OQXfOV+m8CD35REXq9bpIzpCxXluYy+v8fx4Ysi3zZ2
         8NV97ZEKTkoa3xpeHwYlH3aRnC6eykxuou+F2RmPI9hubtdMXfSt0JDargzPOFzHM0kL
         NVew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jxbJukyaJl2CP1RcQXxy+hbiTq406qGg8r0G19v6yDo=;
        b=aTeIVzof0NdRF6roK5pyrJoDLRg+0k+UCHSzNWTqFaz8FB+KoqKFq26SuCKyN5UqdN
         3hcfk+h9ZAiBZ9lNYnBVAMxKsV//AsBVl3u7UsAX+lx2Y9OWOJg4S4SlclI+9G23DyPp
         aylVH/jX4rJJ9h9dR23slWBiD/KtFcSKo4IdgdoFWAXeswoaAiC242u/0TB1lBuQQd8f
         8G2yLUhiahKDpSZ6qNE8py3IfVPEqyJkTmA4iIXEoqij7JpT1JmKNb5/QfdtihaLHCwK
         wrZD/r2nRALLObdqEmhhFJQcqLPTVqvMx+Cj8eLovAoSMG4T+FqO7BBa9RUc336C58ue
         1w7g==
X-Gm-Message-State: AOAM533zqJUfUciPL3rby/aiGxbpbgde0hELNS8d9if6nQsFo8zhf4WF
        4OR7xN/JZjEOU56EmKszymY=
X-Google-Smtp-Source: ABdhPJxDwubbC8qf7n+m2es9YTplZsWy1G3eyK2GMWpRPsGQbx/1Oj4eNlRRYMShKrftYF4MYJ5+wQ==
X-Received: by 2002:a5d:65cb:: with SMTP id e11mr4659422wrw.105.1626343499841;
        Thu, 15 Jul 2021 03:04:59 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id b15sm6915537wrr.27.2021.07.15.03.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:04:59 -0700 (PDT)
Date:   Thu, 15 Jul 2021 13:04:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dong Aisheng <aisheng.dong@nxp.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-imx@nxp.com, kernel@pengutronix.de, dongas86@gmail.com,
        robh+dt@kernel.org, shawnguo@kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/7] dt-bindings: net: dsa: sja1105: fix wrong indentation
Message-ID: <20210715100457.ut7ji2mizog4qghe@skbuf>
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-4-aisheng.dong@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715082536.1882077-4-aisheng.dong@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aisheng,

On Thu, Jul 15, 2021 at 04:25:32PM +0800, Dong Aisheng wrote:
> This patch fixes the following error:
> Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:70:17: [warning] wrong indentation: expected 18 but found 16 (indentation)
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
> ---

Thank you for preparing and sending the patch.
It looks like Rob already applied another version of this change
yesterday:
https://lore.kernel.org/netdev/20210622113327.3613595-1-thierry.reding@gmail.com/
I wasn't copied on that patch, I noticed it rather by coincidence.
