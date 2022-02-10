Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0559C4B1048
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242845AbiBJOXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:23:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbiBJOXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:23:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFDE21B;
        Thu, 10 Feb 2022 06:23:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DF6E6141B;
        Thu, 10 Feb 2022 14:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC17C004E1;
        Thu, 10 Feb 2022 14:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644503030;
        bh=kFD4BdX/xGNQMXDRnzY9jSgp8cW8ooG1pe8p+Wttp5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g5CmlsrmlIy2rSKWBZvJJzCg9k2iQDqcY05aL6/qJCLmA2IH8GC93GNE6UM0MdFAa
         TIcu51fyjfmx+H8sDOR0CGwa4x0pPNjzUUBGgyYXy25Hy9hq4J/BZO0PTrDhwzSzB7
         8/xQiaG2+wokXKBkfljrGfKqKRf2OGP8w4ec+rBPGLu01D0OVoiBtIyvucfoVY51un
         tkkkWv5Fs0KIYG3NTRrpxenwUd5I2LxFRfUE94RBRbkNa6JwvAdrxnZ7QuGO0SOeUo
         agkz2KmIaP0viGxAQwvL2PUmGHe+gut85/5PgS47s5FZaH/O7H/DiDlmZj61whcCOM
         U98HjespBmwNA==
Received: by pali.im (Postfix)
        id 96859869; Thu, 10 Feb 2022 15:23:47 +0100 (CET)
Date:   Thu, 10 Feb 2022 15:23:47 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 05/24] wfx: add main.c/main.h
Message-ID: <20220210142347.nwmbynkcdtjhvsj5@pali>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
 <20220111171424.862764-6-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111171424.862764-6-Jerome.Pouiller@silabs.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 11 January 2022 18:14:05 Jerome Pouiller wrote:
> +/* The device needs data about the antenna configuration. This information in
> + * provided by PDS (Platform Data Set, this is the wording used in WF200
> + * documentation) files. For hardware integrators, the full process to create
> + * PDS files is described here:
> + *   https:github.com/SiliconLabs/wfx-firmware/blob/master/PDS/README.md
> + *

Just a small cosmetic issue but URL cannot be automatically opened as it
is missing slashes after https protocol.
