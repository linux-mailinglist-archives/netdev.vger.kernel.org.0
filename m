Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C936977BF
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbjBOIDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbjBOIDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:03:35 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268EA29E39
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:03:34 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id sa10so46047521ejc.9
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=odpnWeMORqVf/dQodngPKEq0zuVIfUomF2twr9X3A6Q=;
        b=yAnQzwHyAs7zt4gJytnggfw++m0+7nFUh/5MFh9JHhTgPUFK9ELWaiHPlt67t7Abj9
         IWZs6QGdM3KpgOpAnfFnr75mgku5ueb5MC4qPU+6Bjpv594LtSBh9N9K9QU2IfgE8YOE
         I86rXk7XH2nMbn1jO9c3GDwS+Do8S+Bbo0iaGIjY632zDyiGojS5eDHJX9zecFmtVlM+
         yoMqtdh8axnJAOuRaP3oRWgdWa/hRR1H6/OB40mXx/W2B92kdNEe7nHe7yleGizwPQKq
         SW75GVhoSlVquRGiyBSuJBi8+rvNpa5UQ6GPw0vPPqlPtpW6bWK1DsaCBlggg4v1zzSf
         zNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=odpnWeMORqVf/dQodngPKEq0zuVIfUomF2twr9X3A6Q=;
        b=6PMXCSuq5vpS63oXgDh8fJGl7GB2j5x9bFCO2JOaFzVBHCXbAH7tO0FmS/zQ7KxemK
         hevU7v2sAffGyQC2KFpR51n6m3wLk//ajchWQR7kV1O9xas4VfSPDJGuT5dawkqfzmRL
         pecOXDwL/mdXcuFv49pQ7Dhj2Ua3pRp+SZuIq7RfPzxVgg2q1su1inuM7Ltdtay1V9Yr
         YwYIAfX/XgNWD+0/sNvjEoj+xDXqx7VMtgc2KwqXvnitYtuPP/CxTJdW9LE9YWorVMfp
         3d+3dfZc144RujycFy0AHnBwh7Tsx3GXusG9HzxIAlcZKIqx3RHAhPBr5tPaB+aWqob1
         C+1A==
X-Gm-Message-State: AO0yUKUS+ktlQaRu2y2nG66jcaXj8QrfOQf02Q/VeeV4WzZ5RyliMGQA
        Ft+RKmX32ShiRI6AjuvuPWaXAQ==
X-Google-Smtp-Source: AK7set+JDmciJLbAEp68JgctFn4lF8eOc6NdZFnF1mjqyrDPpJ512t+B/7UxIZCPh8fmDdLmApG+CA==
X-Received: by 2002:a17:906:2c18:b0:883:3c6e:23eb with SMTP id e24-20020a1709062c1800b008833c6e23ebmr1325297ejh.42.1676448212777;
        Wed, 15 Feb 2023 00:03:32 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d21-20020a170906c21500b008790ae3e094sm9274653ejz.20.2023.02.15.00.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 00:03:32 -0800 (PST)
Date:   Wed, 15 Feb 2023 09:03:30 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver
 Updates 2023-02-14 (ice)
Message-ID: <Y+yR0oJxCl9ksx8f@nanopsycho>
References: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
 <Y+yQTnI0okJU++q7@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+yQTnI0okJU++q7@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 15, 2023 at 08:57:02AM CET, jiri@resnulli.us wrote:
>Tue, Feb 14, 2023 at 10:29:58PM CET, anthony.l.nguyen@intel.com wrote:
>>This series contains updates to ice driver only.
>>
>>Karol extends support for GPIO pins to E823 devices.
>>
>>Daniel Vacek stops processing of PTP packets when link is down.
>>
>>Pawel adds support for BIG TCP for IPv6.
>>
>>Tony changes return type of ice_vsi_realloc_stat_arrays() as it always
>>returns success.
>>
>>Zhu Yanjun updates kdoc stating supported TLVs.
>>
>>The following are changes since commit 2edd92570441dd33246210042dc167319a5cf7e3:
>>  devlink: don't allow to change net namespace for FW_ACTIVATE reload action
>>and are available in the git repository at:
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE
>>
>>Daniel Vacek (1):
>>  ice/ptp: fix the PTP worker retrying indefinitely if the link went
>>    down
>>
>>Karol Kolacinski (1):
>>  ice: Add GPIO pin support for E823 products
>>
>>Pawel Chmielewski (1):
>>  ice: add support BIG TCP on IPv6
>>
>>Tony Nguyen (1):
>>  ice: Change ice_vsi_realloc_stat_arrays() to void
>>
>>Zhu Yanjun (1):
>>  ice: Mention CEE DCBX in code comment
>>
>> drivers/net/ethernet/intel/ice/ice.h        |  2 +
>> drivers/net/ethernet/intel/ice/ice_common.c | 25 +++++++
>> drivers/net/ethernet/intel/ice/ice_common.h |  1 +
>> drivers/net/ethernet/intel/ice/ice_dcb.c    |  4 +-
>> drivers/net/ethernet/intel/ice/ice_lib.c    | 11 ++--
>> drivers/net/ethernet/intel/ice/ice_main.c   |  2 +
>> drivers/net/ethernet/intel/ice/ice_ptp.c    | 72 ++++++++++++++++++++-
>> drivers/net/ethernet/intel/ice/ice_txrx.c   |  3 +
>> 8 files changed, 109 insertions(+), 11 deletions(-)
>
>Tony, could you please send the patches alongside with the pull request,
>as for example Saeed does for mlx5 pull requests?

Ah, I see it now. Unlike 0/5, the rest got filtered out to another
folder in my inbox. Sorry :)

>
>Thanks!
