Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8663D17D4
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 22:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhGUTgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 15:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhGUTgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 15:36:18 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B67C061575;
        Wed, 21 Jul 2021 13:16:53 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u13so4992274lfs.11;
        Wed, 21 Jul 2021 13:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G6evUBtzDyrwC+2iP3eObsnDh4RHkR2+PcsOWYOK9i0=;
        b=HiV2zOJDnGD1W9n7+PRDaEpxwa7vFEYj2tngh7aLHtdXBVZThX2zIoQ06bkgOWFzAR
         i0HQDjkpmN0vr485OXVS98z/1JtAansGFAq5WHX4S9ANMdhGgGryN+oGB5hMW+xS1NOa
         201Zi6Jb/NHN17OEPUJEQyycWfoFIZFTZAImCW0+oJ+2TdWbQSXv4SnOU0mTyjle2av8
         rp1LqAMkYK/L4VmPkCUuCfh5+sdjKuhbVm9L2uHmqBqjBTn4RS+XS+fznzuBTjlkEan5
         ZUJx+e/ylhWmRAV8VAhj22vVkouLMwIYJn+bxcIobWT+LgX8odG4y+0pKhgnUO9pRt63
         dJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G6evUBtzDyrwC+2iP3eObsnDh4RHkR2+PcsOWYOK9i0=;
        b=HgL4jeYM8JY0x7Tlfs+YEtW5WF1nKmwNrHt/EM4mz5FK+yHnBm488nSx44PeeWbJ33
         y5Z0wWMWyzL7obSMCz/YEb54y/5BxjsLrUXyUbsW7eSVwYZ2RtMdmDtZYOapcuUsRy+N
         WlqSnhiuYW4gxb1apO4sRMZ9LbfSOQbBas3XMAmggAj7iigDnyfe9A64QtkwISBkeIsx
         n4ikclXxg6a+AfY2mgrJjyj+uv+CilNWkmgA/L//tL39qReImEo9LnSEpsfBVQNQq8u0
         gCv8oTTyttfr8+RF5KhUxYWaG/8H7dYeh4VnQyX1jqEWAWI0BYhn+QeZhZa3RRjkHrC4
         HpaQ==
X-Gm-Message-State: AOAM533XyAKbb+naxdlEaks80gdNO0nQRs3dVcWmVKVBndcFqMNahp1g
        wp/hAzPvNLK9/bFGY/27fzI=
X-Google-Smtp-Source: ABdhPJz8DoMHyqcCcZ4ipA/Yw9fCY4/bebEtmPKK21ucZDGK8XA4EzfXVn6XDj1Cwuenw4J7VEJlyQ==
X-Received: by 2002:ac2:5de3:: with SMTP id z3mr3517613lfq.193.1626898611661;
        Wed, 21 Jul 2021 13:16:51 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.77.130])
        by smtp.gmail.com with ESMTPSA id h4sm1826135lft.184.2021.07.21.13.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 13:16:51 -0700 (PDT)
Subject: Re: [PATCH] ravb: Remove extra TAB
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210721182126.18861-1-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <b06ce2b4-a433-ba7a-062d-91146f5c1d4b@gmail.com>
Date:   Wed, 21 Jul 2021 23:16:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210721182126.18861-1-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/21 9:21 PM, Biju Das wrote:

> Align the member description comments for struct ravb_desc by
> removing the extra TAB.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

MBR, Sergei
