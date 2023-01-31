Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043DD6820D9
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 01:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjAaAjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 19:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjAaAjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 19:39:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1D3A26E
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 16:39:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2E18B8188E
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 00:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4DAC433D2;
        Tue, 31 Jan 2023 00:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675125560;
        bh=R28yJDwAcGYnaLfvFr5ZfcLf7w2JopZ+ArM0LRlbLew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a3pOP7QBqavj6x9ED5jbrWSTnfCAB90CuEtFEV2cmbkKhftHZ6REBxVi2O9HHl6yS
         PHZzEqeYe1//ID8tY1uh7MeZ2tZ3i6UvPd7o+3FBlRODGRSZaqS7ml44qyPX0ajNAE
         wYPyVK+uqtxf1gCDCixU3XzHY/a8Rh9OblxBw7ps4bGj1dKdPM2BO5rNE8wEBbzio7
         VxXlWmuyKk/o8Rway5vs0MZQqwOApH5AQQc3vssoxR5+m8Ep9WMg3lOvoF08EMvR/O
         qG5P4y2lIC76d+vCiFHErlFMhE1wwUYKLbWooX1OTUsQ6QYwcIJWxndQ4H1m4+tL6V
         tVB2kR1O/5S1A==
Date:   Mon, 30 Jan 2023 16:39:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] gve: Introduce a way to disable queue formats
Message-ID: <20230130163919.4c6c8022@kernel.org>
In-Reply-To: <20230127190744.3721063-1-jeroendb@google.com>
References: <20230127190744.3721063-1-jeroendb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Jan 2023 11:07:44 -0800 Jeroen de Borst wrote:
> The device is capable of simultaneously supporting multiple
> queue formats. With this change the driver can deliberately
> pick a queue format.

Please add more documentation, I see information about GQI vs DQO
but not RDA vs QPL.
