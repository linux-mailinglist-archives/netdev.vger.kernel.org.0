Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C6155A768
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 08:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiFYFoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 01:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiFYFoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 01:44:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6612F36B52
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 22:44:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EADA960AE3
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E154DC3411C;
        Sat, 25 Jun 2022 05:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656135852;
        bh=h98dHv9rA/1JfE9X9rY6b/yOmOTfi2E1vWMWNaI1MGU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fRI1J/vdldWgcJkJTRNyxkMv83il245+JyzkrHwlyCfcQBKZzuxnlibWN8Qpcq1Az
         nJdTJB/OxmpBAb7b5LObiOiFsqJGwOo+4NrFqbUrxfO7zc6xIMZvFJOkf1GecM020z
         coX/0yZt0SK3xDxuh/pnJnNF4fa1kTpCEJLkd3yd817944u7vokp+2AmaugPrhJ9AV
         S4/+CrcJUKw8EtxxYuZmDzJNv2TEMrtXfQBsnjemlR3NJBfhstw7715fkBuRq9jTlz
         jFCGFgs3aRpZKj9u+JKN6HQyuCe7Kfl+J1IVQJePeq6rHYGjRlUvNIOn/Exzas8b+2
         YopRj32fGi4xw==
Date:   Fri, 24 Jun 2022 22:43:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next 0/2] nfp: add VEPA and adapter selftest support
Message-ID: <20220624224356.7deaa68b@kernel.org>
In-Reply-To: <20220624073816.1272984-1-simon.horman@corigine.com>
References: <20220624073816.1272984-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jun 2022 09:38:14 +0200 Simon Horman wrote:
> this short series implements two new features in the NFP driver.
> 
> 1. Support for ethtool -t: adapter selftest
> 2. VEPA mode in HW bridge.
>    This supplements existing support for VEB mode.

Acked-by: Jakub Kicinski <kuba@kernel.org>
