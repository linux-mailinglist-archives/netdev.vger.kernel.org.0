Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233E5520A23
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbiEJAc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbiEJAcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:32:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C8F3464F;
        Mon,  9 May 2022 17:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE8E260E9F;
        Tue, 10 May 2022 00:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4084C385C2;
        Tue, 10 May 2022 00:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652142496;
        bh=B85se5Bs3/5XJRP8iK2SxKEaEwxfsjrbck9rAd8h7zU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cZNJUrw1OxiKjJON01d1Em0WYcsJEBHYEDiccPjxAIodsAsFyFnohr39GFPJEHPnp
         muhvE2C05/fHE+UAY53FXnWBMyv8VxJxRoGQ0ZLpXX54iFd1nZ293M7jDwiEAAnAAs
         VmKgmn8p2o6JhYH4ZKskilC9dqotPrz/BBk8CqjQGN0bIJnw9biBrfjA2lyn4B6hX2
         QJkJEfCQIfkW+MC+nzofnl0diPYX/KMyOZgy7JStStz/Nql1roAD48Bi7Losz8VqzB
         nBTiCQGhfq4NUxFg5dPdFQmMWBnNc14e4dTJqxGzlCnEvZeoNsVjKN5tmw7DAQTOmO
         frf9pxkbtmikA==
Date:   Mon, 9 May 2022 17:28:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        andrew@lunn.ch, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
Message-ID: <20220509172814.31f83802@kernel.org>
In-Reply-To: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
References: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
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

On Fri,  6 May 2022 09:06:20 +1200 Chris Packham wrote:
> Subject: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema

JSON or YAML?
