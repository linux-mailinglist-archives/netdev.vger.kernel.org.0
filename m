Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056EC6B5CF9
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 15:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCKOnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 09:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjCKOn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 09:43:26 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71881B30F;
        Sat, 11 Mar 2023 06:43:24 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so7714534pja.5;
        Sat, 11 Mar 2023 06:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678545804;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nXM/UF5GgRup6jMt6h+LtaT6QVXEZj0KXMptbShshHE=;
        b=E40t+zgvZHCVKrNiHeVevkeIBFXt6i7FUBglkpE3LbyP3kQToKv7UGIlA0fuw90AQJ
         Z8ycKySARL3yraVxMwdcrGohyv+D1Vt/bPJq0T3Sfrmrk+QWdH+dDZITKpMEwjOZa+wG
         mZWtYUIgt7VHJ5f/L62Xm7U6EFsfDEKuVVHJV7xbeT8khQbVk2oMAKdJn+if+2miRKi/
         jqy+jyJNQmmCMN2JL2lXP+hZyunW2Jc905Lt9PHRu9C8JSMOsao+S3OCy9Yur62cnaYC
         jmf6s7bFbd8xkQmSx8rXPaMDV2nFOHElzrqddd+TzXf2KB17sYKZcezQXYl7FH4HvYLj
         6I9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678545804;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nXM/UF5GgRup6jMt6h+LtaT6QVXEZj0KXMptbShshHE=;
        b=NMh0mzLSkBqMpS4Nu+4IZ/lb7gO+rW5ofQAjMVlkJicEhoxLffMZd+Nsrqs3Ht2772
         r605kDRqouF01rrn5P3suLLpgDBQpyDTUg0MXMMVdUrOZj6lcVMZvu4V6y49zLpL19hc
         /+7nUrED64cGU4NycljZAeu/UJtZfHv8N/HJjy7XagIZlTt9R7LR3idHgnlk7nMV5N3O
         VX3kq0sQLIYbMID482Zf6s0MvIB7H6Z9zNgSfFE5qhiumYFP2mfMLz9+QTf41vhuC6+j
         Jwoldg1/RXS9BFwg8krtEeWf30loFR4/LzrHaS/8wdFI7KSqTWwmlUZqP9FlwOylXAz4
         82kg==
X-Gm-Message-State: AO0yUKXOsyWanrsI2erjO0iav+kCJIRHnEwCgq4ajssIDh1LBDlS3EPK
        AU9GaGYE3R5gwkxi8Z2ql4M=
X-Google-Smtp-Source: AK7set9voO5GMcwrRcvfHrGLQVHExBuHPtdo+Kpw/RjvPtE8MU6m/kk4cyI3ss5Oyeea+j2xYefQdA==
X-Received: by 2002:a17:902:da91:b0:19c:d7a9:8bf0 with SMTP id j17-20020a170902da9100b0019cd7a98bf0mr6351397plx.10.1678545804050;
        Sat, 11 Mar 2023 06:43:24 -0800 (PST)
Received: from ubuntu ([117.199.152.23])
        by smtp.gmail.com with ESMTPSA id ld5-20020a170902fac500b0019f3095ae28sm727554plb.157.2023.03.11.06.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 06:43:23 -0800 (PST)
Date:   Sat, 11 Mar 2023 06:43:18 -0800
From:   Sumitra Sharma <sumitraartsy@gmail.com>
To:     error27@gmail.com
Cc:     GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, manishc@marvell.com,
        netdev@vger.kernel.org, outreachy@lists.linux.dev
Subject: Re: [PATCH] Staging: qlge: Remove parenthesis around single condition
Message-ID: <20230311144318.GC14247@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4caf380-bac5-4df3-bb98-529f5703a410@kili.mountain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

Your suggestion for correcting the indentation to
"[tab][tab][space][space][space][space](i ==." conflicts with the 
statement "Outside of comments, documentation and except in Kconfig, 
spaces are never used for indentation" written in 
https://elixir.bootlin.com/linux/latest/source/Documentation/process/coding-style.rst

However, If you still recommend to correct the indentation in the manner
"[tab][tab][space][space][space][space](i ==." Should I create a
patch for the same? 

Regards,

Sumitra

