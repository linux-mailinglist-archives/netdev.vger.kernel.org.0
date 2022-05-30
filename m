Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E7F53802E
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236919AbiE3N5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238992AbiE3Nzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:55:31 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759B0954A4;
        Mon, 30 May 2022 06:38:03 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id z17so6393374wmf.1;
        Mon, 30 May 2022 06:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ytl48+gf/9+wU974bliYN68rRr9GC5CbXhv9Mqbfs9Y=;
        b=7xDOwNr7xvdjI0Dmws9lD6EJBin+IlsgKVOFb/eeKlvlrAEem/DC489NQv3O1eN5IY
         YrkTkPVoiFDdG1yrEMRzbwhisC7OLn3D6vHP+chtIDK1DdsV2sRIcTpwhT/yzr1v9Wt0
         3hcLOaH62FARz/TWyecrSfnSvqPC9zSyNnnCLP6ePNchVc34flzCBUPnLSmQIw2R8fla
         9nil4FKSMoUTUwX8fI1c34j8s7jKSM5cfwW3r3wqi/Ae2lznuYcpHMim6EbPDneVPkSC
         fpem+yz9XO/p/tVfxMdiwyleCUNU4BcdDmkI6KD4m/5dpjbI0VYNM6+0TSqZHrkIn9+a
         qfqQ==
X-Gm-Message-State: AOAM532+VTZgxuMy+Kju2ixwKx4i55jH5Dg2eVW/1Qh0/7/4NY8UITO9
        D25rzo5ySS251OCmy2sgGzw=
X-Google-Smtp-Source: ABdhPJyoFBGlSKlV74jeFHZeQEIiKD71BnJBLmLRXZanLlnEJT/DxNOlAxTa51VmVdIsBUKX2lv0Kg==
X-Received: by 2002:a1c:4e19:0:b0:397:7b13:1bc7 with SMTP id g25-20020a1c4e19000000b003977b131bc7mr18980855wmh.114.1653917881735;
        Mon, 30 May 2022 06:38:01 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id o15-20020a5d58cf000000b0020d02ddf4d0sm8911403wrf.69.2022.05.30.06.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 06:38:01 -0700 (PDT)
Date:   Mon, 30 May 2022 13:37:59 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] xen/netback: do some code cleanup
Message-ID: <20220530133759.mpwhh744l7miszbp@liuwe-devbox-debian-v2>
References: <20220530114103.20657-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530114103.20657-1-jgross@suse.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 01:41:03PM +0200, Juergen Gross wrote:
> Remove some unused macros and functions, make local functions static.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
