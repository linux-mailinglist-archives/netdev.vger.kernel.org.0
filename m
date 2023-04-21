Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344A76EAD7D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbjDUOyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbjDUOyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:54:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10C9BB86;
        Fri, 21 Apr 2023 07:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1308E61083;
        Fri, 21 Apr 2023 14:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECE3C433D2;
        Fri, 21 Apr 2023 14:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682088845;
        bh=qTp7GhdoyNEaqLzE1Ywju/UzLL5cR+pDzBIJw/MlMXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WWpP3Um8HdY7SUH9IcJoMzxwBQZbB84vX2zq+AuSwFv4OMIde7MUXVc12PfCHZNvi
         d4VN3a5DyqavrREJh0pKbPe4K5MLQEqVIOjfqDaMhZJumstSnI3VZXn9sE0V3rKr93
         lgqdKd2v8oyoR4BkQIfSlnSsErdhubzwEJVTMpdH0P6nT10IyuyHe/nWss9wuQqybF
         wfXeiPhVP4I9RJ44X1TrvNwg2ICf+sbtD2Pmu1vt7XEfcRdLVSsmZ8rm5LZo2eTH8O
         SqM7d/PRpPS8PmQGewbilGKE9mvtpb7CAieyhyoYJbsfuVuduYoGlv1mr7QMQ2bGJV
         dcNTDS2CltK3w==
Date:   Fri, 21 Apr 2023 07:54:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2023-04-21
Message-ID: <20230421075404.63c04bca@kernel.org>
In-Reply-To: <20230421104726.800BCC433D2@smtp.kernel.org>
References: <20230421104726.800BCC433D2@smtp.kernel.org>
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

On Fri, 21 Apr 2023 10:47:26 +0000 (UTC) Kalle Valo wrote:
>  .../net/wireless/realtek/rtw89/rtw8851b_table.c    | 14824 +++++++++++++++++++
>  .../net/wireless/realtek/rtw89/rtw8851b_table.h    |    21 +

We should load these like FW, see the proposal outlined in
https://lore.kernel.org/all/20221116222339.54052a83@kernel.org/
for example. Would that not work?

The huge register tables in C sources makes it look like
a Windows drivers :(
