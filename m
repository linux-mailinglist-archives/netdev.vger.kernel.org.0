Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3E4534898
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 04:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344428AbiEZCHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 22:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiEZCHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 22:07:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A017FD05;
        Wed, 25 May 2022 19:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37395B81EC8;
        Thu, 26 May 2022 02:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98BCC385B8;
        Thu, 26 May 2022 02:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653530855;
        bh=VdNXFge3R6+PIbAtpUi/5xR8rIBIMY61yBeKFaaaSKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cQmQCt6S9XdBnxaw3pDXAqZ2BFdk76fv4hAVYSZDCou76a/QIy/BFG77JMa7ECMAE
         ZeEKiaXmhLC3C4WTGg4K+YveQ/VrD0xwZo0Wtj8ZtB9X9QOaoo02r2C+JQ6nW2RGx6
         XsMJ8rtOYSxyu8UkCKswS1llmnVj+xtiUfcgCPIT67O8s06PBIvcWvip07kFi/buv+
         u1eNsReJzgNirqkqvpWjZoRoktESJOrzplQBS+qaOiqn5qSVNnA0jGMXFKIJt+P5o4
         9USmMys2yNvwGNPIlkXjVtk//Sw9H9YfVxdnIsg8ex/e7/vFcUSJBK96G8U4ciHuoG
         flhRDAS7yynbQ==
Date:   Wed, 25 May 2022 19:07:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     johannes.berg@intel.com, gregory.greenman@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] iwlwifi: pcie: Rename the CAUSE() macro
Message-ID: <20220525190733.37b08dc8@kernel.org>
In-Reply-To: <20220526004434.1160267-1-festevam@gmail.com>
References: <20220526004434.1160267-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 May 2022 21:44:34 -0300 Fabio Estevam wrote:
> arch/mips/include/uapi/asm/ptrace.h already defines CAUSE, which
> causes a name clash:
> 
> drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1093: warning: "CAUSE" redefined
> 
> Fix the problem by renaming it to IWLWIFI_CAUSE().

https://lore.kernel.org/all/20220523220300.682be2029361.I283200b18da589a975a284073dca8ed001ee107a@changeid/
