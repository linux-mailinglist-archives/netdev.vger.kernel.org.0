Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D793D598A6E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344687AbiHRR1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344896AbiHRR06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:26:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C2F5FF7F;
        Thu, 18 Aug 2022 10:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D72086170D;
        Thu, 18 Aug 2022 17:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9397C433D6;
        Thu, 18 Aug 2022 17:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660843617;
        bh=yO4Sdmeb0urmwPNXABS7U51vtDrMnVAyJ4gHwuD5HPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GSF6+YcexksGUVSCpWzf+c8HwvVElVoE7FgGFo+GGm2JtyWMO4zlpkpas6KlMfcps
         Fu8KbSTMkZ10HWj2QeQ2QztUqPrR8RomdcgBaAusrElIKwWRCWEfjGgQ80oa/U3QP/
         RdMLchl48kyLg5Em0y/u9V/VM91cSK4GdKCensTNxs7yHir+MIJaVgKIUgrRVth6rg
         GWxFD+9IM7lBZH8iwythMEELFF9S5urFN2jXl4bmGy5NHyvHYjZ0z0A0N4h/aCCQ/S
         qP9W2oSkp7cDeKp5Yv5+byfpsQrnm6TPlXu+ktXKKEzw3PW9sj2ib/3xPslOS5+Q2x
         I/ytUCMiuS8nw==
Date:   Thu, 18 Aug 2022 10:26:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Richard Cochran <richardcochran@gmail.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] net: ethernet: altera: Add use of
 ethtool_op_get_ts_info
Message-ID: <20220818102656.5913ef0d@kernel.org>
In-Reply-To: <20220817095725.97444-1-maxime.chevallier@bootlin.com>
References: <20220817095725.97444-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 11:57:25 +0200 Maxime Chevallier wrote:
> Add the ethtool_op_get_ts_info() callback to ethtool ops, so that we can
> at least use software timestamping.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

I think our definition of bug is too narrow to fit this. It falls into
"never worked" category AFAICT so to net-next it goes.
