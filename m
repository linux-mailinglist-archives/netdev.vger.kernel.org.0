Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB909428371
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 21:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhJJToQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 15:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbhJJToM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 15:44:12 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E9EC061745;
        Sun, 10 Oct 2021 12:42:13 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z20so58619371edc.13;
        Sun, 10 Oct 2021 12:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7AOn8IBQkBi70i3vw/2+YYiK72dXO95HMpLtZaqXWmE=;
        b=BwZsHRvCFNYTqJaIimsvr7VH/e8F2yHtpuSRGTHD62fEbUSKuntU/Is2kIgPG3e1WY
         lgSjxCdtVNfSj0htwkEHdm77ixgh0zuR/auc+c2H2pqOAWKjnNYcJIMuqXFLaxCTD4A9
         zA7OTpr77XDDlAlMFASeznK15g2dQ7cVFHziN/sXWXc+uRpnXMiM36564/HCF8n8DCXI
         EvYTMmzZhgJbxbqZsY/3BMO6cRUd+Vf6J7f634UPRbc9+wmjqwiN5QyySyUuntOvjXAd
         Qvtr7/95gYbztOfHKIATQjal5zxrZoENjKLVTDkMLYWiXLer4uDXSJUOMvJPqrdXYrVE
         PJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7AOn8IBQkBi70i3vw/2+YYiK72dXO95HMpLtZaqXWmE=;
        b=aMukZpiBEG3S9O/0lH5KQwdRxeI4SN3dcpopywvaljHSNQs3zlD2Fn+jPEsoE/8/I7
         aREYt63zNVh13QVWqAWuehV/tq4N1v3qteEjvHe+ChwJvMA7N41h+408LXQ04r2LrnEv
         fTmKbxURn0t+v8TgdJ+/DmovRf/lUBLQ3LNSdauHgtlIZFALU7/CKfTP10Ym/Z34uafz
         Tlof/whmGEAoEzR/VtW1id4K7a23EF8uv+o3up0hd7pUCq5nB3ys0tlDFBE79mgrpUY4
         NlEfr2hR5RmZL5LHGJQnfwUNh7f4OjzjkWDi/C8yjF7RoG8dILNqgNLMJ8/xbZBrXunq
         aeFg==
X-Gm-Message-State: AOAM533MHG07dvawH8J07wEIZIjKaNUP8g4CRbCJ/BGKXD+zOjFEHr5B
        WIE6cN0kjIb0AeHbE0LZ8cQ=
X-Google-Smtp-Source: ABdhPJzzvz0UXcm3p2Nz7dEd8n+BhjyawhvOWElMqb7JnCGeIwb3Bu+qL05ZohFlWMwE7AXH090Nlg==
X-Received: by 2002:a50:d903:: with SMTP id t3mr34509709edj.70.1633894932238;
        Sun, 10 Oct 2021 12:42:12 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id z4sm2438120ejn.112.2021.10.10.12.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 12:42:11 -0700 (PDT)
Date:   Sun, 10 Oct 2021 22:42:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v4 01/13] net: dsa: qca8k: add mac_power_sel
 support
Message-ID: <20211010194210.yqgytrriuuk5gdh2@skbuf>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010111556.30447-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 01:15:44PM +0200, Ansuel Smith wrote:
> Add missing mac power sel support needed for ipq8064/5 SoC that require
> 1.8v for the internal regulator port instead of the default 1.5v.
> If other device needs this, consider adding a dedicated binding to
> support this.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
