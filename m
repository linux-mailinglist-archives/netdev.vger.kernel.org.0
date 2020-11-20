Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDF32BB926
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgKTWjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgKTWjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:39:14 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38D4C0613CF;
        Fri, 20 Nov 2020 14:39:13 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id lv15so9179560ejb.12;
        Fri, 20 Nov 2020 14:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tyv5OFB+qrvxnHU7HGFq5SV6iBsOAQQfHcmdEX02vPE=;
        b=KtvyIRCL+E+Yj5qVX1rPRw002NNstsSGU7iWH4Ar9FOEpfd6eIrb4D5/OKz1ibKwvc
         7DMcO5fyedmWL2Apoczri+/SqvFMYX1EKt+p8BmfWLj6lAVJIJL5yeSNWFtrv2ejSnGk
         +Nzt9IYaLhf4OGjymk7aY9BBQl3JZ/o9PKc8ynT8MD22T/jjd2hDL9exe3qJ8K0OPwDq
         LeLrUXxuOOsgiXaLosn+oW30yAa5fUOim3krjgEsVAzUebsAc77KBzkIK6qylR/tGO29
         qpgIVheiHwiJFX426OKtMRamYhXWEkf/Pt+NJXRRr04AyUnJH5gT8r0C292oXYIRU69p
         gQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tyv5OFB+qrvxnHU7HGFq5SV6iBsOAQQfHcmdEX02vPE=;
        b=UKrUjjI2o0Ga06qX6oZBUpTnTUyMblIOm16SKgOZCg/1GyRplIBVDKm1TPBQqpjnMG
         YsrfSrLAkykG4xAIxTqSKgGX9Sgem2mmWIKpotogjh1PNFE6vHWDWfDhQKPqjW0bFVzF
         cW9ALRi1EYohR84yq3D0h+nGG8d7NkS7miS9zwrvp1nPBXstZiN7U1Np1+JIIXsvC9Tp
         9uAeDHjqoBhCHY/5F9MWLQ2157py7q/uqIzP9446tGwmubqcC8rbGJT/yiIkjWpYhsUu
         RhPYUKHUrxfBmpZxQcBq7CpISwVD3ypkNmNCoz7CrmrrNEHiH8H1SkVy0ryqsO0hwTuN
         89/Q==
X-Gm-Message-State: AOAM532kFU7S2yDyF+GQx0BWM3MUHezxMWrOHeoc9KtEDiY+COISI+eL
        HSXWZNe+IqJ7V+0B/PSy5So=
X-Google-Smtp-Source: ABdhPJyQ5rkszrlMk96fKSySje+dkOL45nv9ONpUDBDizAEc/rglSq0m0BA2+bkDaGCTk/HoHPV9bQ==
X-Received: by 2002:a17:906:d102:: with SMTP id b2mr2091190ejz.52.1605911952419;
        Fri, 20 Nov 2020 14:39:12 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id ov32sm1608980ejb.123.2020.11.20.14.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 14:39:11 -0800 (PST)
Date:   Sat, 21 Nov 2020 00:39:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] net: ptp: introduce common defines for
 PTP message types
Message-ID: <20201120223910.q6bmnt25nes6ggq2@skbuf>
References: <20201120084106.10046-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120084106.10046-1-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 09:41:03AM +0100, Christian Eggers wrote:
> This series introduces commen defines for PTP event messages. Driver
> internal defines are removed and some uses of magic numbers are replaced
> by the new defines.
> 
> Changes v2 --> v3
> ------------------
> - extend commit description for ptp_ines (Jacob Keller)
> 
> Changes v1 --> v2
> ------------------
> - use defines instead of an enum (Richard Cochran)
> - no changes necessary for dp63640
> - add cover message (Vladimir Oltean)

I understand that you don't want to spend a lifetime on this, but I see
that there are more drivers which you did not touch.

is_sync() in drivers/net/phy/dp83640.c can be made to
	return ptp_get_msgtype(hdr, type) == PTP_MSGTYPE_SYNC;

this can be removed from drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h:
enum {
	MLXSW_SP_PTP_MESSAGE_TYPE_SYNC,
	MLXSW_SP_PTP_MESSAGE_TYPE_DELAY_REQ,
	MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_REQ,
	MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_RESP,
};

Either way, this can also be applied as-is, since there's nothing wrong
with it.
