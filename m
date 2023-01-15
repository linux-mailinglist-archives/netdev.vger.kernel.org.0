Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E70166AF16
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 03:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjAOCbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 21:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjAOCbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 21:31:23 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDC37EC3
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 18:31:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o18so4867417pji.1
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 18:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uo/ImoykEcz7bOlBIHx2tak9OnwtMhTS7SyebQjo9DM=;
        b=01qvmrS0Ccjpl3OC21kruDbQ9bYEmd6zVviL9aUQx8NS5zbskRx5Cvf7DVmJ3WbFfc
         ndtj1kb5k2irHCQEJ6lVB2VncVooTxBWf5UNCLwgfd4ufeUzuw8nHvu6q2YgRi8jxNl7
         nZzYKfoZJMrL6ezrBk9ck679bp0B3yOHLbN75PAw/baPQRpEMiTTCTy8A3lvOCK8qz6F
         mFzSY38nTy1beb0GO3jlbWgVy0VX1cGqSg2z2QGAknvzXAar6D/Ga6G9sJJ/YMGkI8iD
         4F6BvXTx2t4rRBje7WPln41qiqQmEfi8zF4DomdqV2W7M0mouHzckND8W69lOKaeZV+2
         P5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uo/ImoykEcz7bOlBIHx2tak9OnwtMhTS7SyebQjo9DM=;
        b=yauGNkN2aJRiQ69mGan+Kezy45b8rtdDSApa0KHV5Y+7sw7m166zLZT1Y6Zni6YWGM
         vFLRAMFA0V+V8OiotIWHNAphnukxeD2QFZbFDBsQd/4jYr2g2GEd/eEgKVkN/e9kaGnZ
         hJt+sYm2TrM+uVdFu62s6MytzjPYc4gwSWGTubJIkhRO8oisXNkEKR902SDrgVeX9H3j
         My+u3Uue0ERykXNw2z0fz+4lGW2K3iDQaqzx2DW9QqoWkau2oNq86kxcqAGkoJVCPVFp
         BBschwTPXT7KWGo4F7wGmurdjRkrPmGIHKhxuRLw0D4kzL2SuTiWBtMXOLNFawgA5RPz
         6gCg==
X-Gm-Message-State: AFqh2ko8UFCZ8B2zfXjLv4GHQnNKXIIdIlC+/Y/V/W+tv0D+V16rmcOk
        egX0Qtn2JX8RWj2Mpplm+/GCnQ==
X-Google-Smtp-Source: AMrXdXuynKh7tSTn0PzSmSzY9TKo4/RWVq/osru5okF1/eLo4MlPn5pKULwLdnlCz9drCvBw3FNb1Q==
X-Received: by 2002:a17:903:1209:b0:193:2303:c9e5 with SMTP id l9-20020a170903120900b001932303c9e5mr37609385plh.20.1673749881685;
        Sat, 14 Jan 2023 18:31:21 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b00188f6cbd950sm16563156plh.226.2023.01.14.18.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 18:31:21 -0800 (PST)
Date:   Sat, 14 Jan 2023 18:31:18 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Stefan Pietsch <stefan+linux@shellforce.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] man: ip-link.8: Fix formatting
Message-ID: <20230114183118.4b7c0a3a@hermes.local>
In-Reply-To: <1488212e-7324-4f4a-d7d6-48ebd91a3936@shellforce.org>
References: <1488212e-7324-4f4a-d7d6-48ebd91a3936@shellforce.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Jan 2023 00:17:55 +0000
Stefan Pietsch <stefan+linux@shellforce.org> wrote:

> Signed-off-by: Stefan Pietsch <stefan+linux@shellforce.org>
> 
> ---
> 
>   man/man8/ip-link.8.in | 1 +
> 
>   1 file changed, 1 insertion(+)
> 
> 
> 
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> 
> index 4956220b..ac33b438 100644
> 
> --- a/man/man8/ip-link.8.in
> 
> +++ b/man/man8/ip-link.8.in
> 
> @@ -301,6 +301,7 @@ Link types:
> 
>   .sp
> 
>   .B bond
> 
>   - Bonding device
> 
> +.sp
> 
>   .B bridge
> 
>   - Ethernet Bridge device
> 
>   .sp
> 

Your mailer is double spacing text so the patch doesn't work.
Either resend it, or I can just fix the file instead..
