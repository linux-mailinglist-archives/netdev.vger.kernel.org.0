Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1431B1DFAD5
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 21:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387899AbgEWT6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 15:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387569AbgEWT57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 15:57:59 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC59C061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 12:57:58 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u5so6633246pgn.5
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 12:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a+FsnCbr2hFwUTU6hizBX0tQKcETm4fpDGcoP3/wVio=;
        b=hUseroLXHSHeSVQmWd8QGDJbvT+Ve14Semv8700lYGfg7ITqui5T0/GtupYUzcff84
         A2Q4OQJSyM7TSNpG/wjSeMTU3QPo6+0lrl31PWJBEPkz3/VZcHifOv66Nv7ryNn6218s
         eJZuoKiutCloehkbVznflkbPOjbPXdKjlNIdypwVewRulqpLgBGZpwq79VYh1s5B1lQE
         PuIAA+hd0D+y0lLaOrfhRvhAXYc8ko7cLxY9ycU6iYwhDuBNu1+bdJulDhOEEzyl7xSv
         j7ynGFKuYZA/uU2xu4Ks5/ON4ydrGf1vPnKRkoFHEKbU6Fw0gayQpyyXSiU67Pabt7mZ
         Kotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a+FsnCbr2hFwUTU6hizBX0tQKcETm4fpDGcoP3/wVio=;
        b=A8ZMviQnfFYEAycR0QhZMMWhWgnRXCouc26j0xAFykL7lVTIzQM0T4T2H73w749BE2
         QSUbRPiHDmydoWRZoC+6RRxvGcpvPyJQGBUZ2FSmV55xTbU8W5Uo4iGNuxbDeCuiqMxW
         YBOWpHNIKsJSDzgi6iyXJ5h1a0H9bxUFcfhZB8Xa1rbzQ90YA4mfO4iGiYnGqxGKpcL4
         7qFPob6549ZcTyxsQVN9fLcNybygqTZGGIe/sDZFrf+KXoNsSf28u1NnwciAyB/g5xPE
         v1XzAi0dKXzEU9XSA+nITGCWlwAhtXHWgNlajQf0g9hniYe3uujpvbmheKl9kydfPvSz
         Tlsw==
X-Gm-Message-State: AOAM533sqspReBqpSEnLMPZ2BSqEjw6ioAWFHCjv3Y5OLbE9XPJvrrw+
        68nUW9KuT89zQJ8LQdNMQGhWlIBUtcngbQ==
X-Google-Smtp-Source: ABdhPJxT65V7j1RH+/tgKKfLMzqzGeLQ5Zz0rVj/HCklhVtANhzTMn5FyqVl0GiOXDFx+XoJLvmQzw==
X-Received: by 2002:a63:a36e:: with SMTP id v46mr19280866pgn.378.1590263878399;
        Sat, 23 May 2020 12:57:58 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x190sm8781329pgb.79.2020.05.23.12.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 12:57:58 -0700 (PDT)
Date:   Sat, 23 May 2020 12:57:55 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix various coding-style issues and improve printk()
 usage
Message-ID: <20200523125755.65457014@hermes.lan>
In-Reply-To: <20200523160644.GA17787@mx-linux-amd>
References: <20200523160644.GA17787@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 May 2020 18:06:44 +0200
Armin Wolf <W_Armin@gmx.de> wrote:

>  /* These identify the driver base version and may not be removed. */
>  static const char version[] =
> -	KERN_INFO DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE
> -	" D. Becker/P. Gortmaker\n";
> +	"Version " DRV_VERSION " " DRV_RELDATE " D. Becker/P. Gortmaker\n";


This is how Linux drivers behaved years ago, it is bad practice now.
