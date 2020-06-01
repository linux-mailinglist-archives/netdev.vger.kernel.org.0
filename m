Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BF11EA1F9
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgFAKhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFAKhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:37:00 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E967C061A0E;
        Mon,  1 Jun 2020 03:37:00 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e2so8709405eje.13;
        Mon, 01 Jun 2020 03:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ue0RfH9mcbqs6OOPuFsUYFCC+BDZdNW72pIEeu8wOoQ=;
        b=vQ6Vo707SyMJYC2o7E4SAZHV0ChEQ6uOuBoo1FhRe6Y2LzEE/tDgIowjO+yTsr2h5m
         Obxj2Pm690sgAl7DlOlFoZuTcDP3ya+7SX5tniddKmZUCYtP2hazox3naifTG+rHcSaI
         /9W5pJcENZZDXUSIxRy6btgH84K+BME1O8VHU/HF05xOsDMdSvTnN8MYdAYcMz7TxCiP
         zkWQSqUKQpl2u+gpiNeE5eo79+pBvLGeZ1FRFP6VcPE1B3ZkEfjnhtdlCr1W9vGcuQkl
         RJYPlTOQUFH2Y6nuMOXHzcEwQB+PYSwr2zPQKe/keW2FU8ofFsgvU6rsMoqz2uioI2Dy
         XQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ue0RfH9mcbqs6OOPuFsUYFCC+BDZdNW72pIEeu8wOoQ=;
        b=TKsTveLXwhzVjfHekcxOTFMhDV9l6VZ0tk7lI7zb6tHkQCosvBo5XaU+KrHW9bz9oR
         tJ2wUkII2UZxwmClbqMzg2nPuLLaMeRyGDKndtwSLPXgIOk4TIFsL81QmSOs8LLFWMIP
         3e6Cl+wIm4jv8jVfX1ye+E64yuqiXqvqTcYDQe7DxWwTOvxed98/JWfbkJ0yoE2Bmks+
         YPu6yBmgtWM6CL6phl0SoKVSjgXeLiN+mdWp6lzMB/sbf2us329l1iOW42MclbuQ2tPu
         oYuFVOHNoXfPJaVNaIzVwh/x/cL3USC3PPAdxxQ63jz6n1N+u2/b8WLV7KCcdkc7wud2
         En9A==
X-Gm-Message-State: AOAM531gb4LuVPBN74/pwWxefqw8DuV/F9UAtzgdvEd++Mb5WEyq9bx/
        IHmoGSsV73zMxQJnVgrmfkNWb2ndwotH1A==
X-Google-Smtp-Source: ABdhPJykpSExvDz3HfRnnW9p+LN7xTwwzRdDp8ESAGy1qxIfQmdKdE058SE2ntN2E5PZ594+wkFXTg==
X-Received: by 2002:a17:906:11d9:: with SMTP id o25mr3418753eja.377.1591007818872;
        Mon, 01 Jun 2020 03:36:58 -0700 (PDT)
Received: from ubuntu (host-85-26-109-233.dynamic.voo.be. [85.26.109.233])
        by smtp.gmail.com with ESMTPSA id ch14sm15746997edb.33.2020.06.01.03.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 03:36:58 -0700 (PDT)
Date:   Mon, 1 Jun 2020 12:36:55 +0200
From:   Jil Rouceau <jilrouceau@gmail.com>
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: qlge_main.c: fixed spaces coding style
 issues
Message-ID: <20200601123326.2d755bfa@ubuntu>
In-Reply-To: <20200601051947.GA12667@f3>
References: <20200529151749.34018-1-jilrouceau@gmail.com>
        <20200601051947.GA12667@f3>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Jun 2020 14:19:47 +0900
Benjamin Poirier <benjamin.poirier@gmail.com> wrote:

> On 2020-05-29 17:17 +0200, Jil Rouceau wrote:
> > Fixed the missing spaces before and after binary operators.
> > 
> > Signed-off-by: Jil Rouceau <jilrouceau@gmail.com>  
> 
> This patch does not apply cleanly. I think your base tree is missing
> commit ec269f1250c6 ("staging: qlge: Remove unnecessary spaces in
> qlge_main.c").

Indeed, I was using Linus' tree instead of linux-next, thank you.
