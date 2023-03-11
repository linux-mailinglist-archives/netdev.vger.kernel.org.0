Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569DF6B5D16
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 15:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCKO7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 09:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjCKO7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 09:59:14 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495BBDB4A5;
        Sat, 11 Mar 2023 06:59:11 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id g3so7602029wri.6;
        Sat, 11 Mar 2023 06:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678546749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GXU++RTy/QtfoFNBTLNutZqfPQRVbzLlMVHk9uJLiYo=;
        b=CyltH56tbofEBHJs90HfHYPpH/Rqd3JnnW2npTYK6MZBgKw1/OrbbH9kXQ3p6o1CXo
         KtXGIk+bMs5X3eU+iTGqdK8n63Ba/jwR6EsjEYecjR4hIvCrtgbixjufaCBgpCjcg18Q
         fKtShj+VNh/jNC1bbP5gbn42k8DfrFpKuZsyRShRC+c+x98YlgR82ol/xxKKzf9lMPsu
         yuRSLG+LelCvCCuAo/ZBsCE4y49dPUOCbmXktDonq2d/4jCtPEiT9tm6JpmEtHmL5/1U
         O7XTSAgh5bPcJp3f1pt3RfI1S4G8snuYXwAhDnLmk8TiQwXuiJMkiElNYuOS+JZixkUu
         ZkVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678546749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXU++RTy/QtfoFNBTLNutZqfPQRVbzLlMVHk9uJLiYo=;
        b=qHVe4yzTH1WBOHeONQy3khnbE99WL+PbiRDNcIzkuxVYMxd7aN5lP0vNSwXRgKAEQI
         3EPdKJIZHecoY9AmWXEvxqrYy2ilSNuFFCKxJQ2HkdAYcOYuerwLxOyyTvxlY46pnZeo
         EFO8qum4ppGdc5lAoi1ssJS53Te9XJJ8/Eq6D6ZWWgY3f5ejIp2hcDoa+qw6Mkwqc+3j
         LIM4SHELZTMA7o6rGfbqhv/NOLNEIaJWoQ6/Teu3ln1aUjDtOX/cVVRQjwjOnwwBrm6G
         tyMWubdi2hq3ITXC7WokXBs1eb6QxDlJcTvSFHTtfDeHwC/oDz5/qvCVbvOt4nmKIvt6
         8oHw==
X-Gm-Message-State: AO0yUKVxgnVXK6RVZx0Xnf7sbk3bTsRlloIiDRGsGqf2gUmMdHaY6H7w
        oPPEPfDon3WseAAA10WjUv+c+iXcWH5QRRFZ
X-Google-Smtp-Source: AK7set+63NHyHBs7nWxhV2Bzacldo5xiBJaVU7ynv9KB+PBrnKDxwp9eTSA6FQSFJLuWZZjBYCNP8w==
X-Received: by 2002:adf:e682:0:b0:2c5:5641:d1ba with SMTP id r2-20020adfe682000000b002c55641d1bamr5021030wrm.3.1678546749650;
        Sat, 11 Mar 2023 06:59:09 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e2-20020a5d5002000000b002c567b58e9asm2646782wrt.56.2023.03.11.06.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 06:59:09 -0800 (PST)
Date:   Sat, 11 Mar 2023 17:59:05 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Sumitra Sharma <sumitraartsy@gmail.com>
Cc:     GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, manishc@marvell.com,
        netdev@vger.kernel.org, outreachy@lists.linux.dev
Subject: Re: [PATCH] Staging: qlge: Remove parenthesis around single condition
Message-ID: <20838efc-e8ef-4696-9a27-958bc5aab19e@kili.mountain>
References: <e4caf380-bac5-4df3-bb98-529f5703a410@kili.mountain>
 <20230311144318.GC14247@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311144318.GC14247@ubuntu>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 06:43:18AM -0800, Sumitra Sharma wrote:
> Hi Dan,
> 
> Your suggestion for correcting the indentation to
> "[tab][tab][space][space][space][space](i ==." conflicts with the 
> statement "Outside of comments, documentation and except in Kconfig, 
> spaces are never used for indentation" written in 
> https://elixir.bootlin.com/linux/latest/source/Documentation/process/coding-style.rst

Huh...  That documentation is very wrong.  Maybe you are not the only
person who has read that and been confused.  Not only do we use spaces,
but checkpatch will complain if you don't use spaces to align function
parameters.

Aligning conditions is not universal but it's generally prefered. There
isn't a checkpatch warning for misaligned conditions, but I think that's
because it's much trickier to parse conditions correctly.  Aligning
conditions is much more subtle.

What this means is that maybe you should consult with your mentor and
try to fix the documentation.  Maybe say something to the effect of "You
can use spaces for micro alignments to function parameters and
conditions in an if statement".

> 
> However, If you still recommend to correct the indentation in the manner
> "[tab][tab][space][space][space][space](i ==." Should I create a
> patch for the same? 

I'm not going to tell you what to do with your life.  :P  But if you
send that patch then we will merge it.

regards,
dan carpenter
