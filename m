Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41535A6272
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiH3LwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiH3LwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:52:19 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F9A9926D
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 04:52:18 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id m16so13846377wru.9
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 04:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=o0xWsTQdrwELsoKAYNu6ozwRujSquaKsvzVo6MWuCkU=;
        b=XEZ+D4cr97nGbqCoAdTHfh9wK4K08S/qJK5zoEi+ZZ/IikkybrmR48OwDB+8FTEJGu
         nB0tn7fg6kyJnREBNFX6UIAGmHLhiRixrEzdkLoDm7k8zutI9BOfSQJPQ5DNtmzaRLQt
         kGGX7pyeQPGXZ4s111i1QNjUZQjHO/4XE+v9O/DDrJmPc8SKBhbtobfy4ewhxN2pKIDM
         7eC8mNbux4A8UKryl/N0sFpE/Zlb1iDCzMdNqfqSlPVCOwGL5OpRk+OFOVHlAqQZwVtL
         SubPPA1dgOyxZdnlqw5ty+embtCee5rdZyvCyg+NmscBaPIelOyAuFJb7B9lYE5d0RlX
         Eltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=o0xWsTQdrwELsoKAYNu6ozwRujSquaKsvzVo6MWuCkU=;
        b=eusV0Peu5UXVgCu1r1LVjLsGl0vsaBlejpVUn/LW7FLWC/ubuj6k6SDUazYLsyAzx+
         MhEeIPMggCK7p7MojSYFFJussIRJE1ah0vqt/TBV9M764QG5SVgXm9bZ+5qJTlYopXOm
         OWbUBnOu9f1g6sKLfugOx4qJr7UnnYv4ZYfYJd97VRrGG/EmJELDOTtivVunRCQ06s1Q
         PsF1LmA/ZKYTvssOON9MKsQt48teEJvhwdYaNlqFAzpeJnqiqkjBCqv1vtYkEOAnkOU9
         G+TLl+ekuw/hMXny4ixgIcn7WRnPqehnVjx9lNDipLg8MiR/PpQntTC4fD1a3yuvdPBl
         oM/A==
X-Gm-Message-State: ACgBeo3itoGHJJCFlGwZSR42MTRN9RdRVabfgG1YWuDeWE0AbASZ1Xae
        up3SD6ItWfaVEvUhzWH42FMzoLIYcA8dKQ==
X-Google-Smtp-Source: AA6agR6b7K4lbNGGkh3UnTYNLdrSfewYd3C8LwduIWJmDk2xbqjyfC8YQyVyAcw/ytq6mzy1NncQjA==
X-Received: by 2002:a5d:4e09:0:b0:226:da61:190a with SMTP id p9-20020a5d4e09000000b00226da61190amr5950367wrt.653.1661860336243;
        Tue, 30 Aug 2022 04:52:16 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id n18-20020a05600c3b9200b003a846a014c1sm8141528wms.23.2022.08.30.04.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 04:52:15 -0700 (PDT)
Date:   Tue, 30 Aug 2022 12:52:14 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Message-ID: <Yw357sE8jmv15gKT@debian>
References: <20220830101237.22782-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830101237.22782-1-gal@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 01:12:37PM +0300, Gal Pressman wrote:
> When CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled,
> NL802154_CMD_DEL_SEC_LEVEL is undefined and results in a compilation
> error:
> net/ieee802154/nl802154.c:2503:19: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?
>  2503 |  .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
>       |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                   NL802154_CMD_SET_CCA_ED_LEVEL
> 
> Use __NL802154_CMD_AFTER_LAST instead of
> 'NL802154_CMD_DEL_SEC_LEVEL + 1' to indicate the last command.
> 
> Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>

Tested-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

-- 
Regards
Sudip
