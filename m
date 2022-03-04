Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940874CCCC0
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiCDFCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiCDFCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:02:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B22A10A7C6
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 21:01:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11322B82755
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 05:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD49C340E9;
        Fri,  4 Mar 2022 05:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646370073;
        bh=TEgqIRgvgE91Al3D07G0e8QdAYSbPaOAtzSRjGtfTr0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c9NpqeodN0fkOOLenHTR83CQr2E0jMEaN+vUqMmWeRNVIxrEXjKaDGvDSrEGiotWf
         pkzkE1sh0tFMImGlKSfasmfiM+vtAdeKeXBLT5xmIuNFe7EjHZ+r47M5B3psNMcZWM
         iA/9E6nGdEWYb92TFbRrOXyyU8SObTmZNlPDGxAw0R+g6vi34WKr1HOz3XoKIK+9ON
         TWQdiMjoi8zOGUiggG1utePMhuFRL+8wE1YdoBEzLRL8uq14ULj1qUi9/PsCwKoa0I
         qBVChZv7+kyDgwO/51ijWHWRSIMLxkfUH8B5eDI49/Xc5g2jdiH3JQxwarmd/4Cm1X
         7Uzl23Xk5NY4g==
Date:   Thu, 3 Mar 2022 21:01:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/2] ptp: ocp: add nvmem interface for
 accessing eeprom
Message-ID: <20220303210112.701ed143@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303233801.242870-4-jonathan.lemon@gmail.com>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
        <20220303233801.242870-4-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Mar 2022 15:38:00 -0800 Jonathan Lemon wrote:
> manufacturer

The generic string is for manufacture, i.e. fab; that's different 
from manufacture*r* i.e. vendor. It's when you multi-source a single
board design at multiple factories.
