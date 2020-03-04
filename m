Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B76179948
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 20:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387847AbgCDTsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 14:48:20 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33363 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbgCDTsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 14:48:19 -0500
Received: by mail-qk1-f194.google.com with SMTP id p62so2913207qkb.0
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 11:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GwAcjTuZWzMw/nqFhMwrcQn8IesVdpbyRCY0k3Yktro=;
        b=FIPpCTX5f6cd+dwjnHUngDQKSC1KAAaWNR6DNxeopYG32UbDCZTAeOtQi7MBrc42Sy
         ZB4sN0FFqd9+2Me6ao0U9CdB5Xs/xHAM+QWDr8D+ZDdemeMYisD5pBAiZryOlfgvnv5t
         ohDtlKeVJiiM/Ll5KHNdPyI3+3tR4jvcwgIJMWGOMDMwD8Gy0wzOdPPMbGjkbSbUd+Vl
         ordCWgFEAJAFUb359b0iMEDBcKOKfxrCvxsRGgPXT8ETY/qrslNNRIzpinUm23On1iFA
         skTTypCOaJPYA40Zl81ix3rmTMYdetoLtCjYJWvj4j4bft+ENk1WMpSg2CmIeRUn3OQb
         85Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GwAcjTuZWzMw/nqFhMwrcQn8IesVdpbyRCY0k3Yktro=;
        b=e2+gGSQjjih9wGMjtK7M6oXxdMDWbhAq8osvJ8SKwons4g+KY+ncVOp/wfFXMXcf1U
         MYNk8tVxxw1QDAF25KZgAhTb0Su8sbVam4tySBNW9oN5d441M9IpRyPyLYl72kC4w/x6
         Ay2HzUFbOkZMuU6W7h/xMVH56RjV9XmnAXJK9eZ1oN0pc7NlipARoThd/V4xgYHmIE8D
         EFx2lNXaI5lIaa5M9kR7Wz3QT4o5m9TcdBidpAV6AS3yp+zA8/84z/Vw3mGZ6TBrFUdb
         hIs1PT4s9Jzj7dRGB16h/6JULqO/Z0GecxUVW9SktY6yQGHqn+yAufmrsbwFc8rr1N3u
         uJeA==
X-Gm-Message-State: ANhLgQ3DgYhjlHvXj8aWdXhuBvHrPlZYX6aHzVcp22QGGYCtrf1Q/l49
        becXWjzWUgTV1t6oyWBKoaU=
X-Google-Smtp-Source: ADFU+vv0mjs/xH2DV4XlmaQI7cwH7thLywhILOCyKbZAruGORufG/aMfceSGKOzDjto/LvlKHnnD4w==
X-Received: by 2002:a37:a2d6:: with SMTP id l205mr4521528qke.92.1583351298705;
        Wed, 04 Mar 2020 11:48:18 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:95f4:82ed:fbec:d0a2? ([2601:282:803:7700:95f4:82ed:fbec:d0a2])
        by smtp.googlemail.com with ESMTPSA id g8sm5422017qke.1.2020.03.04.11.48.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 11:48:17 -0800 (PST)
Subject: Re: [PATCH net-next iproute2 2/2] devlink: Introduce devlink port
 flavour virtual
To:     Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org, jiri@mellanox.com
References: <20200304040626.26320-1-parav@mellanox.com>
 <20200304040626.26320-3-parav@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e786e0bf-8032-c86e-161b-2ee7299ad291@gmail.com>
Date:   Wed, 4 Mar 2020 12:48:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304040626.26320-3-parav@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 9:06 PM, Parav Pandit wrote:
> Currently PCI PF and VF devlink devices register their ports as
> physical port in non-representors mode.
> 
> Introduce a new port flavour as virtual so that virtual devices can
> register 'virtual' flavour to make it more clear to users.
> 
> An example of one PCI PF and 2 PCI virtual functions, each having
> one devlink port.
> 
> $ devlink port show
> pci/0000:06:00.0/1: type eth netdev ens2f0 flavour physical port 0
> pci/0000:06:00.2/1: type eth netdev ens2f2 flavour virtual port 0
> pci/0000:06:00.3/1: type eth netdev ens2f3 flavour virtual port 0
> 
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  devlink/devlink.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
applied to iproute2-next. Thanks


